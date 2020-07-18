# frozen_string_literal: true

module Captive
  class VTT
    include Base

    # Standard VTT Header
    VTT_HEADER = 'WEBVTT'

    # VTT METADATA Regex
    VTT_METADATA = /^NOTE|^STYLE/.freeze

    # Parse VTT blob and return array of cues
    def self.parse(blob:)
      cue_list = []
      lines = blob.split("\n")
      cue_count = 1
      state = :new_cue
      cue = nil
      raise InvalidSubtitle, 'Invalid VTT Signature' unless validate_header(lines.shift)

      lines.each_with_index do |line, index|
        line.strip!

        case state
        when :new_cue
          next if line.empty?

          if metadata?(line)
            state = :metadata
            next
          end

          # If its not metadata, and its not an empty line, it should be a timestamp or an identifier
          unless time?(line)
            # If this line is an identifier the next line should be a timecode
            next if time?(lines[index + 1])

            raise InvalidSubtitle, "Invalid Time Format at line #{index + 1}" unless time?(line)
          end

          elements = line.split
          start_time = elements[0]
          end_time = elements[2]
          cue = Cue.new(cue_number: cue_count, start_time: start_time, end_time: end_time)
          cue_count += 1
          state = :text
        when :text
          if line.empty?
            ## end of previous cue
            cue_list << cue
            cue = nil
            state = :new_cue
          else
            cue.add_text(line)
          end
        when :metadata
          next unless line.empty?

          # Line is empty which means metadata block is over
          state = :new_cue
        end
      end

      # Check to make sure we add the last cue if for some reason the file lacks an empty line at the end
      cue_list << cue unless cue.nil?

      # Return the cue_list
      cue_list
    end

    # Dump contents to String
    def to_s
      string = VTT_HEADER.dup
      string << "\n\n"
      cues.each do |cue|
        string << milliseconds_to_timecode(cue.start_time)
        string << ' --> '
        string << milliseconds_to_timecode(cue.end_time)
        string << "\n"
        string << cue.text
        string << "\n\n"
      end
      string
    end

    # VTT Header tag matcher
    def self.validate_header(line)
      # Make sure BOM does not interfere with header detection
      !!line.force_encoding('UTF-8').delete("\xEF\xBB\xBF").strip.match(/^#{VTT_HEADER}/)
    end

    # VTT Metadata tag matcher
    def self.metadata?(text)
      !!text.match(VTT_METADATA)
    end

    # VTT Timecode matcher
    def self.time?(text)
      !!text.match(/^(\d{2}:)?\d{2}:\d{2}.\d{3}.*(\d{2}:)?\d{2}:\d{2}.\d{3}/)
    end

    def self.integer?(val)
      val.to_i.to_s == val
    end
  end
end

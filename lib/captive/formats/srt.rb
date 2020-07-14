# frozen_string_literal: true

module Captive
  class SRT
    include Base

    def self.parse(blob:)
      cue_list = []
      lines = blob.split("\n")
      count = 0
      state = :new_cue
      cue = nil

      lines.each_with_index do |line, _index|
        line.strip!
        case state
        when :new_cue
          next if line.empty? ## just another blank line, remain in new_cue state

          raise InvalidSubtitle, "Invalid Cue Number at line #{count}" if /^\d+$/.match(line).nil?

          cue = Cue.new(cue_number: line.to_i)
          state = :time
        when :time
          raise InvalidSubtitle, "Invalid Time Format at line #{count}" unless timecode?(line)

          start_time, end_time = line.split('-->').map(&:strip)
          cue.set_times(
            start_time: format_time(start_time),
            end_time: format_time(end_time)
          )
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
        end
      end

      # Check to make sure we add the last cue if for some reason the file lacks an empty line at the end
      cue_list << cue unless cue.nil?

      # Return the cue_list
      cue_list
    end

    def to_s
      string = String.new
      cues.each do |cue|
        string << cue.number.to_s
        string << "\n"
        string << milliseconds_to_timecode(cue.start_time).gsub!('.', ',')
        string << ' --> '
        string << milliseconds_to_timecode(cue.end_time).gsub!('.', ',')
        string << "\n"
        string << cue.text
        string << "\n\n"
      end
      string
    end

    def self.format_time(text)
      text.strip.gsub(/,/, '.')
    end

    def self.timecode?(text)
      !!text.match(/^\d{2,}:\d{2}:\d{2},\d{3}.*\d{2,}:\d{2}:\d{2},\d{3}$/)
    end
  end
end

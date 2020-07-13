# frozen_string_literal: true

module Captive
  class SRT
    include Base

    def to_s
      string = String.new
      @cue_list.each do |cue|
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
  end
end

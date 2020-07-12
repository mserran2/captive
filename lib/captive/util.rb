# frozen_string_literal: true

module Captive
  module Util
    TIMECODE_REGEX = /^(\d{2,}:)?[0-5]\d:[0-5]\d(\.\d{1,3})?$/.freeze

    # Converts timecode in HH:MM:SS.MSEC (or) MM:SS.MSEC to milliseconds.
    def timecode_to_milliseconds(timecode)
      raise InvalidInput, 'Input should be a valid Timecode' unless TIMECODE_REGEX.match(timecode)

      timecode_split = timecode.split('.')
      time_split = timecode_split[0].split(':')

      # To handle MM:SS.MSEC format
      time_split.unshift('00') if time_split.length == 2

      # Get HH:MM:SS in seconds
      seconds = time_split[-1].to_i
      seconds += minutes_to_seconds(time_split[-2].to_i)
      seconds += hours_to_seconds(time_split[-3].to_i)

      milliseconds = seconds_to_milliseconds(seconds)

      # Millisecond component exists. Pad it to make sure its a full 3 digits
      milliseconds += timecode_split[1].ljust(3, '0').to_i if timecode_split[1]

      milliseconds
    end

    def minutes_to_seconds(minutes)
      minutes * 60
    end

    def hours_to_seconds(hours)
      minutes_to_seconds(hours * 60)
    end

    def seconds_to_milliseconds(seconds)
      seconds * 1000
    end

    # Converts milliseconds to timecode format and returns HH+:MM:SS.MSEC where hours are two or more characters.
    def milliseconds_to_timecode(milliseconds)
      ms_in_a_second = 1000
      ms_in_a_minute = ms_in_a_second * 60
      ms_in_an_hour = ms_in_a_minute * 60

      hours, remaider = milliseconds.divmod(ms_in_an_hour)
      minutes, remaider = remaider.divmod(ms_in_a_minute)
      seconds, milliseconds = remaider.divmod(ms_in_a_second)

      format('%<h>02d:%<m>02d:%<s>02d.%<ms>03d', { h: hours, m: minutes, s: seconds, ms: milliseconds })
    end
  end
end

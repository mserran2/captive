# frozen_string_literal: true

module Captive
  class Cue
    include Util

    # Text Properties supported
    ALIGNMENT    = 'alignment'
    COLOR        = 'color'
    POSITION     = 'position'

    # List of Text Properties
    TEXT_PROPERTIES = [ALIGNMENT, COLOR, POSITION].freeze

    attr_accessor :text, :properties
    attr_reader :start_time, :end_time

    # Creates a new Cue class denoting a subtitle.
    def initialize(text: nil, start_time: nil, end_time: nil, properties: {})
      self.text = text
      self.start_time = start_time
      self.end_time = end_time
      self.properties = properties || {}
    end

    def self.from_json(json:, mapping: {})
      schema = {}
      %i[text! start_time! end_time! properties].each do |field|
        field_name = field.to_s.delete('!')
        schema[field] = mapping[field_name] || mapping[field_name.to_sym] || field_name.to_sym
      end
      data = {}
      schema.each do |mask, mapper|
        key = mask[-1] == '!' ? mask.to_s[0...-1].to_sym : mask
        if key.to_s != mask.to_s && !(json.key?(mapper.to_s) || json.key?(mapper.to_sym))
          raise InvalidJsonInput, "Cue missing field: #{mapper}"
        end

        data[key] = json[mapper.to_s] || json[mapper.to_sym]
      end
      new(**data)
    end

    def start_time=(time)
      set_time(:start_time, time)
    end

    def end_time=(time)
      set_time(:end_time, time)
    end

    def set_times(start_time:, end_time:)
      self.start_time = start_time
      self.end_time = end_time
    end

    # Getter and Setter methods for Text Properties
    TEXT_PROPERTIES.each do |setting|
      define_method :"#{setting}" do
        return properties[setting] if properties[setting].present?

        return nil
      end

      define_method :"#{setting}=" do |value|
        properties[setting] = value
      end
    end

    def duration
      end_time - start_time
    end

    # Adds text. If text is already present, new-line is added before text.
    def add_text(text)
      if self.text.nil?
        self.text = text
      else
        self.text += "\n" + text
      end
    end

    def <=>(other)
      start_time <=> other.start_time
    end

    def as_json(**args)
      options = args.delete(:options) || {}
      format = options['format'] || {}
      obj = {
        'start_time' => format[:time] == :timecode ? milliseconds_to_timecode(start_time) : start_time,
        'end_time' => format[:time] == :timecode ? milliseconds_to_timecode(end_time) : end_time,
        'text' => text,
        'properties' => properties,
      }
      obj.respond_to?(:as_json) ? obj.as_json(**args) : obj
    end

    private

    def set_time(field, time)
      return if time.nil?

      if time.is_a?(Integer)
        instance_variable_set("@#{field}", time)
      elsif TIMECODE_REGEX.match(time)
        instance_variable_set("@#{field}", timecode_to_milliseconds(time))
      else
        raise InvalidInput, "Input for #{field} should be an integer denoting milliseconds or a valid timecode."
      end
    end
  end
end

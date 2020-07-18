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

    attr_accessor :number, :text, :properties
    attr_reader :start_time, :end_time

    # Creates a new Cue class denoting a subtitle.
    def initialize(text: nil, start_time: nil, end_time: nil, cue_number: nil, properties: {})
      self.text = text
      self.start_time = start_time
      self.end_time = end_time
      self.number = cue_number
      self.properties = properties || {}
    end

    def self.from_json(json:)
      schema = {
        text!: :text,
        start_time!: :start_time,
        end_time!: :end_time,
        number!: :cue_number,
        properties: :properties,
      }
      data = {}
      schema.each do |mask, value|
        key = mask[-1] == '!' ? mask.to_s[0...-1] : mask.to_s
        raise InvalidJsonInput, "Cue missing field: #{key}" if key.to_s != mask.to_s && !json.key?(key)

        data[value] = json[key]
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
      if respond_to?(:instance_values) && instance_values.respond_to?(:as_json)
        instance_values.as_json(**args)
      else
        instance_variables.each_with_object({}) { |key, hash| hash[key[1..-1]] = instance_variable_get(key) }
      end
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

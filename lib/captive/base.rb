# frozen_string_literal: true

module Captive
  module Base
    module ClassMethods
      def from_file(filename:)
        file = File.new(filename, 'r:bom|utf-8')
        blob = file.read
        from_blob(blob: blob)
      ensure
        file&.close
      end

      def from_blob(blob:)
        new(cue_list: parse(blob: blob))
      end
    end

    def self.included(base)
      base.extend(ClassMethods)
      base.include(Util)
    end

    attr_accessor(:cue_list)

    def initialize(cue_list: nil)
      @cue_list = cue_list || []
    end

    def save_as(filename:)
      File.open(filename, 'w') do |file|
        file.write(to_s)
      end
    end

    def as_json(**args)
      results = {
        'version' => VERSION,
        'cues' => @cue_list.map(&:as_json),
      }
      if results.respond_to?(:as_json)
        results.as_json(**args)
      else
        results
      end
    end

    def method_missing(method_name, *_args)
      super unless (match = /^as_([a-z]+)$/.match(method_name))

      if valid_format?(match.captures.first.upcase)
        define_format_conversion(method_name, match.captures.first.upcase)
        send(method_name)
      elsif valid_format?(match.captures.first.capitalize)
        define_format_conversion(method_name, match.captures.first.capitalize)
        send(method_name)
      else
        super
      end
    end

    def respond_to_missing?(method_name, _)
      super unless (match = /^as_([a-z]+)$/.match(method_name))

      return true if valid_format?(match.captures.first.upcase) || valid_format?(match.captures.first.capitalize)

      super
    end

    private

    def base_klass
      base = self.class.to_s.split('::')
      Kernel.const_get(base.first)
    end

    def valid_format?(format)
      base_klass.const_defined?(format) && base_klass.const_get(format).include?(Base)
    end

    def define_format_conversion(method_name, format)
      self.class.define_method(method_name) do
        if self.class.to_s.split('::').last == format
          self
        else
          base_klass.const_get(format).new(cue_list: cue_list)
        end
      end
    end
  end
end

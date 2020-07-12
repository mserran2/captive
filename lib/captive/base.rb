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
  end
end

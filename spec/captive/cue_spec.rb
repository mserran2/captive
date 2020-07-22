# frozen_string_literal: true

require 'spec_helper'

module Captive
  describe Cue do
    include Util

    let(:start_time) { '00:00:01.500' }
    let(:end_time) { '00:00:02.500' }
    let(:text) { 'Hello Captive' }
    let(:properties) { {} }

    shared_examples 'valid cue' do
      it 'allows access to all its attributes' do
        expect(subject).not_to be nil
        expect(subject.class).to eq Cue

        expect(subject.start_time).to eql 1500
        expect(subject.end_time).to eql 2500
        expect(subject.duration).to eql 1000
        expect(subject.text).to eql text
      end
    end
    context 'when parsing a cue from JSON' do
      let(:args) do
        {
          json: {
            start_time: start_time,
            end_time: end_time,
            text: text,
            properties: properties,
          },
        }
      end
      subject { Cue.from_json(**args) }
      it_behaves_like 'valid cue'

      context 'when using a custom schema' do
        let(:args) do
          {
            json: {
              start: start_time,
              end: end_time,
              txt: text,
              props: properties,
            },
            mapping: {
              start_time: :start,
              end_time: :end,
              text: :txt,
              properties: :props,
            },
          }
        end
        it_behaves_like 'valid cue'
      end
    end

    context 'when a cue exists' do
      subject(:cue) { Cue.new(start_time: start_time, end_time: end_time, text: text) }

      context 'when adding text' do
        it 'appends new line before text being added if text is not nil' do
          cue.add_text('world')
          expect(cue.text.split("\n").count).to eq 2
        end

        context 'and the text is nil' do
          let(:text) { nil }
          it 'adds a newline before adding text' do
            cue.add_text('hello')
            expect(cue.text).to eq 'hello'
          end
        end
      end

      context 'when exporting' do
        it 'exports as JSON' do
          expect(cue.as_json).to include(
            'start_time' => cue.start_time,
            'end_time' => cue.end_time,
            'text' => cue.text,
            'properties' => cue.properties
          )
        end

        it 'exports as JSON with options requested' do
          expect(cue.as_json(options: { format: { time: :timecode } })).to include(
            'start_time' => timecode_to_milliseconds(start_time),
            'end_time' => timecode_to_milliseconds(end_time)
          )
        end
      end
    end
  end
end

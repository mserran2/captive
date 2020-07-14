# frozen_string_literal: true

require 'spec_helper'

module Captive
  describe VTT do
    let(:sample_file) { 'spec/samples/test.vtt' }

    context 'when parsing a file' do
      subject { VTT.from_file(filename: sample_file) }

      it 'has correct number of cues' do
        expect(subject.cues.count).to eq 3
      end

      it 'has the correct start times' do
        correct_values = [4080, 6400, 8300]
        expect(subject.cues.map(&:start_time)).to eq correct_values
      end

      it 'has the correct end times' do
        correct_values = [6320, 7880, 9400]
        expect(subject.cues.map(&:end_time)).to eq correct_values
      end

      it 'has correct text' do
        correct_values = [
          'Pick a card, any card!',
          'Well any card except that one.',
          "You ruined it.\nThanks a lot.",
        ]
        expect(subject.cues.map(&:text)).to eq correct_values
      end
    end
  end
end

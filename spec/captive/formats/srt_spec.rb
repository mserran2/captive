# frozen_string_literal: true

require 'spec_helper'

module Captive
  describe SRT do
    let(:sample_file) { 'spec/samples/test.srt' }

    context 'when parsing a file' do
      subject { SRT.from_file(filename: sample_file) }

      it 'has correct number of cues' do
        expect(subject.cue_list.count).to eq 2
      end

      it 'has the correct start times' do
        correct_values = [1600, 2767]
        expect(subject.cue_list.map(&:start_time)).to eq correct_values
      end

      it 'has the correct end times' do
        correct_values = [2684, 6021]
        expect(subject.cue_list.map(&:end_time)).to eq correct_values
      end

      it 'has correct text' do
        correct_values = [
          "Why does SRT use commas in timecodes\n1234",
          'But like really though?',
        ]
        expect(subject.cue_list.map(&:text)).to eq correct_values
      end
    end
  end
end

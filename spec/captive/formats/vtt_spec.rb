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

      it 'outputs its format correctly as a string' do
        file = File.open('spec/samples/parsed.vtt')
        expect(subject.to_s).to eql(file.read)
        file.close
      end

      it 'outputs and parses its format correctly as JSON' do
        vtt = VTT.from_json(json: subject.as_json)
        file = File.open('spec/samples/parsed.vtt')
        expect(vtt.to_s).to eql(file.read)
        file.close
      end
    end

    context 'when parsing from a blob' do
      let(:sample) do
        f = File.open(sample_file, 'r:bom|utf-8')
        blob = f.read
        f.close
        blob
      end
      context 'and the blob has a BOM' do
        let(:blob) { "\xEF\xBB\xBF#{sample}" }
        subject { VTT.from_blob(blob: blob) }

        it 'should detect the header and not raise an error' do
          expect { subject }.not_to raise_error
        end
      end
    end
  end
end

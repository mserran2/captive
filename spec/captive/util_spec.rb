# frozen_string_literal: true

require 'spec_helper'

module Captive
  describe Util do
    include Util

    context 'timecode_to_milliseconds' do
      it 'converts time code in HH:MM:SS.sss to milliseconds' do
        timecode = '00:01:00.300'
        expect(timecode_to_milliseconds(timecode)).to eq 60_300
      end

      it 'converts time code in MM:SS.sss to milliseconds' do
        timecode = '01:00.300'
        expect(timecode_to_milliseconds(timecode)).to eq 60_300
      end

      it 'converts time code in MM:SS.s' do
        timecode = '01:00.3'
        expect(timecode_to_milliseconds(timecode)).to eq 60_300
      end
    end

    context 'milliseconds_to_timecode' do
      it 'converts milliseconds to timecode format' do
        msec = 45_296_789
        expect(milliseconds_to_timecode(msec)).to eq '12:34:56.789'
      end
    end
  end
end

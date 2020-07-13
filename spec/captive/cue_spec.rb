# frozen_string_literal: true

require 'spec_helper'

module Captive
  describe Cue do
    it 'creates new cue' do
      t1 = '00:00:01.500'
      t2 = '00:00:02.500'
      cue = Cue.new(start_time: t1, end_time: t2)
      expect(cue).not_to be nil
      expect(cue.class).to eq Cue

      expect(cue.start_time).to eql 1500
      expect(cue.end_time).to eql 2500
      expect(cue.duration).to eql 1000
    end

    context 'add_text' do
      before :each do
        @cue = Cue.new
        expect(@cue.text).to be nil
      end

      it 'adds text' do
        @cue.add_text('hello')
        expect(@cue.text).to eq 'hello'
      end

      it 'appends new line before text being added if text is not nil' do
        @cue.add_text('hello')
        @cue.add_text('world')
        expect(@cue.text.split("\n").count).to eq 2
      end
    end
  end
end

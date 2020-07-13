# frozen_string_literal: true

require 'spec_helper'

module Captive
  class Formata
    include Base
  end
  class FORMATB
    include Base
  end

  describe Base do
    subject { Formata.new }

    it 'includes Util' do
      modules = subject.class.ancestors.select { |c| c.class == Module }
      expect(modules.include?(Util)).to be true
    end
    it 'exports as json' do
      expect(subject.as_json).to include('version' => VERSION, 'cues' => a_kind_of(Array))
    end

    context 'when converting to other methods' do
      it 'dynamically defines conversion methods to other methods' do
        expect(subject.as_formatb).to be_a(FORMATB)
      end

      it 'returns self when converting to itself' do
        expect(subject.as_formata).to eql(subject)
      end
    end
  end
end

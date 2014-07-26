require 'test_helper'

describe String do
  describe 'to_color' do
    it 'color is starting with a dash' do
      hex = '#0000ff'
      hex.to_color.hex.must_equal '0000ff'
    end

    it 'invalid hex color raise an error' do
      hex = 'this is invalid color'
      proc { hex.to_color }.must_raise RuntimeError
    end

    it 'accepts short version of hex color' do
      'fff'.to_color.hex.must_equal 'ffffff' 
    end
  end
end

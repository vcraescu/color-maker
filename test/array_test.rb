require 'test_helper'

describe Array do
  describe 'to_color' do
    it 'raise error if invalid color format' do
      a = []
      proc { a.to_color(:xxx) }.must_raise RuntimeError
    end

    it 'empty array return black' do
      a = []
      color = a.to_color
      color.hex.must_equal '000000'

      color = a.to_color(:hsv)
      color.hex.must_equal '000000'
    end

    it 'missing values assume they are 0' do
      a = [10, 10]
      color = a.to_color
      color.hex.must_equal '0a0a00'

      a = [200, 0.7]
      color = a.to_color(:hsv)
      color.hex.must_equal '000000'
    end

    it 'h: 200, s: 0.7, v: 0.4' do
      a = [200, 0.7, 0.4]
      color = a.to_color(:hsv)
      color.hex.must_equal '1e4e66'
    end

    it 'r: 255, g: 255, b: 255' do
      a = [255, 255, 255]
      color = a.to_color(:rgb)
      color.hex.must_equal 'ffffff'
    end

    it 'wrong format specified' do
      a = [255, 255, 255]
      color = a.to_color(:hsv)
      color.hex.must_equal '0000ff'
    end
  end
end

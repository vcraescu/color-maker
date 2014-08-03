require 'test_helper'

describe Hash do
  describe 'to_color' do
    it 'raise an error if format is not recognized' do
      proc { Hash.new.to_color(:xxx) }.must_raise RuntimeError
    end

    it 'all keys missing return black' do
      h = { x: 1, y: 2, c: 3 }
      color = h.to_color(:rgb)
      color.hex.must_equal '000000'

      color = h.to_color(:hsv)
      color.hex.must_equal '000000'
    end

    it 'some keys are missing, assume they are 0' do
      h = { r: 10, g: 10, x: 10 }
      color = h.to_color(:rgb)
      color.hex.must_equal '0a0a00'
    end

    it 'empty hash return black' do
      h = {}
      color = h.to_color(:hsv)
      color.hex.must_equal '000000'
    end

    it 'wrong format specified return black' do
      h = { r: 255, g: 255, b: 255 }
      color = h.to_color(:hsv)
      color.hex.must_equal '000000'
    end

    it 'h: 61, s: 0.30, l: 0.55' do
      h = { h: 61, s: 0.30, l: 0.55 }
      color = h.to_color(:hsl)
      color.hex.must_equal 'aeaf6a'
    end
    it 'replace key!' do
      h = { one: 1, two: 2 }
      h.replace_key!([:one, :two], :three)
      h.must_equal({ three: 2 })

      h = { one: 1, two: 2 }
      h.replace_key!(:one, :three).must_equal({three: 1, two: 2})
    end
  end
end

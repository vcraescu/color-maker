require 'test_helper'

describe Color::Maker::Support do
  it 'hsv to rgb' do
    rgb = Color::Maker::Support.hsv_to_rgb({ h: 12, s: 0.9, v: 0.2 })
    rgb.must_equal ({ r: 51, g: 14, b: 5 })

    rgb = Color::Maker::Support.hsv_to_rgb({ h: 30, s: 0.5, v: 0.9 })
    rgb.must_equal ({ r: 229, g: 172, b: 114 })
  end

  it 'hsv to color' do
    color = Color::Maker::Support.hsv_to_color({ h: 12, s: 0.9, v: 0.2 })
    color.must_equal Color::RGB.new(51, 14, 5)

    color = Color::Maker::Support.hsv_to_color({ h: 30, s: 0.5, v: 0.9 })
    color.must_equal Color::RGB.new(229, 172, 114)
  end

  it 'hex to color' do
    hex = '#0000ff'
    color = Color::Maker::Support.hex_to_color(hex)
    color.must_equal Color::RGB.by_hex(hex)
  end

  it 'string to color' do
    hex = '0000ff'
    color = hex.to_color
    color.must_equal Color::RGB.by_hex(hex)
  end
end

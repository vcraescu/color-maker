require 'test_helper'

describe Color::Maker::Support do
  it 'hsv to rgb' do
    rgb = Color::Maker::Support.hsv_to_rgb({ h: 12, s: 0.9, v: 0.2 })
    rgb.must_equal ({ r: 51, g: 14, b: 5 })

    rgb = Color::Maker::Support.hsv_to_rgb({ h: 30, s: 0.502, v: 0.898 })
    rgb.must_equal ({ r: 229, g: 172, b: 114 })
  end

  it 'hsv to color' do
    color = Color::Maker::Support.hsv_to_color({ h: 12, s: 0.9, v: 0.2 })
    color.must_equal Color::RGB.new(51, 14, 5)

    color = Color::Maker::Support.hsv_to_color({ h: 30, s: 0.502, v: 0.898 })
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

  it 'rgb to hsv' do
    hsv = Color::Maker::Support.rgb_to_hsv(r: 15, g: 193, b: 17)
    hsv.must_equal({ h: 120.7, s: 0.922, v: 0.757 })

    hsv = Color::Maker::Support.rgb_to_hsv(r: 25, g: 115, b: 189)
    hsv.must_equal({ h: 207.1, s: 0.868, v: 0.741 })
  end

  it 'rgb to hsl' do
    hsl = Color::Maker::Support.rgb_to_hsl(r: 15, g: 193, b: 17)
    hsl.must_equal({ h: 120.7, s: 0.856, l: 0.408 })

    hsl = Color::Maker::Support.rgb_to_hsl(r: 25, g: 115, b: 189)
    hsl.must_equal({ h: 207.1, s: 0.766, l: 0.42 })
  end

  it 'hsl to rgb' do
    rgb = Color::Maker::Support.hsl_to_rgb(h: 120.7, s: 0.856, l: 0.408)
    rgb.must_equal({ r: 15, g: 193, b: 17 })

    rgb = Color::Maker::Support.hsl_to_rgb(h: 207.1, s: 0.766, l: 0.42)
    rgb.must_equal({ r: 25, g: 115, b: 189 })

    rgb = Color::Maker::Support.hsl_to_rgb(h: 61, s: 0.30, l: 0.55)
    rgb.must_equal({ r: 174, g: 175, b: 106 })
  end

  it 'hsl to hsv' do
    hsv = Color::Maker::Support.hsl_to_hsv(h: 120.7, s: 0.856, l: 0.408)
    hsv.must_equal({ h: 120.7, s: 0.922, v: 0.757 })

    hsv = Color::Maker::Support.hsl_to_hsv(h: 207.1, s: 0.766, l: 0.42)
    hsv.must_equal({ h: 207.1, s: 0.868, v: 0.741 })
  end

  it 'hsv to hsl' do
    hsl = Color::Maker::Support.hsv_to_hsl(h: 120.7, s: 0.922, v: 0.757)
    hsl.must_equal({ h: 120.7, s: 0.856, l: 0.408 })

    hsl = Color::Maker::Support.hsv_to_hsl(h: 207.1, s: 0.868, v: 0.741)
    hsl.must_equal({ h: 207.1, s: 0.766, l: 0.42 })
  end
end

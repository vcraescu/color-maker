require "nice_color/version"
require 'active_support/core_ext/hash/keys'
require 'active_support/core_ext/object/try'
require 'color'
require 'yaml'

module NiceColor
  PHI = 0.618033988749895

  @colors_path = File.join(File.dirname(__FILE__), 'colors.yml')
  @make_color_default = {
    hue: nil,
    saturation: nil,
    value: nil,
    base_color: nil,
    greyscale: false,
    grayscale: false,
    golden: true,
    full_random: false,
    colors_returned: 1,
  }

  @make_scheme_default = {
    scheme_type: 'analogous',
    format: 'hex'
  }

  @make_contrast_default = {
    golden: false,
    format: 'hex'
  }

  class << self
    def from_name(name)
      name = name.downcase.to_sym
      raise 'Color name not recognized' if colors.key?(name.to_sym)
      Color::RGB.by_hex(colors[name.to_sym])
    end

    def make(options = {})
      options[:greyscale] ||= options.fetch(:grayscale, false)
      options = @make_color_default.merge(options)
      base_color = from_name(name) if options[:base_color]
      color = []
      options[:colors_returned].times do |i|
        random_hue = rand(0..360)
        if base_color
          base_color = base_color.to_hsl
          hue = rand((base_color.hue - 5), (base_color.hue + 5))
          saturation = rand(0.4..0.85)
          value = rand(0.4..0.85)
          color << hsv_to_color(h: hue, s: saturation, v: value)
        else
          # make hue golden
          if options[:greyscale]
            hue = 0
          elsif options[:golden]
            hue = (random_hue + (random_hue / PHI)) % 360
          elsif options[:hue].nil? || options[:full_random]
            hue = random_hue
          else
            hue = clamp(options[:hue], 0, 360)
          end

          # set saturation
          if options[:greyscale]
            saturation = 0
          elsif options[:full_random]
            saturation = rand(0..1.0)
          elsif options[:saturation].nil?
            saturation = 0.4
          else
            saturation = clamp(options[:saturation], 0, 1)
          end

          # set value
          if options[:full_random]
            value = rand(0..1.0)
          elsif options[:greyscale]
            value = rand(0.15..0.75)
          elsif options[:value].nil?
            value = 0.75
          else
            value = clamp(options[:value], 0, 1)
          end

          color << hsv_to_color(h: hue, s: saturation, v: value)
        end
      end

      color = color[0] if color.size == 1
    end

    private
    def hsv_to_rgb(hsv)
      h = hsv[:h] / 360
      s = hsv[:s]
      v = hsv[:v]
      i = (h * 6).floor
      f = h * 6 - i
      p = v * (1 - s)
      q = v * (1 - f * s)
      t = v * (1 - (1 - f) * s)
      case i % 6
      when 0
        r, g, b = v, t, p
      when 1
        r, g, b = q, v, p
      when 2
        r, g, b = p, v, t
      when 3
        r, g, b = p, q, v
      when 4
        r, g, b = t, p, v
      else
        r, g, b = v, p, q
      end
      
      r, g, b = (r * 255).floor, (g * 255).floor, (b * 255).floor
      { r: r, g: g, b: b }
    end

    def rgb_to_color(rgb)
      Color::RGB.new(rgb[:r], rgb[:g], rgb[:b])
    end

    def hsv_to_color(hsv)
      rgb = hsv_to_rgb(hsv)
      rgb_to_color(rgb)
    end

    def clamp(num, min, max)
      [min, [num, max].min].max
    end

    def colors
      return @colors if @colors
      @colors = YAML.load_file(@colors_path)
      @colors.symbolize_keys!
      @colors
    end
  end
end

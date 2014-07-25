require "color/maker/version"
require 'color/hash'
require 'color/string'
require 'color/array'
require 'color/maker'
require 'color/maker/support'
require 'active_support/core_ext/hash/keys'
require 'active_support/core_ext/object/try'
require 'color'
require 'yaml'

module Color
  class Maker
    PHI = 0.618033988749895
    attr_accessor :generator

    @colors_path = File.join(File.dirname(__FILE__), '..', 'colors.yml')

    @defaults = {
      hue: nil,
      saturation: nil,
      value: nil,
      base_color: nil,
      greyscale: false,
      grayscale: false,
      golden: true,
      random: false,
      count: 1,
      seed: false
    }

    class << self
      attr_accessor :defaults

      def colors
        return @colors if @colors
        @hex_colors = ::YAML.load_file(@colors_path)
        @hex_colors.symbolize_keys!
        @colors = Hash.new do |h, k|
          h[k] = Color::RGB.by_hex(@hex_colors[k])
        end
      end
    end

    def initialize(options = {})
      options[:greyscale] ||= options.fetch(:grayscale, false)
      @options = self.class.defaults.merge(options)
      @generator = Random.new(options[:seed]) rescue Random.new
    end

    def make(options = {})
      self.generator = Random.new(options[:seed]) if options[:seed]

      options[:greyscale] ||= options.fetch(:grayscale, false)
      options = self.class.defaults.merge(@options.merge(options))

      base_color = from_name(options[:base_color]) if options[:base_color]
      colors = []
      options[:count].times do |i|
        if base_color
          base_color = base_color.to_hsl
          hue = self.generator.rand((base_color.hue - 5)..(base_color.hue + 5))
          saturation = self.generator.rand(0.4..0.85)
          value = self.generator.rand(0.4..0.85)
          colors << [hue, saturation, value].to_color(:hsv)
        else
          hue = make_hue(options)
          saturation = make_saturation(options)
          value = make_value(options)

          colors << [hue, saturation, value].to_color(:hsv)
        end
      end

      colors = colors[0] if colors.size == 1
      colors
    end

    private
    def from_name(name)
      self.class.colors[name.downcase.to_sym]
    end

    def make_hue(options = {})
      if options[:greyscale]
        hue = 0
      elsif options[:golden]
        random_hue = self.generator.rand(0..360)
        hue = (random_hue + (random_hue / PHI)) % 360
      elsif options[:hue].nil? || options[:random]
        hue = random_hue
      else
        hue = clamp(options[:hue], 0, 360)
      end
      hue
    end

    def make_saturation(options = {})
      if options[:greyscale]
        saturation = 0
      elsif options[:random]
        saturation = self.generator.rand(0..1.0)
      elsif options[:saturation].nil?
        saturation = 0.4
      else
        saturation = clamp(options[:saturation], 0, 1)
      end

      saturation
    end

    def make_value(options = {})
      if options[:random]
        value = self.generator.rand(0..1.0)
      elsif options[:greyscale]
        value = self.generator.rand(0.15..0.75)
      elsif options[:value].nil?
        value = 0.75
      else
        value = clamp(options[:value], 0, 1)
      end

      value
    end

    def clamp(num, min, max)
      [min, [num, max].min].max
    end
  end
end

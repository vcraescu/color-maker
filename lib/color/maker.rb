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
        @colors = YAML.load_file(@colors_path)
        @colors.symbolize_keys!
        @colors
      end
    end

    def initialize(options = {})
      options[:greyscale] ||= options.fetch(:grayscale, false)
      @options = self.class.defaults.merge(options)
      @generator = Random.new(options[:seed]) rescue Random.new
    end

    def make(options = {})
      options[:greyscale] ||= options.fetch(:grayscale, false)
      options = self.class.defaults.merge(@options.merge(options))

      base_color = from_name(options[:base_color]) if options[:base_color]
      colors = []
      options[:count].times do |i|
        if base_color
          base_color = base_color.to_hsl
          hue = generator.rand((base_color.hue - 5)..(base_color.hue + 5))
          saturation = generator.rand(0.4..0.85)
          value = generator.rand(0.4..0.85)
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
      name = name.downcase.to_sym
      raise 'Color name not recognized' unless self.class.colors.key?(name.to_sym)
      Color::RGB.by_hex(self.class.colors[name.to_sym])
    end

    def make_hue(options = {})
      if options[:greyscale]
        hue = 0
      elsif options[:golden]
        random_hue = generator.rand(0..360)
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
        saturation = generator.rand(0..1.0)
      elsif options[:saturation].nil?
        saturation = 0.4
      else
        saturation = clamp(options[:saturation], 0, 1)
      end

      saturation
    end

    def make_value(options = {})
      if options[:random]
        value = generator.rand(0..1.0)
      elsif options[:greyscale]
        value = generator.rand(0.15..0.75)
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

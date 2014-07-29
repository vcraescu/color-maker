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
      options = normalize_options(options)
      #options[:greyscale] ||= options.fetch(:grayscale, false)
      @options = self.class.defaults.merge(options)
      @generator = Random.new(options[:seed]) rescue Random.new
    end

    def make(options = {})
      generator = self.generator
      generator = Random.new(options[:seed]) if options[:seed]

      options = normalize_options(options)
      #options[:greyscale] ||= options.fetch(:grayscale, false)
      options = self.class.defaults.merge(@options.merge(options))

      base_color = from_name(options[:base_color]) if options[:base_color]
      colors = []
      options[:count].times do |i|
        if base_color
          base_color = base_color.to_hsl
          base_color = Support::hsl_to_hsv(h: base_color.hue, s: base_color.s, l: base_color.l)

          hue = generator.rand((base_color[:h] - 5)..(base_color[:h] + 5))
          saturation = generator.rand(0.4..0.85)
          value = generator.rand(0.4..0.85)
          colors << [hue, saturation, value].to_color(:hsv)
        else
          hue = make_hue(options, generator)
          saturation = make_saturation(options, generator)
          value = make_value(options, generator)

          colors << [hue, saturation, value].to_color(:hsv)
        end
      end

      colors = colors[0] if colors.size == 1
      colors
    end

    private
    def normalize_options(options)
      normalized = {}

      variants = { hue: [:h], saturation: [:s], value: [:v], 
                   red: [:r], green: [:g], blue: [:b],
                   lightness: [:l, :luminosity, :light],
                   greyscale: [:grayscale, :gray] }

      variants.each do |key, keys|
        found_key = keys.find { |k| options[k] } || key
        normalized[key] ||= options[found_key] if options[found_key]
        options.delete(found_key) if normalized[key]
      end

      options.each { |key, value| normalized[key] = value unless normalized.key?(key) }
      normalized
    end

    def extract_color(options)
      formats = { :hsv => [:hue, :saturation, :value],
                  :rgb => [:red, :green, :blue ],
                  :hsl => [:hue, :saturation, :lightness] }

      format = formats.map do |key, keys| 
        [key, keys.count { |k| options[k] } ] 
      end
      format = format.max_by { |v| v.last }.first

      color = {}
      formats[format].each { |value| color[value] = options[value].to_f }

      case format
      when :rgb
        color = Support.rgb_to_hsv(color)
      when :hsl
        color = Support.hsl_to_hsv(color)
      end

      color
    end

    def from_name(name)
      self.class.colors[name.downcase.to_sym]
    end

    def make_hue(options = {}, generator = nil)
      generator ||= self.generator

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

    def make_saturation(options = {}, generator = nil)
      generator ||= self.generator

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

    def make_value(options = {}, generator = nil)
      generator ||= self.generator

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

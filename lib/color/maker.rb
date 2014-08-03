module Color
  # Create random pleasing colors as well as color schemes based on a given color.
  class Maker
    PHI = 0.618033988749895

    # Value generator, Random class instance
    attr_accessor :generator

    @colors_path = File.join(File.dirname(__FILE__), '..', 'colors.yml')

    # @!attribute [r]
    # Default color make options
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
      # @!macro color_maker_defaults
      #   @option options [Symbol] :hue (nil) By setting the hue, you determine the 
      #    color. (0..360)
      #   @option options [Symbol] :saturation (nil) By setting the saturation, you 
      #     determine the distance from gray. (0..1.0)
      #   @option options [Symbol] :value (nil) By setting the value, you determine 
      #     the balance between black and white. (0..1.0)
      #   @option options [Symbol] :base_color (nil) Setting a base_color (e.g. "pink") 
      #     will create a random color within the HSV range of the chosen color. 
      #     Will recognize any of the 146 standard HTML colors, it has a very
      #     good memory.
      #   @option options [Symbol] :greyscale (false) for the brits - Setting either 
      #     greyscale or grayscale (but we all know which one is correct) to true 
      #     will cause all of the colors you generate to be within the grey or gray 
      #     range. This is effectively the same as setting your saturation to 0.
      #   @option options [Symbol] :grayscale (false) for the yanks - Setting either 
      #     greyscale or grayscale (but we all know which one is correct) to true 
      #     will cause all of the colors you generate to be within the grey or gray 
      #     range. This is effectively the same as setting your saturation to 0.
      #   @option options [Symbol] :golden (true) Setting golden to true randomizes 
      #     your hue (overrides hue setting) and makes you a spectacular color 
      #     based on the golden ratio. It's so good, it's the default. Make sure to 
      #     turn it off if you want to have more control over your generated colors.
      #   @option options [Symbol] :random (false) It will completely randomize the 
      #     hue, saturation, and value of the colors it makes.
      #   @option options [Symbol] :count (1) Setting count to higher than 1 will 
      #     return an array full of the colors. If you set it to 1, you'll just get 
      #     the one color! It makes a sort of sense if you think about it.
      
      # @!macro color_maker_defaults_rgb
      #   @option options [Symbol] :red (nil) red value for the color to start with (0..255)
      #   @option options [Symbol] :green (nil) green value for the color to start with (0..255)
      #   @option options [Symbol] :blue (nil) blue value for the color to start with (0..255)

      # @!macro color_maker_defaults_hsl
      #   @option options [Symbol] :lightness (nil) the luminosity of the colour (0..1.0)

      # @!macro color_maker_defaults
      attr_reader :defaults

      # Memorized colors
      #
      # @return [Hash]
      # @example
      #   Color::Maker.colors(:aquamarine) #=> 7FFFD4
      def colors
        return @colors if @colors
        @hex_colors = ::YAML.load_file(@colors_path)
        @hex_colors.symbolize_keys!
        @colors = Hash.new do |h, k|
          if @hex_colors[k]
            h[k] = Color::RGB.by_hex(@hex_colors[k])
          else
            h[k] = Color::RGB.by_name(k)
          end
        end
      end

      # Return a Color::RGB object
      #
      # @param name [Symbol] css color name or from above list
      # @return Color::RGB
      # @example
      #   Color::Maker.by_name(:aquamarine) #=> Color::RGB
      #   Color::Maker.by_name(:blue) #=> Color::RGB
      #   Color::Maker.by_name(:aliceblue) #=> Color::RGB
      # {include:file:lib/colors.yml}
      def by_name(name)
        self.colors[name.downcase.to_sym]
      end
    end

    # @!macro color_maker_defaults
    # @!macro color_maker_defaults_rgb
    # @!macro color_maker_defaults_hsl
    def initialize(options = {})
      options = normalize_options(options)
      @options = self.class.defaults.merge(options)
      @generator = Random.new(options[:seed]) rescue Random.new
    end

    # Generates a new color
    # @param [Hash] options the options to generate the color
    # @!macro color_maker_defaults
    # @!macro color_maker_defaults_rgb
    # @!macro color_maker_defaults_hsl
    # @return Color::RGB
    def make(options = {})
      generator = self.generator
      generator = Random.new(options[:seed]) if options[:seed]

      options = normalize_options(options)
      options = self.class.defaults.merge(@options.merge(options))

      base_color = self.class.by_name(options[:base_color]) if options[:base_color]
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
      normalized.merge(extract_color(normalized))
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

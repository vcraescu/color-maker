module Color
  class Maker
    # Utilities methods
    module Support
      class << self
        # Convert color from HSV to RGB format
        #
        # @param [Hash] hsv 
        # @return [Hash] color in RGB format
        # @example
        #   Color::Maker::Support.hsv_to_rgb({ h: 12, s: 0.9, v: 0.2 }) #=> { r: 51, g: 14, b: 5 }
        #   Color::Maker::Support.hsv_to_rgb({ hue: 12, saturation: 0.9, value: 0.2 }) #=> { r: 51, g: 14, b: 5 }
        def hsv_to_rgb(hsv)
          hsv = normalize_color_keys(hsv, format: :hsv)
          h, s, v = hsv[:h].to_f / 360.0, hsv[:s].to_f, hsv[:v].to_f
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
          
          r, g, b = (r * 255).round(0), (g * 255).round(0), (b * 255).round(0)
          { r: r, g: g, b: b }
        end

        # Convert color from RGB to HSV
        #
        # @param [Hash] rgb
        # @return [Hash] color in HSV format
        # @example
        #   Color::Maker::Support.rgb_to_hsv({ r: 15, g: 193, b: 17 }) #=> { h: 120.7, s: 0.922, v: 0.757 }
        #   Color::Maker::Support.rgb_to_hsv({ red: 15, green: 193, blue: 17 }) #=> { h: 120.7, s: 0.922, v: 0.757 }
        def rgb_to_hsv(rgb)
          rgb = normalize_color_keys(rgb, format: :rgb)
          r, g, b = rgb[:r].to_f / 255.0, rgb[:g].to_f / 255.0, rgb[:b].to_f / 255.0  
          min, max = [r, g, b].min, [r, g, b].max
          delta = max - min
          v = max

          return { h: 0, s: 0, v: v.round(3) } if max == 0 || delta == 0

          s = delta / max
          h = 4 + (r - g) / delta

          if r == max
            h = (g - b) / delta
          elsif g == max
            h = 2 + (b - r) / delta
          end

          h *= 60
          h += 360 if h < 0
          { h: h.round(1), s: s.round(3), v: v.round(3) }
        end

        # Convert color from RGB to HSL
        #
        # @param [Hash] rgb
        # @return [Hash] color in HSL format
        # @example
        #   Color::Maker::Support.rgb_to_hsl({ r: 15, g: 193, b: 17 }) #=> { h: 120.7, s: 0.922, v: 0.757 }
        #   Color::Maker::Support.rgb_to_hsl({ red: 15, green: 193, blue: 17 }) #=> { h: 120.7, s: 0.922, v: 0.757 }
        def rgb_to_hsl(rgb)
          rgb = normalize_color_keys(rgb, format: :rgb)
          r, g, b = rgb[:r].to_f / 255.0, rgb[:g].to_f / 255.0, rgb[:b].to_f / 255.0  
          min, max = [r, g, b].min, [r, g, b].max
          delta = max - min

          l = (min + max) / 2.0
          return { h: 0, s: 0, l: l } if delta == 0

          s = l < 0.5 ? delta / (max + min) : delta / (2 - max - min)

          case(max)
          when r
            h = (g - b) / delta + (g < b ? 6 : 0)
          when g
            h = (b - r) / delta + 2
          when b
            h = (r - g) / delta + 4
          end

          h *= 60

          { h: h.round(1), s: s.round(3), l: l.round(3) }
        end

        # Convert color from HSL to RGB
        #
        # @param [Hash] hsl
        # @return [Hash] color in RGB format
        # @example 
        #   Color::Maker::Support.hsl_to_rgb({ h: 120.7, s: 0.856, l: 0.408 }) #=> { r: 15, g: 193, b: 17 }
        #   Color::Maker::Support.hsl_to_rgb({ hue: 120.7, saturation: 0.856, lightness: 0.408 }) #=> { r: 15, g: 193, b: 17 }
        def hsl_to_rgb(hsl)
          hsl = normalize_color_keys(hsl, format: :hsl)
          h, s, l = hsl[:h].to_f / 360.0, hsl[:s].to_f, hsl[:l].to_f
          return { r: l, g: l, b: l } if s == 0

          q = l < 0.5 ? l * (1 + s) : l + s - l * s
          p = 2 * l - q

          r = hue_to_rgb(p: p, q: q, t: h + 1 / 3.0) * 255
          g = hue_to_rgb(p: p, q: q, t: h) * 255
          b = hue_to_rgb(p: p, q: q, t: h - 1 / 3.0) * 255

          { r: r.round(0), g: g.round(0), b: b.round(0) }
        end

        # Convert color from HSV to HSL
        # 
        # @param [Hash] hsv
        # @return [Hash] color in HSL format
        # @example
        #   Color::Maker::Support.hsv_to_hsl({ h: 120.7, s: 0.922, v: 0.757 }) #=> { h: 120.7, s: 0.856, v: 0.408 })
        #   Color::Maker::Support.hsv_to_hsl({ hue: 120.7, saturation: 0.922, value: 0.757 }) #=> { h: 120.7, s: 0.856, v: 0.408 })
        def hsv_to_hsl(hsv)
          rgb = hsv_to_rgb(hsv)
          rgb_to_hsl(rgb)
        end

        # Convert color from HSL to HSV
        # 
        # @param [Hash] hsl
        # @return [Hash] color in HSL format
        # @example
        #   Color::Maker::Support.hsl_to_hsv({ h: 120.7, s: 0.856, l: 0.408 }) #=> { h: 120.7, s: 0.922, v: 0.757 })
        #   Color::Maker::Support.hsl_to_hsv({ hue: 120.7, saturation: 0.856, lightness: 0.408 }) #=> { h: 120.7, s: 0.922, v: 0.757 })
        def hsl_to_hsv(hsl)
          rgb = hsl_to_rgb(hsl)
          rgb_to_hsv(rgb)
        end

        # Convert color from HSL to Color::RGB
        #
        # @param [Hash] hsl
        # @return [Color::RGB] color
        # @example
        #   Color::Maker::Support.hsl_to_color({ h: 120.7, s: 0.856, l: 0.408 }) #=> Color::RGB
        #   Color::Maker::Support.hsl_to_color({ hue: 120.7, saturation: 0.856, lightness: 0.408 }) #=> Color::RGB
        def hsl_to_color(hsl)
          rgb = hsl_to_rgb(hsl)
          Color::RGB.new(rgb[:r], rgb[:g], rgb[:b])
        end

        # Convert color from RGB to Color::RGB
        # 
        # @param [Hash] rgb
        # @return [Color::RGB] color
        # @example
        #   Color::Maker::Support.rgb_to_color({ r: 100, g: 150, b: 250 }) #=> Color::RGB
        #   Color::Maker::Support.rgb_to_color({ red: 100, green: 150, blue: 250 }) #=> Color::RGB
        def rgb_to_color(rgb)
          rgb = normalize_color_keys(rgb, format: :rgb)
          Color::RGB.new(rgb[:r], rgb[:g], rgb[:b])
        end

        # Convert color from HSV to Color::RGB
        # 
        # @param [Hash] hsv
        # @return [Color::RGB] color
        def hsv_to_color(hsv)
          rgb = hsv_to_rgb(hsv)
          rgb_to_color(rgb)
        end

        # Convert color from HEX to Color::RGB
        # 
        # @param [Hash] hex
        # @return [Color::RGB] color
        def hex_to_color(hex)
          hex = hex.sub(/0x/, '')
          Color::RGB.by_hex(hex)
        end

        # Normalize color keys
        #
        # @param [Hash] hash values in HSV, RGB or HSL format
        # @param [Hash] options ({ format: :rgb, short: true })
        # @return [Hash] color keys normalized
        # @example
        #   Color::Maker::Support.normalize_color_keys({ r: 100, blue: 100, g: 100 }) #=> { r: 100, b: 100, g: 10 }
        #   Color::Maker::Support.normalize_color_keys({ r: 100, blue: 100, g: 100 }, short: false) #=> { red: 100, blue: 100, green: 10 }
        def normalize_color_keys(hash, options = {})
          default_options =  { format: :rgb, short: true }
          options = default_options.merge(options)

          format = options[:format].to_sym
            
          keys = {
            rgb: { [:r, :red] => [:r, :red], [:b, :blue] => [:b, :blue], [:g, :green] => [:g, :green] },
            hsv: { [:h, :hue] => [:h, :hue], [:s, :saturation] => [:s, :saturation], [:v, :value] => [:v, :value] },
            hsl: { [:h, :hue] => [:h, :hue], [:s, :saturation] => [:s, :saturation], [:l, :light] => [:l, :lightness, :luminosity, :light] }
          }

          return unless keys[format]

          normalized = hash.dup
          keys[format].each do |key, variants|
            default = options[:short] ? key.first : key.last
            normalized.replace_key!(variants, default)
          end

          normalized
        end

        private
        def hue_to_rgb(hue)
          p, q, t = hue[:p].to_f, hue[:q].to_f, hue[:t].to_f
          t += 1 if t < 0
          t -= 1 if t > 1
          return p + (q - p) * 6 * t if t < (1 / 6.0)
          return q if t < (1 / 2.0)
          return p + (q - p) * (2 / 3.0 - t) * 6 if t < (2 / 3.0)
          p
        end

      end
    end
  end
end

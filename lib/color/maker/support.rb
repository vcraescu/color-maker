module Color
  class Maker
    module Support
      class << self
        def hsv_to_rgb(hsv)
          h, s, v = hsv[:h] / 360.0, hsv[:s], hsv[:v]
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

        def hex_to_color(hex)
          hex = hex.delete('#')
          Color::RGB.by_hex(hex) 
        end

      end
    end
  end
end

module Color
  class Maker
    module Support
      class << self
        def hsv_to_rgb(hsv)
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

        def rgb_to_hsv(rgb)
          r, g, b = rgb[:r].to_f / 255.0, rgb[:g].to_f / 255.0, rgb[:b].to_f / 255.0  
          min, max = [r, g, b].min, [r, g, b].max
          delta = max - min
          v = max

          return { h: -1, s: 0, v: v } if max == 0

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

        def rgb_to_hsl(rgb)
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

        def hsl_to_rgb(hsl)
          h, s, l = hsl[:h].to_f / 360.0, hsl[:s].to_f, hsl[:l].to_f
          return { r: l, g: l, b: l } if s == 0

          q = l < 0.5 ? l * (1 + s) : l + s - l * s
          p = 2 * l - q

          r = hue_to_rgb(p: p, q: q, t: h + 1 / 3.0) * 255
          g = hue_to_rgb(p: p, q: q, t: h) * 255
          b = hue_to_rgb(p: p, q: q, t: h - 1 / 3.0) * 255

          { r: r.round(0), g: g.round(0), b: b.round(0) }
        end

        def hsv_to_hsl(hsv)
          rgb = hsv_to_rgb(hsv)
          rgb_to_hsl(rgb)
        end

        def hsl_to_hsv(hsl)
          rgb = hsl_to_rgb(hsl)
          rgb_to_hsv(rgb)
        end

        def hsl_to_color(hsl)
          rgb = hsl_to_rgb(hsl)
          Color::RGB.new(rgb[:r], rgb[:g], rgb[:b])
        end

        def hue_to_rgb(hue)
          p, q, t = hue[:p].to_f, hue[:q].to_f, hue[:t].to_f
          t += 1 if t < 0
          t -= 1 if t > 1
          return p + (q - p) * 6 * t if t < (1 / 6.0)
          return q if t < (1 / 2.0)
          return p + (q - p) * (2 / 3.0 - t) * 6 if t < (2 / 3.0)
          p
        end

        def rgb_to_color(rgb)
          Color::RGB.new(rgb[:r], rgb[:g], rgb[:b])
        end

        def hsv_to_color(hsv)
          rgb = hsv_to_rgb(hsv)
          rgb_to_color(rgb)
        end

        def hex_to_color(hex)
          hex = hex.delete('#').strip
          raise 'Invalid hex number' unless hex.hex?
          Color::RGB.by_hex(hex) 
        end
      end
    end
  end
end

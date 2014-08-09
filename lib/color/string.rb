# Monkey patch String class with color conversion utility methods
class String
  # Convert a String to color
  #
  # @param [Symbol] format color format (:hex, :html, :name)
  # @return Color::RGB
  # @example
  #   '0x0000ff'.to_color(:hex) #=> Color::RGB
  #   '#0000ff'.to_color(:html) #=> Color::RGB
  #   'aquamarine'.to_color(:name) #=> Color::RGB
  def to_color(format = :hex)
    format = format.to_sym

    if format == :hex
      text = self.sub(/0x/, '')
      return Color::RGB.by_hex(text)
    end

    if format == :html
      return Color::RGB.from_html(self)
    end

    if format == :name
      return Color::Maker.by_name(self)
    end
    
    raise "Unknown format: #{format}"
  end
end


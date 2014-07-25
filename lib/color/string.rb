class String
  def to_color
    Color::Maker::Support.hex_to_color(self)
  end
end


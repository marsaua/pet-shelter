module DogsHelper
  def render_field(label, value)
    return unless value.present?

    content_tag(:p) do
      concat content_tag(:span, "#{label}:", class: "fw-bold")
      concat " #{value}"
    end
  end
end

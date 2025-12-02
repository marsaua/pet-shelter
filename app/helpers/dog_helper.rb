module DogHelper
  def render_field(label, value)
    return unless value.present?

    content_tag(:p) do
      concat content_tag(:span, "#{label}:", class: "fw-bold")
      concat " #{value}"
    end
  end

  def health_status_options
    Dog.health_statuses.map { |key, value| [key.humanize, key] }
  end

  def status_options
    Dog.statuses.map { |key, value| [key.humanize, key] }
  end

  def aggressiveness_options
    Dog.agressivnesses.map { |key, value| [key.humanize, key] }
  end
end

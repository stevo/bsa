class ApplicationDecorator < Draper::Decorator

  delegate :content_tag, :t, to: :h

  def labeled(field, label=nil)
    content_tag(:p) do
      label_for(field, label) << ': ' << object.public_send(field)
    end
  end

  private

  def label_for(field, label=nil)
    content_tag(:strong, label || t("simple_form.labels.#{object.class.model_name.i18n_key.to_s}.#{field}"))
  end

  def widget_dom(widget)
    (widget == 'label' ? :span : :div)
  end
end

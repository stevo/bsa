class ApplicationDecorator < Draper::Decorator

  private

  def widget_dom(widget)
    (widget == 'label' ? :span : :div)
  end
end

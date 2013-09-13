class DatepickerInput < SimpleForm::Inputs::StringInput
  def input
    super.tap do
      input_html_classes.push 'datepicker'
    end
  end
end

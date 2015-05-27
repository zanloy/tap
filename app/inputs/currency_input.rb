# app/inputs/currency_input.rb
class CurrencyInput < SimpleForm::Inputs::Base
  def input
    content_tag(:div, :class => 'input-prepend') do
      content_tag(:span, '$', :class => 'add-on') +
      text_field(attribute_name, {:class => 'currency', :size => 7}.merge(input_html_options))
    end
  end
end

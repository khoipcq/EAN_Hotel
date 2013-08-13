module ReservationsHelper
  include ActionView::Helpers::TagHelper
  include ActionView::Helpers::OutputSafetyHelper 
  def result(content)
    raw content_tag :div, content, :class => "row-fluid row-bordered first"
  end
  
  def show_card_number(card_number)
    card_str = ""

    if !card_number.blank? && card_number.length >4
      length = card_number.length
      card_str = ('*' * (length-4)) + card_number[length - 4, 4]
    end
    card_str
  end
end

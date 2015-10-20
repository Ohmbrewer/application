module ApplicationHelper

  # Returns the full title on a per-page basis.
  # @param [String] page_title The specific page title to prepend to the base title
  # @return [String] The full title of the page
  def full_title(page_title = '')
    base_title = 'Ohmbrewer'
    if page_title.empty?
      base_title
    else
      "#{page_title} | #{base_title}"
    end
  end

  def js_back_button(back_or_cancel=:back)
    case back_or_cancel
      when :back
        link_to 'Back',
                'javascript:history.back()',
                class: 'btn btn-sm btn-primary',
                alt: 'Back',
                title: 'Back'
      when :cancel
        link_to 'Cancel',
                'javascript:history.back()',
                class: 'btn btn-sm btn-danger',
                alt: 'Cancel',
                title: 'Cancel'
      else
        link_to 'Back',
                'javascript:history.back()',
                class: 'btn btn-sm btn-primary',
                alt: 'Back',
                title: 'Back'
    end
  end

end

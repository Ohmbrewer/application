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

end

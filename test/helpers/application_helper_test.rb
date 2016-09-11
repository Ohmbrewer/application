require 'test_helper'

class ApplicationHelperTest < ActionView::TestCase
  def setup; end

  test 'shows default title' do
    assert_equal 'Ohmbrewer', full_title
  end

  test 'defaults to back button' do
    link_html = '<a class="btn btn-sm btn-primary" ' \
                'alt="Back" title="Back" ' \
                'href="javascript:history.back()">Back</a>'
    assert_equal link_html, js_back_button(:garbage)
  end
end

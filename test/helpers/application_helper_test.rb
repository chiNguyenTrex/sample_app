require "test_helper"

class ApplicationHelperTest < ActionView::TestCase
  def setup
    @base_title = I18n.t "layouts.application.base_title"
  end
  test "full title helper" do
    assert_equal full_title, @base_title
    assert_equal full_title(I18n.t("static_pages.help.help_title")),
      I18n.t("static_pages.help.help_title") + " | " + @base_title
  end
end

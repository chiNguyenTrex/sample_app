require "test_helper"

class UserTest < ActiveSupport::TestCase
  # Create an valid User model object. This method automatically
  # gets run before each test.
  def setup
    @user = User.new(name: "Le Chi Nguyen", email: "user@example.com")
  end

  # Test @user valid?
  test "should be valid" do
    assert @user.valid?
  end
end

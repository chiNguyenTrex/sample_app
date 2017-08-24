require "test_helper"

class PasswordResetsTest < ActionDispatch::IntegrationTest
  def setup
    ActionMailer::Base.deliveries.clear
    @user = users :michael
  end

  test "password resets" do
    post password_resets_path, params: {password_reset: {email: @user.email}}
    user = assigns :user
    get new_password_reset_path
    assert_template "password_resets/new"

    # Invalid password & confirmation
    patch password_reset_path(user.reset_token),
      params: {
        email: user.email,
        user: {
          password: "foobaz",
          password_confirmation: "barquux"
        }
      }
    assert_select "div#error_explanation"
    # Empty password
    patch password_reset_path(user.reset_token),
      params: {
        email: user.email,
        user: {
          password: "",
          password_confirmation: ""
        }
      }
    assert_select "div#error_explanation"
  end

  test "invalid email" do
    # Invalid email
    post password_resets_path, params: {password_reset: {email: ""}}
    assert_not flash.empty?
    assert_template "password_resets/new"
  end

  test "valid email" do
    # Valid email
    post password_resets_path, params: {password_reset: {email: @user.email}}
    assert_not_equal @user.reset_digest, @user.reload.reset_digest
    assert_equal 1, ActionMailer::Base.deliveries.size
    assert_not flash.empty?
    assert_redirected_to root_url
  end

  test "password reset form" do
    post password_resets_path, params: {password_reset: {email: @user.email}}
    user = assigns :user
    # Wrong email
    get edit_password_reset_path(user.reset_token, email: "")
    assert_redirected_to root_url
    # Inactive user
    user.update_attributes(activated: !user.activated)
    get edit_password_reset_path(user.reset_token, email: user.email)
    assert_redirected_to root_url
    user.update_attributes(activated: !user.activated)
    # Right email, wrong token
    get edit_password_reset_path("wrong token", email: user.email)
    assert_redirected_to root_url
    # Right email, right token
    get edit_password_reset_path(user.reset_token, email: user.email)
    assert_template "password_resets/edit"
    assert_select "input[name=email][type=hidden][value=?]", user.email
  end

  test "password confirmation reset" do
    post password_resets_path, params: {password_reset: {email: @user.email}}
    user = assigns :user
    # Valid password & confirmation
    patch password_reset_path(user.reset_token),
      params: {
        email: user.email,
        user: {
          password: "foobaz",
          password_confirmation: "foobaz"
        }
      }
    assert is_logged_in?
    assert_not flash.empty?
    assert_redirected_to user
  end
end

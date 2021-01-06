require "test_helper"

class RodauthTest < ActionDispatch::IntegrationTest
  test "create account" do
    rodauth = Rodauth::Rails.rodauth

    visit pages_index_path
    assert page.has_text?('You are not logged in')

    visit rodauth.create_account_path
    fill_in('login', with: 'test@example.com')
    fill_in('password', with: 'example')
    fill_in('password-confirm', with: 'example')
    click_button('Create Account')

    assert page.has_text?('test@example.com')

  end

  test "login" do
    rodauth = Rodauth::Rails.rodauth

    rodauth.new_account('test@example.com')
    rodauth.save_account
    rodauth.set_password('example')
    rodauth.verify_account

    visit rodauth.login_path
    fill_in('login', with: 'test@example.com')
    fill_in('password', with: 'example')
    click_button('Login')

    assert page.has_text?('test@example.com')

    visit rodauth.logout_path
    click_button('Logout')

    visit pages_index_path
    assert page.has_content?('You are not logged in')

    visit rodauth.login_path
    fill_in('login', with: 'test@example.com')
    fill_in('password', with: 'example')
    click_button('Login')

    assert page.has_content?('test@example.com')
  end
end

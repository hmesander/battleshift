require 'rails_helper'

describe 'Guest user' do
  context 'visits homepage' do
    it 'they can register for the game' do
      email_address = 'mymail@example.com'
      name = 'My Name'
      password = 'password1'

      visit root_path

      click_on 'Register'

      expect(current_path).to eq('/register')

      fill_in 'user[email_address]', with: email_address
      fill_in 'user[name]', with: name
      fill_in 'user[password]', with: password
      fill_in 'user[password_confirmation]', with: password

      click_on 'Submit'

      expect(current_path).to eq(dashboard_path(User.first))
      expect(page).to have_content("Logged in as #{name}")
      expect(page).to have_content('This account has not yet been activated. Please check your email.')
    end
  end

  context 'clicks activation link in email' do
    it 'they should activate their account' do
      email_address = 'mymail@example.com'
      name = 'My Name'
      password = 'password1'

      visit register_path

      fill_in 'user[email_address]', with: email_address
      fill_in 'user[name]', with: name
      fill_in 'user[password]', with: password
      fill_in 'user[password_confirmation]', with: password
      click_on 'Submit'

      test_session = Capybara.current_session.driver
      test_session.submit :get, "/activate/#{User.last.token}", nil

      expect(current_path).to eq(dashboard_path)
      expect(page).to have_content('Thank you! Your account is now activated.')
      expect(page).to have_content('Status: Active')
    end
  end
end

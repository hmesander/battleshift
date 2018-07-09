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

      # And when I fill in an email address (required)
      fill_in 'user[email_address]', with: email_address
      # And I fill in name (required)
      fill_in 'user[name]', with: name
      # And I fill in password and password confirmation (required)
      fill_in 'user[password]', with: password
      fill_in 'user[password_confirmation]', with: password

      click_on 'Submit'

      expect(current_path).to eq(dashboard_path)
      expect(page).to have_content("Logged in as #{name}")
      expect(page).to have_content('This account has not yet been activated. Please check your email.')
    end
  end
end

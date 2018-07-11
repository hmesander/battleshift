require 'rails_helper'

describe 'registered user' do
  describe 'register user visits home page' do
    it 'can login to their account' do
      user = create(:user, status: 'active')

      visit root_path

      click_on 'Log in'

      expect(current_path).to eq(login_path)

      fill_in 'email_address', with: user.email_address
      fill_in 'password', with: user.password

      within ('.login_form') do
        click_on 'Log in'
      end

      expect(current_path).to eq(dashboard_path)
      expect(page).to have_content(user.name)
    end
    
    it 'sees their name and logout' do
      user = create(:user, status: 'active')

      visit login_path

      fill_in 'email_address', with: user.email_address
      fill_in 'password', with: user.password

      within ('.login_form') do
        click_on 'Log in'
      end

      expect(page).to have_content(user.name)

      click_on 'Logout'

      expect(page).to_not have_content(user.name)
      expect(page).to have_content('Log in')
    end
  end
end

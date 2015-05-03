require 'rails_helper'

RSpec.feature "SignUps", type: :feature, js: true do
  let(:sign_up_container) { page.find("#sign-up")}
  let(:new_user) { build(:user) }
  scenario "All time zones" do

    visit "/#/sign_up"
    sign_up_container.fill_in "email", with: new_user.email
    sign_up_container.fill_in "password", with: "password"
    sign_up_container.fill_in "password-confirmation", with: "password"
    sign_up_container.click_on "Sign up"

    uri = URI.parse(current_url)
    expect(uri.fragment).to eq("/sign_in")
    current_user = User.find_by_email(new_user.email)
    expect(current_user).to_not eq(nil)
    expect(!!current_user.authenticate("password")).to eq(true)
  end
end

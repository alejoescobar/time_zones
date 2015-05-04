require 'rails_helper'

RSpec.feature "SignUps", type: :feature, js: true do
  let(:sign_up_container) { page.find("#sign-up")}
  let(:errors_container) { page.find(".errors")}

  let(:existing_user) { create(:user) }
  let(:new_user) { build(:user) }
  scenario "Sign up" do

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

  scenario "Already taken email" do
    visit "/#/sign_up"
    sign_up_container.fill_in "email", with: existing_user.email
    sign_up_container.fill_in "password", with: "password"
    sign_up_container.fill_in "password-confirmation", with: "password"
    sign_up_container.click_on "Sign up"

    uri = URI.parse(current_url)
    expect(uri.fragment).to eq("/sign_up")
    expect(errors_container).to have_content("email has already been taken")

    expect(User.where(email: existing_user.email).count).to eq(1)
  end
  

end

require 'rails_helper'

RSpec.feature "SignIns", type: :feature, js: true do

  let(:sign_in_container) { page.find("#sign-in")}
  let(:errors_container) { page.find(".errors")}

  let(:existing_user) { create(:user,password:"password") }
  let(:not_existing_user) { build(:user) }

  scenario "sign in with correct credentials" do
    visit "/#/sign_in"
    sign_in_container.fill_in "email", with: existing_user.email
    sign_in_container.fill_in "password", with: "password"
    sign_in_container.click_on "Sign in"

    expect(current_fragment).to eq("/time_zones")
    expect(existing_user.reload.auth_token).to_not eq(nil)

  end

  scenario "sign in with incorrect credentials" do
    visit "/#/sign_in"
    sign_in_container.fill_in "email", with: not_existing_user.email
    sign_in_container.fill_in "password", with: "password"
    sign_in_container.click_on "Sign in"

    expect(current_fragment).to eq("/sign_in")
    expect(errors_container).to have_content("Invalid email or password")
  end
end

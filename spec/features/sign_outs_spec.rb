require 'rails_helper'

RSpec.feature "SignOuts", type: :feature, js: true do

  let(:user) { create(:user,password: "password") }
  let(:navbar) { page.find(".navbar") }

  scenario "Sign out" do
    sign_in(user)
    visit "/#/time_zones"
    page.click_on user.email
    navbar.click_on "Sign out"

    expect(current_fragment).to eq("/sign_in")
  end

end

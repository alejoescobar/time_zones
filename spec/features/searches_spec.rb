require 'rails_helper'

RSpec.feature "Search time zones", type: :feature, js: true do
  scenario "finding time zones" do
    visit '/'

    fill_in "search-input", with: "bog"
    click_on "Search"

    expect(page).to have_content("bog")

 end
end

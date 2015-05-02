require 'rails_helper'

RSpec.feature "Search time zones", type: :feature, js: true do

  let(:time_zones) { TimeZone.all }
  let(:time_zones_container) { page.find("#time-zones")}

  context "list without search filter" do
    before do
      create_list(:time_zone,10)
    end

    scenario "All time zones" do

      visit "/"
      time_zones_container = page.find("#time-zones")
      time_zones.each do |t|
        expect(time_zones_container).to have_content(t.name)
      end

   end
  end
  context "3 time zones" do
    before do
      create(:time_zone,name: "Colombian time", city: "Bogotá")
      create(:time_zone,name: "Medellín time", city: "Medellín")
      create(:time_zone,name: "Western time", city: "San Francisco")
    end
    context "Search by name or city" do
      before do
        visit "/"
      end

      scenario "filter the time zones by name" do
        fill_in "search-input", with: "Col"
        click_on "Search"

        time_zones_container.assert_selector('.time-zone-item', count: 1)
        expect(time_zones_container).to have_content("Colombian time")
      end

      scenario "should filter the time zones by name case insensitive" do
        fill_in "search-input", with: "col"
        click_on "Search"

        time_zones_container.assert_selector('.time-zone-item', count: 1)
        expect(time_zones_container).to have_content("Colombian time")
      end

      scenario "should filter the time zones by city" do
        fill_in "search-input", with: "bog"
        click_on "Search"

        time_zones_container.assert_selector('.time-zone-item', count: 1)
        expect(time_zones_container).to have_content("Bogotá")

      end

      scenario "should allow special characters" do

        fill_in "search-input", with: "tá"
        click_on "Search"

        time_zones_container.assert_selector('.time-zone-item', count: 1)
        expect(time_zones_container).to have_content("Bogotá")

      end

      scenario "should ignore special characters in DB" do

        fill_in "search-input", with: "llin"
        click_on "Search"

        time_zones_container.assert_selector('.time-zone-item', count: 1)
        expect(time_zones_container).to have_content("Medellín")

      end

      scenario "should allow multiple search tokens" do

        fill_in "search-input", with: "med time"
        click_on "Search"

        time_zones_container.assert_selector('.time-zone-item', count: 1)
        expect(time_zones_container).to have_content("Medellín")

      end

      scenario "should trim the search string" do
        fill_in "search-input", with: "   med    time  "
        click_on "Search"

        time_zones_container.assert_selector('.time-zone-item', count: 1)
        expect(time_zones_container).to have_content("Medellín")
      end
    end

    context "bookmarked url" do
      scenario "filter the time zones by name" do
        visit "/#/?q=Col"

        time_zones_container.assert_selector('.time-zone-item', count: 1)
        expect(time_zones_container).to have_content("Colombian time")
      end
    end
  end

end

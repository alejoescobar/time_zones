require "rails_helper"

RSpec.describe TimeZonesController, type: :controller do

  describe "index" do

    let(:time_zones) { TimeZone.all }

    context "list without search filter" do
      before do
        create_list(:time_zone,10)
      end
      it "returns the list of all time zones" do
        get :index
        expect(response).to have_http_status(:success)
        result = JSON.parse(response.body)
        expect(result.length).to eq(time_zones.length)
      end
    end

    context "Search by name or city" do
      before do
        create(:time_zone,name: "Colombian time", city: "Bogotá")
        create(:time_zone,name: "Medellín time", city: "Medellín")
        create(:time_zone,name: "Western time", city: "San Francisco")
      end

      it "should filter the time zones by name" do
        get :index, q: "Col"

        expect(response).to have_http_status(:success)
        result = JSON.parse(response.body)

        expect(result.length).to eq(1)
        expect(result.first["name"]).to eq("Colombian time")
      end

      it "should filter the time zones by name case insensitive" do
        get :index, q: "col"

        expect(response).to have_http_status(:success)
        result = JSON.parse(response.body)

        expect(result.length).to eq(1)
        expect(result.first["name"]).to eq("Colombian time")
      end

      it "should filter the time zones by city" do
        get :index, q: "bog"

        expect(response).to have_http_status(:success)
        result = JSON.parse(response.body)

        expect(result.length).to eq(1)
        expect(result.first["city"]).to eq("Bogotá")
      end

      it "should allow special characters" do
        get :index, q: "tá"

        expect(response).to have_http_status(:success)
        result = JSON.parse(response.body)

        expect(result.length).to eq(1)
        expect(result.first["city"]).to eq("Bogotá")
      end

      it "should ignore special characters in DB" do
        get :index, q: "llin"

        expect(response).to have_http_status(:success)
        result = JSON.parse(response.body)

        expect(result.length).to eq(1)
        expect(result.first["city"]).to eq("Medellín")
      end

      it "should allow multiple search tokens" do
        get :index, q: "med time"

        expect(response).to have_http_status(:success)
        result = JSON.parse(response.body)

        expect(result.length).to eq(1)
        expect(result.first["city"]).to eq("Medellín")
      end

      it "should trim the search string" do
        get :index, q: "   med    time  "

        expect(response).to have_http_status(:success)
        result = JSON.parse(response.body)

        expect(result.length).to eq(1)
        expect(result.first["city"]).to eq("Medellín")
      end

    end



  end

end

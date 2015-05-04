require "rails_helper"

RSpec.describe TimeZonesController, type: :controller do

  describe "index" do

    context "user signed in" do
      let(:user) { create(:user_signed_in, password: "password") }
      let(:other_user) { create(:user_signed_in, password: "password") }
      before do
        set_auth_headers(user)
      end

      context "list without search filter" do
        before do
          create_list(:time_zone,10, user: user)
          create_list(:time_zone,10, user: other_user)
        end
        it "returns the list time zones asociated to user" do
          get :index
          expect(response).to have_http_status(:success)
          expect(body.length).to eq(user.time_zones.count)
          expect(body.map{|x| x["id"]}.sort).to eq(user.time_zones.pluck(:id).sort)
        end
      end

      context "Search by name or city" do
        before do
          create(:time_zone,name: "Colombian time", city: "Bogotá",user: user)
          create(:time_zone,name: "Medellín time", city: "Medellín",user: user)
          create(:time_zone,name: "Western time", city: "San Francisco",user: user)
        end

        it "should filter the time zones by name" do
          get :index, q: "Col"

          expect(response).to have_http_status(:success)

          expect(body.length).to eq(1)
          expect(body.first["name"]).to eq("Colombian time")
        end

        it "should filter the time zones by name case insensitive" do
          get :index, q: "col"

          expect(response).to have_http_status(:success)

          expect(body.length).to eq(1)
          expect(body.first["name"]).to eq("Colombian time")
        end

        it "should filter the time zones by city" do
          get :index, q: "bog"

          expect(response).to have_http_status(:success)

          expect(body.length).to eq(1)
          expect(body.first["city"]).to eq("Bogotá")
        end

        it "should allow special characters" do
          get :index, q: "tá"

          expect(response).to have_http_status(:success)

          expect(body.length).to eq(1)
          expect(body.first["city"]).to eq("Bogotá")
        end

        it "should ignore special characters in DB" do
          get :index, q: "llin"

          expect(response).to have_http_status(:success)

          expect(body.length).to eq(1)
          expect(body.first["city"]).to eq("Medellín")
        end

        it "should allow multiple search tokens" do
          get :index, q: "med time"

          expect(response).to have_http_status(:success)

          expect(body.length).to eq(1)
          expect(body.first["city"]).to eq("Medellín")
        end

        it "should trim the search string" do
          get :index, q: "   med    time  "

          expect(response).to have_http_status(:success)

          expect(body.length).to eq(1)
          expect(body.first["city"]).to eq("Medellín")
        end
      end
    end

    context "User not signed in" do
      let(:user) { create(:user_not_signed_in, password: "password") }
      it "responds with unauthorized" do
        get :index
        expect(response).to have_http_status(:unauthorized)
      end

    end
  end

end

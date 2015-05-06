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

  describe "create update and delete" do
    let(:user) { create(:user_signed_in, password: "password") }
    let(:other_user) { create(:user_signed_in, password: "password") }
    let(:time_zone) { build(:time_zone, user: user) }
    let(:time_zone_data) do
      {
        name: time_zone.name,
        city: time_zone.city,
        gmt_hour_diff: time_zone.gmt_hour_diff,
        gmt_minute_diff: time_zone.gmt_minute_diff
      }
    end
    context "signed in user" do
      before do
        set_auth_headers(user)
        create_list(:time_zone,10, user: user)
        create_list(:time_zone,10, user: other_user)
      end


      it "should create a time_zone" do
        post :create, time_zone_data
        expect(response).to have_http_status(:created)
        expect(user.time_zones.where(name: time_zone.name).take).to_not eq(nil)
      end

      it "should update a time_zone" do
        time_zone.save

        patch :update, {id: time_zone.id, name: "new name"}
        expect(response).to have_http_status(:ok)
        expect(time_zone.reload.name).to eq("new name")
      end

      it "should not allow update time_zones of other users" do
        other_time_zone = other_user.time_zones.first

        patch :update, {id: other_time_zone.id, name: "new name"}
        expect(response).to have_http_status(:forbidden)
        expect(other_time_zone.name).to eq(other_time_zone.reload.name)
      end


      it "should not update an invalid time_zone (name)" do
        time_zone.save

        patch :update, {id: time_zone.id, name: ""}
        expect(response).to have_http_status(:unprocessable_entity)
        expect(body).to have_key("name")
        expect(time_zone.name).to eq(time_zone.reload.name)
      end

      it "should not update an invalid time_zone (gmt_hour_diff)" do
        time_zone.save

        patch :update, {id: time_zone.id, gmt_hour_diff: "XX"}
        expect(response).to have_http_status(:unprocessable_entity)
        expect(body).to have_key("gmt_hour_diff")
        expect(time_zone.gmt_hour_diff).to eq(time_zone.reload.gmt_hour_diff)
      end

      it "should delete a time_zone" do
        time_zone.save

        delete :destroy, {id: time_zone.id}
        expect(response).to have_http_status(:no_content)
        expect(TimeZone.find_by_id(time_zone.id)).to eq(nil)
      end

      it "should not allow deletion of time_zones of other users" do
        other_time_zone = other_user.time_zones.first

        delete :destroy, {id: other_time_zone.id}
        expect(response).to have_http_status(:forbidden)
        expect(TimeZone.find_by_id(other_time_zone.id)).to_not eq(nil)

      end

    end

    context "not signed in user" do
      it "should not create a time_zone and repond with 401" do
        post :create, time_zone_data
        expect(response).to have_http_status(:unauthorized)
        expect(user.time_zones.where(name: time_zone.name).take).to eq(nil)
      end
    end

  end

end

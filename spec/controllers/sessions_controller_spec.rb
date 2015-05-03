require 'rails_helper'

RSpec.describe SessionsController, type: :controller do

  let(:user) { create(:user,password: "password") }
  let(:user_signed_in) { create(:user_signed_in,password: "password") }
  let(:user_not_signed_in) { create(:user_not_signed_in,password: "password") }

  let(:sign_in_params) do
    { email: user.email, password: "password" }
  end
  before do
    set_json_headers
  end
  describe "Sign in" do
    it "should return the auth token of the user" do
      post :create, sign_in_params

      expect(response).to have_http_status(:created)
      expect(body).to have_key("auth_token")
      expect(body).to_not have_key("password")
      expect(body).to_not have_key("password_digest")
      expect(body["auth_token"]).to eq(user.reload.auth_token)
    end

    it "should not change the auth token on sign in" do
      curr_auth_token = user_signed_in.auth_token
      post :create, {email: user_signed_in.email,password:"password"}

      expect(response).to have_http_status(:created)
      expect(body).to have_key("auth_token")
      expect(body["auth_token"]).to eq(curr_auth_token)
      expect(user_signed_in.reload.auth_token).to eq(curr_auth_token)
    end

    it "should not allow sign in with invalid credentials" do
      post :create, sign_in_params.merge(password:"wrongpass")

      expect(response).to have_http_status(:unauthorized)
      expect(body).to_not have_key("auth_token")

    end

  end

  describe "Sign out" do
    it "should delete auth_token" do
      set_auth_headers(user_signed_in)
      delete :destroy
      expect(response).to have_http_status(:ok)

      expect(user_signed_in.reload.auth_token).to eq(nil)

    end

    it "should respond unauthorized if user is not signed in" do
      set_auth_headers(user_not_signed_in)
      delete :destroy
      expect(response).to have_http_status(:unauthorized)

      expect(user_not_signed_in.reload.auth_token).to eq(nil)
    end
  end

  describe "get session" do
    context "user logged in" do
      it "should respond with the user info" do
        set_auth_headers(user_signed_in)
        get :show

        expect(response).to have_http_status(:ok)

      end
    end

    context "user not logged in" do
      it "should respond with the user info" do
        set_auth_headers(user_not_signed_in)
        get :show

        expect(response).to have_http_status(:unauthorized)

      end
    end

    context "incorrect credentials" do
      it "should respond with the user info" do
        request.headers["X-AUTH-EMAIL"] = user_signed_in.email
        request.headers["X-AUTH-TOKEN"] = user_signed_in.auth_token+"X"
        get :show

        expect(response).to have_http_status(:unauthorized)

      end
    end

  end

end

require "rails_helper"

RSpec.describe RegistrationsController, type: :controller do
  
  let(:sign_up_params) do
    { email: "pepe@mailinator.com", password: "password", password_confirmation: "password" }
  end

  describe "sign up" do

    it "should create a user" do
      post :create, sign_up_params, json_headers

      expect(response).to have_http_status(:created)

      expect(User.find_by_email(sign_up_params[:email])).to_not eq(nil)
    end

    it "should validate unique email" do

      post :create, sign_up_params, json_headers
      post :create, sign_up_params, json_headers

      expect(response).to have_http_status(:unprocessable_entity)
      expect(User.where(email: sign_up_params[:email]).count).to eq(1)
    end

    it "should validate presence of password" do
      user = {email:"pepe@mail.com"}
      post :create, user, json_headers

      expect(response).to have_http_status(:unprocessable_entity)
      expect(User.where(email: user[:email]).count).to eq(0)
    end

    it "should not allow blank password" do
      user = {email:"pepe@mail.com",password:"",password_confirmation:""}
      post :create, user, json_headers

      expect(response).to have_http_status(:unprocessable_entity)
      expect(User.where(email: user[:email]).count).to eq(0)
    end
  end

end

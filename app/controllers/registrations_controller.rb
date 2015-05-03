class RegistrationsController < ApplicationController
  # POST /users/sign_up
  def create
    user = User.new(sign_up_params)
    if user.save
      head :created
    else
      render json: user.errors, status: :unprocessable_entity
    end
  end

  protected
  def sign_up_params
    params.permit(:email,:password,:password_confirmation)
  end

end

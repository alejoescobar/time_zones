class TimeZonesController < ApplicationController
  before_action :authenticate_user!

  # GET /time_zones
  def index
    time_zones = current_user.time_zones
    if((q = params[:q]) && !q.blank?)
      time_zones = time_zones.by_name_or_city(q)
    end
    render json: time_zones
  end

  # POST /time_zones
  def create
    time_zone = current_user.time_zones.build(time_zone_params)

    if time_zone.save
      render json: time_zone, status: :created
    else
      render json: time_zone.errors, status: :unprocessable_entity
    end
  end

  # UPDATE /time_zones/:id
  def update

  end

  # DELETE /time_zones/:id
  def destroy
  end

  protected

  def time_zone_params
    params.permit(
      :name,:city,:gmt_hour_diff,:gmt_minute_diff
    )
  end
end

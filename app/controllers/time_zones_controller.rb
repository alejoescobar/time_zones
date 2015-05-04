class TimeZonesController < ApplicationController
  before_action :authenticate_user!

  def index
    time_zones = current_user.time_zones
    if((q = params[:q]) && !q.blank?)
      time_zones = time_zones.by_name_or_city(q)
    end
    render json: time_zones
  end
end

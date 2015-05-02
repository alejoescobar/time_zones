class TimeZonesController < ApplicationController
  def index
    time_zones = TimeZone.all
    if((q = params[:q]) && !q.blank?)
      time_zones = time_zones.by_name_or_city(q)
    end
    render json: time_zones
  end
end

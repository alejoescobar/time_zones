class TimeZonesController < ApplicationController
  def index
    time_zones = TimeZone.all
    if q = params[:q]
      query_string = q.split.join('%')
      time_zones = time_zones
        .where(%Q(
          LOWER(UNACCENT(name)) LIKE LOWER(UNACCENT(:q)) OR
          LOWER(UNACCENT(city)) LIKE LOWER(UNACCENT(:q))
        ),q: "%#{query_string}%")
    end
    render json: time_zones
  end
end

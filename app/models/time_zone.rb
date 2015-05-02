# == Schema Information
#
# Table name: time_zones
#
#  id              :integer          not null, primary key
#  name            :string
#  city            :string
#  gmt_hour_diff   :integer
#  gmt_minute_diff :integer
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#

class TimeZone < ActiveRecord::Base
  validates :name, presence: true
  validates :city, presence: true
  validates :gmt_hour_diff, presence: true, numericality: { only_integer: true}
  validates :gmt_minute_diff, presence: true, numericality: {
    only_integer: true, greater_than_or_equal_to: 0, less_than: 60 }

  scope :by_name_or_city, ->(q) do
    query_string = q.split.join('%')
    where(%Q(
      LOWER(UNACCENT(name)) LIKE LOWER(UNACCENT(:q)) OR
      LOWER(UNACCENT(city)) LIKE LOWER(UNACCENT(:q))
    ),q: "%#{query_string}%")
  end

end

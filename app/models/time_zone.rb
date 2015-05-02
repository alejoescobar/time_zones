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
end

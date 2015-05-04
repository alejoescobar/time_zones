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
#  user_id         :integer
#

FactoryGirl.define do
  factory :time_zone do
    name { Faker::Address.city }
    city { self.name }
    gmt_hour_diff { rand(24)-12 }
    gmt_minute_diff { [0,15,30][rand(3)] }
    user
  end

end

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

require 'rails_helper'

RSpec.describe TimeZone, type: :model do
  context 'validations' do
    it { should validate_presence_of :name }
    it { should validate_presence_of :city }

    it { should validate_presence_of :gmt_hour_diff }
    it { should validate_numericality_of(:gmt_hour_diff).only_integer }

    it { should validate_presence_of :gmt_minute_diff }
    it { should validate_numericality_of(:gmt_minute_diff).only_integer }
    it { should validate_numericality_of(:gmt_minute_diff).is_greater_than_or_equal_to 0 }
    it { should validate_numericality_of(:gmt_minute_diff).is_less_than 60 }
  end
  context 'factory' do
    it "should have a valid factory" do
      expect(build(:time_zone)).to be_valid
    end
  end
end

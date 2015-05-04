class AddUserToTimeZones < ActiveRecord::Migration
  def change
    add_reference :time_zones, :user, index: true
    add_foreign_key :time_zones, :users
  end
end

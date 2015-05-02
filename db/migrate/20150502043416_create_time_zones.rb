class CreateTimeZones < ActiveRecord::Migration
  def change
    create_table :time_zones do |t|
      t.string :name
      t.string :city
      t.integer :gmt_hour_diff
      t.integer :gmt_minute_diff

      t.timestamps null: false
    end
  end
end

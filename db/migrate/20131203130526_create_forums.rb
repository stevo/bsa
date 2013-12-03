class CreateForums < ActiveRecord::Migration
  def change
    create_table :forums do |t|
      t.string :name
      t.string :url
      t.string :login_url
      t.string :meeting_url
      t.boolean :state
      t.string :user
      t.string :password

      t.timestamps
    end
  end
end

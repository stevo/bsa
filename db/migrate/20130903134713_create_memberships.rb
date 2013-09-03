class CreateMemberships < ActiveRecord::Migration
  def change
    create_table :memberships do |t|
      t.integer :user_id
      t.date :approved_at
      t.decimal :monthly_contribution
      t.string :state

      t.timestamps
    end
  end
end

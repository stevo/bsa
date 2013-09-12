class AddFieldsToContributions < ActiveRecord::Migration
  def change
    add_column :contributions, :expires_at, :date
    add_column :contributions, :membership_id, :integer
  end
end

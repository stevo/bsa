class AddStateToEvents < ActiveRecord::Migration
  def change
    add_column :events, :state, :string, default: 'new', null: false
  end
end

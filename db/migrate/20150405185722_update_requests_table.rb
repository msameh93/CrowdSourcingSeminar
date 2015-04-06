class UpdateRequestsTable < ActiveRecord::Migration
  def change
  	change_column :requests, :sender_id, :integer
  	change_column :requests, :receiver_id, :integer
  	add_column :requests, :category_id, :integer
  end
end

class RemoveUserIdFromLessons < ActiveRecord::Migration[7.0]
  def change
    remove_column :lessons, :user_id, :integer
  end
end

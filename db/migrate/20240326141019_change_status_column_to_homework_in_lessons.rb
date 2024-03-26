class ChangeStatusColumnToHomeworkInLessons < ActiveRecord::Migration[7.0]
  def change
    remove_column :lessons, :status
    add_column :lessons, :homework, :text
  end
end

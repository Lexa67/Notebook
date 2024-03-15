class AddFieldsToLessons < ActiveRecord::Migration[7.0]
  def change
    add_column :lessons, :status, :string
    add_column :lessons, :paid, :boolean
    add_column :lessons, :confirmed, :boolean
  end
end

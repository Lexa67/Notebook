class AddImageToLessons < ActiveRecord::Migration[7.0]
  def change
    add_column :lessons, :image, :string
  end
end

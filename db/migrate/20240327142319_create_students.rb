class CreateStudents < ActiveRecord::Migration[7.0]
  def change
    create_table :students do |t|
      t.references :user, null: false, foreign_key: true
      t.string :name
      t.decimal :price

      t.timestamps
    end
  end
end

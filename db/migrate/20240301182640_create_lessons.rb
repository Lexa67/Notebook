class CreateLessons < ActiveRecord::Migration[7.0]
  def change
    create_table :lessons do |t|
      t.datetime :lesson_date
      t.references :student, null: false, foreign_key: true
      t.boolean :paid
      t.boolean :confirmed
      t.text :homework

      t.timestamps
    end
  end
end

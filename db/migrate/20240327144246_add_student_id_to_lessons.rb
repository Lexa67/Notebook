class AddStudentIdToLessons < ActiveRecord::Migration[7.0]
  def change
    add_reference :lessons, :student, null: false, foreign_key: true
  end
end

class Lesson < ApplicationRecord
  belongs_to :user

  def not_started?
    current_time = Time.now
    lesson_date > current_time
  end
end

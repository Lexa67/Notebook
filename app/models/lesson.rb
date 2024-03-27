class Lesson < ApplicationRecord
  belongs_to :student
  before_validation :set_defaults

  validates :lesson_date, presence: true
  validates :student_id, presence: true
  
  def not_started?
    current_time = Time.now
    lesson_date < current_time
  end

  private
  
  def set_defaults
    self.paid ||= false
    self.confirmed ||= false
  end
end

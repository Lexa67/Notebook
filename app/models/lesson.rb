class Lesson < ApplicationRecord
  belongs_to :user
  before_validation :set_defaults
  
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

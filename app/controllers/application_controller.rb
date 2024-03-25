class ApplicationController < ActionController::Base
  def total_price
    @lessons = Lesson.all

    @lessons = @lessons.where(user_id: params[:user_id]) if params[:user_id].present?
    @lessons = @lessons.where(lesson_date: Date.parse(params[:start_date])..Date.parse(params[:end_date]).end_of_day) if params[:start_date].present? && params[:end_date].present?
    @lessons = @lessons.where(paid: params[:paid]) if params[:paid].present?

    @lessons = @lessons.order(lesson_date: :desc)

    @lessons = @lessons.page(params[:page]).per(10)
    
    @total_price = 0
    @not_paid_total_price = 0

    @lessons.each do |lesson|
      if lesson.paid?
        if lesson.not_started?
        @total_price += lesson.user.price
        end
      else
        if lesson.not_started?
        @not_paid_total_price += lesson.user.price
        end
      end
    end
  end    
end

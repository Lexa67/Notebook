class ApplicationController < ActionController::Base
  before_action :configure_permitted_parameters, if: :devise_controller?
  
  def after_sign_in_path_for(resource)
    if resource.admin?
      users_path
    else resource.teacher?
      lessons_path
    end
  end

  def total_price
    @lessons = Lesson.where(student_id: current_user.students.ids)

    @lessons = @lessons.where(student_id: params[:student_id]) if params[:student_id].present?
    @lessons = @lessons.where(lesson_date: Date.parse(params[:start_date])..Date.parse(params[:end_date]).end_of_day) if params[:start_date].present? && params[:end_date].present?
    @lessons = @lessons.where(paid: params[:paid]) if params[:paid].present?

    @lessons = @lessons.order(lesson_date: :desc)

    @lessons = @lessons.page(params[:page]).per(10)
    
    @total_price = 0
    @not_paid_total_price = 0

    @lessons.each do |lesson|
      if lesson.paid?
        if lesson.not_started?
        @total_price += lesson.student.price
        end
      else
        if lesson.not_started?
        @not_paid_total_price += lesson.student.price
        end
      end
    end
  end    

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:name])
    devise_parameter_sanitizer.permit(:account_update, keys: [:name])
  end
  
end

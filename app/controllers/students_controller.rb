class StudentsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_student, only: %i[ show edit update destroy ]

  def index
    if current_user.role == "admin" && params[:user_id].present?
      @students = Student.where(user_id: params[:user_id])
    elsif current_user.role == "teacher"
      @students = Student.where(user_id: current_user.id)
    else
      @students = Student.all.order(:name)
    end
  end

  def show
    @lessons = Lesson.where(student_id: @student.id).order(lesson_date: :desc)
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

  def new
    @student = Student.new
  end

  def edit
  end

  def create
    @student = Student.new(student_params)
    @student.user_id = current_user.id

    if @student.save
      flash[:notice] = "Student was successfully created."
      redirect_to students_path
    else
      flash[:alert] = "Error: Student could not be created."
      redirect_to new_student_path
    end
  end

  def update
    if @student.update(student_params)
      flash[:notice] = "Student was successfully updated."
      redirect_to student_path(@student)
    else
      flash[:alert] = "Error: Student could not be updated."
      redirect_to student_url(@student)
    end
  end

  def destroy
    @student.destroy

    respond_to do |format|
      format.html { redirect_to students_url, notice: "Student was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    def set_student
      @student = Student.find(params[:id])
    end

    def student_params
      params.require(:student).permit(:user_id, :name, :price)
    end
end

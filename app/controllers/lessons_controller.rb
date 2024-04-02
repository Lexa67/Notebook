class LessonsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_lesson, only: %i[ show edit update destroy toggle_paid toggle_confirmed]
  before_action :total_price, only: [:index]

  def index
  end

  def show
  end

  def new
    @lesson = Lesson.new
  end

  def edit
  end

  def create
    @lesson = Lesson.new(lesson_params)
    if @lesson.save
      flash[:notice] = "Lesson was successfully created."
      redirect_to lesson_path(@lesson)
    else
      flash[:alert] = "Error: Lesson could not be created."
      redirect_to new_lesson_path
    end
  end
  
  def update
    if @lesson.update(lesson_params)
      flash[:notice] = "Lesson was successfully updated."
      redirect_to lesson_path(@lesson)
    else
      flash[:alert] = "Error: Lesson could not be updated."
      redirect_to lesson_url(@lesson)
    end
  end

  def destroy
    if @lesson.destroy
      flash[:notice] = "Lesson was successfully deleted."
      redirect_to lessons_url
    end
  end
  
  def filter_by_date
    start_date = params[:start_date]
    end_date = params[:end_date]
    @lessons = Lesson.where(lesson_date: start_date..end_date)
  end

  def toggle_paid
    @lesson.toggle!(:paid)
    redirect_back(fallback_location: lessons_path)
  end

  def toggle_confirmed
    @lesson.toggle!(:confirmed)
    redirect_back(fallback_location: lessons_path)
  end

  def create_next_lesson
    original_lesson = Lesson.find(params[:lesson_id])

    next_week_date = original_lesson.lesson_date.advance(weeks: 1).beginning_of_week(:sunday)

    next_week_date = next_week_date.advance(days: days_until(original_lesson.lesson_date, next_week_date))

    new_lesson = Lesson.new(lesson_date: next_week_date.change(hour: original_lesson.lesson_date.hour, min: original_lesson.lesson_date.min), student_id: original_lesson.student_id)

    if new_lesson.save
      redirect_to new_lesson
    else
      redirect_to lessons_path
    end
  end

  def homework
    @lessons = Lesson.where(student_id: params[:student_id]).order(lesson_date: :desc)
  end

  private
  
  def set_lesson
    if params[:id] == "by_date"
      @lessons = Lesson.where("DATE(lesson_date) = ?", params[:date]).order(date: :desc)
    else
      @lesson = Lesson.find(params[:id])
    end
  end

  def lesson_params
    params.require(:lesson).permit(:lesson_date, :student_id, :homework)
  end

  def days_until(original_date, next_date)
    days = (original_date.wday - next_date.wday) % 7
    days += 7 if days.negative?
    days
  end
end
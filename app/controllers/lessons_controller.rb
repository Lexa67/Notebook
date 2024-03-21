class LessonsController < ApplicationController
  before_action :set_lesson, only: %i[ show edit update destroy toggle_paid toggle_confirmed]
  before_action :total_price, only: [:index]

  # GET /lessons or /lessons.json
  
  def index
  end


  # GET /lessons/1 or /lessons/1.json
  def show
  end

  # GET /lessons/new
  def new
    @lesson = Lesson.new
  end

  # GET /lessons/1/edit
  def edit
  end

  # POST /lessons or /lessons.json
  def create
    @lesson = Lesson.new(lesson_params)

    respond_to do |format|
      if @lesson.save
        format.html { redirect_to lesson_url(@lesson), notice: "Lesson was successfully created." }
        format.json { render :show, status: :created, location: @lesson }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @lesson.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /lessons/1 or /lessons/1.json
  def update
    respond_to do |format|
      if @lesson.update(lesson_params)
        format.html { redirect_to lesson_url(@lesson), notice: "Lesson was successfully updated." }
        format.json { render :show, status: :ok, location: @lesson }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @lesson.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /lessons/1 or /lessons/1.json
  def destroy
    @lesson.destroy

    respond_to do |format|
      format.html { redirect_to lessons_url, notice: "Lesson was successfully destroyed." }
      format.json { head :no_content }
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
    # Находим урок, который нужно продублировать
    original_lesson = Lesson.find(params[:lesson_id])

    # Добавляем неделю к дате и находим ближайшее следующее воскресенье
    next_week_date = original_lesson.lesson_date.advance(weeks: 1).beginning_of_week(:sunday)

    # Находим ближайший день с тем же днем недели, что и оригинальный урок
    next_week_date = next_week_date.advance(days: days_until(original_lesson.lesson_date, next_week_date))

    # Создаем новый урок на следующей неделе в тот же день недели и том же времени с тем же учеником
    new_lesson = Lesson.new(lesson_date: next_week_date.change(hour: original_lesson.lesson_date.hour, min: original_lesson.lesson_date.min), user_id: original_lesson.user_id)

    # Сохраняем новый урок
    if new_lesson.save
      redirect_to new_lesson
    else
      redirect_to lessons_path
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_lesson
      if params[:id] == "by_date"
        @lessons = Lesson.where("DATE(lesson_date) = ?", params[:date]).order(date: :desc)
      else
        @lesson = Lesson.find(params[:id])
      end
    end

    # Only allow a list of trusted parameters through.
    def lesson_params
      params.require(:lesson).permit(:lesson_date, :user_id)
    end

    def total_price
      if params[:start_date].present? && params[:end_date].present? && params[:user_id].present?
        start_date = Date.parse(params[:start_date])
        end_date = Date.parse(params[:end_date]).end_of_day
        @lessons = Lesson.where(lesson_date: start_date..end_date, user_id: params[:user_id]).order(:lesson_date).page(params[:page]).per(10)
      elsif params[:start_date].present? && params[:end_date].present?
        start_date = Date.parse(params[:start_date])
        end_date = Date.parse(params[:end_date]).end_of_day
        @lessons = Lesson.where(lesson_date: start_date..end_date).order(lesson_date: :desc).page(params[:page]).per(10)
      elsif params[:user_id].present?
        @lessons = Lesson.where(user_id: params[:user_id]).order(lesson_date: :desc).page(params[:page]).per(10)
      elsif params[:paid].present?
        if params[:paid] == "true"
          @lessons = Lesson.where(paid: true).order(lesson_date: :desc).page(params[:page]).per(10)
        else
          @lessons = Lesson.where(paid: false).order(lesson_date: :desc).page(params[:page]).per(10)
        end
      else
        @lessons = Lesson.all.order(lesson_date: :desc).page(params[:page]).per(10)
      end
     
      @total_price = 0

      @lessons.each do |lesson|
        if lesson.paid?
          if lesson.not_started?
          @total_price += lesson.user.price
          end
        end
      end

      @not_paid_total_price = 0

      @lessons.each do |lesson|
        unless lesson.paid?
          if lesson.not_started?
          @not_paid_total_price += lesson.user.price
          end
        end
      end
    end

    def days_until(original_date, next_date)
      days = (original_date.wday - next_date.wday) % 7
      days += 7 if days.negative? # Если результат отрицательный, добавляем 7 для получения положительного значения
      days
    end
end

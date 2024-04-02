class StudentsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_student, only: %i[ show edit update destroy ]

  # GET /students or /students.json
  def index
    if current_user.role == "admin" && params[:user_id].present?
      @students = Student.where(user_id: params[:user_id])
    elsif current_user.role == "teacher"
      @students = Student.where(user_id: current_user.id)
    else
      @students = Student.all.order(:name)
    end
  end

  # GET /students/1 or /students/1.json
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

  # GET /students/new
  def new
    @student = Student.new
  end

  # GET /students/1/edit
  def edit
  end

  # POST /students or /students.json
  def create
    @student = Student.new(student_params)
    @student.user_id = current_user.id

    respond_to do |format|
      if @student.save
        format.html { redirect_to student_url(@student), notice: "Student was successfully created." }
        format.json { render :show, status: :created, location: @student }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @student.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /students/1 or /students/1.json
  def update
    respond_to do |format|
      if @student.update(student_params)
        format.html { redirect_to student_url(@student), notice: "Student was successfully updated." }
        format.json { render :show, status: :ok, location: @student }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @student.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /students/1 or /students/1.json
  def destroy
    @student.destroy

    respond_to do |format|
      format.html { redirect_to students_url, notice: "Student was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_student
      @student = Student.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def student_params
      params.require(:student).permit(:user_id, :name, :price)
    end
end

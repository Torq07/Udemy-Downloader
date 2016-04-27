class CoursesController < ApplicationController
  before_action :set_course, only: [:show, :edit, :update, :destroy]
  before_filter :authenticate_user! 
  # GET / eurses
  # GET /courses.json
  def index
    @courses = Course.all
  end

  # GET /courses/1
  # GET /courses/1.json
  def show
  end

  # GET /courses/new
  def new
    @course = Course.new
  end

  # GET /courses/1/edit
  def edit
    # @download_file
  end

  # POST /courses
  # POST /courses.json
  def create
    unless Course.find_by(url: course_params['url'].strip)
      @course = Course.new(course_params)
      @course.name = course_params['url'].split('/')[3].gsub('-',' ').capitalize
      respond_to do |format|
        if @course.save
          format.html { redirect_to @course, notice: 'Course was successfully created.' }
          format.json { render :show, status: :created, location: @course }
        else
          format.html { render :new }
          format.json { render json: @course.errors, status: :unprocessable_entity }
        end
      end
      
      call_rake :upload,  :course_url => course_params['url'], 
                          :name => @course.name.gsub(' ','-'),
                          :udemy_name=>@udemy_account.udemy_username, 
                          :udemy_password=>@udemy_account.udemy_password,
                          :course_id=>@course.id
    else
      redirect_to :back,  alert: 'Course already exist'  
    end  
  end

  # PATCH/PUT /courses/1
  # PATCH/PUT /courses/1.json
  def update
    respond_to do |format|
      if @course.update(course_params)
        format.html { redirect_to @course, notice: 'Course was successfully updated.' }
        format.json { render :show, status: :ok, location: @course }
      else
        format.html { render :edit }
        format.json { render json: @course.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /courses/1
  # DELETE /courses/1.json
  def destroy
    @course.destroy
    respond_to do |format|
      format.html { redirect_to courses_url, notice: 'Course was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def udemy
    account=params['udemy_account']
    UdemyAccount.create(udemy_username:account['udemy_username'] ,udemy_password:account['udemy_password'] ,user_id:current_user.id)
    redirect_to :back
  end

  def udemy_destroy
    @udemy_account.destroy
    redirect_to :back
  end


  private
    # Use callbacks to share common setup or constraints between actions.
    def set_course
      @course = Course.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def course_params
      params.require(:course).permit(:name, :url)
    end

end

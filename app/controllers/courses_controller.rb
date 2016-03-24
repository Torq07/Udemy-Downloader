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
    @download_file
  end

  # POST /courses
  # POST /courses.json
  def create
    @course = Course.new(course_params)
    # call_rake :upload_course, :course_url => course_params['url']
    system('rake upload course_url=https://www.udemy.com/become-an-android-developer-from-scratch/learn/ >/dev/null &')
    respond_to do |format|
      if @course.save
        format.html { redirect_to @course, notice: 'Course was successfully created.' }
        format.json { render :show, status: :created, location: @course }
      else
        format.html { render :new }
        format.json { render json: @course.errors, status: :unprocessable_entity }
      end
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

  def pdf
    require 'open-uri'
    url = 'https://udemy-assets-on-demand.udemy.com/2014-11-30_17-32-22-6fb22fa93c8d804cde2dc99e95b68a29/d1e03564-c66f-4f97-9610-7504a8dff0ca.pdf?nva=20160321172359&download=True&filename=GetTheMost.pdf&token=0a7a19c98ce57cab8f413'
    data = open(url, :http_basic_authentication => ['torq07@gmail.com' ,'wry135qa'], :ssl_verify_mode => OpenSSL::SSL::VERIFY_NONE).read
    send_data data, :disposition => 'attachment', :filename=>"test.pdf"
    # send_file open("https://udemy-assets-on-demand.udemy.com/2014-11-30_17-32-22-6fb22fa93c8d804cde2dc99e95b68a29/d1e03564-c66f-4f97-9610-7504a8dff0ca.pdf?nva=20160321172359&download=True&filename=GetTheMost.pdf&token=0a7a19c98ce57cab8f413"), :type=>"application/pdf", :x_sendfile=>true
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

    def download_course(url)
      exec("udemy-dl -u torq07@gmail.com -p wry135qa --lecture-start 1 --lecture-end 1  #{url}")
    end


   
end

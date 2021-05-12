require "git"
require 'find'
require 'squid'
require 'uri'
require 'Date'
require 'rugged'
require 'linguist'


class ProjectController < ApplicationController
def index
   
  end
  def show
      @project = Project.find(params[:id])
     @mvc = Mvc.find(params[:id])
     @filedets = @project.filedets
     @yes = @project.created_at.strftime("#{@project.created_at.day}-%B-%Y")   #sending data to show.html.erb through @yes as date
     #creating a pie chart imaage for displaying in pdf
     config = """{
       type: 'pie',
       data: {
       labels: ['model', 'view', 'controller'],
       datasets: [{
       label: 'Data',
       data: [#{@mvc.models_count},#{@mvc.views_count},#{@mvc.controllers_count}]
       }]
     }
    }"""
    encoded = URI.encode_www_form_component(config.strip)
    # Output a URL to my image
    @hello = "https://quickchart.io/chart?c=#{encoded}" 
    @mvcs = Mvc.all
    puts @mvc.controllers_count
    @project = Project.find(params[:id])
    respond_to do |format|
      format.html
      format.pdf do
        render pdf: "project",
        template: "project/show.html.erb",            #rendering pdf file through url
        layout: 'pdf.html.erb'
      end
    end
end
  def new
    
    @project = Project.new
    @mvc = Mvc.new
    @filedet = Filedet.new
  end
  def edit
    @project = Project.find(params[:id])
  end
  def create
    @project = Project.new(project_params)
    @mvc = Mvc.new(mvc_params)
    @project.user_id = current_user.id
    g = Git.clone(params["github_url"],params["name"].to_s , :path => './public/')
    respond_to do |format|
    if @project.save       #saving each project
      #getting technogies used in the repository
    repo = Rugged::Repository.new("./public/#{@project.name}")
    project = Linguist::Repository.new(repo, repo.head.target_id)     #=> "Ruby"
    arr = project.languages
    @limit = arr.length - 1 
      for i in 0..@limit
        @technology = Technology_version.new(technology_version_params)
        @technology.technology_name = arr.keys[i]
        @technology.project_id = @project.id
        @technology.save
      end
      @mvc.project_id = @project.id
      @arr = @project.name
        @ary1 = Dir["#{Rails.root}/public/#{@arr}/app/controllers/**/*.rb"].map do |m|
        m.chomp('.rb').camelize.split("::").last
        end
      @mvc.controllers_list = @ary1
      @mvc.controllers_count = @ary1.count
        @ary2 = Dir["#{Rails.root}/public/#{@arr}/app/models/**/*.rb"].map do |m|
        m.chomp('.rb').camelize.split("::").last
        end
      @mvc.models_count = @ary2.count
      @mvc.models_list = @ary2
        @ary3 = Dir["#{Rails.root}/public/#{@arr}/app/views/**/*.erb"].map do |m|
        m.chomp('.erb').camelize.split("::").last
        end
      @mvc.views_count = @ary3.count
      @mvc.views_list = @ary3
      if @mvc.save 
        @len = Array.new                  #saving each project models and controllers and views
        Find.find("#{Rails.root}/public/#{@project.name}/") do |path|
          @len << path 
        end
        @value = @len.length-1
        for i in 1..@value
          if File.file?(@len[i])
            @filedet = Filedet.new(filedet_params)
            @filedet.project_id = @project.id
            @file_name = @len[i].split("#{@project.name}/")
            @filedet.file_name = @file_name[1]
            file=File.open(@len[i],"r:ISO-8859-1:UTF-8")
            s = File.read(@len[i], :encoding => 'iso-8859-1')
            s.encoding
            number_of_words = 0
            file.each_line(){ |line| number_of_words = number_of_words + line.split.size }
            lines = File.readlines(@len[i])
            line_count = lines.size 
            @filedet.lines_count = line_count
            text = lines.join 
            total_characters = text.length 
            # word_count = text.split.length 
            @filedet.letter_count = total_characters
            @filedet.words_count = number_of_words
            @space = s.count(" ")
            @filedet.spaces_count = @space
            # total_characters_nospaces = text.gsub(/\s+/, '').length
            # @filedet.spaces_count = total_characters_nospaces
            @filedet.save
          else
            next
          end
        end   #saving each project file details                      
        format.html { redirect_to  @project, notice: "project was successfully created." }
        format.json { render :show, status: :created, location: @project }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @project.errors, status: :unprocessable_entity }
      end
    end
    end
  end
  def update
      @project = Project.find(params[:id])
      if @project.update(project_params)
      redirect_to @project
    else
      render :edit
    end
  end
  def destroy
     @project = Project.find(params[:id])
    @project.destroy
    respond_to do |format|
      format.html { redirect_to projects_url, notice: "project was successfully destroyed." }
      format.json { head :no_content }
    end
  end
  private
    def project_params
      params.permit(:github_url, :name)
    end
    def mvc_params
      params.permit(:models_count, :views_count, :controllers_count, :controllers_list, :models_list, :views_list, :project_id)
    end
     def filedet_params
      params.permit(:file_name , :words_count, :spaces_count, :lines_count, :letter_count, :project_id)
    end
    def technology_version_params
      params.permit(:technology_name, :project_id)
    end

end
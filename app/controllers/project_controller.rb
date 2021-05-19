require "git"
require 'find'
require 'squid'
require 'uri'
require 'Date'
require 'Rugged'
require 'linguist'
require 'charlock_holmes'

class ProjectController < ApplicationController
  def welcome

  end
 def index
   if user_signed_in?
     puts current_user.id
     @projects = current_user.projects
     @mvc = Mvc.all
   end
 end
 def show
      @project = Project.find(params[:id])
     @mvc = @project.mvc
     @technologies = @project.repositories    #assigning project related repository
     @filedets = @project.filedets           #assigning project related stats
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
    puts @mvc.controllers_count
    @project = Project.find(params[:id])
    respond_to do |format|
      format.html
      format.pdf do
        render template: "project/edit.html.erb",            #rendering pdf file through view
        layout: 'pdf.html.erb',
        pdf: "#{@project.name}",
        disposition: 'attachment'                            #providing  downloading option
        return
      end
    end
  end
  def new
    @project = Project.new
    # @mvc = Mvc.new
    # @filedet = Filedet.new
  end
  def edit
     @project = Project.find(params[:id])
     @mvc = Mvc.find(params[:id])
     @technologies = @project.repositories    #assigning project related repository
     @filedets = @project.filedets             #assigning project related stats
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
    puts @mvc.controllers_count
    @project = Project.find(params[:id])
    respond_to do |format|
      format.html
      format.pdf do
        render template: "project/edit.html.erb",            #rendering pdf file through url
        layout: 'pdf.html.erb',
        pdf: "#{@project.name}",
        disposition: 'attachment'
        return
      end
    end
  end
  def create                      
    # @projects = Project.all
    @project = Project.new(project_params)
    @mvc = Mvc.new(mvc_params)
    @project.user_id = current_user.id
    # cloning project in required directory
    if Project.exists?(github_url: params["github_url"])                        #checking whether name  and url if already exist 
        puts "helllllooooooo"
         flash[:alert] = "project alredy cloned with in db"
          redirect_to new_project_path
          return
    end
      if Project.exists?(name: params["name"])
        puts "helllllooooooo"
        flash[:alert] = "name already exist"
          redirect_to new_project_path
          return
      end
    begin
     Git.clone(params["github_url"],params["name"].to_s , :path => './public/')       #error handling 
    rescue
      if !params["name"].present? && !params["github_url"].present?              #field validations
        flash[:alert] = "fields can't be empty"
      elsif !params["name"].present?
         flash[:alert] = "please enter name"
      elsif !params["github_url"].present?
         flash[:alert] = "url can'be empty"
      else
          flash[:alert] = "invalid url"
      end
      redirect_to new_project_path
      return
    end
    respond_to do |format|
      if @project.save       #saving each project
      #getting technogies used in the repository
      repo = Rugged::Repository.new("./public/#{@project.name}")
      project = Linguist::Repository.new(repo, repo.head.target_id)     #=> "Ruby"
      arr = project.languages
      @limit = arr.length - 1 
      for i in 0..@limit
        @technology = Repository.new(repository_params)           #saving technology names
        @technology.technology_name = arr.keys[i]
        arr1 = Array.new    
        text_file = Array.new  
        arr2 = Array.new                                
        if arr.keys[i] == "Ruby"  
          if (File.exist?("#{Rails.root}/public/#{@project.name}/Gemfile"))                                  #checking Ruby version
            File.open("#{Rails.root}/public/#{@project.name}/Gemfile","r") do |f|
              f.each_line do |line|
                arr1 = line.split(' ')
                arr1.each do |word|
                  if word == "ruby"
                    @words = word
                    arr2 = line.split(' ')
                    for i in 0..arr2.length-1
                      if arr2[i] == "ruby"
                        @ruby_version =  arr2[i+1]
                        @ruby = @ruby_version.delete_prefix("'").delete_suffix("'")
                      end
                    end
                   break
                  end
                end
              end
              break
            end
          end
        elsif arr.keys[i] == "PHP"                                                                              #checking PHP version
          if (File.exist?("#{Rails.root}/public/#{@project.name}/composer.json"))
            File.open("#{Rails.root}/public/#{@project.name}/composer.json","r") do |f|
              f.each_line do |line|
                arr1 = line.split(' ')
                arr1.each do |word|
                  text_file << word
                end  
              end
            end
          elsif (File.exist?("#{Rails.root}/public/#{@project.name}/web/composer.json"))
            File.open("#{Rails.root}/public/#{@project.name}/web/composer.json","r") do |f|
              f.each_line do |line|
                arr1 = line.split(' ')
                arr1.each do |word|
                  text_file << word
                end  
              end
            end
          else
            @ruby = "-"
          end
          if text_file != []
            for i in 0..text_file.length
              if text_file[i] == '"php":'
                @ruby_version =  text_file[i+1]
                @ruby = @ruby_version.delete_prefix('">=').delete_suffix('",')
              end
            end
          end
        elsif arr.keys[i] == "Python"                                                                        #checking Python version
          File.open("#{Rails.root}/public/#{@project.name}/setup.py","r") do |f|
            f.each_line do |line|
              arr1 = line.split(' ')
              arr1.each do |word|
                text_file << word
              end  
            end
          end
          for i in 0..text_file.length
            if text_file[i] == "<"
              @ruby_version =  text_file[i+1]
              @python = @ruby_version.delete_prefix("'").delete_suffix('",')
              @ruby =  @python.delete_suffix("'")
            end
          end
        elsif arr.keys[i] == "Java"                                                                           #checking java version
          if (File.exist?("#{Rails.root}/public/#{@project.name}/build.gradle"))
            File.open("#{Rails.root}/public/#{@project.name}/build.gradle","r") do |f|
              f.each_line do |line|
                arr1 = line.split(' ')
                arr1.each do |word|
                  text_file << word
                end  
              end
            end
            for i in 0..text_file.length
              if text_file[i] == "sourceCompatibility"
                @ruby_version =  text_file[i+2]
                @ruby = @ruby_version.delete_prefix("JavaVersion.VERSION_")
              end
            end
          elsif (File.exist?("#{Rails.root}/public/#{@project.name}/complete/build.gradle"))
            File.open("#{Rails.root}/public/#{@project.name}/complete/build.gradle","r") do |f|
              f.each_line do |line|
                arr1 = line.split(' ')
                arr1.each do |word|
                  text_file << word
                end  
              end
            end
            if text_file != []
              for i in 0..text_file.length
                if text_file[i] == "sourceCompatibility"
                  @ruby =  text_file[i+2]
                end
              end
            end
          else
            @ruby = "-"
          end
        else
          @ruby = "-"
        end
        @technology.version = @ruby 
        @technology.project_id = @project.id
        @technology.save                                                           #saving repository technologies and versions
      end
      @mvc.project_id = @project.id
      @arr = @project.name                                    
      @ary1 = Dir["#{Rails.root}/public/#{@arr}/***/controllers/**/**.**"].map do |m|                #saving controller stats
        m.chomp('*.**').camelize.split("::").last
      end
      @mvc.controllers_list = @ary1
      @mvc.controllers_count = @ary1.count
      @ary2 = Dir["#{Rails.root}/public/#{@arr}/***/models/**/**.**"].map do |m|                     #saving model stats
        m.chomp('*.**').camelize.split("::").last
      end
      @mvc.models_count = @ary2.count
      @mvc.models_list = @ary2
      @ary3 = Dir["#{Rails.root}/public/#{@arr}/***/views/**/**.**"].map do |m|                      #saving view stats
        m.chomp('*.**').camelize.split("::").last
      end
      @mvc.views_count = @ary3.count
      @mvc.views_list = @ary3
      if @mvc.save 
                 #saving each project models and controllers and views
        Find.find("#{Rails.root}/public/#{@project.name}/") do |path|                       #saving each file stats with names
          @len = path 
          if File.file?(@len)
            @filedet = Filedet.new(filedet_params)
            @filedet.project_id = @project.id
            @file_name = Array.new
            @file_name = @len.split("#{@project.name}/")
            @filedet.file_name = @file_name[1]
            file=File.open(@len,"r:ISO-8859-1:UTF-8")
            s = File.read(@len, :encoding => 'iso-8859-1')
            s.encoding
            number_of_words = 0
            file.each_line(){ |line| number_of_words = number_of_words + line.split.size }
            lines = File.readlines(@len)
            line_count = lines.size 
            @filedet.lines_count = line_count
            text = lines.join 
            total_characters = text.length 
            @filedet.letter_count = total_characters
            @filedet.words_count = number_of_words
            @space = s.count(" ")
            @filedet.spaces_count = @space
            @filedet.save             #saving each project file details 
          else
            next
          end 
        end 
      end                    
      format.html { redirect_to  root_path, notice: "project was successfully created." }
      format.json { render :show, status: :created, location: @project }
    else
      format.html { render :new, status: :unprocessable_entity }
      format.json { render json: @project.errors, status: :unprocessable_entity }
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
    def repository_params
      params.permit(:technology_name, :version, :project_id)
    end

end
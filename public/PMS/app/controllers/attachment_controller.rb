class AttachmentController < ApplicationController
	def index
    @attachments = Attachment.all
  end
  def new
    @attachment = Attachment.new 
  end
  def show
     @attachment = Attachment.find(params[:attachment_id])
  end
  def edit
     @attachment = Attachment.find(params[:attachment_id])
  end
  def create
    @attachment = Attachment.new(attachment_params)
    respond_to do |format|
      if @attachment.save
        format.html { redirect_to project_path(@attachment.project_id), notice: "attachment was successfully created." }
        format.json { render :show, status: :created, location: @attachment }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @attachment.errors, status: :unprocessable_entity }
      end
    end
  end
  def update
      @attachment = Attachment.find(params[:attachment_id])
      if @attachment.update(attachment_params)
      redirect_to project_path(@attachment.project_id)
    else
      render :edit
    end
  end
  def destroy
  	 @attachment = Attachment.find(params[:attachment_id])
    @attachment.destroy
    respond_to do |format|
      format.html { redirect_to project_path(@attachment.project_id), notice: "attachment was successfully destroyed." }
      format.json { head :no_content }
    end
  end
  private
    def attachment_params
      params.require(:attachment).permit(:image, :project_id)
    end
    def project_params
      params.require(:project).permit(:name, :project_type)
    end
end

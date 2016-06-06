class AttachmentFilesController < ApplicationController
  # GET /attachment_files
  # GET /attachment_files.json
  include AttachmentFilesHelper
  before_action check_admin_grants, only: [:new, :edit, :create, :update, :destroy]
  
  def index
    @attachment_files = AttachmentFile.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render :json => @attachment_files }
    end
  end

  # GET /attachment_files/1
  # GET /attachment_files/1.json
  def show
    @attachment_file = AttachmentFile.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render :json => @attachment_file }
    end
  end

  # GET /attachment_files/new
  # GET /attachment_files/new.json
  def new
    @attachment_file = AttachmentFile.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render :json => @attachment_file }
    end
  end

  # GET /attachment_files/1/edit
  def edit
    @attachment_file = AttachmentFile.find(params[:id])
  end

  # POST /attachment_files
  # POST /attachment_files.json
  def create
	if params[:attachment_file][:product_id] != nil and params[:attachment_file][:product_id] != ""
		product = Product.find_by_id(params[:attachment_file][:product_id])
		if product != nil
			directory = "#{params[:attachment_file][:file_type]}/#{product.id.to_s}_#{product.s_name}"
			if params[:attachment_file][:file_type] != '' and params[:attachment_file][:file_type] != ''
				add_file(directory, product, params[:attachment_file][:file_type])
			end
		else
			directory = "#{params[:attachment_file][:file_type]}/price_list"
			
			if params[:attachment_file][:file_type] != '' and params[:attachment_file][:file_type] != ''
				add_file(directory, product, params[:attachment_file][:file_type])
			end
		end
	else
		redirect_to root_path
	end
  end

  # PUT /attachment_files/1
  # PUT /attachment_files/1.json
  def update
    @attachment_file = AttachmentFile.find(params[:id])

    respond_to do |format|
      if @attachment_file.update_attributes(params[:attachment_file])
        format.html { redirect_to @attachment_file, :notice => 'Attachment file was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render :action => "edit" }
        format.json { render :json => @attachment_file.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /attachment_files/1
  # DELETE /attachment_files/1.json
  def destroy
    @attachment_file = AttachmentFile.find(params[:id])
	remove_file(@attachment_file)
	@attachment_file.destroy

    respond_to do |format|
      format.html { redirect_to :back }
      format.json { head :no_content }
    end
  end
  
  private 
  
  def check_admin_grants
    redirect_to '/404' if user_type == 'admin'
  end 
end

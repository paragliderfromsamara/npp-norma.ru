class ProductsController < ApplicationController
  # GET /products
  # GET /products.json
  before_action :check_grants#, only: [:new, :create, :edit, :update, :destroy]
  
  def index
  optimize_db #application_helper 
	product = Product.new
	@cur = product.categoryById((params[:c]).to_i)
	if @flag != 0	
		@products = Product.where(visibility: 'visible', category_id: @cur[:id]) if user_type != 'admin'
		@products = Product.where(category_id: @cur[:id]) if user_type == 'admin'
	end
	@title = "НОРМА - Научно-производственное предприятие"
	@header = "#{Производимая продукция}: <span class = 'subheader'>#{@cur[:tab_name]}</span>"
	@robots_meta = [{:name => 'ROBOTS', :content => 'INDEX, FOLLOW'}]
    respond_to do |format|
      format.html # index.html.erb
      format.json { render :json => @products }
    end
  end

  # GET /products/1
  # GET /products/1.json
  def show
    
    @product = Product.find(params[:id])
	  @photos = @product.photos.where.not(id: @product.photo_id) #if @product.photo_id?
	  @comments = @product.comments
	  @component_types = @product.component_types
	  @title = @product.s_name
	  @header = @product.s_name
	  @meta_description = @product.note
    
	  @robots_meta = [{:name => 'ROBOTS', :content => 'INDEX, FOLLOW'}]
    respond_to do |format|
      format.html # show.html.erb
      format.json { render :json => @product }
      format.pdf do 
        render pdf: "file_name"   # Excluding ".pdf" extension.
      end
    end
  end

  # GET /products/new
  # GET /products/new.json
  def new
		@product = Product.new
		@products = Product.all
		@attachment_file = AttachmentFile.new
		@action = 'create'
		respond_to do |format|
		  format.html # new.html.erb
		  format.json { render :json => @product }
		end
  end

  # GET /products/1/edit
  def edit
	  @product = Product.find(params[:id])
    @header = "Изменение описания прибора"
		@products = Product.all
		@action = 'update'
		@attachment_file = AttachmentFile.new
		@device_photos = @product.photos(:order => 'id ASC')
  end

  # POST /products
  # POST /products.json
  def create
		@product = Product.new(params[:product])
		respond_to do |format|
		  if @product.save
			if @product.photos != [] and @product.photos != nil and @product.photos != ""
				photo = Photo.find_by_product_id(@product.id)
				@product.update_attributes(:photo_id => photo.id)
			end
			format.html { redirect_to @product, :notice => 'Успешно обновлён' }
			format.json { render :json => @product, :status => :created, :location => @product }
		  else
			format.html { render :action => "new" }
			format.json { render :json => @product.errors, :status => :unprocessable_entity }
		  end
		end
  end

  # PUT /products/1
  # PUT /products/1.json
  def update
    @product = Product.find(params[:id])
		respond_to do |format|
		  if @product.update_attributes(params[:product])
			if @product.photo == nil
				photo = Photo.find_by_product_id(@product.id)
				@product.update_attributes(:photo_id => photo.id)
			end
			format.html { redirect_to @product, :notice => 'Успешно обновлено' }
			format.json { head :no_content }
		  else
			format.html { render :action => "edit" }
			format.json { render :json => @product.errors, :status => :unprocessable_entity }
		  end
		end
  end

  def units
    
		@product = Product.find_by_id(params[:id])
		@units = @product.units
		@component_types = ComponentType.order('name ASC')
		if params[:u] != nil and params[:u] != ''
			@unit = @product.unit(params[:u].to_i)
		else
			@unit = @product.units.first
		end
		@title = @header = "Спецификации для \"#{@product.s_name}\""
		@unit_product_link = UnitProductLink.new
  end
  # DELETE /products/1
  # DELETE /products/1.json
  def destroy
		@product = Product.find(params[:id])
		@product.destroy
		respond_to do |format|
		  format.html { redirect_to products_url }
		  format.json { head :no_content }
		end
  end
  
  def edit_product_list
    @title = @header = "Редактирование цен на изделия"
    @products = Product.order("order_number ASC")
  end

  private 
  
  def check_grants
    case self.action_name
    when "index"
      user_could_see_product_list?(true)
    when "show"
      user_could_see_product?(true)
    when "new", "create"
      user_could_add_product?(true)
    when "edit", "update", "edit_product_list"
      user_could_edit_product?(true)
    when "units"
      user_could_see_units_list?(true)
    end
  end
  
  
end

class ComponentsController < ApplicationController
  include ComponentsHelper
  include ApplicationHelper
  before_action :check_admin, only: [:new, :create, :edit, :update, :destroy]
  # GET /components
  # GET /components.json
  def index
	@title = @header = 'Комплектующие'
	@component_types = ComponentType.order('name ASC')
	@components = []
	if params[:t] != nil and params[:t] != ''
		@componentType = ComponentType.find_by_id(params[:t])
	else
		@componentType = ComponentType.find_by_id(10)
	end
	@components = @componentType.components.select('id, name, cost, designation').order('name ASC') if @componentType != nil
    respond_to do |format|
      format.html # index.html.erb
      format.json { render :json => @components }
    end
  end

  # GET /components/1
  # GET /components/1.json
  def show
    @component = Component.find(params[:id])
	  @title = @header = @component.name
    @photos = @component.photos.size > 1 ? @component.photos.where.not(id: @component.get_photo.id) : []
	  @componentLinks = @component.component_links
    respond_to do |format|
      format.html # show.html.erb
      format.json { render :json => @component }
    end
  end

  # GET /components/new
  # GET /components/new.json
  def new
		@title = @header = 'Новый компонент'
		@component = Component.new
		respond_to do |format|
		  format.html # new.html.erb
		  format.json { render :json => @component }
		end
  end

  # GET /components/1/edit
  def edit
		@title = @header = 'Изменение компонента'
		@component = Component.find(params[:id])
		@componentTypes = ComponentType.order('name ASC')
  end

  # POST /components
  # POST /components.json
  def create
		componentTypeName = params[:component][:type_name].strip
		if componentTypeName != '' 
			componentType = ComponentType.find_by_name(componentTypeName)
			componentType = ComponentType.create(:name => componentTypeName) if componentType == nil
			params[:component][:component_type_id] = componentType.id 
		end
		
		@component = Component.new(params[:component])

		respond_to do |format|
		  if @component.save
			format.html { redirect_to @component, :notice => 'Компонент успешно добавлен' }
			format.json { render :json => @component, :status => :created, :location => @component }
		  else
			format.html { render :action => "new" }
			format.json { render :json => @component.errors, :status => :unprocessable_entity }
		  end
		end
  end

  # PUT /components/1
  # PUT /components/1.json
  def update
    @component = Component.find(params[:id])
		respond_to do |format|
		  if @component.update_attributes(params[:component])
			format.html { redirect_to @component, :notice => 'Компонент успешно обновлён' }
			format.json { head :no_content }
		  else
			format.html { render :action => "edit" }
			format.json { render :json => @component.errors, :status => :unprocessable_entity }
		  end
		end
  end

  # DELETE /components/1
  # DELETE /components/1.json
  def destroy
		@component = Component.find(params[:id])
		@component.destroy

		respond_to do |format|
		  format.html { redirect_to components_url }
		  format.json { head :no_content }
		end
  end
  
  def migrate_components
	  migrateComponents
	  redirect_to components_path
  end
  
  private 
  
  def check_admin
    redirect_to root_path if user_type != 'admin' 
  end
end

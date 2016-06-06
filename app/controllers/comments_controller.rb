class CommentsController < ApplicationController
  
  before_action :check_admin
  
  def new
    @title = @header = "Новый отзыв"
		@comment = Comment.new
		@products = Product.order('name ASC')
		respond_to do |format|
		  format.html # new.html.erb
		  format.json { render :json => @comment }
		end
  end

  # GET /comments/1/edit
  def edit
    @comment = Comment.find(params[:id])
    @title = @header = "Редактировать отзыв"
    @products = Product.order('name ASC')
  end

  # POST /comments
  # POST /comments.json
  def create
		@comment = Comment.new(params[:comment])

		respond_to do |format|
		  if @comment.save
			format.html { redirect_to @comment.product, :notice => 'Comment was successfully created.' }
			format.json { render :json => @comment, :status => :created, :location => @comment }
		  else
        @title = @header = "Новый отзыв"
			format.html { render :action => "new" }
			format.json { render :json => @comment.errors, :status => :unprocessable_entity }
		  end
		end
  end

  # PUT /comments/1
  # PUT /comments/1.json
  def update
		@comment = Comment.find(params[:id])

		respond_to do |format|
		  if @comment.update_attributes(params[:comment])
			format.html { redirect_to @comment.product, :notice => 'Comment was successfully updated.' }
			format.json { head :no_content }
		  else
        @title = @header = "Редактировать отзыв"
			format.html { render :action => "edit" }
			format.json { render :json => @comment.errors, :status => :unprocessable_entity }
		  end
		end
  end

  # DELETE /comments/1
  # DELETE /comments/1.json
  def destroy
		@comment = Comment.find(params[:id])
    p = @comment.product
		@comment.destroy
		respond_to do |format|
		  format.html { redirect_to p }
		  format.json { head :no_content }
		end
  end
  
  
  private 
  
  def check_admin
    redirect_to root_path if user_type != 'admin'
  end
end

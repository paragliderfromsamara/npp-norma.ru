class ComponentTypesController < ApplicationController
  def edit
	if user_type == 'admin'
		@type = ComponentType.find(params[:id])
		@title = @header = "Изменение типа компонентов \"#{@type.name}\""
	else
		redirect_to '/404'
	end
  end

  def update
	if user_type == 'admin'
		@type = ComponentType.find(params[:id])
		respond_to do |format|
		  if @type.update_attributes(params[:component_type])
			format.html { redirect_to components_path, :notice => 'Тип компонента успешно обновлен' }
			format.json { head :no_content }
		  else
			format.html { render :action => "edit" }
			format.json { render :json => @type.errors, :status => :unprocessable_entity }
		  end
		end
	else
		redirect_to '/404'
	end
  end

  def destroy
  end
end

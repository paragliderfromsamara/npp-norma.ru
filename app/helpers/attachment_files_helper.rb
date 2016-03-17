module AttachmentFilesHelper
 def add_file(directory, product, file_type)

			@directory = "public/uploads/#{directory}"
			FileUtils.mkdir_p(@directory) unless File.exists?(@directory)
			uploaded_io = params[:attachment_file][:link]
				File.open(Rails.root.join(@directory, uploaded_io.original_filename), 'w') do |file|
					file.write(uploaded_io.read)
				end
			@link = "/uploads/#{directory}/" +  uploaded_io.original_filename
			
			AttachmentFile.create(:name => uploaded_io.original_filename, :link => @link, :product_id => 0, :file_type => file_type) if product == nil
			AttachmentFile.create(:name => uploaded_io.original_filename, :link => @link, :product_id => product.id, :file_type => file_type) if product != nil
			redirect_to product if product != nil
			redirect_to root_path if product == nil
  end
  
  def remove_file(file)
	if user_type == "admin"
		if File.delete("#{Rails.root}/public/#{file.link}")
			file.destroy
		end
	end			
  end
end

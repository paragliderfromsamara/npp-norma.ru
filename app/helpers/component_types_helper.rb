module ComponentTypesHelper
	def componentTypesList
		val = ''
		if @component_types != nil and @component_types != ''
			@component_types.each do |type|
				val += "#{componentTypesListItem(type)}"
			end
			val = "<ul id = 'componentTypes'>#{val}</ul>"
		end
		return val.html_safe
	end
	
	def componentTypesListItem(type)
		"
			<a href = '#{request.env['PATH_INFO']}?t=#{type.id}'>
				<li #{"id = 'c_type'" if type == @componentType }>
					<p>
						#{type.name}
					</p>
				</li>
			</a>
		"
	end
end

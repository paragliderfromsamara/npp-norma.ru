module ActiveRecord
  class Base
    
    def s_name
      short_name.blank? ? name : short_name
    end
    
    def uploaded_photos=(attrs)
  	attrs.each {|attr| self.photos.build(:link => attr)}
    end
  
    def alter_photo
  	if get_photo.nil?
  		return '/files/nophoto.jpg'
  	else
  		return get_photo.link
  	end
    end
  
    def alter_photo_mini
  	if get_photo.nil?
  		return '/files/nophoto_mini.jpg'
  	else
  		return get_photo.link.mini
  	end
    end
  
    def alter_photo_thumb
    	if get_photo.nil?
    		return '/files/nophoto.jpg'
    	else
    		return get_photo.link.thumb
    	end
    end
  
    def get_photo
  	p = nil
  	if self.photo == nil
  		if self.photos != []
  			self.update_attribute(:photo_id, self.photos.first.id)
  			p = self.photo
  		end
  	else
  		p = self.photo
  	end
  	return p
    end
    
    def rur_cost
      if cost == 0.0 || cost.blank?
        'не указана'
      else
        c = cost.to_i.to_s.reverse
        v = ''
        i = 0
        c.chars do |c|
          i += 1
          v += i==3 ? "#{c} " : c
          i = 0 if i == 3
        end
        return "<span class = 'stat'>#{v.strip.reverse}</span> рублей"
      end
    end

    def nds   
    	"<span data-tooltip aria-haspopup='true' class='has-tip right' data-disable-hover='false' tabindex='1' title='НДС не начисляется в связи с применением упрощённой системы налогообложения'>
        НДС не начисляется
      </span>"
    end
  end
end


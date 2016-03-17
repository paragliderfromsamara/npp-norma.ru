class Message < ActiveRecord::Base
  attr_accessible :copy, :from, :subject, :to, :user_id, :folder_id, :read_flag, :message_type, :add_attachments, :sent_date, :receive_date, :message_id, :create_raw_mails, :text_html, :text_plain, :get_attachments, :content, :raw_mail_id, :mail_id, :old_folder_id, :in_reply
  belongs_to :user
  belongs_to :message
  belongs_to :folder
  has_one :raw_mail
  has_many :attachments
  
  def input_content
	if (text_html != '' and text_html != nil) or (text_plain != '' and text_plain != nil)
		if text_html != ''
			return text_html.html_safe
		else
			return text_plain
		end
	else
		return "Текст отсутствует"
	end
  end
  
  def message_choose_content
	if message_type == 'output'
		return content 
	elsif message_type == 'input'
		return input_content 
	end
  end
  
  def add_attachments=(attrs)
	attrs.each do |attr|
		save_file(attr)
	end
  end
  
  def get_attachments=(attchs)
	if attchs != nil and attchs != [] and attchs != ''
		attchs.each do |attachment|
			get_file(attachment)
		end
	end
  end
  
  def create_raw_mails=(mail)
	directory = "/raw_mails/#{mail.date.strftime("%Y")}/#{mail.date.strftime("%d_%m")}/#{mail.from.to_s}"
	attachment_directory = "public#{directory}"
	FileUtils.mkdir_p(attachment_directory) unless File.exists?(attachment_directory)
				File.open(Rails.root.join(attachment_directory, "#{mail.date.strftime("%H-%M")}_#{mail.from.to_s}.txt"), 'w') do |file|
					file.write(mail.to_s)
				end
				
	self.build_raw_mail(
						   :link => "#{directory}/#{mail.date.strftime("%H-%M")}_#{mail.from.to_s}.txt"
						)
  end
  
  def get_file(attachment)
	directory = "/mail_attachments/input/#{(Time.now).strftime("%Y")}/#{(Time.now).strftime("%d_%m_%H_%M")}"
	attachment_directory = "public#{directory}"
	
	uploaded_io = attachment
	FileUtils.mkdir_p(attachment_directory) unless File.exists?(attachment_directory)
				File.open(Rails.root.join(attachment_directory, uploaded_io.filename), 'w') do |file|
					file.write(uploaded_io.body.decoded)
				end
	
	self.attachments.build(
						   :name => uploaded_io.filename,
						   :link => "#{directory}/#{uploaded_io.filename}"
						   )
  end
  
  def save_file(attr)
	directory = "/mail_attachments/output/#{(Time.now).strftime("%Y")}/#{(Time.now).strftime("%d_%m_%H_%M")}"
	attachment_directory = "public#{directory}"
	
	uploaded_io = attr
	FileUtils.mkdir_p(attachment_directory) unless File.exists?(attachment_directory)
				File.open(Rails.root.join(attachment_directory, uploaded_io.original_filename), 'w') do |file|
					file.write(uploaded_io.read)
				end
	
	self.attachments.build(
						   :name => uploaded_io.original_filename,
						   :link => "#{directory}/#{uploaded_io.original_filename}"
						   )
  end
	
  def id_in_person_cell
	"message_from" if message_type == "input" #Входящие сообщения
	"message_to" if message_type == "output" #Исходящие сообщения
  end
  
  def message_from_to
	return to if message_type == 'output'
	return from if message_type == 'input'
  end
  
  def subject_content
	("<span style = 'font-weight: 600;'>#{subject}</span> - <span style = 'font-weight: 100;'>#{content}</span>").html_safe
  end
  
  def attachments_hash
	name = []
	link = []
	hash = {}
	i = -1
	if attachments != []
		attachments.each do |attachment|
		i += 1
			name[i] = attachment.name
			link[i] = attachment.link
		end
		hash = {
				:names => name,
				:links => link
				}
		return hash
	else
		return nil
	end
  end
  
  def check_to_read
	return "message_old" if read_flag == 0 or read_flag == nil #Прочитанные сообщения
	return "message_new" if read_flag == 1 #Непрочитанные сообщения
  end
  
  def time #доделать
	if message_type == 'output'
		if sent_date != nil and sent_date != ''
			"<span id = 'date_time'>#{mes_date_format(sent_date)}</span>"
		else
			"<span id = 'date_time'>#{mes_date_format(updated_at)}</span>"
		end
	elsif message_type == 'input'
		if receive_date != nil and receive_date != ''
			"<span id = 'date_time'>#{mes_date_format(receive_date)}</span>"
		else
		end
	end
  end
 #.strftime("%d.%m.%Y") 
  def mes_date_format(date)
	date_now = Time.now
	value = ""
	if date_now.strftime("%d.%m.%Y") == date.strftime("%d.%m.%Y") 
		value = "Сегодня в #{date.strftime("%H:%M")}"
	elsif date_now.strftime("%d.%m.%Y") != date.strftime("%d.%m.%Y") and date_now.strftime("%m.%Y") == date.strftime("%m.%Y")
		value = "#{date.strftime("%d #{ru_month(date.strftime("%m"), 'partial')}")}"
	end
	return value
  end
  
  def show_id
	if mail_id != nil
		return mail_id
	else
		return ""
	end
  end
  
  def ru_month(m, type) #type == partial or full or родительный падеж
	value = ''
	month_array = [
					['01', 'Январь', 'Янв.', 'Января'],
					['02', 'Февраль', 'Фев.', 'Февраля'],
					['03', 'Март', 'Мар.', 'Марта'],
					['04', 'Апрель', 'Апр.', 'Апреля'],
					['05', 'Май', 'Май', 'Мая'],
					['06', 'Июнь', 'Июн.', 'Июня'],
					['07', 'Июль', 'Июл.', 'Июля'],
					['08', 'Август', 'Авг.', 'Августа'],
					['09', 'Сентябрь', 'Сент.', 'Сентября'],
					['10', 'Октябрь', 'Окт.', 'Октября'],
					['11', 'Ноябрь', 'Ноя.', 'Ноября'],
					['12', 'Декабрь', 'Дек.', 'Декабря']
				  ]
	month_array.each do |month|
		value = month[1] if month[0] == m and type == 'full'
		value = month[2] if month[0] == m and type == 'partial'
		value = month[3] if month[0] == m and type == 'rod_padej'
	end
	return value
  end
  
end

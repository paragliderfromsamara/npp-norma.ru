module ApplicationHelper
  def my_title
    (@title == nil)? "Норма - Научно-Производственное Предприятие" : @title
  end
  def my_header
    if @header != nil
      return "<div class='row tb-pad-s'><div class='small-12 columns'><h1>#{@header}</h1></div></div>"
    else
      return ""
    end
  end
  def mainMenuItems
    [
      {
        name: "О нас",
        link: "/about_us"
      },
      {
        name: "Продукция",
        link: products_path,
        items: getMenuProductsList
      },
      {
        name: "Контакты",
        link: "/contacts"
      }
    ]
  end
  def drawMenu
    h = ""
    mainMenuItems.each do |i|
      if !i[:items].nil?
        h += makeMenuDropItems(i)
      else
        h += "<li #{"class = 'active'" if current_page?(i[:link])}><a href='#{i[:link]}'>#{i[:name]}</a></li>"
      end
    end
    return h.html_safe
  end
  def makeMenuDropItems(i)
    v = ""
    i[:items].each do |s|
      v += "<li #{"class = \"active\"" if current_page?(s[:link])}><a href=\"#{s[:link]}\">#{s[:name]}</a></li>"
    end
    v = "<li>
            <a href=\"#{i[:link]}\">#{i[:name]}</a>
            <ul class='menu'>
              #{v}
            </ul>
        </li>"
    return v
  end
end

module GrantsComponentHelper
  def user_could_see_component_list?(redirect = false)
    #проверка прав для просмотра списка продуктов если надо
    condition = !signed_in?
    redirect_to root_path if condition && redirect
    return !condition
  end
  def user_could_see_component?(redirect = false)
    true
    #проверка прав для просмотра продукта если надо
  end
  def user_could_add_component?(redirect = false)
    condition = user_type != "admin"
    redirect_to root_path if condition && redirect
    return !condition
  end
  def user_could_edit_component?(redirect = false)
    condition = user_type != "admin"
    redirect_to root_path if condition && redirect
    return !condition
  end
  def user_could_del_component?(redirect = false)
    condition = user_type != "admin"
    redirect_to root_path if condition && redirect
    return !condition
  end
end

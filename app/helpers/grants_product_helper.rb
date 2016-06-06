module GrantsProductHelper
  def user_could_see_product_list?(redirect = false)
    #проверка прав для просмотра списка продуктов если надо
    true
  end
  def user_could_see_product?(redirect = false)
    true
    #проверка прав для просмотра продукта если надо
  end
  def user_could_add_product?(redirect = false)
    condition = user_type != "admin"
    redirect_to root_path if condition && redirect
    return !condition
  end
  def user_could_edit_product?(redirect = false)
    condition = user_type != "admin"
    redirect_to root_path if condition && redirect
    return !condition
  end
  def user_could_del_product?(redirect = false)
    condition = user_type != "admin"
    redirect_to root_path if condition && redirect
    return !condition
  end
  def user_could_see_units_list?(redirect = false)
    condition = user_type != "admin"
    redirect_to root_path if condition && redirect
    return !condition
  end
end

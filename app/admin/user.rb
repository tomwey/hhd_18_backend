ActiveAdmin.register User do
# See permitted parameters documentation:
# https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
#
permit_params :mobile, :nickname, :password, :password_confirmation, :name, :dept, :avatar
#
# or
#
# permit_params do
#   permitted = [:permitted, :attributes]
#   permitted << :other if params[:action] == 'create' && current_user.admin?
#   permitted
# end

form do |f|
  f.semantic_errors
  f.inputs "基本信息" do
    f.input :mobile
    f.input :nickname
    f.input :avatar
    f.input :name
    f.input :dept
  end
  f.inputs "登录密码" do
    f.input :password
    f.input :password_confirmation
  end
  
  actions
end

end

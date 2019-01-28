ActiveAdmin.register Address do
# See permitted parameters documentation:
# https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
#
permit_params :name, :addr_id, :police, :local_psb, :parent_addr, :district, :house_id, :has_child
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
    f.input :name
    f.input :addr_id, required: true
    f.input :has_child, label: '是否有下级楼栋'
    f.input :police
    f.input :local_psb
    f.input :parent_addr
    f.input :district
    f.input :house_id, as: :select, label: "房屋", collection: House.all.map { |h| [h.id, h.id] }
  end
  f.actions
end

end

ActiveAdmin.register BuildingUnitHouse do
# See permitted parameters documentation:
# https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
#
permit_params :address_id, :building_id, :unit_id, :house_id, :room_no
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
    f.input :address_id, as: :select, label: "所在地址", collection: Address.valid_addresses.map { |a| [a.name, a.id] }, required: true
    f.input :building_id, as: :select, label: "所属楼栋", required: true, collection: Building.order('id asc').map { |b| [b.name, b.id] }
    f.input :unit_id, as: :select, label: "所属单元", collection: Unit.order('id asc').map { |b| [b.name, b.id] }
    f.input :room_no, label: "房号"
    f.input :house_id, as: :select, required: true, label: "关联房屋", collection: House.valid_houses.map { |h| [h.id, h.id] }
  end
  f.actions
end

end

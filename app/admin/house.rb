ActiveAdmin.register House do
# See permitted parameters documentation:
# https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
#
permit_params :image, :_type, :jg_type, :plot_name, :area, :rooms_count, :mgr_level, :use_type, :rent_type, :mgr_reason, :memo, house_use: []
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
    f.input :image
    f.input :house_use, as: :check_boxes, collection: HouseUse.all.map { |use| [use.name, use.name] }, required: true
    f.input :_type, as: :select, collection: ['单元楼','筒子楼', '别墅', '自建小楼', '独立平房', '四合院平房', '临时工棚', '其他']
    f.input :jg_type, as: :select, collection: ['框架', '砖混', '土墙', '立材夹壁', '其他']
    f.input :plot_name
    f.input :area
    f.input :rooms_count, as: :number
    f.input :mgr_level, as: :select, collection: ['重点管控类（A）','重点关注类（B）','常规管理类（C）']
    f.input :mgr_reason
    f.input :use_type, as: :select, collection: ['自用', '一般租借', '其他租借', '闲置', '其他', '暂未查明']
    f.input :rent_type, as: :select, collection: ['整租房','合租房']
    f.input :memo, as: :text, rows: 10
  end
  f.actions
end

end

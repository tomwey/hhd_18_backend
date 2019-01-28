ActiveAdmin.register PropertyInfo do
# See permitted parameters documentation:
# https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
#
permit_params :_type, :house_id, :license_no, :comp_name, :comp_phone, :comp_addr, :comp_position, :card_type,:card_no, :name, :sex, :nation, :phone, :address, :serv_space, :memo

form do |f|
  f.semantic_errors
  f.inputs "基本信息" do
    f.input :_type, as: :select, collection: ['单位', '个人']
    
    f.input :house_id, as: :select, collection: House.all.map { |h| [h.address.try(:name) || h.id, h.id] }, required: true
    f.input :license_no
    f.input :comp_name
    f.input :comp_phone
    f.input :comp_addr
    f.input :comp_position
    f.input :card_type
    f.input :card_no
    f.input :name
    f.input :sex, as: :radio, collection: ['男', '女']
    f.input :nation, as: :select, collection: ['汉族','藏族','维族','苗族']
    f.input :phone
    f.input :address
    f.input :serv_space
    f.input :memo, as: :text, rows: 10
  end
  f.actions
end

end

ActiveAdmin.register Merchant do
# See permitted parameters documentation:
# https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
#
permit_params :logo, :name, :lic_no, :_type, :phone, :address, :intro, :_balance, :vip_expired_at, { lic_images: [] }

index do
  selectable_column
  column('#', :id)
  column :merch_id
  column :logo do |o|
    image_tag o.logo.url(:large), size: "60x60"
  end
  column :name
  column :phone
  column :balance do |o|
    o._balance
  end
  column :vip_expired_at
  column :lic_no
  column :lic_images do |o|
    html = ''
    o.lic_images.each do |img|
      html += image_tag(img.url, size: "108x192") + "<br>"
    end
    raw(html)
  end
  column :intro
  column :address
  actions
end

form html: { multipart: true } do |f|
  f.semantic_errors
  f.inputs "基本信息" do
    f.input :name
    f.input :logo
    f.input :_type, as: :select, collection: ['公司','个体户', '实名个人']
    f.input :lic_no
    f.input :lic_images, as: :file, hint: "附件格式为图片", input_html: { multiple: true }
    f.input :phone
    f.input :address
    f.input :_balance, as: :number, label: "余额", placeholder: "0.0", hint: "单位为元"
    f.input :vip_expired_at, as: :string, placeholder: "例如：2019-12-20"
    f.input :intro, as: :text
  end
  f.actions
end

end

require 'rest-client'
module API
  module V1
    class YbssAPI < Grape::API
      
      helpers API::SharedParams
      
      resource :user, desc: "用户账号相关" do
        desc "用户登录"
        params do
          requires :login, type: String, desc: "手机或昵称"
          requires :password, type: String, desc: "密码"
        end
        post :login do
          user = User.where("mobile = :login or nickname = :login", { login: params[:login].downcase }).first
          if user.blank?
            return { code: -2, message: "账号不存在" }
          end
          
          if !user.authenticate(params[:password])
            return { code: -1, message: "密码不正确" }
          end
          
          { code: 0, message: "ok", data: { token: user.private_token } }
        end
        
        desc "获取账号个人资料"
        params do
          requires :token, type: String, desc: "登录TOKEN"
        end
        get :me do
          user = authenticate!
          render_json(user, API::V1::Entities::User)
        end
      end # end user resource
      
      resource :ybss do
        desc "扫码查询地址信息"
        params do
          requires :token,   type: String, desc: "登录TOKEN"
          requires :addr_id, type: String, desc: "地址ID"
        end
        get :scan do
          user = authenticate!
          address = Address.find_by(addr_id: params[:addr_id])
          if address.blank?
            return render_error(4004, "不存在的地址")
          end
          
          if address.has_child
            # 有下级地址
            buildings = BuildingUnitHouse.includes(:address, :building, :unit, :house).where(address_id: address.id).order("building_id asc, unit_id asc")
            render_json(buildings, API::V1::Entities::BuildingUnitHouse)
          else
            # 无下级地址，直接查询房屋
            if address.house.blank?
              return render_error(4001, "该地址还未绑定房屋")
            end
            
            OperateLog.create!(house_id: address.house.id, title: "扫码查询地址", action: "扫码查询地址", operateable: address.house, begin_time: Time.zone.now, owner_id: user.id, ip: client_ip)
          
            render_json(address.house, API::V1::Entities::House)
            
          end
        end # end scan
        
        desc "扫码查询"
        params do
          requires :token,   type: String, desc: "登录TOKEN"
          requires :addr_id, type: String, desc: "地址ID"
        end
        get :house do
          user = authenticate!
          
          address = Address.find_by(addr_id: params[:addr_id])
          if address.blank?
            return render_error(4004, "不存在的地址")
          end
          
          if address.house.blank?
            return render_error(4001, "该地址还未绑定房屋")
          end
          
          OperateLog.create!(house_id: address.house.id, title: "扫码查询地址", action: "扫码查询地址", operateable: address.house, begin_time: Time.zone.now, owner_id: user.id, ip: client_ip)
          
          render_json(address.house, API::V1::Entities::House)
        end # end get house
        
        desc "更新房屋信息"
        params do
          requires :token, type: String, desc: "登录TOKEN"
          requires :id, type: Integer, desc: "房屋ID"
          optional :image, type: Rack::Multipart::UploadedFile, desc: '房屋图片'
          optional :payload, type: JSON, desc: "其他非图片json数据"
        end
        post '/house/update' do
          user = authenticate!
          
          house = House.find_by(id: params[:id])
          if house.blank?
            return render_error(4004, "房屋不存在")
          end
          
          # 修改房屋图片
          image = params[:image]
          if image
            house.image = params[:image]
          end
          
          # 修改房屋其他信息
          payload = params[:payload]
          if payload
            # puts payload.class
            # keys = payload.keys
            payload.each do |k,v|
              # puts "k:#{k},v:#{v}"
              if v.present? and house.has_attribute?(k)
                house.send "#{k}=", v
              end
            end
          end
          
          if house.save!
            OperateLog.create!(house_id: house.id, title: "更新房屋", action: "更新", operateable: house, begin_time: Time.zone.now, owner_id: user.id, ip: client_ip)
            render_json(house, API::V1::Entities::House)
          else
            render_error(2001, "房屋更新失败")
          end
        end # end update house
        
        desc "保存房屋附属信息"
        params do
          requires :token,   type: String, desc: "登录TOKEN"
          requires :id,      type: Integer, desc: "房屋ID"
          requires :class,   type: String, desc: "对象类名字"
          optional :obj_id,  type: Integer, desc: "对象ID"
          optional :payload, type: JSON, desc: "对象JSON数据"
          optional :files,   type: Array do
            requires :file, type: Rack::Multipart::UploadedFile, desc: '附件二进制'
          end
        end
        post "/house/:class/save" do
          user = authenticate!
        
          house = House.find_by(id: params[:id])
          if house.blank?
            return render_error(4004, "房屋不存在")
          end
          
          klass = params[:class].classify.constantize
          obj = klass.find_by(id: params[:obj_id])
          if obj.blank?
            obj = klass.new
          end
          
          if params[:payload]
            params[:payload].each do |k,v|
              # puts "#{k}:#{v}"
              if v.present? && obj.has_attribute?(k)
                # puts k
                obj.send "#{k}=", v
              end
            end
          end
          
          # 保存图片
          if params[:files] && params[:files].any?
            # puts params[:files]
            if obj.has_attribute?(:images)
              files = []
              params[:files].each do |param|
                files << param[:file]
              end
              # puts files
              obj.images = files
            elsif obj.has_attribute?(:image)
              files = params[:files]
              if files.size > 0 
                obj.image = files[0][:file]
              end
            end
          end
          
          obj.house_id = house.id
          
          if obj.save!
            action = params[:obj_id].blank? ? "新增" : "更新"
            if obj.state == 1
              action = "注销"
            end
            OperateLog.create!(house_id: house.id, title: "更新房屋数据", action: action, operateable: obj, begin_time: Time.zone.now, owner_id: user.id, ip: client_ip)
            render_json(house, API::V1::Entities::House)
          else
            render_error(3001, "提交失败!")
          end
        end # end save class
        
        desc "注销跟房屋相关的附属信息"
        params do
          requires :token,   type: String, desc: "登录TOKEN"
          requires :id,      type: Integer, desc: "房屋ID"
          requires :class,   type: String, desc: "对象类名字"
          requires :obj_id,  type: Integer, desc: "对象ID"
        end
        post "/house/:class/delete" do
          user = authenticate!
        
          house = House.find_by(id: params[:id])
          if house.blank?
            return render_error(4004, "房屋不存在")
          end
          
          klass = params[:class].classify.constantize
          obj = klass.find_by(params[:obj_id])
          if obj.blank?
            return render_error(4004, "对象不存在")
          end
          
          if obj.has_attribute?(:state)
            obj.state = 1
            obj.save!
            OperateLog.create!(house_id: house.id, title: "更新房屋数据", action: "注销", operateable: obj, begin_time: Time.zone.now, owner_id: user.id, ip: client_ip)
            render_json(house, API::V1::Entities::House)
          else
            render_error(-1, "非法操作")
          end
        end # end delete
        
        desc "保存公司从业人员信息"
        params do
          requires :token,   type: String, desc: "登录TOKEN"
          requires :id,      type: Integer, desc: "公司ID"
          optional :emp_id,  type: Integer, desc: "从业人员ID"
          optional :payload, type: JSON, desc: "从业人员信息JSON"
        end
        post '/company/save_emp' do
          user = authenticate!
        
          company = Company.find_by(id: params[:id])
          if company.blank?
            return render_error(4004, "单位不存在")
          end
          
          obj = Employee.where(company_id: company.id, id: params[:emp_id]).first
          if obj.blank?
            obj = Employee.new
          end
          
          if params[:payload]
            params[:payload].each do |k,v|
              if v.present? and obj.has_attribute?(k)
                obj.send "#{k}=", v
              end
            end
          end
          
          obj.company_id = company.id
          
          if obj.save!
            action = params[:emp_id].blank? ? "新增" : "更新"
            if obj.state == 1
              action = "注销"
            end
            OperateLog.create!(house_id: company.house.id, title: "更新单位", action: action, operateable: obj, begin_time: Time.zone.now, owner_id: user.id, ip: client_ip)
            render_json(company, API::V1::Entities::Company)
          else
            render_error(5001, "提交失败")
          end
        end # end save
        
        desc "注销公司从业人员信息"
        params do
          requires :token,   type: String, desc: "登录TOKEN"
          requires :id,      type: Integer, desc: "公司ID"
          requires :emp_id,  type: Integer, desc: "从业人员ID"
        end
        post '/company/delete_emp' do
          user = authenticate!
        
          company = Company.find_by(id: params[:id])
          if company.blank?
            return render_error(4004, "单位不存在")
          end
          
          obj = Employee.where(company_id: company.id, id: params[:emp_id]).first
          if obj.blank?
            return render_error(4004, "从业人员不存在")
          end
          
          obj.state = 1
          
          if obj.save!
            OperateLog.create!(house_id: company.house.id, title: "更新单位", action: "注销", operateable: obj, begin_time: Time.zone.now, owner_id: user.id, ip: client_ip)
            render_json(company, API::V1::Entities::Company)
          else
            render_error(5001, "注销失败")
          end
        end # end delete
        
      end # end resource
      
    end
  end
end
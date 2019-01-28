class Merchant < ActiveRecord::Base
  validates :logo, :name, :lic_no, :_type, :phone, presence: true
  mount_uploader :logo, AvatarUploader
  mount_uploaders :lic_images, LicImagesUploader
  
  before_create :generate_unique_id
  def generate_unique_id
    begin
      n = rand(10)
      if n == 0
        n = 8
      end
      self.merch_id = (n.to_s + SecureRandom.random_number.to_s[2..8]).to_i
    end while self.class.exists?(:merch_id => merch_id)
  end
  
  # 定义状态机
  state_machine initial: :pending do # 默认状态，待审核
    state :approved  # 审核通过，可以使用
    state :rejected  # 未审核通过
    
    # 审核
    after_transition [:pending, :rejected] => :approved do |merch, transition|
      # TODO: 记录活动操作日志
      # merch.do_approve
    end
    event :approve do
      transition [:pending, :rejected] => :approved
    end
    
    # 拒绝通过审核
    after_transition [:pending, :approved] => :rejected do |event, transition|
      # TODO: 记录活动操作日志
      # event.send_message
    end
    event :reject do
      transition [:pending, :approved] => :rejected
    end
    
  end # end state define
  
  def _balance=(val)
    if val.present?
      val = val.to_f
      if val >= 0
        self.balance = val
      end
    end
  end
  
  def _balance
    self.balance / 100.0
  end
end

# t.integer :merch_id
# t.string :logo,  null: false
# t.string :name,  null: false
# t.string :lic_no, null: false
# t.string :lic_images, array: true, default: []
# t.string :_type, null: false
# t.string :phone, null: false
# t.string :address
# t.integer :balance, default: 0
# t.string :state, default: 'pending'
# t.datetime :vip_expired_at

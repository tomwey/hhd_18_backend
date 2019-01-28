class User < ActiveRecord::Base
  has_secure_password
  
  validates :mobile, :nickname, :password, :password_confirmation, presence: true
  validates_uniqueness_of :mobile, :nickname
  
  mount_uploader :avatar, AvatarUploader
  
  # has_one :profile, dependent: :destroy
  # has_many :salaries, dependent: :destroy
  
  before_create :generate_uid_and_private_token
  def generate_uid_and_private_token
    begin
      n = rand(10)
      if n == 0
        n = 8
      end
      self.uid = (n.to_s + SecureRandom.random_number.to_s[2..8]).to_i
    end while self.class.exists?(:uid => uid)
    self.private_token = SecureRandom.uuid.gsub('-', '')
  end
  
  def hack_mobile
    return "" if self.mobile.blank?
    hack_mobile = String.new(self.mobile)
    hack_mobile[3..6] = "****"
    hack_mobile
  end
  
  # def auth_profile
  #   @profile ||= AuthProfile.where(user_id: self.uid, provider: 'qq').first || AuthProfile.where(user_id: self.uid, provider: 'wechat').first
  # end
  
  def format_nickname
    auth_profile.try(:nickname) || self.nickname || "ID:#{self.uid}"
    # @ud ||= UserDevice.where(uid: self.uid).first
    # return @ud.try(:uname) || "ID:#{self.uid}"
  end
  
  def format_avatar_url
    if avatar.present?
      avatar.url(:large)
    else
      ''
    end
    # if auth_profile
    #   auth_profile.try(:headimgurl)
    # else
    #   if avatar.present?
    #     avatar.url(:large)
    #   else
    #     ''
    #   end
    # end
  end
  
  def wx_bind
    AuthProfile.where(user_id: self.uid, provider: 'wechat').count > 0
  end
  
  def qq_bind
    AuthProfile.where(user_id: self.uid, provider: 'qq').count > 0
  end
  
  def qrcode_url
    "#{SiteConfig.main_server}/qrcode?text=#{self.portal_url}"
  end
  
  def portal_url
    ShortUrl.sina("#{SiteConfig.front_url}/?uid=#{self.uid}")
  end
  
  def block!
    self.verified = false
    self.save!
  end
  
  def unblock!
    self.verified = true
    self.save!
  end
  
end

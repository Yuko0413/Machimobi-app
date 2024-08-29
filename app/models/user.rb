class User < ApplicationRecord
  devise :database_authenticatable, :registerable,

         :recoverable, :rememberable, :validatable, :omniauthable, omniauth_providers: %i[google_oauth2 line]

  has_one :qr_code, dependent: :destroy
  has_one :care_content, dependent: :destroy

  before_validation :set_default_line_user_id, on: :create

  after_create :generate_qr_code_and_care_content

  def self.from_omniauth(auth)
    puts "=============="
    puts auth
    user = where(provider: auth.provider, uid: auth.uid).first_or_initialize do |u|
      u.email = auth.info.email || "#{auth.uid}+#{auth.provider}@example.com"# LINE => nothing 
      u.password = Devise.friendly_token[0, 20] if u.password.blank?
      u.nickname = auth.info.name if u.nickname.blank?  # Googleから提供される名前をニックネームとして設定
      u.line_user_id ||= auth.uid  # line_user_id が空の場合は一意の値を生成
    end
    user.save!(validate: false)
    user
  end

  # def self.from_omniauth(auth)
  #   where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
  #     user.email = auth.info.email
  #     user.password = Devise.friendly_token[0, 20]
  #     user.nickname = auth.info.name   # LINEの表示名を保存
  #   end
  # end

  def self.create_unique_string
    SecureRandom.uuid
  end

  validates :uid, presence: true, uniqueness: { scope: :provider }, if: -> { uid.present? }

  # 新規追加: has_password? メソッド
  def has_password?
    encrypted_password.present?
  end

  private

  def set_default_line_user_id
    self.line_user_id ||= SecureRandom.uuid
  end

  # def generate_qr_code_and_care_content
  #   Rails.logger.debug "Generating care content and QR code for user #{self.id}"
  #   care_content = self.build_care_content(preferred_name: self.nickname || "ユーザー")
  #   if care_content.save
  #     Rails.logger.debug "Care content created: #{care_content.inspect}"
  #   else
  #     Rails.logger.debug "Care content creation failed: #{care_content.errors.full_messages.join(', ')}"
  #   end
  #   qr_code = QrCode.create(user: self)
  #   tmp = generate_qr_code_data
  #   qr_code.update(qr_code: tmp)

  #   if qr_code.persisted?
  #     Rails.logger.debug "QR code created: #{qr_code.inspect}"
  #   else
  #     Rails.logger.debug "QR code creation failed: #{qr_code.errors.full_messages.join(', ')}"
  #   end
  # end

  def generate_qr_code_and_care_content
    Rails.logger.debug "Generating care content and QR code for user #{self.id}"
    
    # CareContentを作成
    care_content = self.build_care_content(preferred_name: self.nickname || "ユーザー")
    
    if care_content.save
      Rails.logger.debug "Care content created: #{care_content.inspect}"
      
      # 3つの緊急連絡先を作成
      3.times do
        EmergencyContact.create(care_content: care_content, phone_number: "", relationship: "")
      end
      Rails.logger.debug "Emergency contacts created for care content #{care_content.id}"
      else
      Rails.logger.debug "Care content creation failed: #{care_content.errors.full_messages.join(', ')}"
    end
  
    # QRコードを作成
    qr_code = QrCode.create(user: self)
    tmp = generate_qr_code_data
    qr_code.update(qr_code: tmp)
  
    if qr_code.persisted?
      Rails.logger.debug "QR code created: #{qr_code.inspect}"
    else
      Rails.logger.debug "QR code creation failed: #{qr_code.errors.full_messages.join(', ')}"
    end
  end
  

  def generate_qr_code_data
    qr_code_id = self.qr_code&.id

    if qr_code_id

      host_url = ENV["HOST_URL_#{Rails.env.upcase}"]
      Rails.application.routes.url_helpers.scan_qr_code_url(qr_code_id, host: host_url)

      

      # host_url = Rails.application.credentials.host[Rails.env.to_sym]
      # Rails.application.routes.url_helpers.scan_qr_code_url(qr_code_id, host: host_url)
    else
      "QRコードの生成に失敗しました"
    end
  end
end

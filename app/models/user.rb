class User < ApplicationRecord
  before_validation :set_default_line_user_id, if: -> { line_user_id.nil? }


  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :omniauthable, omniauth_providers: %i[google_oauth2]

  has_one :qr_code, dependent: :destroy
  has_one :care_content, dependent: :destroy

  after_create :generate_qr_code_and_care_content

  def self.from_omniauth(auth)
    user = where(provider: auth.provider, uid: auth.uid).first_or_initialize do |u|
      u.email = auth.info.email if u.email.blank?
      u.password = Devise.friendly_token[0, 20] if u.password.blank?
      u.nickname = auth.info.name if u.nickname.blank?  # Googleから提供される名前をニックネームとして設定
    end
    user.save!(validate: false)
    user
  end

  def self.create_unique_string
    SecureRandom.uuid
  end

  validates :uid, presence: true, uniqueness: { scope: :provider }, if: -> { uid.present? }


  def has_password?
    encrypted_password.present?
  end


  private

  def generate_qr_code_and_care_content
    Rails.logger.debug "Generating care content and QR code for user #{self.id}"
    care_content = self.build_care_content(preferred_name: self.nickname || "ユーザー")
    if care_content.save
      Rails.logger.debug "Care content created: #{care_content.inspect}"
    else
      Rails.logger.debug "Care content creation failed: #{care_content.errors.full_messages.join(', ')}"
    end
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
      Rails.application.routes.url_helpers.scan_qr_code_url(qr_code_id, host: 'localhost:3000')
    else
      "QRコードの生成に失敗しました"
    end
  end
end


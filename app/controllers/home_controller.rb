class HomeController < ApplicationController
  before_action :authenticate_user!

  def index
    if current_user.present?
      Rails.logger.debug "Current user: #{current_user.inspect}"
      @care_content = current_user.care_content
      @qr_code = current_user.qr_code
      Rails.logger.debug "Care content: #{@care_content.inspect}"
      Rails.logger.debug "QR code: #{@qr_code.inspect}"
    else
      Rails.logger.debug "No current user"
    end
  end
end

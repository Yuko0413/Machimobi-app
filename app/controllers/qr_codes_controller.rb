class QrCodesController < ApplicationController
  before_action :authenticate_user!, except: :scan
  before_action :set_qr_code, only: [:show, :scan]

  def show
    @qr = RQRCode::QRCode.new(@qr_code.qr_code)
    @care_content = current_user.care_content

    respond_to do |format|
      format.html
      format.png do
        send_data @qr.as_png(size: 300).to_s, type: 'image/png', disposition: 'inline'
      end
    end
  end

  def scan
    @qr_code = QrCode.find(params[:id])
  end

  private

  def set_qr_code
    @qr_code = QrCode.find_by(id: params[:id])
    unless @qr_code
      flash[:alert] = "QRコードが見つかりません。"
      redirect_to root_path
    end
  end
end

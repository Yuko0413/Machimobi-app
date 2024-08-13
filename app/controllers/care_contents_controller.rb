class CareContentsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_care_content, only: [:new, :create, :edit, :update, :generate_pdf]

  def new
    render :form
  end

  def create
    if @care_content.update(care_content_params)
      redirect_to root_path, notice: 'ケア内容が登録されました。'
    else
      render :form
    end
  end

  def edit
    render :form
  end

  def update
    if @care_content.update(care_content_params)
      redirect_to root_path, notice: 'ケア内容が更新されました。'
    else
      render :form
    end
  end

  def generate_pdf
    @care_content = CareContent.find(params[:id])
    html = render_to_string(template: 'care_contents/pdf', layout: 'pdf', locals: { care_content: @care_content }, formats: [:html])
    pdf = html2pdf(html)
    send_data pdf, filename: 'care_content.pdf', type: 'application/pdf'
  end


  private

  def set_care_content
    @care_content = current_user.care_content || current_user.build_care_content
  end

  def care_content_params
    params.require(:care_content).permit(:preferred_name, :phone_number, :custom_message, :message)
  end

  def html2pdf(html)
    # Ferrumを使ってHTMLからPDFを生成
    browser = Ferrum::Browser.new

    browser.goto("data:text/html,#{html}")
    pdf = browser.pdf(
      format: :A4,
      encoding: :binary,
      display_header_footer: false,
    )

    browser.quit

    pdf
  end
end

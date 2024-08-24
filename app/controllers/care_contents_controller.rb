class CareContentsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_care_content, only: [:new, :create, :edit, :update]

  def new
    render :form
  end

  def create
    if @care_content.update(care_content_params)
      redirect_to root_path, notice: '緊急時の表示内容が登録されました。'
    else
      render :form
    end
  end

  def edit
    Rails.logger.debug("CareContent: #{@care_content.inspect}")
    render :form
  end

  def update
    if @care_content.update(care_content_params)
      redirect_to root_path, notice: '緊急時の表示内容が更新されました。'
    else
      render :form
    end
  end

  private

  def set_care_content
    @care_content = current_user.care_content || current_user.build_care_content
  end

  def care_content_params
    params.require(:care_content).permit(:preferred_name, :custom_message, :message, phone_numbers: [])
  end
end

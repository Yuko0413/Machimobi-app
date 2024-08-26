class CareContentsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_care_content, only: [:new, :create, :edit, :update]

  def new
    render :form
  end

  def create
      @care_content = current_user.care_content
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
    @care_content = current_user.care_content
    if @care_content.update(care_content_params)
      redirect_to root_path, notice: '緊急時の表示内容が更新されました。'
    else
      binding.irb
      render :form
    end
  end

  private

  def set_care_content
    @care_content = current_user.care_content || current_user.build_care_content
    3.times { @care_content.emergency_contacts.build } if @care_content.emergency_contacts.size < 3

  end

  def care_content_params
    params.require(:care_content).permit(:preferred_name, :custom_message, :message, emergency_contacts_attributes: [:id, :phone_number, :relationship, :_destroy])
  end
end

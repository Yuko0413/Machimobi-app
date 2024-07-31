class Public::PasswordsController < Devise::PasswordsController
  skip_before_action :require_no_authentication, only: [:new, :create]

  def new
    if user_signed_in?
      redirect_to edit_user_registration_path, notice: "ログイン中はアカウント編集からパスワードを変更してください。"
    else
      super
    end
  end

  def create
    if user_signed_in?
      redirect_to edit_user_registration_path, notice: "ログイン中はアカウント編集からパスワードを変更してください。"
    else
      super
    end
  end
end


class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  skip_before_action :verify_authenticity_token, only: [:google_oauth2, :line]

  def google_oauth2
    handle_auth "Google"
  end

  def line
    handle_auth "LINE"
  end

  def failure
    redirect_to root_path, alert: "Authentication failed, please try again."
  end

  private

  # def handle_auth(kind)
  #   @user = User.from_omniauth(request.env['omniauth.auth'])
  
  #   if @user.persisted?
  #     if @user.sign_in_count == 1
  #       flash[:notice] = "アカウントが登録されました"
  #     else
  #       flash[:notice] = "ログインしました"
  #     end
  #     sign_in_and_redirect @user, event: :authentication
  #   else
  #     session["devise.#{kind.downcase}_data"] = request.env['omniauth.auth'].except(:extra)
  #     redirect_to new_user_registration_url, alert: @user.errors.full_messages.join("\n")
  #   end
  # end
  

  def handle_auth(kind)
    @user = User.from_omniauth(request.env['omniauth.auth'])

    if @user.persisted?
      sign_in_and_redirect @user, event: :authentication
      set_flash_message(:notice, :success, kind: kind) if is_navigational_format?
    else
      session["devise.#{kind.downcase}_data"] = request.env['omniauth.auth'].except(:extra)
      redirect_to new_user_registration_url, alert: @user.errors.full_messages.join("\n")
    end
  end

  #   if @user.persisted?
  #     if @user.nickname.present?
  #       sign_in_and_redirect @user, event: :authentication
  #       set_flash_message(:notice, :success, kind: "Google") if is_navigational_format?
  #     else
  #       session["devise.google_data"] = request.env["omniauth.auth"].except("extra")
  #       redirect_to new_user_registration_url
  #     end
  #   else
  #     session["devise.google_data"] = request.env["omniauth.auth"].except("extra")
  #     redirect_to new_user_registration_url, alert: @user.errors.full_messages.join("\n")
  #   end
  # end

  

end



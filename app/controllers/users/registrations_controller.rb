class Users::RegistrationsController < Devise::RegistrationsController
  def build_resource(hash = {})
    hash[:uid] = User.create_unique_string
    super
  end

  def update_resource(resource, params)
    return super if params[:password].present?

    resource.update_without_password(params.except('current_password'))
  end

  def delete_account
    # 確認画面を表示するためのアクション
  end

  def destroy_account
    resource = User.find(current_user.id)
    resource.destroy
    Devise.sign_out_all_scopes ? sign_out : sign_out(resource_name)
    set_flash_message! :notice, :destroyed
    yield resource if block_given?
    respond_with_navigational(resource){ redirect_to goodbye_path }
  end

  private

  def sign_up_params
    params.require(:user).permit(:nickname, :email, :password, :password_confirmation)
  end

  def account_update_params
    params.require(:user).permit(:nickname, :email, :password, :password_confirmation)
  end
end

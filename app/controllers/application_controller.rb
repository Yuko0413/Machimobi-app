class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  # ユーザーがサインインした後にホーム画面にリダイレクトする
  def after_sign_in_path_for(resource)
    root_path
  end

  # 認証が必要ない場合に新規登録画面にリダイレクトする
  def after_sign_out_path_for(resource_or_scope)
    new_user_session_path
  end
end

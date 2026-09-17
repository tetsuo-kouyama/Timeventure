class Api::V1::SessionsController < ApplicationController
  allow_unauthenticated_access only: :create
  rate_limit to: 10,
             within: 3.minutes,
             only: :create,
             with: -> {
               render json: {
                 message: "ログイン試行回数が多すぎます。しばらくしてから再試行して下さい"
                   # 429 Too Many Requests（リクエスト過多）を返す
                 }, status: :too_many_requests
               }

  def create
    if user = User.authenticate_by(params.permit(:email_address, :password))
      start_new_session_for user
      # 200 OK（ログイン成功）を返す
      render json: { message: "ログインしました" }, status: :ok
    else
      # 401 Unauthorized（メールアドレスまたはパスワードが不正）を返す
      render json: { message: "ログインに失敗しました" }, status: :unauthorized
    end
  end

  def destroy
    terminate_session
    # 204 No Content（成功（bodyなし）） を返す
    head :no_content
  end
end

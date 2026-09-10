class Api::V1::UsersController < ApplicationController
  allow_unauthenticated_access only: :create

  def create
    user = User.new(user_params)

    if user.save
      start_new_session_for user

      render json: {
        message: "登録に成功しました",
        user: {
          id: user.id,
          email_address: user.email_address
        }
        # 201 Created（POST成功）を返す
      }, status: :created
    else
      render json: {
        errors: user.errors.full_messages
        # 422 Unprocessable Content（バリデーションエラー）を返す
      }, status: :unprocessable_entity
    end
  end

  private

  def user_params
    params.permit(:email_address, :password, :password_confirmation)
  end
end

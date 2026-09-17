class Api::V1::GuestSessionsController < ApplicationController
  allow_unauthenticated_access

  # ゲストログインのレートリミット
  rate_limit to: 3,
             within: 1.minute,
             only: :create,
             with: -> {
               render json: {
                 message: "ゲストログインの試行回数が多すぎます"
               }, status: :too_many_requests
             }

  def create
    password = SecureRandom.urlsafe_base64

    user = User.create!(
      email_address: "guest_#{SecureRandom.uuid}@example.com",
      password: password,
      password_confirmation: password,
      guest: true
    )

    start_new_session_for user

    render json: {
      message: "ゲストとしてログインしました"
    }, status: :created
  end
end

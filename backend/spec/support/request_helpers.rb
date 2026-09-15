module RequestHelpers
  def login(user, password: "password")
    post api_v1_session_path, params: {
      session: {
        email_address: user.email_address,
        password: user.password
      }
    }
  end
end

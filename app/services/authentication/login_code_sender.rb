module Authentication
  class LoginCodeSender
    def self.call(user)
      new(user).call
    end

    def initialize(user)
      @user = user
    end

    def call
      generate_login_code
      send_login_code_email
      create_temporary_session
    end

    private

    attr_reader :user

    def generate_login_code
      user.set_login_code
    end

    def send_login_code_email
      UserMailer.login_code_email(user).deliver_now
    end

    def create_temporary_session
      user.signed_id(expires_in: 15.minutes)
    end
  end
end

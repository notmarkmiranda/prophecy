module Memberships
  class Creator
    attr_reader :email, :memberable, :role

    def initialize(email:, memberable:, role: :participant)
      @email = email
      @memberable = memberable
      @role = role
    end

    def call
      user = User.find_or_create_by(email: email)
      membership = memberable.memberships.new(user: user, role: role) if user.persisted?

      Result.new(
        success: membership&.save,
        membership: membership,
        user: user,
        errors: collect_errors(user, membership)
      )
    end

    private

    def collect_errors(user, membership)
      return [ "Email can't be blank" ] if email.blank?
      return [ "Invalid email format" ] unless email.match?(URI::MailTo::EMAIL_REGEXP)

      errors = []
      errors.concat(user.errors.full_messages) if user.errors.any?
      errors.concat(membership.errors.full_messages) if membership&.errors&.any?
      errors
    end

    class Result
      attr_reader :membership, :user, :errors

      def initialize(success:, membership:, user:, errors:)
        @success = success
        @membership = membership
        @user = user
        @errors = errors
      end

      def success?
        @success && errors.empty?
      end

      def failure?
        !success?
      end
    end
  end
end

class MembershipsController < ApplicationController
  before_action :require_login, except: :verify
  before_action :set_pool, only: [ :new, :create ]

  def new
    @membership = @pool.memberships.new
  end

  def create
    result = Memberships::Creator.new(
      email: params[:membership][:email],
      memberable: @pool
    ).call

    if result.success?
      MembershipMailer.with(
        membership: result.membership,
        inviter: current_user
      ).invitation_email.deliver_later

      redirect_to @pool, notice: "Member was successfully added and invitation email sent."
    else
      @membership = result.membership || @pool.memberships.new
      flash.now[:alert] = result.errors.to_sentence
      render :new, status: :unprocessable_entity
    end
  end

  def verify
    @membership = Membership.verify_token(params[:token])

    if @membership
      @membership.update!(status: :active)
      redirect_to dashboard_path, notice: "Membership successfully verified!"
    else
      redirect_to root_path, alert: "Invalid or expired verification link."
    end
  end

  private

  def set_pool
    @pool = Pool.find(params[:id])
  end
end

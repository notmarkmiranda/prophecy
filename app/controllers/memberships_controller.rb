class MembershipsController < ApplicationController
  before_action :require_login
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
      redirect_to @pool, notice: "Member was successfully added."
    else
      @membership = result.membership || @pool.memberships.new
      flash.now[:alert] = result.errors.to_sentence
      render :new, status: :unprocessable_entity
    end
  end

  private

  def set_pool
    @pool = Pool.find(params[:id])
  end
end

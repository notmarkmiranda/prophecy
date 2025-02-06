class EntriesController < ApplicationController
  include PoolsHelper

  before_action :require_login
  before_action :set_pool
  before_action :ensure_pool_accepting_entries

  def new
    @entry = @pool.entries.new(user: current_user)
  end

  def create
    @entry = @pool.entries.new(user: current_user)

    if @entry.save
      redirect_to @pool, notice: "Entry was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  def set_pool
    @pool = Pool.find(params[:pool_id])
  end

  def ensure_pool_accepting_entries
    unless accepting_entries?(@pool, @pool.questions.persisted)
      redirect_to @pool, alert: "This pool is not accepting entries at this time."
    end
  end
end

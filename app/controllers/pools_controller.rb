class PoolsController < ApplicationController
  before_action :require_login

  def show
    @pool = Pool.includes(:group, questions: :options).find(params[:id])
    @questions = @pool.questions.persisted
    # Build a new question with 4 blank options for the form
    @new_question = @pool.questions.build
    4.times { @new_question.options.build }
  end

  def new
    @pool = current_user.pools.new
    @default_locked_at = 1.month.from_now.change(hour: 12, minute: 0)
  end

  def create
    if params[:pool][:group_id] == "new"
      group = current_user.groups.create(name: params[:pool][:new_group_name])
      params[:pool][:group_id] = group.id
    end

    @pool = current_user.pools.new(pool_params)
    if @pool.save
      redirect_to pool_path(@pool), notice: "Pool was successfully created."
    else
      render :new
    end
  end

  def edit
    @pool = current_user.pools.find(params[:id])
  end

  def update
    if params[:pool][:group_id] == "new"
      group = current_user.groups.create(name: params[:pool][:new_group_name])
      params[:pool][:group_id] = group.id
    end

    @pool = current_user.pools.find(params[:id])
    if @pool.update(pool_params)
      redirect_to pool_path(@pool), notice: "Pool was successfully updated."
    else
      render :edit
    end
  end

  private

  def pool_params
    params.require(:pool).permit(:name, :price, :allow_multiple_entries, :locked_at, :group_id)
  end
end

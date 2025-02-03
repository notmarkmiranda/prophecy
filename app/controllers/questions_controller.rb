class QuestionsController < ApplicationController
  before_action :require_login
  before_action :set_pool
  before_action :authorize_pool_admin!

  def create
    @question = @pool.questions.build(question_params)

    if @question.save
      redirect_to @pool, notice: "Question was successfully created."
    else
      redirect_to @pool, alert: @question.errors.full_messages.to_sentence
    end
  end

  private

  def set_pool
    @pool = Pool.find(params[:pool_id])
  end

  def authorize_pool_admin!
    unless @pool.user == current_user || @pool.admins.include?(current_user)
      redirect_to @pool, alert: "You are not authorized to manage questions."
    end
  end

  def question_params
    params.require(:question).permit(:text, options_attributes: [ :text ])
  end
end

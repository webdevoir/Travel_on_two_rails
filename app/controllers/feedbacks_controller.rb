class FeedbacksController < ApplicationController

  def create
    @feedback = Feedback.new(feedback_params)
    if @feedback.save

      redirect_to "/"
    else
      redirect_to "/"
    end
  end

  private
  def feedback_params
    params.require(:feedback).permit(:content, :email)
  end
end

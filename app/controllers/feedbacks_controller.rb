class FeedbacksController < ApplicationController

  def create
    @feedback = Feedback.new(feedback_params)
    if @feedback.save
      SendFeedbackEmailJob.set(wait: 20.seconds).perform_later(@feedback)
      flash[:notice] = "Feedback sent, thank you so much for your feedback!"
      redirect_to "/"
    else
      flash[:error] = "Something went wrong, please try again."
      redirect_to "/"
    end
  end

  private
  def feedback_params
    params.require(:feedback).permit(:content, :email)
  end
end

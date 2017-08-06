class Api::V1::TransactionsController < Api::V1::BaseController
  before_action :load_donation_goal

  def create
    @trip = Trip.find(params[:trip_id])

    @result = Braintree::Transaction.sale(
          amount: params[:amount],
          payment_method_nonce: params[:payment_method_nonce])

    if @result.success?
      current_user.update(braintree_customer_id: @result.transaction.customer_details.id) unless current_user.has_payment_info?
      @donation_goal.current_paid += params[:amount].to_f
      if @donation_goal.save
        render(json: {:success => "success"}.to_json)
      else
        render(json: {:success => "error"}.to_json)
      end
    else
      flash[:alert] = "Something went wrong while processing your transaction. Please try again!"
      gon.client_token = generate_client_token
      render(json: {:success => "error"}.to_json)
    end
  end

  private
  def generate_client_token
    if current_user.has_payment_info?
      Braintree::ClientToken.generate(customer_id: current_user.braintree_customer_id)
    else
      Braintree::ClientToken.generate
    end
  end

  def load_donation_goal
    trip = Trip.find(params[:trip_id])
    @donation_goal = trip.donation_goal
    return @donation_goal
  end

end

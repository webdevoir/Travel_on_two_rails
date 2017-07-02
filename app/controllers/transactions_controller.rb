class TransactionsController < ApplicationController
  before_action :load_donation_goal

  def new
    @trip = Trip.find(params[:trip_id])
    gon.client_token = generate_client_token
  end

  def create
    @trip = Trip.find(params[:trip_id])

    @result = Braintree::Transaction.sale(
          amount: params[:amount],
          payment_method_nonce: params[:payment_method_nonce])

    if @result.success?
      current_user.update(braintree_customer_id: @result.transaction.customer_details.id) unless current_user.has_payment_info?
      @donation_goal.current_paid += params[:amount].to_f
      if @donation_goal.save
        redirect_to trip_url(@trip), notice: "Congraulations! Your transaction has been successfully!"
      else
        redirect_to trip_url(@trip), notice: "Something went wrong, your transaction went through but the amount on the page will not be updated, please email us and we can sort this out."
      end
    else
      flash[:alert] = "Something went wrong while processing your transaction. Please try again!"
      gon.client_token = generate_client_token
      redirect_to trip_transactions_url(@trip)
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

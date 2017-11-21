class TransactionsController < ApplicationController
  before_action :load_donation_goal

  def new
    @trip = Trip.find(params[:trip_id])
    @user_stripe_account = @current_user.stripe_account.stripe_customer_id
    @stripe_account = StripeAccount.new()
    # gon.client_token = generate_client_token
  end

  def create
    @trip = Trip.find(params[:trip_id])
    @stripe_account = @current_user.stripe_account

    raise 'hit'

    if params["stripeToken"] != nil
      customer = Stripe::Customer.create(
        email: @current_user.email,
        source: params["stripeToken"]
      )
      @stripe_account.stripe_customer_id = customer.id
      @stripe_account.save
    end
    fee = total_amount*(0.1)
    amount = total_amount - fee
    charge = Stripe::Charge.create({
      # Total Amount user will be charged (in cents)
      amount: total_amount,
      # Currency of charge
      currency: 'USD',
      # the applicant users Stripe Customer ID
      # expect format of "cus_0xxXxXXX0XXxX0"
      customer: @stripe_account.stripe_customer_id,
      # Description of charge
      description: "Donation from #{@current_user.name} to #{@trip.user.name}",
      # Final Destination of charge (host standalone account)
      # Expect format of acct_00X0XXXXXxxX0xX
      destination: @trip.user.stripe_account.uid,
      application_fee: fee.to_i
      }
    )
    if charge["status"] == "succeeded"
      @donation_goal.current_paid += params[:amount].to_f
      if @donation_goal.save
        redirect_to trip_url(@trip), notice: "Congraulations! Your transaction has been successfully!"
      else
        redirect_to trip_url(@trip), notice: "Something went wrong, your transaction went through but the amount on the page will not be updated, please email us and we can sort this out."
      end
    else
      flash[:alert] = "Something went wrong while processing your transaction. Please try again!"
      redirect_to trip_transactions_url(@trip)
    end
  end

  private
  # def generate_client_token
  #   if current_user.has_payment_info?
  #     Braintree::ClientToken.generate(customer_id: current_user.braintree_customer_id)
  #   else
  #     Braintree::ClientToken.generate
  #   end
  # end

  def load_donation_goal
    trip = Trip.find(params[:trip_id])
    @donation_goal = trip.donation_goal
    return @donation_goal
  end

end

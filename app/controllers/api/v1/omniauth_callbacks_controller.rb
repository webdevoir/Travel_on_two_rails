class Api::V1::OmniauthCallbacksController < Devise::OmniauthCallbacksController

  def stripe_connect
    auth_data = request.env["omniauth.auth"]
    @user = current_user
    if @user.persisted? && @user.stripe_account == nil
      @stripe_account = StripeAccount.new({
          user_id: @user.id,
          provider: auth_data.provider,
          access_code: auth_data.credentials.token,
          publishable_key: auth_data.info.stripe_publishable_key,
          uid: auth_data.uid
      })
      @stripe_account.save

      sign_in_and_redirect @user, event: :authentication
      flash[:notice] = 'Stripe Account Created And Connected' if is_navigational_format?
    else
      session["devise.stripe_connect_data"] = request.env["omniauth.auth"]
      redirect_to host_dashboard
    end
  end

  def failure
    # If we do get failures we should probably handle them more explicitly than just rerouting to root. To review in the future with colo
    redirect_to root_path
  end

end

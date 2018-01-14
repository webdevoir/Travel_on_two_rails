class Api::V1::SessionsController < Api::V1::BaseController
  # prepend_before_filter :require_no_authentication, :only => [:create ]

  before_filter :ensure_params_exist

  respond_to :json

  api :post, "sessions"
  param :email, String
  param :password, String
  def create
    # build_resource
    resource = User.find_for_database_authentication(:email=>params[:email])
    return invalid_login_attempt unless resource

    if resource.valid_password?(params[:password])
      sign_in("user", resource)
      # render :json=> {:success=>true, :auth_token=>resource.authentication_token, :login=>resource.login, :email=>resource.email}
      render :json=> {:success=>true, :email=>resource.email, :user_id=>resource.id, :user => resource}
      return
    end
    invalid_login_attempt
  end

  api :delete, "sign_out"
  def destroy
    sign_out(resource_name)
  end

  protected
  def ensure_params_exist
    return unless params.blank?
    render :json=>{:success=>false, :message=>"missing user_login parameter"}, :status=>422
  end

  def invalid_login_attempt
    warden.custom_failure!
    render :json=> {:success=>false, :message=>"Error with your login or password"}, :status=>401
  end
end

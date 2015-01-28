class OmniauthCallbacksController < Devise::OmniauthCallbacksController
  skip_before_filter :authenticate_user!

  def all
    auth_obj = env['omniauth.auth']
    user = User.from_omniauth(auth_obj, current_user)

    if user.persisted?
      flash[:notice] = "Signed In"
      sign_in_and_redirect user, :event => :authentication
    else
      session["devise.user_attributes"] = user.attributes
      redirect_to new_user_registration_url
    end
  end

  alias_method :twitter, :all
end

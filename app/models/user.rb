class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :omniauthable, :omniauth_providers => [:twitter]

  def self.from_omniauth(auth, current_user)
    user = current_user.nil? ? User.where(provider: auth.provider, uid: auth.uid.to_s) : current_user
    if user.blank?
      user = User.new
      user.provider = auth.provider
      user.uid = auth.uid

      user.password = Devise.friendly_token[0, 20]
      user.name = auth.info.name
      user.email = auth.info.email

      # 트위터는 email이 없다. 근데 email이 없으면 저장이 안된다
      user.email = '' if auth.provider == 'twitter'

      auth.provider == 'twitter' ? user.save(:validate => false) : user.save
      user
    else
      user.first
    end
  end

  def self.new_with_session(params, session)
    if session['devise.user_attributes']
      new(session['devise.user_attributes'], without_protection: true) do |user|
        user.attributes = params
        user.valid?
      end
    else
      super
    end
  end
end

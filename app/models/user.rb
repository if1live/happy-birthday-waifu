# == Schema Information
#
# Table name: users
#
#  id                     :integer          not null, primary key
#  email                  :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  reset_password_token   :string
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  sign_in_count          :integer          default(0), not null
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :string
#  last_sign_in_ip        :string
#  token                  :string
#  secret                 :string
#  created_at             :datetime
#  updated_at             :datetime
#  name                   :string
#  provider               :string
#  uid                    :string
#  screen_name            :string
#

class User < ActiveRecord::Base
  include FavoritesHelper

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :omniauthable, :omniauth_providers => [:twitter]

  has_many :favorite

  def self.from_omniauth(auth, current_user)
    user = current_user.nil? ? User.where(provider: auth.provider, uid: auth.uid.to_s) : current_user
    if user.blank?
      need_create = true
      user = User.new

      # 바뀌지 않는 값만 new에서 할당
      user.provider = auth.provider
      user.uid = auth.uid
      user.password = Devise.friendly_token[0, 20]

      # 트위터는 email이 없다. 근데 email이 없으면 저장이 안된다
      # email은 고유값이 들어가야한다. 그래서 공백은 불가능
      # 적당히 하나 만들어넣는다
      user.email = "#{user.uid}@twitter.com" if auth.provider == 'twitter'

      user
    else
      need_create = false
      user = user.first
    end

    # 바뀌었을 가능성이 있는것은 매번 다시 저장
    user.token = auth.credentials.token
    user.secret = auth.credentials.secret

    # production 에서는 auth.info가 안먹힌다
    # 대신 auth.extra.raw_info를 사용해야한다.
    # https://github.com/arunagw/omniauth-twitter
    user.name = auth.info.name
    user.screen_name = auth.extra.raw_info.screen_name

    user.save
    user
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

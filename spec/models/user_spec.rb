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

require 'rails_helper'

RSpec.describe User, :type => :model do
  #pending "add some examples to (or delete) #{__FILE__}"
end

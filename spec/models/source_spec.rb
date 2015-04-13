# == Schema Information
#
# Table name: sources
#
#  id             :integer          not null, primary key
#  slug           :string
#  title_en       :string
#  title_jp       :string
#  title_romaji   :string
#  title_furigana :string
#  anime_db_id    :integer
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#

require 'rails_helper'

RSpec.describe Source, :type => :model do
  pending "add some examples to (or delete) #{__FILE__}"
end

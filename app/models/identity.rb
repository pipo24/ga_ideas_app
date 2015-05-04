class Identity < ActiveRecord::Base
  validates_presence_of :uid, :provider
  validates_uniqueness_of :uid, scope: :provider
  belongs_to :user
end

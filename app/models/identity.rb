class Identity < ActiveRecord::Base
  belongs_to :user
  # after_create :fetch_details
  validates_presence_of :uid, :provider
  # validates_uniqueness_of :uid, scope: :provider

  def self.find_for_oauth(auth)
    identity = find_by(provider: auth.provider, uid: auth.uid)
    identity = create(uid: auth.uid, provider: auth.provider) if identity.nil?
    identity
  end

  def fetch_details
    self.send("fetch_details_from_#{self.provider.downcase}")
  end

  def fetch_details_from_twitter
  end
end

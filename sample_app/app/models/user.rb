class User < ActiveRecord::Base
  has_many :microposts, dependent: :destroy
  before_save { self.email = email.downcase }
  before_create :create_remember_token  
  has_secure_password
  
  def User.new_remember_token
    SecureRandom.urlsafe_base64
  end

  def User.encrypt(token)
    Digest::SHA1.hexdigest(token.to_s)
  end

  private

	def create_remember_token
	  self.remember_token = User.encrypt(User.new_remember_token)
	end

  def feed
    # このコードは準備段階です。
    # 完全な実装は第11章「ユーザーをフォローする」を参照してください。
    Micropost.where("user_id = ?", id)
  end
  
end

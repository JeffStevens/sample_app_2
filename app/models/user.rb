class User < ActiveRecord::Base
	VALID_MAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i	

	validates :name, presence: :true, length: { maximum: 50 }
	validates :email, presence: :true, length: { maximum: 255 },
					  format: { with: VALID_MAIL_REGEX },
					  uniqueness: { case_sensitive: false }
	validates :password, presence: :true, length: { minimum: 6 }, allow_nil: true
	has_secure_password
end

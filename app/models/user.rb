class User < ActiveRecord::Base
	VALID_MAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i

	has_many :entries

	validates :name, presence: :true, length: { maximum: 50 }
	validates :email, presence: :true, length: { maximum: 255 },
					  format: { with: VALID_MAIL_REGEX },
					  uniqueness: { case_sensitive: false }
	validates :password, presence: :true, length: { minimum: 6 }, allow_nil: true

	has_secure_password
	before_save :downcase_email

	def downcase_email
		self.email = email.downcase
	end

	def feed
		Entry.where "user_id = ?", id
	end
end

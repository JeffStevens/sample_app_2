class User < ActiveRecord::Base
	VALID_MAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i

	has_many :entries
	has_many :comments
	has_many :active_relationships, class_name: "Relationship",
									foreign_key: "follower_id",
									dependent: :destroy
	has_many :passive_realtionships, class_name: "Relationship",
									 foreign_key: "followed_id",
									 dependent: :destroy
	has_many :following, through: :active_relationships, source: :followed
	has_many :followers, through: :passive_realtionships, source: :follower

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

	def follow other_user
		active_relationships.create followed_id: other_user.id
	end

	def unfollow other_user
		active_relationships.find_by(followed_id: other_user.id).destroy
	end

	def following? other_user
		following.include? other_user
	end
end

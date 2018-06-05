class User < ApplicationRecord
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i

  validates :name, presence: true, length: {maximum: Settings.name_max_length}
  validates :email, presence: true, length: {maximum: Settings.email_max_length},
    format: {with: VALID_EMAIL_REGEX},
    uniqueness: {case_sensitive: false}
  validates :password, presence: true, length: {minimum: Settings.pass_min_length}

  before_save{self.email = email.downcase}

  has_secure_password
end

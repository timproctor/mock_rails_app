class User < ActiveRecord::Base
  has_secure_password

  validates :name, presence: true
  validates :email, presence: true,
                    format: {
                        with: /\A\S+@\S+\z/,
                        message: "try another format"
                      },
                    uniqueness: {
                        case_sensitive: false
                      }
  validates :password, length: { minimum: 10, allow_blank: true }
  validates :username, presence: true, uniqueness: { case_sensitive: false },
            format: {with: /\A[A-Z0-9]+\z/i}


end

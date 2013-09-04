class User < ActiveRecord::Base
  rolify
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable, :lockable, :timeoutable and :omniauthable
  devise :invitable,
         :database_authenticatable,
         :registerable,
         :confirmable,
         :recoverable,
         :rememberable,
         :trackable,
         :validatable

  has_many :contributions
  has_one :membership

  delegate :approved?, :new?, to: :membership, prefix: true, allow_nil: true

  def guest?
    !membership
  end

  def admin?
    has_role?(:admin)
  end

  def membership_state
    guest? ? 'guest' : membership.state
  end
end

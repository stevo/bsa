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

  mount_uploader :avatar, AvatarUploader

  has_many :contributions
  has_one :membership
  has_one :voting, through: :membership

  delegate :approved?, :new?, :being_polled?, :disapproved?, to: :membership, prefix: true, allow_nil: true

  def guest?
    !membership
  end

  def latest_contribution
    contributions.order(:expires_at).last
  end

  def admin?
    has_role?(:admin)
  end

  def membership_state
    guest? ? 'guest' : membership.state
  end
end

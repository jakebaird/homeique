require 'users_helper'

class User < ActiveRecord::Base
  belongs_to :referrer, class_name: 'User', foreign_key: 'referrer_id'
  has_many :referrals, class_name: 'User', foreign_key: 'referrer_id'

  validates :email, presence: true, uniqueness: true, format: {
    with: /\w+([-+.']\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*/i,
    message: 'Invalid email format.'
  }
  validates :referral_code, uniqueness: true

  before_create :create_referral_code
  after_create :send_welcome_email

  REFERRAL_STEPS = [
    {
      'count' => 5,
      'html' => 'Free <b>green</b> Member<br>Round 4 Access', 
      'class' => 'two',
      'image' =>  ActionController::Base.helpers.asset_path(
        'img/blade-explain@2x.png')
    },
    {
      'count' => 15,
      'html' => 'Free <b>Silver</b> Member <br> Round 3 Access ',
      'class' => 'three',
      'image' => ActionController::Base.helpers.asset_path(
        'img/blade-explain@2x.png')
    },
    {
      'count' => 30 ,
      'html' => 'Free <b>Gold</b> Member <br> Round 2 Access <br> -Exclusive Finance Deals',
      'class' => 'four',
      'image' => ActionController::Base.helpers.asset_path(
        'img/blade-explain@2x.png')
    },
    {
      'count' => 60,
      'html' => 'Free <b>Platinum</b> Member <br>- Round 1 Access <br> - <b>Invite Only Opportunities</b> <br> -Exclusive Finance Deals ',
      'class' => 'five',
      'image' => ActionController::Base.helpers.asset_path(
        'img/blade-explain@2x.png')
    }
  ]

  private

  def create_referral_code
    self.referral_code = UsersHelper.unused_referral_code
  end

  def send_welcome_email
    UserMailer.delay.signup_email(self)
  end
end

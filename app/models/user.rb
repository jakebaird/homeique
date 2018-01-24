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
      'html' => '<b>Green</b> Membership', 
      'class' => 'two',
      'image' =>  ActionController::Base.helpers.asset_path(
        'img/blade-explain@2x.png')
    },
    {
      'count' => 15,
      'html' => '<b>Silver</b> Membership',
      'class' => 'three',
      'image' => ActionController::Base.helpers.asset_path(
        'img/blade-explain@2x.png')
    },
    {
      'count' => 30 ,
      'html' => '<b>Gold</b><br> Membership <br>',
      'class' => 'four',
      'image' => ActionController::Base.helpers.asset_path(
        'img/blade-explain@2x.png')
    },
    {
      'count' => 60,
      'html' => '<b>Platinum</b> Membership',
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

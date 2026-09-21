class User < ApplicationRecord
  has_secure_password

  has_many :sessions, dependent: :destroy
  has_one :timer_setting, dependent: :destroy
  has_many :timer_sessions, dependent: :destroy
  has_one :character, dependent: :destroy

  # User のレコードが DB に作成された「直後」に指定したメソッドを実行
  after_create :create_default_timer_setting
  after_create :create_default_character

  validates :email_address, presence: true,
                            uniqueness: true,
                            format: { with: URI::MailTo::EMAIL_REGEXP }

  validates :password, length: { minimum: 6 },
                       confirmation: true,
                       allow_nil: true

  normalizes :email_address, with: ->(e) { e.strip.downcase }

  private

  # 初期タイマー設定を作成する
  def create_default_timer_setting
    create_timer_setting!
  end

  # 初期キャラクターを作成する
  def create_default_character
    create_character!
  end
end

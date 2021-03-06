class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  mount_uploader :avatar, AvatarUploader

  # 需要 app/views/devise 裡找到樣板，加上 name 屬性
  # 並參考 Devise 文件自訂表單後通過 Strong Parameters 的方法
  validates :name, presence: true, uniqueness: { case_sensitive: true }
  # 加上驗證 name 不能重覆 (關鍵字提示: uniqueness)
  has_many :tweets, dependent: :destroy
  has_many :replies, dependent: :destroy

  has_many :likes, dependent: :destroy
  has_many :liked_tweets, through: :likes, source: :tweet

  has_many :followships, dependent: :destroy#外鍵預設為user_id
  has_many :followings, through: :followships#有很多自己追蹤的user

  has_many :inverse_followships, class_name: "Followship", foreign_key: :following_id
  has_many :followers, through: :inverse_followships, source: :user # 從inverse_followships表裡面的user欄位去找
  def admin?
    self.role == 'admin'
  end

  def following?(other_user)
    self.followings.include?(other_user)
  end

  def like?(tweet)
    self.liked_tweets.include?(tweet)
  end
end

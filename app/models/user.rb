class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  has_many :students, dependent: :destroy

  
  validates :name, presence: true
  
  enum role: [:teacher, :admin]
  after_initialize :set_default_role, if: :new_record?

  def set_default_role
    self.role ||= :teacher
  end
end

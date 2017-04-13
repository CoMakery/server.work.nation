class Skill < ApplicationRecord
  belongs_to :user
  has_many :confirmations

  def as_json options={}
    {
        name: name,
        confirmationCount: confirmations.size,
        projectCount: project_count
    }
  end
end

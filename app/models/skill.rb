class Skill < ApplicationRecord
  belongs_to :user

  def as_json options={}
    {
        name: name,
        confirmationCount: confirmation_count,
        projectCount: project_count
    }
  end
end

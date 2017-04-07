class Skill < ApplicationRecord
  belongs_to :user

  def as_json options={}
    {
        name: name,
        confirmation_count: confirmation_count,
        project_count: project_count
    }
  end
end

class Project < ApplicationRecord
  acts_as_taggable_on :skills
  validates :name, presence: true

  def as_json(_options = {})
    {
      name: name,
      permanodeId: permanode_id,
    }
  end
end

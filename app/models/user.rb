class User < ApplicationRecord
  has_many :skills

  def as_json options={}
    {
        name: name,
        uport_address: uport_address,
        skills: skills.map(&:as_json)
    }
  end
end

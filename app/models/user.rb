class User < ApplicationRecord
  has_many :skills
  has_many :confirmations

  validates_presence_of :uport_address
  validates_uniqueness_of :uport_address

  def self.find(input)
    find_by_uport_address(input)
  end

  def to_param
    uport_address
  end

  def as_json options={}
    {
        name: name,
        uportAddress: uport_address,
        skills: skills.map(&:as_json)
    }
  end
end

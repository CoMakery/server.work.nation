class User < ApplicationRecord
  def as_json options={}
    {
        name: name,
        uport_address: uport_address,
        skills: []
    }
  end
end

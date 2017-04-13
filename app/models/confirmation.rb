class Confirmation < ApplicationRecord
  belongs_to :skill,
             counter_cache: true  # to use cached db column: skill.confirmations.size (not .count)
end

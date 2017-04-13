class Confirmation < ApplicationRecord
  belongs_to :skill,
             counter_cache: true  # to use cached db column: skill.confirmations_count (not skill.confirmations.count)
end

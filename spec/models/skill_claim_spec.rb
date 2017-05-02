require 'rails_helper'

RSpec.describe SkillClaim, type: :model do
  specify { expect(SkillClaim.new.project_count).to eq(0) }

  specify { expect(SkillClaim.new.confirmations.size).to eq(0) }

  specify { expect(SkillClaim.new.confirmations_count).to eq(0) }
end

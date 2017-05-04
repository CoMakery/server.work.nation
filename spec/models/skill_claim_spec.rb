require 'rails_helper'

RSpec.describe SkillClaim, type: :model do
  specify { expect(SkillClaim.new.confirmations.size).to eq(0) }

  specify { expect(SkillClaim.new.confirmations_count).to eq(0) }

  describe 'join to project' do
    let!(:project) { create :project }
    let!(:skill_claim) do
      create :skill_claim,
        project_permanode_id: project.permanode_id
    end

    specify do
      expect(skill_claim.project).to eq(project)
    end
  end
end

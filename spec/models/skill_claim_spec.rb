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

    describe '2 skill claims with same name for same user on the same project' do
      let(:user) { create :user }
      let(:project) { create :project }

      before do
        create :skill_claim, name: 'Ruby', user: user, project: project
      end

      specify do
        expect do
          create :skill_claim, name: 'Ruby', user: user, project: project
        end.to raise_error(ActiveRecord::RecordInvalid, /'Ruby' .* existing skill claim .* user ##{user.id} .* project #{project.permanode_id}/)
      end
    end
  end
end

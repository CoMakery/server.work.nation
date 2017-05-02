class SkillsController < ApplicationController
  def index
    skills = SkillClaim.select('name').distinct.order(:name).pluck(:name)
    render json: skills
  end
end

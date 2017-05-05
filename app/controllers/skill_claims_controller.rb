class SkillClaimsController < ApplicationController
  # A list of skill claims, marked as confirmed or not by the specified user
  # GET /users/0x5d2e5e76624b05377dd9405df253e877532f9733/confirmables
  def confirmables
    skill_claims = SkillClaim
                   .where.not('users.uport_address': params[:user_uport_address])
                   .includes(:user)
                   .order('skill_claims.created_at DESC')
                   .limit(300)
    render json: skill_claims.as_json(
      user: true,
      project: true,
      confirmed_by?: params[:user_uport_address],
    )
  end
end

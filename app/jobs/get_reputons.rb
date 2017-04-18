class GetReputons
  include Sidekiq::Worker

  def perform
    known_claim_count = 5 # TODO: get from, and store in, DB
    Worknation::Reputon.get_latest_reputons(known_claim_count)
  end
end

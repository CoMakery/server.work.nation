class GetReputons
  include Sidekiq::Worker

  def perform
    known_claim_count = 5
    logger.info "---> !"
    reputons = Worknation::Reputon.get_latest_reputons(known_claim_count)
    # logger.info "---> reputons"
    # logger.info reputons
    # reputons.each do |reputon|
    #   logger.info "---> reputon"
    #   logger.info reputon
    #   HandleReputon.perform_async(reputon)
    # end
  end
end

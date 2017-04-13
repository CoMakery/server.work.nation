require_relative 'config/environment'

# class WorkNation::ReputonNotFound < StandardError
# end
#
# class WorkNation::ReputonSignatureInvalid < StandardError
# end
#
# class WorkNation::ReputonInvalid < StandardError
#   attr_reader :object
#   def initialize(object)
#     @object = object
#   end
# end

def error(*args)
  args.each do |arg|
    puts arg.to_s.red
  end
end

def address(candidate)
  candidate&.sub(/^0x/, '')
end

start = Time.current

client = Ethereum::HttpClient.new('https://ropsten.infura.io/7YRuqHoxzZfJhyGdvVq0')

contract = Ethereum::Contract.create(
  file: '/Users/harlan/comakery/clients/cisco/contracts.work.nation/Claim.sol',
  address: '0x8cb4cb36e7cc72bb84f48daed7cb8071c3f55f8f',
  client: client
)

known_claim_count = 5

claim_count = contract.call.claim_count

(known_claim_count + 1...claim_count).each do |claim_index|
  puts
  puts "Claim ##{claim_index}".purple
  ipfs_key = contract.call.get_claim(claim_index)
  signer = contract.call.get_signer(ipfs_key)

  p ipfs_url = "https://ipfs.io/ipfs/#{ipfs_key}"
  response = HTTParty.get(ipfs_url)
  # puts response.body, response.code #, response.message, response.headers.inspect
  p response.code
  if response.code != 200
    # raise WorkNation::ReputonNotFound.new(), "Error fetching #{ipfs_url.inspect}: #{response.code.inspect}\n#{response.body}"
    error "Error fetching #{ipfs_url}", response.body, response.code
    next
  end

  reputons = JSON.parse(response.body)
  ap reputons
  application = reputons['application']
  if application != 'skills'
    error "Expected application 'skills' but was: #{reputon['application']}"
    next
  end

  reputons['reputons'].each do |reputon|
    if address(reputon['rater']) != address(signer)
      error "Reputon rater: #{reputon['rater'].inspect} should match transaction signer: #{signer.inspect}.\nFull reputon:\n#{JSON.pretty_unparse(reputon)}"
      next
    end
    if reputon['rater'] == reputon['rated']
      user = User.find_or_create_by(uport_address: reputon['rater'])
      ap user.skills.create!(
        name: reputon['assertion'],
        ipfs_reputon_key: ipfs_key
      )
    else
      # TODO: reject conf if normal rating not 0.5

      confirmer = User.find_or_create_by(uport_address: reputon['rater'])
      ap skill = Skill.find_by(ipfs_reputon_key: reputon['rated'])
      if address(confirmer.uport_address) == address(skill.user.uport_address)
        error "Attempting to self confirm, rejected.\nFull reputon:\n#{JSON.pretty_unparse(reputon)}"
        next
      end
      ap confirmer.confirmations.create!(
        user: confirmer,
        skill: skill,
        claimant: skill.user,
        rating: reputon['rating'],
        ipfs_reputon_key: ipfs_key
      )
    end
  end
end

finish = Time.current
p "#{(finish - start)} seconds"

#
# # // this claim has IPFS address QmX3eFcpPL3bN3EBzcPnUH4fTiJyWi3G8NxEZjfKCGqrnj
# claim = {
#     "application" => "skills",
#     "reputons" => [
#         {
#             "rater" => "0x57fab088be2f8bfd5d4cbf849c2568672e4f3db3", # // Harlan
#             "assertion" => "Ruby on Rails",
#             "rated" => "0x57fab088be2f8bfd5d4cbf849c2568672e4f3db3", # // Harlan
#             "rating" => 1,
#             "sample-size" => 1
#         }
#     ]
# }
#
# confimation = {
#     "application" => "skills",
#     "reputons" => [
#         {
#             "rater" => "0x9df6d7f675d119228eae858213587c0687d0a498", # // Alice
#             "assertion" => "confirm",
#             "rated" => "QmX3eFcpPL3bN3EBzcPnUH4fTiJyWi3G8NxEZjfKCGqrnj", # // Harlan"s signed claim of ROR skills
#             "rating" => 1, # // 1 = master, 0.5 = confirm
#             "normal-rating" => 0.5,
#             "sample-size" => 1
#         }
#     ]
# }

# summarize skills for this user
# get users who have skills xyz in my network
# verify underlying data

# skill <-[trust]- confirmation
# alice <-[trust]- bob

# user = me
# skill = 'ruby'
#
# def get_network(user, depth = 1)
#   for confirmation in user.confirmations
#     get_network(confirmation.claimant, depth - 1)
#   end
# end
#
# search network for network

require_relative 'config/environment'

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

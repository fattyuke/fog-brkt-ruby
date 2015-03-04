# Use so you can run in mock mode from the command line
#
# FOG_MOCK=true fog

if ENV["FOG_MOCK"] == "true"
  Fog.mock!
end

# if in mocked mode, fill in some fake credentials for us
if Fog.mock?
  Fog.credentials = {
    brkt_public_access_token: "token",
    brkt_private_mac_key:     "key"
  }.merge(Fog.credentials)
else
  Fog.credentials = {
    brkt_public_access_token: ENV['BRKT_PUBLIC_ACCESS_TOKEN'],
    brkt_private_mac_key:     ENV['BRKT_PRIVATE_MAC_KEY']
  }.merge(Fog.credentials)
end

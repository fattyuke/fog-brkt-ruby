# Use so you can run in mock mode from the command line
#
# FOG_MOCK=true fog

if ENV["FOG_MOCK"] == "true" || ENV["FOG_MOCK"] == "1" || ENV["FOG_MOCK"] == nil
  Fog.mock!
end

# if in mocked mode, fill in some fake credentials for us
if Fog.mock?
  Fog.credentials = {
    :brkt_public_access_token => "token",
    :brkt_private_mac_key     => "key",
    :brkt_api_host            => "http://not.important"
  }.merge(Fog.credentials)
else
  public_access_token  = ENV['BRKT_PUBLIC_ACCESS_TOKEN']
  brkt_private_mac_key = ENV['BRKT_PRIVATE_MAC_KEY']
  api_host             = ENV['BRKT_API_HOST']

  if public_access_token.nil? || public_access_token == '' || brkt_private_mac_key.nil? || brkt_private_mac_key == ''
    puts "\n\n[Warning] You have to specify BRKT_PUBLIC_ACCESS_TOKEN and BRKT_PRIVATE_MAC_KEY " \
      "env variables when running specs not in mock mode\n\n"
    exit(1)
  end

  credentials = {
    :brkt_public_access_token => ENV['BRKT_PUBLIC_ACCESS_TOKEN'],
    :brkt_private_mac_key     => ENV['BRKT_PRIVATE_MAC_KEY']
  }
  credentials[:brkt_api_host] = ENV['BRKT_API_HOST'] if ENV['BRKT_API_HOST']
  Fog.credentials = credentials.merge(Fog.credentials)
end

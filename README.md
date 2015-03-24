# Fog::Brkt

Module for the 'fog' gem to support Bracket

## Installation

Add this line to your application's Gemfile:

    gem 'fog-brkt'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install fog-brkt

## Usage

TODO: Write usage instructions here

## Testing

To run test suite execute(it will mock interaction with API by default):

    $ rake spec

To run test suite against a real API endpoint execute:

    $ FOG_MOCK=false BRKT_API_HOST=<api host> BRKT_PUBLIC_ACCESS_TOKEN=<api public toke> BRKT_PRIVATE_MAC_KEY=<api private mac key> rake spec

In non-mocking mode some test take a long time to execute (for example you can test reboot instance behavior only after it's booted completely), to skip a slowest test add FAST_TESTS=true

    $ FOG_MOCK=false FAST_TESTS=true BRKT_API_HOST=<api host> BRKT_PUBLIC_ACCESS_TOKEN=<api public toke> BRKT_PRIVATE_MAC_KEY=<api private mac key> rake spec

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

# Fog::Brkt Examples

The following folder contains a collection of examples of using the Fog::Brkt module in Ruby scripts. Use these examples as your guide to integrate Fog::Ruby into your Bracket projects! For  description of the module please see: https://github.com/brkt/fog-brkt-ruby 

Note: All examples require a proper Bracket portal url, along with a proper API Token and Private Key. You will need to edit the following code block in each of these examples, and add in user specific data.

```
# First establish a connection to the API portal
##########################################################
compute = Fog::Compute.new({
    :provider => "brkt",
    :brkt_public_access_token => "93e...",
    :brkt_private_mac_key => "b48...",
    :brkt_api_host => "https://{url of portal @ brkt.com}/"
})
##########################################################

```

## Contributing

If you find a bug in an example then please report it on GitHub Issues or our Support Forum.

You can issue Pull Requests for new examples or fixes to existing ones against the master branch.

If you have a feature request, or have written a script that shows Fog::Brkt in use, then please get in touch. We'd love to hear from you! 

## Bugs?

Please add them to the Issue Tracker with as much info as possible, especially source code demonstrating the issue.

## About Fog::Brkt

Fog::Brkt is a module for the 'fog' gem to support Bracket Computing Cells.

## Credits

created by Andy Ryan based on original work done by Berndt Jung<br>
andy@brkt.com<br>
date: 6/15/15
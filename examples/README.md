# Fog::Brkt Examples

[![Fog::Brkt VERSION](https://img.shields.io/badge/Fog%3A%3ABrkt%20Version-alpha-green.svg)](https://github.com/brkt/fog-brkt-ruby)

![fog](http://geemus.s3.amazonaws.com/fog.png)

fog is the Ruby cloud services library, top to bottom:

* Collections provide a simplified interface, making clouds easier to work with and switch between.
* Requests allow power users to get the most out of the features of each individual cloud.
* Mocks make testing and integrating a breeze.

The following folder contains a collection of examples of using the Fog::Brkt module in Ruby scripts. Use these examples as your guide to integrate Fog::Ruby into your Bracket projects! For  description of the module please see: https://github.com/brkt/fog-brkt-ruby 

## Usage

These Ruby files all have the .rb file extension. To run any of these Ruby script, run the command ruby {scriptname}.rb. 

Alternatively, these example scripts have been configured to run without using the Ruby command. The shebang line is already done for you; it's the first line in the script starting with #!. This tells the shell what type of file this is. In this case it's a Ruby file to be executed with the Ruby interpreter. To mark the file as executable, run the command chmod +x {scriptname}.rb. This will set a file permission bit indicating that the file is a program and that it can be run. Now, to run the program simply enter the command ./{scriptname}.rb.

<b>Since it's a bad practice to have your credentials in source code, you should load them from the default fog configuration file: ~/.fog. This file could look like this:</b>

```
default:
  brkt_public_access_token: <YOUR_ACCESS_TOKEN>
  brkt_private_mac_key: <YOUR_SECRET_MAC_KEY>
```

If there is no .fog file in your home directory, simply create one.

Note: All examples require a proper Bracket portal url. You will need to edit the following code block in each of these examples, and add in the proper url of your portal.

```
# First establish a connection to the API portal
##########################################################
compute = Fog::Compute.new({
    :provider => "brkt",
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
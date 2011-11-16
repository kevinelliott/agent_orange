= agent_orange 
{<img src="https://secure.travis-ci.org/kevinelliott/agent_orange.png">}[http://travis-ci.org/kevinelliott/agent_orange]

User Agent detection for Ruby. ActionController integration coming soon.

== About

There are quite a few User Agent parsing libraries already, but none of them make adequate
detection of mobile browsers and clients. With such a significant number of requests
coming from mobile users a library with the ability to detect what type of device a user
is coming from is necessary.

This library for Ruby will allow you to detect whether a user is on a computer, a mobile
device, or is a bot (such as Google). It was composed by using techniques gathered from
several other libraries/gems in an effort to be consistent and cover as many types
of agents as possible.

== Project Status

=== Stable, but needs improvement.

This library does detect the requesting user (device, platform, os, framework, and browser with versions)
and now has some rpsec tests. While it is stable and no large restructuring is planned, it can use
some optimizations and improvements to the detection algorithms. The techniques currently in place
are rather simple, and not perfect (for example, it is currently confused if it sees both Chrome and
Safari in user agent string, and doesn't pick based on order of appearance). If you'd like to help,
please contact me.

== Installation

  gem install agent_orange

If you're going to use it with Rails then add the gem to your Gemfile.

== Example Usage

=== Create new user agent parser

  >> ua = AgentOrange::UserAgent.new(user_agent_string)

=== Looking at the device

  >> device = ua.device
  => "Mobile"
  >> device.type
  => "mobile"
  >> device.name
  => "Mobile"
  >> device.version
  => nil

=== Check to see if the device is mobile, a desktop/laptop/server computer, or a bot

  >> device.is_mobile?
  => true
  >> device.is_computer?
  => false
  >> device.is_bot?
  => false

=== Use the proxies to check if the user is on a mobile device

  >> ua.is_mobile?
  => true

=== Looking at the platform

  >> platform = ua.device.platform
  => "iPhone"
  >> platform.type
  => "iphone"
  >> platform.name
  => "iPhone"
  >> platform.version
  => "3GS"
  
=== Looking at the operating system

  >> os = ua.device.os
  => "iPhone OS 4.3"
  >> os.type
  => "iphone_os"
  >> os.name
  => "iPhone OS"
  >> os.version
  => "4.3"
  
=== Looking at the web engine

  >> engine = ua.device.engine
  => "WebKit 5.3"
  >> engine.type
  => "webkit"
  >> engine.name
  => "WebKit"
  >> engine.version
  => "5.3.1.2321"

=== Looking at the browser

  >> browser = ua.device.engine.browser
  => "Internet Explorer 10"
  >> browser.type
  => "ie"
  >> browser.name
  => "Internet Explorer"
  >> browser.version
  => "10.0.112"

=== Quickly get to the browser version

  >> AgentOrange::UserAgent.new(user_agent_string).device.engine.browser.version
  => "10.0.112"

== General Class Definition

This is not up to date or a reflection of the actual class structure. This will be updated eventually.

AgentOrange::UserAgent
  device
  parse
  is_computer?   # proxy
  is_mobile?     # proxy
  is_bot?        # proxy
  to_s
  
AgentOrange::Device
  parse
  type
  name
  version
  is_computer?(name=nil) # 
  is_mobile?(name=nil)   # accepts a :symbol or "String"
  is_bot?(name=nil)      #
  to_s
  
AgentOrange::Engine
  parse
  type
  name
  version
  to_s
  
AgentOrange::Version
  parse
  major
  minor
  patch_level
  build_number
  to_s
  
== Maintainer

* Kevin Elliott - http://kevinelliott.net - http://github.com/kevinelliott
* WeLike - http://www.welikeinc.com - http://github.com/welike

== Contributors

A warm thank you to all contributors to the project, who have put effort and time into making this gem more useful.

* David Rice (davidjrice) - RSpec tests and bug fixes.
* Joshua Siler (eatenbyagrue) - Bot detection, initial test, and bug fixes.

== License

(The MIT License)

Permission is hereby granted, free of charge, to any person obtaining
a copy of this software and associated documentation files (the
'Software'), to deal in the Software without restriction, including
without limitation the rights to use, copy, modify, merge, publish,
distribute, sublicense, and/or sell copies of the Software, and to
permit persons to whom the Software is furnished to do so, subject to
the following conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED 'AS IS', WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

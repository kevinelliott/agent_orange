require 'rubygems'
require 'bundler/setup'
require File.join(File.dirname(__FILE__), 'user_agent_matcher')

$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
$LOAD_PATH.unshift(File.dirname(__FILE__))
require 'agent_orange'

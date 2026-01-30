#!/bin/env ruby
require 'yaml'
require 'json'
require_relative '../lib/tigerroad-lib.rb'

class TigerroadUser
  include TigerroadLib
  TEMPLATE = File.read(File.join(__dir__, "..", "lib", "template.html.erb"))

  def usage
    abort "tigerroad-update.rb <path_to_userdir>"
  end

  def initialize
    fp = ARGV.shift
    dp, @user_id = File.split(fp)
    @webroot, _user = File.split(dp)
    @user_dir = fp

    unless File.directory?(fp) && File.file?(File.join(fp, "usermeta.json"))
      usage
    end

    setup
  end

  def main
    variant = "user"

    usermeta = JSON.load File.read File.join(@user_dir, "usermeta.json")
    uservideos = JSON.load File.read File.join(@user_dir, "videos.json")

    dirwant(@webroot, "profile")
    File.open(File.join(@webroot, "profile", @user_id), "w") do |f|
      f.puts generate(binding)
    end
  end
end

TigerroadUser.new.main

#!/bin/env ruby
require 'json'
require 'erb'
require_relative '../lib/tigerroad-lib'

# Update metadata for video.
class TigerroadUpdate
  include TigerroadLib
  def usage
    abort "tigerroad-update.rb <path_to_meta.json>"
  end

  def initialize
    fp = ARGV.shift
    dp, meta_json = File.split(fp)
    dp, @media_id = File.split(dp)
    dp, @user_id = File.split(dp)
    @webroot, _dp = File.split(dp)

    usage if !File.exist?(fp) || meta_json != "meta.json"

    setup

    @titlemeta = JSON.load File.read fp
    @usermeta = JSON.load File.read File.join(@webroot, "user", @user_id, "usermeta.json")
    @this_path = ["video", @user_id, @media_id].join("/")
  end

  def read_titlemeta
    JSON.load File.read 
  end

  #TIGERROAD
  def tigerroad_create_player titlemeta
    variant = "play"
    dirwant @webroot, "video", @user_id
    File.open(File.join(@webroot, "video", @user_id, @media_id), "w") do |f|
      f.puts generate(binding)
    end
  end

  def main
    tigerroad_create_player @titlemeta
  end
end

TigerroadUpdate.new.main
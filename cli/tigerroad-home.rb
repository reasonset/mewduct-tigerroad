#!/bin/env ruby
require 'json'
require_relative '../lib/tigerroad-lib'

class TigerroadHome
  include TigerroadLib

  def usage
    abort "tigerroad-home.rb <path_to_webroot>"
  end

  def initialize
    fp = ARGV.shift
    json = File.join(fp, "meta", "index.json")
    users = File.join(fp, "meta", "users.json")

    unless File.file? json
      usage
    end

    @homemeta = JSON.load File.read json
    @usersmeta = JSON.load File.read users
    @outfile = File.join(fp, (ENV["TIGERROAD_INDEX_FILENAME"] || "tigerhome.html"))

    setup
  end

  def main
    write
  end

  def write
    variant = "index"
    File.open(@outfile, "w") do |f|
      f.puts generate(binding)
    end
  end
end

TigerroadHome.new.main

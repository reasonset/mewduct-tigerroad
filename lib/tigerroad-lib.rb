#!/bin/env ruby
require 'yaml'
require 'json'
require 'erb'
require 'fileutils'

module TigerroadLib
  include ERB::Util

  TEMPLATE = File.read(File.join(__dir__, "template.html.erb"))

  CARD_TEMPLATE = File.read File.join(__dir__, "card.html.erb")
  # Call from eRuby
  def video_card meta
    ERB.new(CARD_TEMPLATE).result(binding)
  end

  USERCARD_TEMPLATE = File.read File.join(__dir__, "usercard.html.erb")
  # Call from eRuby
  def user_card meta
    ERB.new(USERCARD_TEMPLATE).result(binding)
  end

  def get_duration_sec(duration_str)
    dur = duration_str.split(":").map(&:to_i).reverse
    dur_s = dur[0]
    dur_s += (dur[1] || 0) * 60
    dur_s += (dur[2] || 0) * 60 * 60

    dur_s
  end

  def json_embed data
    JSON.dump(data).gsub(/[&><]/) do |s|
      {'&' => '\u0026', '>' => '\u003e', '<' => '\u003c'}[s]
    end
  end

  def json_ld data
    ld = {
      "@context" => "https://schema.org",
      "@type" => "VideoObject",
      "name" => data["title"],
      "description" => data["description"],
      "uploadDate" => Time.at(data["created_at"]).iso8601,
      "thumbnailUrl" => [[(@config["instance_schema"] || "https"), "://", @config["instance_domain"]].join, "media", @user_id, @media_id, "thumbnail.webp"].join("/")
    }

    json_embed ld
  end

  def setup
    @config = YAML.load File.read(File.join(__dir__, "..", "config", "config.yaml"))
    @instance_name = @config["instance_name"] || "Unnamed instance"
  end

  def dirwant *path
    unless File.exist?(File.join(*path))
      FileUtils.mkdir_p(File.join(*path))
    end
  end

  def generate b
    ERB.new(TEMPLATE, trim_mode: "%<>").result(b)
  end
end
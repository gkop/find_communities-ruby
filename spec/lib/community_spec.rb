require 'spec_helper'
include FindCommunities

describe Community do
  it "can be initialized from a filename" do
    filename = File.dirname(__FILE__) + "/../data/karate.bin"
    c = Community.new(filename)
  end
end

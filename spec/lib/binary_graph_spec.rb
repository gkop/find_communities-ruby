require 'spec_helper'
include FindCommunities

describe BinaryGraph do
  it "can read a file" do
    filename = File.dirname(__FILE__) + "/../data/karate.bin"
    bg = BinaryGraph.new(filename)
  end
end

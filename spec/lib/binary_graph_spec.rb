require 'spec_helper'

describe BinaryGraph do
  it "can read a file" do
    filename = File.dirname(__FILE__) + "/../data/karate.bin"
    bg = BinaryGraph.new(filename)
  end
end

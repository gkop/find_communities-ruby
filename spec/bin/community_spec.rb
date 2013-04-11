require 'spec_helper'

describe "community (executable)" do
  it "outputs a hierarchy", :retry => 3 do
    filename = File.dirname(__FILE__) + "/../data/karate.bin"
    run "community -l -1 #{filename}"
    relevant_lines = out.split("\n").last(4)
    relevant_lines[0].should == "1 1"
    relevant_lines[1].should == "2 2"
    relevant_lines[2].should == "3 3"
    relevant_lines[3].to_f.round(1).should == 0.4
  end
end

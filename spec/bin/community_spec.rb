require 'spec_helper'

describe "community (executable)" do
  let(:filename) { File.dirname(__FILE__) + "/../data/karate.bin" }

  it "outputs a hierarchy", :retry => 2 do
    run "community -l -1 #{filename}"
    relevant_lines = out.split("\n").last(4)
    relevant_lines[0].should == "1 1"
    relevant_lines[1].should == "2 2"
    relevant_lines[2].should == "3 3"
    relevant_lines[3].to_f.round(2).should == 0.43
  end

  it "outputs level 2 in the hierchy", :retry => 2 do
    run "community -l 2 #{filename}"
    lines = out.split("\n")
    lines.length.should > 5
    lines[0..lines.length-2].each_with_index do |l, i|
      l.should match /\A#{i}:( \(\d+ \d+\)){3,}\z/
    end
    lines.last.to_f.round(2).should == 0.43
  end

  it "outputs level 3 in the hierchy", :retry => 2 do
    run "community -l 3 #{filename}"
    lines = out.split("\n")
    lines.length.should == 5
    lines[0..lines.length-2].each_with_index do |l, i|
      l.should match /\A#{i}:( \(\d+ \d+\)){2,}\z/
    end
    lines.last.to_f.round(2).should == 0.43
  end
end

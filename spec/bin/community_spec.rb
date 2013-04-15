require 'spec_helper'

describe "community (executable)" do
  let(:filename) { File.dirname(__FILE__) + "/../data/karate.bin" }
  let(:weights_file) { File.dirname(__FILE__) + "/../data/karate.weights" }

  context "outputs a hierarchy", :retry => 2 do
    it "works when no level given" do
      run "community #{filename}"
      relevant_lines = out.split("\n").last(4)
      3.times do |i|
        relevant_lines[i].should == "#{i+1} #{i+1}"
      end
      relevant_lines[3].to_f.round(2).should == 0.43
    end

    it "works when level given is -1" do
      run "community -l -1 #{filename}"
      relevant_lines = out.split("\n").last(4)
      3.times do |i|
        relevant_lines[i].should == "#{i+1} #{i+1}"
      end
      relevant_lines[3].to_f.round(2).should == 0.43
    end

    it "can provide verbose output", :retry => 2 do
      run "community #{filename} -v"
      output = out
      3.times do |i|
        output.should match /^level #{i}:\n  start computation [0-9\-: +]+\n  network size: \d+ nodes, \d+ links, \d+ weight.$(\n\d+ \d+){4,}\n  modularity increased from (-)?\d+\.\d+ to \d+\.\d+\n  end computation [0-9\-: +]+$/
      end
      lines = output.split("\n")
      lines.first.should match /^Begin: [0-9\-: +]+$/
      lines[lines.length-3].should match /^End: [0-9\-: +]+$/
      lines[lines.length-2].should match /^Total duration: \d+\.\d+ sec\.$/
      lines.last.to_f.round(2).should == 0.43
    end
  end

  it "outputs level 2 in the hierarchy", :retry => 2 do
    run "community -l 2 #{filename}"
    lines = out.split("\n")
    lines.length.should > 5
    lines[0..lines.length-2].each_with_index do |l, i|
      l.should match /\A#{i}:( \(\d+ \d+\)){3,}\z/
    end
    lines.last.to_f.round(2).should == 0.43
  end

  it "outputs level 3 in the hierarchy", :retry => 2 do
    run "community #{filename} -l 3"
    lines = out.split("\n")
    lines.length.should == 5
    lines[0..lines.length-2].each_with_index do |l, i|
      l.should match /\A#{i}:( \(\d+ \d+\)){2,}\z/
    end
    lines.last.to_f.round(2).should == 0.43
  end

  context "with a weights file", :retry => 2 do
    it "works when no level given" do
      run "community #{filename} -w #{weights_file}"
      relevant_lines = out.split("\n").last(4)
      3.times do |i|
        relevant_lines[i].should == "#{i} #{i}"
      end
      relevant_lines[3].to_f.round(2).should == 0.41
    end

    it "outputs level 2 in the hierarchy", :retry => 2 do
      run "community -l 2 #{filename} -w #{weights_file}"
      lines = out.split("\n")
      lines.length.should > 5
      lines[0..lines.length-2].each_with_index do |l, i|
        l.should match /\A#{i}:( \(\d+ \d+\)){3,}\z/
      end
      lines.last.to_f.round(2).should == 0.41
    end

    it "outputs level 3 in the hierarchy", :retry => 2 do
      run "community #{filename} -l 3 -w #{weights_file}"
      lines = out.split("\n")
      lines.length.should == 5
      lines[0..lines.length-2].each_with_index do |l, i|
        l.should match /\A#{i}:( \(\d+ \d+\)){2,}\z/
      end
      lines.last.to_f.round(2).should == 0.41
    end
  end
end

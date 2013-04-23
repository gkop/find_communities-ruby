require 'spec_helper'
require 'fileutils'

describe "convert (executable)" do
  let(:filename) { File.dirname(__FILE__) + "/../data/dense_weighted_graph.txt" }
  let(:outfile) { File.dirname(__FILE__) + "/../tmp/test.bin" }
  let(:weights_file) { File.dirname(__FILE__) + "/../tmp/test.weights" }
  let(:control_file) { File.dirname(__FILE__) + "/../data/dense_weighted_graph.bin" }
  let(:control_weights_file) { File.dirname(__FILE__) + "/../data/dense_weighted_graph.weights" }

  before do
    Dir.mkdir(File.dirname(__FILE__) + "/../tmp")
  end

  after do
    FileUtils.rm_r(File.dirname(__FILE__) + "/../tmp")
  end

  context "given a dense weighted graph", :retry => 2 do
    it "produces the correct .bin file" do
      run "convert -i #{filename} -o #{outfile}"
      new_bg = BinaryGraph.new(outfile)
      control_bg = BinaryGraph.new(control_file)
      new_bg.nb_nodes.should == control_bg.nb_nodes
      new_bg.nb_links.should == control_bg.nb_links
      new_bg.degrees.should == control_bg.degrees
      new_bg.total_weight.should == control_bg.total_weight
      new_bg.links.should =~ control_bg.links
      new_bg.weights.should =~ control_bg.weights
      [control_bg, new_bg].each { |bg| bg.stub(:print) }
      new_bg.display_graph.should == control_bg.display_graph
    end

    it "produces the correct .weights files" do
      run "convert -i #{filename} -o #{outfile} -w #{weights_file}"
      new_bg = BinaryGraph.new(outfile, weights_file)
      control_bg = BinaryGraph.new(control_file, control_weights_file)
      new_bg.nb_nodes.should == control_bg.nb_nodes
      new_bg.nb_links.should == control_bg.nb_links
      new_bg.degrees.should == control_bg.degrees
      new_bg.total_weight.should == control_bg.total_weight
      new_bg.links.should =~ control_bg.links
      new_bg.weights.should =~ control_bg.weights
      [control_bg, new_bg].each { |bg| bg.stub(:print) }
      new_bg.display_graph.should == control_bg.display_graph
    end
  end
end

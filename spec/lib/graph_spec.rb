require 'spec_helper'

describe Graph do
  let(:filename) { File.dirname(__FILE__) + "/../data/dense_weighted_graph.txt" }
  let(:control_file) { File.dirname(__FILE__) + "/../data/dense_weighted_graph.bin" }
  let(:control_weights_file) { File.dirname(__FILE__) + "/../data/dense_weighted_graph.weights" }

  it "can read a file and create a binary graph" do
    g = Graph.new(filename, :weighted)
    g.clean
    new_bg = g.to_binary_graph
    control_bg = BinaryGraph.new(control_file, control_weights_file)
    new_bg.nb_nodes.should == control_bg.nb_nodes
    new_bg.nb_links.should == control_bg.nb_links
    new_bg.degrees.should =~ control_bg.degrees
    new_bg.total_weight.should == control_bg.total_weight
    new_bg.links.should =~ control_bg.links
    new_bg.weights.should =~ control_bg.weights
    [control_bg, new_bg].each { |bg| bg.stub(:print) }
    new_bg.display_graph.should == control_bg.display_graph
  end
end

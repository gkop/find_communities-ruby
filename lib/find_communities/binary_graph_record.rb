require 'bindata'

# binary file format is
# 4 bytes for the number of nodes in the graph
# 8*(nb_nodes) bytes for the cumulative degree for each node:
#    deg(0)=degrees[0]
#    deg(k)=degrees[k]-degrees[k-1]
# 4*(sum_degrees) bytes for the links
# IF WEIGHTED 4*(sum_degrees) bytes for the weights in a separate file

module FindCommunities
  class BinaryGraphRecord < BinData::Record
    endian :little
    uint32 :nb_nodes
    array  :degrees, :type => :uint64, :initial_length => :nb_nodes
    array  :links, :type => :uint32, :initial_length => lambda { degrees.last }
  end
end

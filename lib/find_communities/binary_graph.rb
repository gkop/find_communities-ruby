module FindCommunities
  class BinaryGraph
    attr_accessor :degrees, :nb_nodes, :nb_links, :total_weight
    attr_reader :links, :weights

    def initialize(filename=nil, type=nil)
      if filename
        @record = BinaryGraphRecord.read(open(filename, "rb"))
        @nb_nodes = @record["nb_nodes"]
        @degrees = @record["degrees"]
        @links = @record["links"]
        @nb_links = @links.count
      else
        @nb_nodes = 0
        @nb_links = 0
        @links = []
      end
      @weights = []
      @total_weight = nb_nodes.times.inject(0.0) {|sum, node|
        sum + weighted_degree(node)
      }
    end

    def nb_neighbors(node)
      check_node(node)
      node == 0 ? degrees[0] : degrees[node] - degrees[node-1]
    end

    def nb_selfloops(node)
      check_node(node)
      p = neighbors(node)
      nb_neighbors(node).times do |i|
        if p.first[i] == node
          return weights.any? ? p.last[i] : 1.0
        end
      end
      0.0
    end

    def neighbors(node)
      check_node(node)
      if node == 0
        [links, weights]
      elsif weights.length > 0
        [links[degrees[node-1], links.length],
         weights[degrees[node-1], weights.length]]
      else
        [links[degrees[node-1], links.length], weights]
      end
    end

    def weighted_degree(node)
      check_node(node)
      if weights.length == 0
        nb_neighbors(node)
      else
        p = neighbors(node)
        nb_neighbors(node).times.inject(0.0) { |sum, neighbor|
          sum + p.last[neighbor]
        }
      end
    end

    private
    def check_node(node)
      if node < 0 || node >= nb_nodes
        raise ArgumentError.new("Node index out of bounds: #{node}")
      end
    end

  end
end

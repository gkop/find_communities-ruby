module FindCommunities
  class BinaryGraph
    attr_accessor :degrees, :nb_nodes, :nb_links, :total_weight
    attr_reader :links, :weights

    def initialize(source=nil, weights=nil)
      if source
        if source.is_a?(String)
          @record = BinaryGraphRecord.read(open(source, "rb"))
        elsif source.is_a?(BinaryGraphRecord)
          @record = source
        end
        @nb_nodes = @record["nb_nodes"]
        @degrees = @record["degrees"].to_a
        @links = @record["links"].to_a
        @nb_links = @links.count
      else
        @nb_nodes = 0
        @nb_links = 0
        @links = []
      end
      if weights
        if weights.is_a?(String)
          weights_record = WeightsRecord.new(:nb_links => nb_links)
                                      .read(open(weights, "rb"))
        elsif weights.is_a?(WeightsRecord)
          weights_record = weights
        end
        @weights = weights_record["weights"].to_a
      else
        @weights = []
      end
      @total_weight = nb_nodes.times.inject(0.0) {|sum, node|
        sum + weighted_degree(node)
      }
    end

    def display_graph
      nb_nodes.times do |node|
        p = neighbors(node)
        print "#{node}:"
        nb_neighbors(node).times do |i|
          if weights.any?
            print " (#{p.first[i]} #{p.last[i].to_i})"
          else
            print " #{p.first[i]}"
          end
        end
        print "\n"
      end
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

require "securerandom"

module FindCommunities
  class Community
    attr_accessor :neigh_weight, :neigh_pos, :neigh_last

    attr_accessor :g    # network to compute communities for
    attr_accessor :size # nummber of nodes in the network and size of all vectors
    attr_accessor :n2c  # community to which each node belongs
    attr_accessor :in_graph, :tot # used to compute the modularity participation
                                  # of each community

    # a new pass is computed if the last one has generated an increase
    # greater than min_modularity
    # if 0. even a minor increase is enough to go for one more pass
    attr_accessor :min_modularity

    def initialize(source, nbp=nil, minm=nil)
      @g = source.is_a?(BinaryGraph) ? source : BinaryGraph.new(source)
      @size = g.nb_nodes
      @neigh_last = 0

      @neigh_weight = size.times.map { -1 }
      @neigh_pos = size.times.map { 0 }
      @n2c = []
      @in_graph = []
      @tot = []
      size.times do |i|
        n2c[i] = i
        tot[i] = g.weighted_degree(i)
        in_graph[i] = g.nb_selfloops(i)
      end
      @min_modularity = minm
    end

    def one_level
      improvement = false
      nb_pass_done = 0
      new_mod = modularity
      cur_mod = new_mod
      random_order = size.times.map { |i| i }
      (size-1).times do |i|
        rand_pos = SecureRandom.random_number(size-i) + i
        tmp = random_order[i]
        random_order[i] = random_order[rand_pos]
        random_order[rand_pos] = tmp
      end

      begin
        cur_mod = new_mod
        nb_moves = 0
        nb_pass_done += 1

        size.times do |node_tmp|
          node = random_order[node_tmp]
          node_comm = n2c[node]
          w_degree = g.weighted_degree(node)

          # computation of all neighboring communities of current node
          compute_neigh_comm(node)
          # remove node from its current community
          remove(node, node_comm, neigh_weight[node_comm])

          # compute the nearest community for node
          # default choice for future insertion is the former community
          best_comm = node_comm
          best_nblinks = 0.0
          best_increase = 0.0

          neigh_last.times do |i|
            increase = modularity_gain(node, neigh_pos[i],
                                       neigh_weight[neigh_pos[i]], w_degree)
            if increase > best_increase
              best_comm = neigh_pos[i]
              best_nblinks = neigh_weight[neigh_pos[i]]
              best_increase = increase
            end
          end

          # insert node in the nearest community
          insert(node, best_comm, best_nblinks)

          nb_moves += 1 if best_comm != node_comm
        end

        new_mod = modularity
        improvement = true if nb_moves > 0
      end while nb_moves > 0 && (new_mod - cur_mod > min_modularity)

      improvement
    end

    def display_partition
      renumber = size.times.map { -1 }
      size.times do |node|
        renumber[n2c[node]] += 1
      end

      final = 0
      size.times do |i|
        if renumber[i] != -1
          renumber[i] = final
          final += 1
        end
      end

      size.times do |i|
        puts "#{i} #{renumber[n2c[i]]}"
      end
    end

    def partition2graph_binary
      renumber = size.times.map { -1 }
      size.times do |node|
        renumber[n2c[node]] += 1
      end

      final = 0
      size.times do |i|
        if renumber[i] != -1
          renumber[i] = final
          final += 1
        end
      end

      # Compute communities
      comm_nodes = final.times.map { [] }
      size.times do |node|
        comm_nodes[renumber[n2c[node]]].push(node)
      end

      # Compute weighted graph
      g2 = BinaryGraph.new
      g2.nb_nodes = comm_nodes.size
      g2.degrees = comm_nodes.size.times.map { 0 }

      comm_nodes.size.times do |comm|
        m = {}

        comm_size = comm_nodes[comm].size
        comm_size.times do |node|
          p = g.neighbors(comm_nodes[comm][node])
          deg = g.nb_neighbors(comm_nodes[comm][node])
          deg.times do |i|
            neigh = p.first[i]
            neigh_comm = renumber[n2c[neigh]]
            local_neigh_weight = (g.weights.size == 0 ? 1.0 : p.last[i])

            if m[neigh_comm]
              m[neigh_comm][1] += local_neigh_weight
            else
              m[neigh_comm] = [neigh_comm, local_neigh_weight]
            end
          end
        end
        g2.degrees[comm] = m.to_a.size + (comm == 0 ? 0 : g2.degrees[comm - 1])
        g2.nb_links += m.to_a.size

        m.each do |key, value|
          g2.total_weight += value[1]
          g2.links.push(value[0])
          g2.weights.push(value[1])
        end
      end
      g2
    end

    def modularity
      q = 0.0
      m2 = g.total_weight
      size.times do |i|
        if tot[i] > 0
          q += (in_graph[i] / m2 - (tot[i] / m2)**2)
        end
      end

      q
    end

private
    def check_node(node)
      if node < 0 || node >= size
        raise ArgumentError.new("Node index out of bounds: #{node}")
      end
    end

    def insert(node, comm, dnodecomm)
      check_node(node)

      tot[comm] += g.weighted_degree(node)
      in_graph[comm] += 2 * dnodecomm + g.nb_selfloops(node)
      n2c[node] = comm
    end

    def modularity_gain(node, comm, dnodecomm, w_degree)
      check_node(node)

      totc = tot[comm]
      degc = w_degree
      m2 = g.total_weight

      dnodecomm - ((totc.to_f * degc) / m2)
    end

    def compute_neigh_comm(node)
      neigh_last.times { |i| neigh_weight[neigh_pos[i]] = -1 }

      p = g.neighbors(node)

      deg = g.nb_neighbors(node)

      neigh_pos[0] = n2c[node]
      neigh_weight[neigh_pos[0]] = 0
      self.neigh_last = 1

      deg.times do |i|
        neigh = p.first[i]
        neigh_comm = n2c[neigh]
        neigh_w = (g.weights.size == 0 ? 1.0 : p.last[i])

        if neigh != node
          if neigh_weight[neigh_comm] == -1
            neigh_weight[neigh_comm] = 0.0
            neigh_pos[neigh_last] = neigh_comm
            self.neigh_last += 1
          end
          neigh_weight[neigh_comm] += neigh_w
        end
      end
    end

    def remove(node, comm, dnodecomm)
      check_node(node)

      tot[comm] -= g.weighted_degree(node)
      in_graph[comm] -= 2 * dnodecomm + g.nb_selfloops(node)
      n2c[node] = -1
    end
  end
end

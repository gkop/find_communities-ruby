module FindCommunities
  class Graph
    attr_reader :links, :type

    def initialize(filename, type=:unweighted)
      weight = 1.0
      @links = []
      @type = type

      if filename
        File.open(filename, "r") do |file|
          file.each_line do |line|
            pieces = line.split
            src = pieces[0].to_i
            dest = pieces[1].to_i
            weight = pieces[2].to_f if type == :weighted
            add_link(src, dest, weight)
          end
        end
      end
    end

    def add_link(src, dest, weight)
      links[src] ||= []
      links[src] << [dest, weight]
      if src != dest
        links[dest] ||= []
        links[dest] << [src, weight]
      end
    end

    def clean
      links.length.times do |i|
        m = {}

        links[i].length.times do |j|
          k = links[i][j].first
          v = m[k]
          if !v
            m[links[i][j].first] = links[i][j].last
          elsif type == :weighted
            m[links[i][j].first] += links[i][j].last
          end
        end

        vector = []
        m.each do |k, v|
          vector << [k, v]
        end
        links[i] = vector
      end
    end

    def to_binary_graph
      display_binary(nil, nil) unless @record
      BinaryGraph.new(@record, @weights_record)
    end

    def display_binary(filename, weights_file)
      r = BinaryGraphRecord.new
      r["nb_nodes"] = links.size
      tot = 0
      links.size.times do |i|
        tot += links[i].size
        r["degrees"][i] = tot
      end

      link_index = 0
      links.size.times do |i|
        links[i].size.times do |j|
          r["links"][link_index] = links[i][j].first
          link_index += 1
        end
      end
      if filename
        File.open(filename, "w") do |file|
          r.write(file)
        end
      end

      if type == :weighted
        weights_record = WeightsRecord.new(:nb_links => tot)
        weight_index = 0
        links.size.times do |i|
          links[i].size.times do |j|
            weights_record["weights"][weight_index] = links[i][j].last
            weight_index += 1
          end
        end

        if weights_file
          File.open(weights_file, "w") do |file|
            weights_record.write(file)
          end
        end

        @weights_record = weights_record
      end
      @record = r
    end
  end
end

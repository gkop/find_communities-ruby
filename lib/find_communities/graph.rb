module FindCommunities
  class Graph
    attr_reader :links

    def initialize(filename, type=nil)
      weight = 1.0
      @links = []

      File.open(filename, "r") do |file|
        file.each_line do |line|
          pieces = line.split
          src = pieces[0].to_i
          dest = pieces[1].to_i
          weight = pieces[2].to_f if type == :weighted
          links[src] ||= []
          links[src] << [dest, weight]
          if src != dest
            links[dest] ||= []
            links[dest] << [src, weight]
          end
        end
      end
    end

    def clean(type)
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

    def display_binary(filename, weights_file, type)
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
      File.open(filename, "w") do |file|
        r.write(file)
      end

      if type == :weighted
        File.open(weights_file, "w") do |file|
          links.size.times do |i|
            links[i].size.times do |j|
              weight = BinData::FloatLe.new(:value => links[i][j].last)
              weight.write(file)
            end
          end
        end
      end
    end
  end
end

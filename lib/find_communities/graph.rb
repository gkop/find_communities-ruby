module FindCommunities
  class Graph
    def initialize(file, type=nil)
      weight = 1.0
      links = []

      nb_links = file.count
      file.each do |line|
        pieces = line.split
        src = pieces[0].to_i
        dest = pieces[1].to_i
        weight = pieces[2].to_f if type == :weighted
        links[src] ||= []
        links[src] << [dest, weight]
        if src != dest
          links[dest] ||= []
          links[dest] ||= [src, weight]
        end
      end
    end
  end
end

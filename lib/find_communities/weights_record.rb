require 'bindata'

# 4*(sum_degrees) bytes

module FindCommunities
  class WeightsRecord < BinData::Record
    array  :weights, :type => :float_le, :initial_length => :nb_links
  end
end

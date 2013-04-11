module Spec
  module Helpers
    attr_reader :out

    def run(command)
      @out = `#{File.dirname(__FILE__)}/../bin/#{command}`
    end
  end
end

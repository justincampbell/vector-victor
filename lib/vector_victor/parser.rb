module VectorVictor

  class Parser
    attr_accessor :filename

    def initialize(options)
      @filename = options[:filename]
    end

    def parse
      @file = open @filename

      while line = @file.read(32)
        parse_line unpack_line(line)
      end
    end

    def self.unpack_line(line)
      line.unpack("N" * 8)
    end

    def self.parse_line(line)
      {
        :timestamp => line[2],
        :traffic   => line[4],
        :interest  => line[6],
        :checksum  => line[7]
      }
    end

  end

end
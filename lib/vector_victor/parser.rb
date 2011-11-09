module VectorVictor

  class Parser
    attr_accessor :filename

    def initialize(options)
      @filename = options[:filename]

      @from = Date.parse(options[:from]) if options[:from]
      @to   = Date.parse(options[:to])   if options[:to]

      @verbose = options[:verbose]
    end

    def parse
      @file = open @filename

      results = []

      while line = @file.read(32)
        data = self.class.parse_line self.class.unpack_line(line)

        timestamp = Time.at(data[:timestamp]).send(:to_date)

        if @from or @to
          if @from and @to
            results.push data if timestamp.between? @from, @to
          else
            results.push data if @from and timestamp >= @from
            results.push data if @to   and timestamp <= @to
          end
        else
          results.push data
        end

        if @verbose
          puts "#{Time.at(data[:timestamp]).send(:to_date).to_s} #{data[:traffic]} #{data[:interest]}"
        end
      end

      if results.any?
        munged_results = self.class.munge(results)

        unless @quiet
          puts "#{@from or '?'} - #{@to or '?'}"
          puts "#{munged_results[:traffic]} traffic"
          puts "#{munged_results[:interest]} interest"
          puts "#{munged_results[:ratio]}:1"
        end

        munged_results
      else
        puts "No results" unless @quiet

        nil
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

    def self.munge(results)
      traffic  = 0
      interest = 0

      results.each do |result|
        traffic  += result[:traffic]
        interest += result[:interest]
      end

      ratio = traffic / interest

      {
        :traffic  => traffic,
        :interest => interest,
        :ratio    => ratio
      }
    end

  end

end
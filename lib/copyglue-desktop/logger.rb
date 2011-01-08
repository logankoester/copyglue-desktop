module CopyGlue
  module CGDesktop
    @logger = Logger.new(STDOUT)

    def self.logger
      @logger
    end

    def self.logger=(logger)
      @logger = logger
    end
  end
end

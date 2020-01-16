module Stanley
  class Client
    API_BASE = 'https://statsapi.web.nhl.com/api/v1/'.freeze

    attr_reader :conn

    def initialize
      @conn = Faraday.new(self.class::API_BASE) do |faraday|
        faraday.response(:json, content_type: /\bjson$/, parser_options: { symbolize_names: true })
        #faraday.response(:detailed_logger)

        faraday.adapter(Faraday.default_adapter)
      end
    end

    def request(path, **params)
      response = conn.get(path, params)

      raise "Request failed with status: #{response.status}" unless response.success?
      response.body
    end
  end
end

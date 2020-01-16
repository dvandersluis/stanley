module Stanley
  module Report
    class EnPerGp
      def initialize(franchise = nil)
        @franchise = franchise
      end

      def call(limit: nil)
        players = data
        players = players.first(limit) if limit

        name_len = players.map{ |p| p[:skaterFullName].length }.max

        puts "%#{name_len}s  %4s  %4s  %6s  %6s" % ["Player", "GP", "ENG", "ENG/GP", "GP/ENG"];
        puts "%#{name_len}s  %4s  %4s  %6s  %6s" % ["------", "--", "---", "------", "------"];

        players.each do |p|
          puts "%#{name_len}s  %4i  %4i  %0.4f  %0.1f" % [
            p[:skaterFullName],
            p[:gamesPlayed],
            p[:emptyNetGoals],
            p[:emptyNetGoals].fdiv(p[:gamesPlayed]),
            p[:gamesPlayed].fdiv(p[:emptyNetGoals])
          ]
        end

        nil
      end

      private

      attr_reader :franchise

      def data
        query = 'emptyNetGoals>=1'
        @data ||= Stanley::Realtime.new.get(query, franchise: franchise, sort: 'emptyNetGoals').sort_by { |player| -(player[:emptyNetGoals].fdiv(player[:gamesPlayed])) }
      end
    end
  end
end

module Stanley
  class Realtime < Client
    API_BASE = 'https://api.nhle.com/stats/rest/en/skater/realtime'.freeze

    LIMIT = 100

    GAME_TYPES = {
      regular: 2,
      playoffs: 3
    }.freeze

    FRANCHISES = {
      avalanche: 27,
      blackhawks: 11,
      blue_jackets: 36,
      blues: 18,
      bruins: 6,
      canadiens: 1,
      canucks: 20,
      capitals: 24,
      coyotes: 28,
      devils: 23,
      ducks: 32,
      flames: 21,
      flyers: 16,
      golden_knights: 38,
      hurricanes: 26,
      islanders: 22,
      jets: 35,
      kings: 14,
      lightning: 31,
      maple_leafs: 5,
      oilers: 25,
      panthers: 33,
      penguins: 17,
      predators: 34,
      rangers: 10,
      red_wings: 12,
      sabres: 19,
      senators: 30,
      sharks: 29,
      stars: 15,
      wild: 37
    }.freeze

    def get(stat, start: 0, limit: LIMIT, **params)
      params = request_params(stat, **params)

      json = request(start, limit, **params)

      data = json[:data]
      total = json[:total]

      while data.length < total
        sleep 1
        start += limit
        next_page = request(start, limit, **params)
        data.concat(next_page[:data])
      end

      puts
      data.uniq
    end

    private

    def request(start, limit, **params)
      print '.'

      super('',
        start: start,
        limit: limit,
        **params
      )
    end

    def request_params(stat, aggregate: true, game_type: GAME_TYPES[:regular], franchise: nil, sort: nil, dir: :desc)
      sort = [{ property: sort, direction: dir.upcase }] if sort

      {
        isAggregate: aggregate,
        isGame: false,
        factCayenneExp: "gamesPlayed>=1 and #{stat}",
        cayenneExp: cayenne_exp(game_type, franchise),
        sort: sort ? sort.to_json : nil
      }
    end

    def cayenne_exp(game_type, franchise)
      clauses = [
        'seasonId>=19171918',
        'seasonId<=20192020',
        "gameTypeId=#{game_type}"
      ]

      if franchise
        franchise_id = FRANCHISES.fetch(franchise)
        clauses << "franchiseId=#{franchise_id}"
      end

      clauses.join(' and ')
    end
  end
end

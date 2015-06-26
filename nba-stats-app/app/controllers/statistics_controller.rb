class StatisticsController < ApplicationController

  def index
    #Xmlstats authentication
    Xmlstats.api_key      = "cb66fd12-cead-4759-92d3-d3af7cff2de8"
    Xmlstats.contact_info = "rodriguez.reads@gmail.com"

    @Leaders = Xmlstats.nba_leaders(:points_per_game)

    #nba_stats
    client = NbaStats::Client.new
    my_resource = client.box_score("0021401000")
    my_result_set = my_resource.player_track
    @my_row =  my_result_set[0]
    # @my_item = @my_row[:spd]
    @my_speed = @my_row[:spd]
    @my_touches = @my_row[:tchs]
    @my_pass = @my_row[:pass]
    @my_assist = @my_row[:ast]

    @my_row.each do |row|
       row.each do |item|
        p item
      end
    end

    p @my_row

  end

end

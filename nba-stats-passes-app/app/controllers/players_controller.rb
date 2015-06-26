class PlayersController < ApplicationController

	def index
	end

	def show
	@player = Player.find_by(:person_id => params[:person_id])
p "person"
  #NBA.com common player data
    player_data = Unirest.get("http://stats.nba.com/stats/commonplayerinfo?LeagueID=00&PlayerID=#{@player.person_id}&SeasonType=Regular+Season")

    a = player_data.body
    b = a["resultSets"]
    c = b[0]
    d = c["headers"]
    e = c["rowSet"]

    @playerdata = []
     "ZIPPING!!"
    e.each do |row|
     hash = Hash[*d.zip(row).flatten]
     
     @playerdata << hash 
     p @playerdata[0]
    end

    #NBA.com player dashboard totals
    player_dashboard_totals = Unirest.get("http://stats.nba.com/stats/playerdashboardbygeneralsplits?DateFrom=&DateTo=&GameSegment=&LastNGames=0&LeagueID=00&Location=&MeasureType=Base&Month=0&OpponentTeamID=0&Outcome=&PaceAdjust=N&PerMode=Totals&Period=0&PlayerID=#{@player.person_id}&PlusMinus=N&Rank=N&Season=2014-15&SeasonSegment=&SeasonType=Regular+Season&VsConference=&VsDivision=")
    a = player_dashboard_totals.body
    b = a["resultSets"]
    
    c = b[0] #specific array for totals
    
    d = c["headers"]
    e = c["rowSet"]
    p "rowset test"

    @PlayerTotalsdata = []
     "ZIPPING!!"
    e.each do |row|
     hash = Hash[*d.zip(row).flatten]
     # keys_to_delete.each do |key|
     #   hash.delete(key)
     # end
     @PlayerTotalsdata << hash 
    end

#NBA.com passes made 
    @player_passes = Unirest.get("http://stats.nba.com/stats/playerdashptpass?DateFrom=&DateTo=&GameSegment=&LastNGames=0&LeagueID=00&Location=&Month=0&OpponentTeamID=0&Outcome=&PerMode=Totals&Period=0&PlayerID=#{@player.person_id}&Season=2014-15&SeasonSegment=&SeasonType=Regular+Season&TeamID=0&VsConference=&VsDivision=")
     @player_passes

     a = @player_passes.body

     b = a["resultSets"]

     c = b[0] #gets all PassesMade from playerA to teammates

     d = c["headers"]

     e = c["rowSet"]

     g = e.each do |row|
      row.each do |item| 
         
      end
     end
#How do i do this so that the first row references playerA only, but the following nodes are teammates passed to
     keys_to_delete = ["TEAM_NAME", "TEAM_ID", "PASS_TYPE", "G"]
     @data = []
      "ZIPPING!!"
     e.each do |row|
      hash = Hash[*d.zip(row).flatten]
      keys_to_delete.each do |key|
        hash.delete(key)
      end
      @data << hash 
     end

    #Added each do for player total passes
    @player_total_passes = []
    @data.each do |passes|
      @player_total_passes << passes["PASS"]
    end

    recc = b[1] #gets all PassesReceived by playerA from teammates
    recd = recc["headers"]
    rece = recc["rowSet"]

    @ReceivedData = []
      "ZIPPING!!"
    rece.each do |row|
     hash = Hash[*d.zip(row).flatten]
     # keys_to_delete.each do |key|
     #   hash.delete(key)
     # end
     @ReceivedData << hash 
    end
   p @ReceivedData

     @player_total_ast_recd = []
     @player_total_pass_recd = []
     @ReceivedData.each do |passes|
      @player_total_ast_recd << passes["AST"]
      @player_total_pass_recd << passes["PASS"]
    end
    
#NBA.com player's team totals data
    player_team_data = Unirest.get("http://stats.nba.com/stats/teamdashboardbygeneralsplits?DateFrom=&DateTo=&GameSegment=&LastNGames=0&LeagueID=00&Location=&MeasureType=Base&Month=0&OpponentTeamID=0&Outcome=&PaceAdjust=N&PerMode=Totals&Period=0&PlusMinus=N&Rank=N&Season=2014-15&SeasonSegment=&SeasonType=Regular+Season&TeamID=#{@playerdata[0]["TEAM_ID"]}&VsConference=&VsDivision=")
    # p "TEAM PLAYER DATA"
    # p player_team_data
    a = player_team_data.body
    b = a["resultSets"]
    c = b[0] #overall team dashboard
    d = c["headers"]
    e = c["rowSet"]

    @playerteamdata = []
     "ZIPPING!!"
    e.each do |row|
     hash = Hash[*d.zip(row).flatten]
     
     @playerteamdata << hash 
     end

   # Team Passing Totals 
     team_passing = Unirest.get("http://stats.nba.com/stats/teamdashptpass?DateFrom=&DateTo=&GameSegment=&LastNGames=0&LeagueID=00&Location=&MeasureType=Base&Month=0&OpponentTeamID=0&Outcome=&PaceAdjust=N&PerMode=Totals&Period=0&PlusMinus=N&Rank=N&Season=2014-15&SeasonSegment=&SeasonType=Regular+Season&TeamID=1610612746&VsConference=&VsDivision=")
     a = team_passing.body
     b = a["resultSets"]
     c = b[0]
     d = c["headers"]
     e = c["rowSet"]
     # p team_passing
     @team_passes_per_player = []
     e.each do |row|
       hash = Hash[*d.zip(row).flatten]
            @team_passes_per_player << hash 
     end
     @team_passes_total = []
     # @team_assist_total = []
     @team_passes_per_player.each do |player|
       @team_passes_total << player["PASS"]
       # @team_assist_total << player["AST"]
     end
     

   #Team touches
     team_touches = Unirest.get("http://stats.nba.com/js/data/sportvu/2014/touchesTeamData.json")
     a = team_touches.body
     b = a["resultSets"]
     p "TEAM RESULT SETS"
     # p b
     c = b[0]
     p "array 0"
     p c
     d = c["headers"]
     e = c["rowSet"]

     team_touches_array = []
     e.each do |row|
       hash = Hash[*d.zip(row).flatten]
            team_touches_array << hash 
     end

     @team_touches_total = team_touches_array.select {|team| team["TEAM_ID"].to_i == @playerdata[0]["TEAM_ID"] }

   #Player Touches
     player_touches = Unirest.get("http://stats.nba.com/js/data/sportvu/2014/touchesData.json").body["resultSets"][0]["rowSet"]
     # p "PLAYER ROW set"  
     # p player_touches

     @player_touches_total = player_touches.select{ |player| player[0].to_i == @playerdata[0]["PERSON_ID"] }

     #highcarts pie
       @Chart = LazyHighCharts::HighChart.new('pie') do |f|
         f.chart({ :defaultSeriesType=>"pie"} )   
         f.tooltip({
           headerFormat: '<span style="font-size:11px">{series.name}</span><br>',
           pointFormat: '<span style="color:{point.color}">{point.name}</span>: <b>{point.percentage:.1f}%</b> of touches',
           backgroundColor: 'white'
         })
         series = { 
           :type=> 'pie',
           :name=> 'Touches Breakdown',
           :data=> [
             {
               name:'Non-Assist Passes ',
               y: @player_total_passes.inject(:+) - @PlayerTotalsdata[0]['AST'], selected: true
             }, {
               name: 'Assists',
               y: @PlayerTotalsdata[0]['AST']
             }, {
              :name=> 'Field Goal Miss',    
              :y=> @PlayerTotalsdata[0]["FGA"] - @PlayerTotalsdata[0]["FGM"]  
             }, {  
              :name=> 'Field Goal Made',    
              :y=> @PlayerTotalsdata[0]["FGM"]
             }, {
               name: 'Turnovers',
               y: @PlayerTotalsdata[0]["TOV"]    
             }, { 
               name: 'Other',
               y: @player_touches_total[0][15] - ((@player_total_passes.inject(:+)) + (@PlayerTotalsdata[0]["FGA"]) + (@PlayerTotalsdata[0]["TOV"]))
             }  
           ]
         }     
         f.series(series) 

         f.options[:title][:text] = "#{@playerdata[0]["DISPLAY_FIRST_LAST"]} Touches: #{@player_touches_total[0][15]}"
         # f.legend(:layout=> 'vertical',:style=> {:left=> 'auto', :bottom=> 'auto',:right=> '50px',:top=> '100px'}) 
         f.plot_options(
           :pie=>{
             allowPointSelect: true,
             cursor: 'pointer',
             dataLabels: {
               enabled: true,
               format: '<b>{point.name}</b>: {point.y} '              
             }
           }
         )       
       end

     

  end #End Show
end
	
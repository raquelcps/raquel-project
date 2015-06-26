class PlayoffsController < ApplicationController

	def index
		@players = Player.all.order(:id)
		leaders_all = Unirest.get("http://stats.nba.com/stats/homepagev2?GameScope=Season&LeagueID=00&PlayerOrTeam=Player&PlayerScope=All+Players&Season=2014-15&SeasonType=Playoffs&StatType=Traditional")

		a = leaders_all.body
		b = a["resultSets"]
		p "RESULT SETS"
		p b
	    #Points first in array
	    c = b[0] 
	    p c
	    d = c["headers"]
	    e = c["rowSet"] 
	    #Rebounds
	    f = b[1]
	    g = f["headers"]
	    h = f["rowSet"]
	    #Assists
	    i = b[2]
	    j = i["headers"]
	    k = i["rowSet"]
	    #Steals
	    l = b[3]
	    m = l["headers"]
	    n = l["rowSet"]
	    #Blocks
	    o = b[7]
	    p = o["headers"]
	    q = o["rowSet"]

	    @po_Pointsdata = []
	    "ZIPPING!!"
	    e.each do |row|
	    	hash = Hash[*d.zip(row).flatten]
	    	@po_Pointsdata << hash 
	    end
	    p "Points DATA:"
	    p @po_Pointsdata

	    @po_pts_name_array = []
	    @po_points_array = []
	    @po_pts_teamid_array = []
	    @po_pts_playerid_array = []
	    @po_Pointsdata.each do |row|
	    	@po_pts_name_array << row["PLAYER"]
	    	@po_points_array << row["PTS"]
	    	@po_pts_playerid_array << row["PLAYER_ID"]
	    	@po_pts_teamid_array << row["TEAM_ID"]
	    end
	end

	def show
       @player = Player.find_by(:person_id => params[:person_id])

      #NBA.com common player data
      po_player_data = Unirest.get("http://stats.nba.com/stats/commonplayerinfo?LeagueID=00&PlayerID=#{@player.person_id}&SeasonType=Playoffs")

      a = po_player_data.body
      b = a["resultSets"]
      c = b[0]
      d = c["headers"]
      e = c["rowSet"]

      @po_playerdata = []
      "ZIPPING!!"
      e.each do |row|
      	hash = Hash[*d.zip(row).flatten]
      	@po_playerdata << hash 
      end

      #NBA.com player dashboard totals
      po_player_dashboard_totals = Unirest.get("http://stats.nba.com/stats/playerdashboardbygeneralsplits?DateFrom=&DateTo=&GameSegment=&LastNGames=0&LeagueID=00&Location=&MeasureType=Base&Month=0&OpponentTeamID=0&Outcome=&PaceAdjust=N&PerMode=Totals&Period=0&PlayerID=#{@player.person_id}&PlusMinus=N&Rank=N&Season=2014-15&SeasonSegment=&SeasonType=Playoffs&VsConference=&VsDivision=")
      
      a = po_player_dashboard_totals.body
      b = a["resultSets"]
      c = b[0] #specific array for totals    
      d = c["headers"]
      e = c["rowSet"]

      @po_PlayerTotalsdata = []
      "ZIPPING!!"
      e.each do |row|
        hash = Hash[*d.zip(row).flatten]
     # keys_to_delete.each do |key|
     #   hash.delete(key)
     # end
        @po_PlayerTotalsdata << hash 
      end

      #NBA.com passes made 
      @po_player_passes = Unirest.get("http://stats.nba.com/stats/playerdashptpass?DateFrom=&DateTo=&GameSegment=&LastNGames=0&LeagueID=00&Location=&Month=0&OpponentTeamID=0&Outcome=&PerMode=Totals&Period=0&PlayerID=#{@player.person_id}&Season=2014-15&SeasonSegment=&SeasonType=Playoffs&TeamID=0&VsConference=&VsDivision=")
      
      a = @po_player_passes.body
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
      @po_data = []
      "ZIPPING!!"
      e.each do |row|
    	hash = Hash[*d.zip(row).flatten]
    	# keys_to_delete.each do |key|
    	# 	hash.delete(key)
    	# end
    	@po_data << hash 
      end


      #Added each do for player total passes
      @po_player_total_passes = []
      @po_data.each do |passes|
      	@po_player_total_passes << passes["PASS"]
      end

      recc = b[1] #gets all PassesReceived by playerA from teammates
      recd = recc["headers"]        
      rece = recc["rowSet"]

      @po_ReceivedData = []
      "ZIPPING!!"
      rece.each do |row|    	
        hash = Hash[*d.zip(row).flatten]
         # keys_to_delete.each do |key|
         #   hash.delete(key)
         # end
        @po_ReceivedData << hash 
      end

      @po_player_total_ast_recd = []
      @po_player_total_pass_recd = []
      @po_ReceivedData.each do |passes|
 	    @po_player_total_ast_recd << passes["AST"]
 	    @po_player_total_pass_recd << passes["PASS"]
      end

      #NBA.com player's team totals data
      po_player_team_data = Unirest.get("http://stats.nba.com/stats/teamdashboardbygeneralsplits?DateFrom=&DateTo=&GameSegment=&LastNGames=0&LeagueID=00&Location=&MeasureType=Base&Month=0&OpponentTeamID=0&Outcome=&PaceAdjust=N&PerMode=Totals&Period=0&PlusMinus=N&Rank=N&Season=2014-15&SeasonSegment=&SeasonType=Playoffs&TeamID=#{@po_playerdata[0]["TEAM_ID"]}&VsConference=&VsDivision=")
    
      a = po_player_team_data.body
      b = a["resultSets"]
      c = b[0] #overall team dashboard
      d = c["headers"]
      e = c["rowSet"]

      @po_playerteamdata = []
      "ZIPPING!!"
      e.each do |row|
    	hash = Hash[*d.zip(row).flatten]

    	@po_playerteamdata << hash 
      end

   # Team Lineups
   # twoman_lineups = Unirest.get("http://stats.nba.com/stats/teamdashlineups?DateFrom=&DateTo=&GameID=&GameSegment=&GroupQuantity=2&LastNGames=0&LeagueID=00&Location=&MeasureType=Base&Month=0&OpponentTeamID=0&Outcome=&PaceAdjust=N&PerMode=Totals&Period=0&PlusMinus=N&Rank=N&Season=2014-15&SeasonSegment=&SeasonType=Playoffs&TeamID=#{@po_playerdata[0]["TEAM_ID"]}&VsConference=&VsDivision=")
   # a = twoman_lineups.body
   # b = a["resultSets"]
   # c = b[0]
   # d = c["headers"]
   # e = c["rowSet"]

   # @team_lineups_minutes = []
   # e.each do |row|
 	 # hash = Hash[*d.zip(row).flatten]
 	 # @team_lineups_minutes << hash 
   # end

       # Team Passing Totals 
       po_team_passing = Unirest.get("http://stats.nba.com/stats/teamdashptpass?DateFrom=&DateTo=&GameSegment=&LastNGames=0&LeagueID=00&Location=&MeasureType=Base&Month=0&OpponentTeamID=0&Outcome=&PaceAdjust=N&PerMode=Totals&Period=0&PlusMinus=N&Rank=N&Season=2014-15&SeasonSegment=&SeasonType=Playoffs&TeamID=#{@po_playerdata[0]["TEAM_ID"]}&VsConference=&VsDivision=")
       a = po_team_passing.body
       b = a["resultSets"]
       c = b[0]
       d = c["headers"]
       e = c["rowSet"]
         # p team_passing
       @po_team_passes_per_player = []
       e.each do |row|
     	 hash = Hash[*d.zip(row).flatten]
     	 @po_team_passes_per_player << hash 
       end
       @po_team_passes_total = []
       # @team_assist_total = []
       @po_team_passes_per_player.each do |player|
     	 @po_team_passes_total << player["PASS"]
         # @team_assist_total << player["AST"]
       end


       #Team touches
       po_team_touches = Unirest.get("http://stats.nba.com/js/data/sportvu/2014/touchesTeamDataPost.json")
       a = po_team_touches.body
       b = a["resultSets"]
       p "TEAM RESULT SETS"
       c = b[0]
       d = c["headers"]
       e = c["rowSet"]

       po_team_touches_array = []
       e.each do |row|
     	 hash = Hash[*d.zip(row).flatten]
     	 po_team_touches_array << hash 
       end

       @po_team_touches_total = po_team_touches_array.select {|team| team["TEAM_ID"].to_i == @po_playerdata[0]["TEAM_ID"] }

       #Player Touches
       po_player_touches = Unirest.get("http://stats.nba.com/js/data/sportvu/2014/touchesDataPost.json").body["resultSets"][0]["rowSet"]

       @po_player_touches_total = po_player_touches.select{ |player| player[0].to_i == @po_playerdata[0]["PERSON_ID"] }

       #Touches highcarts pie
       @touchesChart = LazyHighCharts::HighChart.new('playoff_touches') do |f|
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
     				y: @po_player_total_passes.inject(:+) - @po_PlayerTotalsdata[0]['AST'], selected: true
     			}, 
                {
     				name: 'Assists',
     				y: @po_PlayerTotalsdata[0]['AST']
     				}, 
                {
     				:name=> 'Field Goal Miss',    
     				:y=> @po_PlayerTotalsdata[0]["FGA"] - @po_PlayerTotalsdata[0]["FGM"]  
     			}, 
                {  
     				:name=> 'Field Goal Made',    
					:y=> @po_PlayerTotalsdata[0]["FGM"]
     			}, 
                {
     				name: 'Turnovers',
     				y: @po_PlayerTotalsdata[0]["TOV"]    
    			}, 
                {
            name: 'Rebounds',
            y: @po_PlayerTotalsdata[0]['REB']
          },
                { 
     				name: 'Other',
     				y: @po_player_touches_total[0][15] - ((@po_player_total_passes.inject(:+)) + (@po_PlayerTotalsdata[0]["FGA"]) + (@po_PlayerTotalsdata[0]["TOV"]) + (@po_PlayerTotalsdata[0]["REB"]))
    			}  
     		]
     		}     
     	f.series(series) 

     	f.options[:title][:text] = "#{@po_playerdata[0]["DISPLAY_FIRST_LAST"]} Touches: #{@po_player_touches_total[0][15]}"
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

       @pointsChart = LazyHighCharts::HighChart.new('playoff_touches') do |f|
      f.chart({ :defaultSeriesType=>"pie"} )   
      f.tooltip({
        headerFormat: '<span style="font-size:11px">{series.name}</span><br>',
        pointFormat: '<span style="color:{point.color}">{point.name}</span>: <b>{point.percentage:.1f}%</b> of touches',
        backgroundColor: 'white'
        })
      series = { 
        :type=> 'pie',
        :name=> 'Points',
        :data=> [
          {
            name:'Points',
            y: @po_PlayerTotalsdata[0]['PTS']
          } 
             
        ]
        }     
      f.series(series) 

      f.options[:title][:text] = "#{@po_playerdata[0]["DISPLAY_FIRST_LAST"]} Points: #{@po_player_touches_total[0][15]}"
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
	end #Show

end
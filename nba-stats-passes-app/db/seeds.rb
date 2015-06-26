# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

players = Unirest.get("http://stats.nba.com/stats/commonallplayers?IsOnlyCurrentSeason=0&LeagueID=00&Season=2014-15").body["resultSets"][0]["rowSet"]

players.each do |player_array|
  Player.create(:name => player_array[1], :person_id => player_array[0]) if player_array[2] == 1
end

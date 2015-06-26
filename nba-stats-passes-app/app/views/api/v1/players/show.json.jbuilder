json.player do
	json.name @playerdata[0]["DISPLAY_FIRST_LAST"]
end 

json.details @playerdata[0]

json.details do
	json.name @playerdata[0]["DISPLAY_FIRST_LAST"]
	json.position @playerdata[0]["POSITION"]
	json.details @playerdata[0]
end


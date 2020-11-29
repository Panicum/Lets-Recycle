--- This module keeps track of a PlayFab leaderboard

local client = require "PlayFab.PlayFabClientApi"
local authentication = require "example.playfab.authentication"
local listener = require "ludobits.m.listener"

local last_score = 0

local M = {
	listeners = listener.create()
}

--- Will be triggered when the leaderboard has refreshed
M.REFRESH_SUCCESS = hash("LEADERBOARD_REFRESH_SUCCESS")

--- Will be trigegred if the leaderboard failed to refresh
M.REFRESH_FAILED = hash("LEADERBOARD_REFRESH_FAILED")

M.leaderboard = {}

local function get_for_player()
	local request = {
		StatisticName = "score",
		MaxResultsCount	= 15,
	}
	local response, error = client.GetLeaderboardAroundPlayer(
		request,
		function(response)
			M.leaderboard = response.Leaderboard
			print("M.leaderboardget_for_player, success!")
			M.listeners.trigger(M.REFRESH_SUCCESS)
		end,
		function(error)
			print("M.leaderboard get_for_player, error!", error)
			M.listeners.trigger(M.REFRESH_FAILED, error)
		end)
end

local function get_for_player_2(f1,f2)
	local request = {
		StatisticName = "score",
		MaxResultsCount	= 15,
	}
	local response, error = client.GetLeaderboardAroundPlayer(request,f1,f2)
	-- function(response)
	-- 	print("M.leaderboard get_for_player2, success!", response)
	-- 	return response, nil
	-- end,
	-- function(error)
	-- 	print("M.leaderboard get_for_player2, error!", error)
	-- 	return  nil, response
	-- end)
	-- function(response)
	-- 	M.leaderboard = response.Leaderboard
	-- 	print("M.leaderboardget_for_player, success!")
	-- 	M.listeners.trigger(M.REFRESH_SUCCESS)
	-- 	return response, error
	-- end,
	-- function(error)
	-- 	print("M.leaderboard get_for_player, error!", error)
	-- 	M.listeners.trigger(M.REFRESH_FAILED, error)
	-- 	return response, error
	-- end)
end


--- Refresh the leaderboard for the currently logged in player
-- Will generate a @{REFRESH_SUCCESS} or @{REFRESH_FAILED}
function M.refresh()
	get_for_player()
end

function M.refresh_2(f1,f2)
	return get_for_player_2(f1,f2)
end

--- Clear the current leaderboard
function M.clear()
	M.leaderboard = {}
	M.listeners.trigger(M.REFRESH_SUCCESS, M.leaderboard)
end


--- Get the score of a player in the leaderboard
-- @param playfab_id
-- @return The score or nil 
function M.get_score(playfab_id)
	for k,v in pairs(M.leaderboard) do
		if v.PlayFabId == playfab_id then
			return v.StatValue
		end
	end
end


--- Update the score for the currently logged in user
-- @param score
-- @return success
-- @return error
function M.update(score)
	local user_id = authentication.user_id()
	print("Best score update for", user_id, score)
	if not user_id then
		return false, "No user id"
	end
	
	local current_score = M.get_score(user_id) or 0
	if current_score > score then
		return true
	end
	
	local request = {
		Statistics = {
			{
				StatisticName = "score",
				Value = score,
			},
		}
	}
	local response, error = client.UpdatePlayerStatistics.flow(request)
	if error then
		return false, error
	end
	return get_for_player()
end


--- Get the leaderboard data
-- @return Leaderboard data
function M.get()
	return M.leaderboard
end

function M.set_last_score(score)
	last_score = score
end

function M.get_last_score()
	return last_score
end

return M
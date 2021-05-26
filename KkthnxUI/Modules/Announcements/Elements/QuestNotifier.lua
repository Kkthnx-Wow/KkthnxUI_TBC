local K, C = unpack(select(2, ...))
local Module = K:GetModule("Announcements")

local _G = _G
local pairs = _G.pairs

local GetQuestLink = _G.GetQuestLink
local IsInGroup = _G.IsInGroup
local IsPartyLFG = _G.IsPartyLFG
local SendChatMessage = _G.SendChatMessage
local GetNumQuestLeaderBoards = _G.GetNumQuestLeaderBoards
local GetQuestLogLeaderBoard = _G.GetQuestLogLeaderBoard
local C_QuestLog_GetQuestTagInfo = _G.C_QuestLog.GetQuestTagInfo
local C_QuestLog_GetInfo = C_QuestLog.GetInfo
local GetNumQuestLogEntries = _G.GetNumQuestLogEntries

local lastList

local function sendQuestMsg(msg)
	if IsPartyLFG() then
		SendChatMessage(msg, "INSTANCE_CHAT")
	elseif IsInGroup() then
		SendChatMessage(msg, "PARTY")
	end
end

function K.CreateColorString(text, db)
    local hex = db.r and db.g and db.b and K.RGBToHex(db.r, db.g, db.b) or "|cffffffff"
    return hex..text.."|r"
end

local function GetQuests()
	local quests = {}

	for questIndex = 1, GetNumQuestLogEntries() do
		local title, level, suggestedGroup, isHeader, _, isComplete, frequency, questID, _, _, _, _, _, isBounty, _, isHidden = GetQuestLogTitle(questIndex)
		local skip = isHeader or isBounty or isHidden

		if not skip then
			local _, tagName, worldQuestType = GetQuestTagInfo(questID)
			quests[questID] = {
				title = title,
				questID = questID,
				level = level,
				suggestedGroup = suggestedGroup,
				isComplete = isComplete,
				frequency = frequency,
				tag = tagName,
				worldQuestType = worldQuestType,
				link = GetQuestLink(questID)
			}

			for queryIndex = 1, GetNumQuestLeaderBoards(questIndex) do
				local queryText = GetQuestLogLeaderBoard(queryIndex, questIndex)
				local _, _, numItems, numNeeded, itemName = strfind(queryText, "(%d+)/(%d+) ?(.*)")
				quests[questID][queryIndex] = {
					item = itemName,
					numItems = numItems,
					numNeeded = numNeeded
				}
			end
		end
	end

	return quests
end

function Module:SetupQuestNotifier()
	local config = C["Announcements"]
	if not config or not config.QuestNotifier then
		return
	end

	local currentList = GetQuests()
	if not lastList then
		lastList = currentList
		return
	end

	for questID, questCache in pairs(currentList) do
		local mainInfo = ""
		local extraInfo = ""
		local mainInfoColored = ""
		local extraInfoColored = ""
		local needAnnounce = false
		local isDetailInfo = false

		if questCache.frequency == 1 and config.Daily then
			extraInfo = extraInfo.."[".._G.DAILY.."]"
			extraInfoColored = extraInfoColored..K.CreateColorString("[".._G.DAILY.."]", {r = 1.000, g = 0.980, b = 0.396})
		elseif questCache.frequency == 3 and config.Weekly then
			extraInfo = extraInfo.."[".._G.WEEKLY.."]"
			extraInfoColored = extraInfoColored..K.CreateColorString("[".._G.WEEKLY.."]", {r = 0.196, g = 1.000, b = 0.494})
		end

		if questCache.suggestedGroup > 1 and config.SuggestedGroup then
			extraInfo = extraInfo.."["..questCache.suggestedGroup.."]"
			extraInfoColored =
				extraInfoColored..K.CreateColorString("["..questCache.suggestedGroup.."]", {r = 1.000, g = 0.220, b = 0.220})
		end

		if questCache.level and config.Level then
			local expansionLevel = GetMaxLevelForExpansionLevel(LE_EXPANSION_BATTLE_FOR_AZEROTH)
			if not config.LevelHideOnMax or questCache.level ~= expansionLevel then
				extraInfo = extraInfo.."["..questCache.level.."]"
				extraInfoColored = extraInfoColored..K.CreateColorString("["..questCache.level.."]", {r = 0.773, g = 0.424, b = 0.941})
			end
		end

		if questCache.tag and config.Tag then
			extraInfo = extraInfo.."["..questCache.tag.."]"
			extraInfoColored = extraInfoColored..K.CreateColorString("["..questCache.tag.."]", {r = 0.490, g = 0.373, b = 1.000})
		end

		local questCacheOld = lastList[questID]
		if questCacheOld then
			if not questCacheOld.isComplete then
				if questCache.isComplete then
					mainInfo = questCache.title.." "..K.CreateColorString("Completed", {r = 0.5, g = 1, b = 0.5})
					mainInfoColored = questCache.link.." "..K.CreateColorString("Completed", {r = 0.5, g = 1, b = 0.5})
					needAnnounce = true
				elseif #questCacheOld > 0 and #questCache > 0 then
					for queryIndex = 1, #questCache do
						if questCache[queryIndex] and questCacheOld[queryIndex] and questCache[queryIndex].numItems and questCacheOld[queryIndex].numItems and questCache[queryIndex].numItems > questCacheOld[queryIndex].numItems then
							local progressColor = {
								r = 1 - 0.5 * questCache[queryIndex].numItems / questCache[queryIndex].numNeeded,
								g = 0.5 + 0.5 * questCache[queryIndex].numItems / questCache[queryIndex].numNeeded,
								b = 0.5
							}
							local subGoalIsCompleted = questCache[queryIndex].numItems == questCache[queryIndex].numNeeded
							if config.IncludeDetails or subGoalIsCompleted then
								local progressInfo = questCache[queryIndex].numItems.."/"..questCache[queryIndex].numNeeded
								local progressInfoColored = progressInfo
								if subGoalIsCompleted then
									local redayCheckIcon = "|TInterface/RaidFrame/ReadyCheck-Ready:15:15:-1:2:64:64:6:60:8:60|t"
									progressInfoColored = progressInfoColored..redayCheckIcon
								else
									isDetailInfo = true
								end

								mainInfo = questCache.link.." "..questCache[queryIndex].item.." "
								mainInfoColored = questCache.link.." "..questCache[queryIndex].item.." "

								mainInfo = mainInfo..progressInfo
								mainInfoColored = mainInfoColored..K.CreateColorString(progressInfoColored, progressColor)
								needAnnounce = true
							end
						end
					end
				end
			end
		else
			if not questCache.worldQuestType then
				mainInfo = questCache.link.." ".."Quest Accepted"
				mainInfoColored = questCache.link.." "..K.CreateColorString("Quest Accepted", {r = 1.000, g = 0.980, b = 0.396})
				needAnnounce = true
			end
		end

		if needAnnounce then
			local message = extraInfo..mainInfo
			if not config.Paused then
				sendQuestMsg(message)
			end

			if not isDetailInfo then
				local messageColored = extraInfoColored..mainInfoColored
				_G.UIErrorsFrame:AddMessage(messageColored)
			end
		end
	end

	lastList = currentList
end

function Module:CreateQuestNotifier()
	local config = C["Announcements"]
	if not config or not config.QuestNotifier then
		return
	end

    K:RegisterEvent("QUEST_LOG_UPDATE", Module.SetupQuestNotifier)
end
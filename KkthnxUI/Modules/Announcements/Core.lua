local K = unpack(select(2, ...))
local Module = K:NewModule("Announcements")

function Module:OnEnable()
	Module:CreateHealthAnnounce()
	Module:CreateInterruptAnnounce()
	Module:CreateItemAnnounce()
	Module:CreateKillingBlow()
	-- Module:CreateQuestNotifier() -- FIX ME LATER
	Module:CreateResetInstance()
	Module:CreateSaySappedAnnounce()
end
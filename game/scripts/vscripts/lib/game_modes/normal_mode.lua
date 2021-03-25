NormalMode = NormalMode or class({})

NormalMode.RandomHeroOnShowcase = true

function NormalMode:InitGameMode()
	local GameMode = GameRules:GetGameModeEntity()

	GameMode:SetDraftingHeroPickSelectTimeOverride(60)
	GameMode:SetDraftingBanningTimeOverride(20)
	
	GameRules:SetStrategyTime(15.0)
	GameRules:SetHeroSelectionTime(90)
end

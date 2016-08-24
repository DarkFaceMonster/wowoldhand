
Oldhand_SaveData = nil;
Oldhand_Data = nil;
Oldhand_PlayerTalentInfoDatas = {};

local dynamicMicroID = 72;
local playerClass;
local englishClass;
local Oldhand_DPS = 2; -- 默认天赋2，比如萨满1元素，2增强，3治疗
local Oldhand_Old_UnitPopup_OnClick;
local Oldhand_AutoFollowName="";
local TestHelpTarget = "";
local target_count = 0;		-- 目标个数
local target_table = {};
local is_valid_class = false; -- 是否有效职业

local oldhand_dps_module = {};

local   Oldhand_DISEASE = '疾病';
local 	Oldhand_MAGIC   = '魔法';
local 	Oldhand_POISON  = '中毒';
local 	Oldhand_CURSE   = '诅咒';

local  Oldhand_IGNORELIST = {
		["放逐术"]	= true,
		["相位变换"]	= true,
		["冰冻"] = true,
		["火球术"] = true,
		["寒冰箭"] = true,
		["深寒之冬"] = true,
		["加尔脉冲"] = true,
		["月火术"] = true,
		["熔岩镣铐"] = true,
		["雷霆一击"] = true,
		["灼烧土地"] = true,
		["强化灼烧"] = true,
		["圣光审判"] = true,
		["智慧审判"] = true,
		["公正审判"] = true,
		["辩护"] = true,
		["正义复仇"] = true,
	};

local Oldhand_SKIP_LIST = {
		["无梦睡眠"] = true,
		["强效昏睡"] = true,
		["心灵视界"] = true,
	};
local 	Oldhand_CLASS_DRUID   = '德鲁伊';
local 	Oldhand_CLASS_HUNTER  = '猎人';
local 	Oldhand_CLASS_MAGE    = '法师';
local 	Oldhand_CLASS_PALADIN = '圣骑士';
local 	Oldhand_CLASS_PRIEST  = '牧师';
local 	Oldhand_CLASS_ROGUE   = '盗贼';
local 	Oldhand_CLASS_SHAMAN  = '萨满祭司';
local 	Oldhand_CLASS_WARLOCK = '术士';
local 	Oldhand_CLASS_WARRIOR = '战士';
local 	Oldhand_CLASS_DEATHKNIGHT = '死亡骑士';

local Oldhand_SKIP_BY_CLASS_LIST = {
		[Oldhand_CLASS_WARRIOR] = {
			["上古狂乱"]   = true,
			["点燃法力"]   = true,
			["污浊之魂"]   = true,
		};
		[Oldhand_CLASS_ROGUE] = {
			["沉默"]       = true;
			["上古狂乱"]   = true,
			["点燃法力"]   = true,
			["污浊之魂"]   = true,
			["煽动烈焰"]   = true,
			["熔岩镣铐"]   = true,
		};
		[Oldhand_CLASS_HUNTER] = {
			["煽动烈焰"]   = true,
		};
		[Oldhand_CLASS_MAGE] = {
			["煽动烈焰"]   = true,
		};
		[Oldhand_CLASS_DRUID]= {
			["煽动烈焰"]   = true,
		};
		[Oldhand_CLASS_PALADIN]= {
			["煽动烈焰"]   = true,
		};
		[Oldhand_CLASS_PRIEST]= {
			["煽动烈焰"]   = true,
		};
		[Oldhand_CLASS_SHAMAN]= {
			["煽动烈焰"]   = true,
		};
		[Oldhand_CLASS_WARLOCK]= {
			["煽动烈焰"]   = true,
		};
	};

oldhand_spell_table = {};
--oldhand_spell_table["临近风暴之怒"] = 72;
--oldhand_spell_table["大副的怀表"] = 71;

-- 获取玩家当前天赋
function Oldhand_AutoSelectMode()
  Oldhand_DPS = 0;
  playerClass, englishClass = UnitClass("player");
	
	if playerClass=="死亡骑士" and (DeathKnight_DpsOut1 ~= nil and DeathKnight_DpsOut2 ~= nil and DeathKnight_DpsOut3 ~= nil) then
	  is_valid_class = true;
	  oldhand_dps_module[englishClass] =  DeathKnight_DpsOut;
	end;
  if playerClass=="战士" and (Warrior_DpsOut1 ~= nil and Warrior_DpsOut2 ~= nil and Warrior_DpsOut3 ~= nil) then
    is_valid_class = true;
    oldhand_dps_module[englishClass] = Warrior_DpsOut;
  end;
  if playerClass=="萨满祭司" and (Shaman_DpsOut1 ~= nil and Shaman_DpsOut2 ~= nil and Shaman_DpsOut3 ~= nil) then 
    is_valid_class = true;
    oldhand_dps_module[englishClass] = Shaman_DpsOut;
  end;
  
	if not is_valid_class then return; end;
	
	if UnitAffectingCombat("player")~=1 then
	  local currentSpec = GetSpecialization();
	  Oldhand_DPS = currentSpec;
	end
end

-- 判断是否需要打断目标施法
function Oldhand_BreakCasting(myspell)
	local target_name = UnitName("target");
	local spell, _, displayName, _, startTime, endTime, _, _, notInterruptible = UnitCastingInfo("target");
	if (spell == null) then currTargetCasting = null; return 0; end;
	if (spell ~= null and spell ~= currTargetCasting) then
	  if (notInterruptible) then
	    --DeathKnight_AddMessage(string.format("目标 正在施放 %s 。。。无法打断", spell));
	    return 0;
	  else
--	    DeathKnight_AddMessage(string.format("目标 正在施放 %s 。。。", spell));
	  end;
	  currTargetCasting = spell;
	end;
	if endTime and startTime then
		target_spellname = spell;

		local isPlayer = false;
		if not (UnitIsPlayer("target") and UnitCanAttack("player","target")) then
			isPlayer = true;
		end;

		if not isPlayer then
			local g_FindNpcName = false;
			for k, v in pairs(DeathKnight_SaveData) do
				if v["npcname"] == target_name and  v["spellname"] == myspell and v["targetspellname"] == target_spellname then
			    	g_FindNpcName = true;
			  	end
			end
			if g_FindNpcName then
				--DeathKnight_AddMessage(string.format("%s 正在施放 %s，无法打断。",target_name,spell));
				return 0;
			end;
		end

		local remainTime = endTime - GetTime() * 1000;
		--DeathKnight_AddMessage(string.format("%s 正在施放 %s。。。，剩余时间：%f",target_name,spell,remainTime));
		if (remainTime <= 800.0) then
			if (spell) then
				--DeathKnight_AddMessage(string.format("打断：%s 的 %s，还剩 %d 毫秒。",target_name,spell,remainTime));
				return 1;
			elseif displayName then
				--DeathKnight_AddMessage(string.format("打断：%s 的 %s，还剩 %d 毫秒。",target_name,displayName,remainTime));
				return 1;
			end;
		end
	else
		target_spellname = "";
	end

	return 0;
end

-- 判断自己或友方debuff类型
function Oldhand_TestPlayerDebuff(unit)
  --local healthPercent, maxHealth = Oldhand_GetPlayerHealthPercent(unit);
	--if healthPercent < 40 then return 0; end;
	local i = 1;
	while UnitDebuff(unit, i ) do
		OldhandTooltip:SetOwner(Oldhand_MSG_Frame, "ANCHOR_BOTTOMRIGHT", 0, 0);
		OldhandTooltip:SetUnitDebuff(unit, i);
		local	debuff_name = OldhandTooltipTextLeft1:GetText();
		local   debuff_type = OldhandTooltipTextRight1:GetText();
		OldhandTooltip:Hide();
		if (debuff_name) and (debuff_type) then
			if (Oldhand_IGNORELIST[debuff_name]) then
				break;
			end
			if (UnitAffectingCombat("player")) then
				if (Oldhand_SKIP_LIST[debuff_name]) then
					break;
				end
				if (Oldhand_SKIP_BY_CLASS_LIST[UClass]) then
					if (Oldhand_SKIP_BY_CLASS_LIST[UClass][debuff_name]) then
						break;
					end
				end
			end
			if (debuff_type) then
				if (debuff_type == Oldhand_MAGIC) then
					return 1;
				elseif (debuff_type == Oldhand_DISEASE) then
					return 2;
				elseif (debuff_type == Oldhand_POISON) then
					return 3;
				elseif (debuff_type == Oldhand_CURSE) then
					return 4;
				end
			end
		end;
		i = i + 1;
	end
	return 0;
end

function Oldhand_RegisterEvents(self)
	playerClass, englishClass = UnitClass("player");
	
	if playerClass=="死亡骑士" and (DeathKnight_DpsOut1 ~= nil and DeathKnight_DpsOut2 ~= nil and DeathKnight_DpsOut3 ~= nil) then
	  is_valid_class = true;
	  oldhand_dps_module[englishClass] =  DeathKnight_DpsOut;
	end;
  if playerClass=="战士" and (Warrior_DpsOut1 ~= nil and Warrior_DpsOut2 ~= nil and Warrior_DpsOut3 ~= nil) then
    is_valid_class = true;
    oldhand_dps_module[englishClass] = Warrior_DpsOut;
  end;
  if playerClass=="萨满祭司" and (Shaman_DpsOut1 ~= nil and Shaman_DpsOut2 ~= nil and Shaman_DpsOut3 ~= nil) then 
    is_valid_class = true;
    oldhand_dps_module[englishClass] = Shaman_DpsOut;
  end;
  if playerClass=="术士" and (Warlock_DpsOut1 ~= nil and Warlock_DpsOut2 ~= nil and Warlock_DpsOut3 ~= nil) then 
    is_valid_class = true;
    oldhand_dps_module[englishClass] = Warlock_DpsOut;
  end;
  
	if not is_valid_class then return; end;
	
	--if not (playerClass=="萨满祭司") then
	--		HideUIPanel(Oldhand_MSG_Frame);
	--		HideUIPanel(OldhandColorRectangle);
	--		return;
	--end;
	self:RegisterEvent("PLAYER_ENTERING_WORLD");
	self:RegisterEvent("UI_ERROR_MESSAGE");
	self:RegisterEvent("PLAYER_TARGET_CHANGED");
	self:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED");
	--self:RegisterEvent("INSPECT_TALENT_READY");

	UnitPopupButtons["OldhandPOPUP"] = { text = "智能施法跟随对象", dist = 0 };

	if (UnitPopupMenus["SELF"]) then
		--table.insert( UnitPopupMenus["SELF"], "OldhandPOPUP");
	end
	if (UnitPopupMenus["PLAYER"]) then
		--table.insert( UnitPopupMenus["PLAYER"], "OldhandPOPUP");
	end
	if (UnitPopupMenus["PARTY"]) then
		--table.insert( UnitPopupMenus["PARTY"], "OldhandPOPUP");
	end

	--Oldhand_Old_UnitPopup_OnClick = UnitPopup_OnClick;
	--UnitPopup_OnClick = Oldhand_UnitPopup_OnClick;
end;
function Oldhand_UnitPopup_OnClick()
	local index = this.value;
	local dropdownFrame = getglobal(UIDROPDOWNMENU_INIT_MENU);
	local button =  this.value;
	local name = dropdownFrame.name;

	if ( button == "OldhandPOPUP" ) then
		Oldhand_AutoFollowName = name;
		PlaySound("UChatScrollButton");
		DEFAULT_CHAT_FRAME:AddMessage("("..Oldhand_AutoFollowName..")目前为跟随对象!");
	else
		Oldhand_Old_UnitPopup_OnClick();
	end
end
function Oldhand_OnEvent(event)
  if not is_valid_class then
    Oldhand_AddMessage("没有 "..playerClass.." 职业插件");
    return;
  end;

	if (event=="PLAYER_ENTERING_WORLD") then
		Oldhand_Data = {};
		Oldhand_Data[UnitName("player")] = {
		  Rogue={},
		};
		if (Oldhand_SaveData == nil) then
		  Oldhand_SaveData = {};
		end
		DEFAULT_CHAT_FRAME:AddMessage("智能施法插件 4.0 (全职业整合版)   www.oldhand.net 版权所有");
		getglobal("OldhandColorRectangle".."NormalTexture"):SetVertexColor(0, 0, 0);
		Oldhand_AutoSelectMode();
		Oldhand_CreateMacro();
	end;

	if (event=="INSPECT_TALENT_READY") then
		if not UnitExists("playertarget") then
			return;
		end;
		if UnitIsPlayer("target") then
		  local MaxTalents = 0;
			for t=1, GetNumTalentTabs(true) do
		    local __,__,Talents = GetTalentTabInfo(t,true);
		    if Talents > MaxTalents then
			    MaxTalents = Talents
		    end
			end

			for s=1, GetNumTalentTabs(true) do
			    local __,__,Talents = GetTalentTabInfo(s,true);
			    if 0==1 and  Talents == MaxTalents then
				   if UnitAffectingCombat("player") ~= 1 then
					 Oldhand_AddMessage_A("**你的目标是"..GetTalentTabInfo(s,true).."天赋的"..UnitClass("target").."**");
				   end
				   if UnitIsUnit("player","target") and UnitAffectingCombat("player") ~= 1 then
					Oldhand_CreateMacro();
				   end;
				   if not UnitCanAttack("player","target")  then
						if UnitClass("target") == "德鲁伊" and GetTalentTabInfo(s,true) == "野性战斗" then
							Oldhand_AddPlayerTalent(UnitName("target"));
						end;
						if UnitClass("target") == "圣骑士" and GetTalentTabInfo(s,true) == "防护" then
							Oldhand_AddPlayerTalent(UnitName("target"));
						end;
						if UnitClass("target") == "战士" and GetTalentTabInfo(s,true) == "防护" then
							Oldhand_AddPlayerTalent(UnitName("target"));
						end;
				   end;
				   return ;
			    end
			end
		end
		return;
	end;

	if (event=="PLAYER_TARGET_CHANGED") then
		if not UnitExists("playertarget") then
			return;
		end;
		if UnitAffectingCombat("player") ~= 1 and UnitIsUnit("target", "player") then
			Oldhand_AutoSelectMode();
			Oldhand_CreateMacro();
		end;
		if UnitIsPlayer("target") and not UnitIsUnit("player","target") then
			NotifyInspect("playertarget");
		end;
	end;

end;

function Oldhand_AddPlayerTalent(playername)
	for k, v in pairs(Oldhand_PlayerTalentInfoDatas) do
		if(playername == v["Name"]) then
			return;
		end
	end

	table.insert(Oldhand_PlayerTalentInfoDatas,
		{
		["Name"] = playername,
		});
end
function Oldhand_GetPlayerTalent(playername)
	for k, v in pairs(Oldhand_PlayerTalentInfoDatas) do
		if(playername == v["Name"]) then
			return true;
		end
	end
	return false;
end

function Oldhand_CreateMacro()
	if GetMacroIndexByName("打断施法") == 0 then
		CreateMacro("打断施法", 67, "/stopcasting", 1, 1);
	end;
	PickupMacro("打断施法");
	PlaceAction(61);
	ClearCursor();

	if GetMacroIndexByName("开始攻击") == 0 then
		CreateMacro("开始攻击", 60, "/startattack", 1, 1);
	end;
	--PickupMacro("开始攻击");
	--PlaceAction(1);
	--ClearCursor();

	if GetMacroIndexByName("狂暴") == 0 then
		CreateMacro("狂暴", 66, "/cast 狂暴", 1, 0);
	end;

	if GetMacroIndexByName("更换模式") == 0 then
		CreateMacro("更换模式", 61, "/script Oldhand_Input(1);", 1, 1);
	end;
	PickupMacro("更换模式");
	PlaceAction(49);
	ClearCursor();
	if Oldhand_DPS == 2 then
		if GetMacroIndexByName("天赋1模式") == 0 then
			CreateMacro("天赋1模式", 62, "/script Oldhand_Input(1);", 0, 0);
		end;
		PickupMacro("天赋2模式");
	elseif Oldhand_DPS == 1 then
		if GetMacroIndexByName("天赋2模式") == 0 then
			CreateMacro("天赋2模式", 62, "/script Oldhand_Input(1);", 0, 0);
		end;
		PickupMacro("天赋2元素模式");
	elseif Oldhand_DPS == 3 then
		if GetMacroIndexByName("天赋3模式") == 0 then
			CreateMacro("天赋3模式", 62, "/script Oldhand_Input(1);", 0, 0);
		end;
		PickupMacro("天赋3模式");
	end
	PlaceAction(50);
	ClearCursor();

  Oldhand_PutAction("自动攻击", 1);
  
  if playerClass == "萨满祭司" then
    Shaman_CreateMacro();
  elseif playerClass == "死亡骑士" then
    DeathKnight_CreateMacro();
  elseif playerClass == "战士" then
    Warrior_CreateMacro();
  elseif playerClass == "术士" then
    Warlock_CreateMacro();
  end

	if Oldhand_TestTrinket("部落勋章") then
		Oldhand_PutAction("部落勋章", 71);
	elseif Oldhand_TestTrinket("大副的怀表") then
		Oldhand_PutAction("大副的怀表", 72);
	elseif Oldhand_TestTrinket("菲斯克的怀表") then
		Oldhand_PutAction("菲斯克的怀表", 72);
	elseif Oldhand_TestTrinket("恐惧小盒") then
		Oldhand_PutAction("恐惧小盒", 71);
	elseif Oldhand_TestTrinket("恐惧小盒") then
		Oldhand_PutAction("战歌的热情", 71);
	elseif Oldhand_TestTrinket("苔原护符") then
		Oldhand_PutAction("苔原护符", 71);
	elseif Oldhand_TestTrinket("食人魔殴斗者的徽章") then
		Oldhand_PutAction("食人魔殴斗者的徽章", 71);
	end
	if Oldhand_TestTrinket("胜利旌旗") then
		Oldhand_PutAction("胜利旌旗", 72);
	elseif Oldhand_TestTrinket("临近风暴之怒") then
		Oldhand_PutAction("临近风暴之怒", 71);
	elseif Oldhand_TestTrinket("英雄勋章") then
		Oldhand_PutAction("英雄勋章", 72);
	elseif Oldhand_TestTrinket("伊萨诺斯甲虫") then
		Oldhand_PutAction("伊萨诺斯甲虫", 72);
	elseif Oldhand_TestTrinket("刃拳的宽容") then
		Oldhand_PutAction("刃拳的宽容", 72);
	end

	Oldhand_PutAction("狂暴", 51);

	SetBinding("F1", "MULTIACTIONBAR1BUTTON1");
	SetBinding("F2", "MULTIACTIONBAR1BUTTON2");
	SetBinding("F3", "MULTIACTIONBAR1BUTTON3");
	SetBinding("[", "MULTIACTIONBAR1BUTTON4");
	SetBinding("F5", "MULTIACTIONBAR1BUTTON5");
	SetBinding("F6", "MULTIACTIONBAR1BUTTON6");
	SetBinding("F7", "MULTIACTIONBAR1BUTTON7");
	SetBinding("F8", "MULTIACTIONBAR1BUTTON8");
	SetBinding("F9", "MULTIACTIONBAR1BUTTON9");
	SetBinding("F10", "MULTIACTIONBAR1BUTTON10");
	SetBinding("F11", "MULTIACTIONBAR1BUTTON11");
	SetBinding("F12", "MULTIACTIONBAR1BUTTON12");
	SetBinding("]", "TARGETSELF");
	--SetBinding("\\", "TARGETPARTYMEMBER1");
	--SetBinding(";", "TARGETPARTYMEMBER2");
	--SetBinding("\'", "TARGETPARTYMEMBER3");
	--SetBinding(",", "TARGETPARTYMEMBER4");

	SetBindingMacro(",","狂暴");	-- 29
	--SetBindingMacro("\'","活力分流");	-- 28
	SetBindingMacro(";","打断施法");	-- 27
	--SetBindingMacro("\\","开始攻击");	-- 26

	SaveBindings(1);
end;

function Oldhand_PutAction(text, index)
	if not text then return false;end;
	Oldhand_AddMessage(text..index);
	if Oldhand_PickupSpellByBook(text) then
		PlaceAction(index);
		ClearCursor();
		oldhand_spell_table[text] = index;
		return true;
	end;
	oldhand_spell_table[text] = 0;
	return false;
end;

function Oldhand_NoTarget_RunCommand()
	return Oldhand_RunCommand();
end;

function Oldhand_Test_IsFriend(unitname)
	if (UnitInRaid("player")) then
		for id=1, GetNumRaidMembers()  do
			if UnitName("raid"..id) == unitname then
				if UnitCanAttack("player","raid"..id) then return false; end;
				return true;
			end;
		end
	else
		for id=1, GetNumGroupMembers()  do
			if UnitName("party"..id) == unitname then
				if UnitCanAttack("player","party"..id) then return false; end;
				return true;
			end;
		end
	end
	return false;
end;

function Oldhand_Damage_Message(arg1, event)
	if (not arg1) then
		return;
	end;

	if event == "CHAT_MSG_SPELL_HOSTILEPLAYER_BUFF" then
		for creatureName,creatureName1 in string.gmatch(arg1, "(.+)对(.+)使用消失。") do
			if not Oldhand_Test_IsFriend(creatureName)  then
				Oldhand_AddMessage("|cff00adef"..creatureName.."|r|cff00ff00使用了消失!自动使用奉献!|r");
				table.insert(Oldhand_Data[UnitName("player")]["Rogue"],{["Command"] = "奉献"});
				StartTimer("Ability_Oldhand_WarCry");
			end
			return;
		end;
	end;

	local playerUnitName = UnitName("Player");

	if ( event == "CHAT_MSG_SPELL_SELF_DAMAGE" ) then
			Oldhand_AddMessage(arg1);
			for spellname, creatureName, spell in string.gmatch(arg1, playerUnitName.."的(.+)打断了(.+)的(.+)。") do
				Oldhand_AddMessage("**你的"..spellname.."打断了"..creatureName.."的"..spell.."...**");
				return;
			end;
			for spell, creatureName, damage in string.gmatch(arg1, "你的(.+)击中(.+)造成(%d+)点伤害。") do
				if spell and damage > 500 then
					Oldhand_AddMessage("你的|cffffff00"..spell.."|r|cff00ff00造成|r|cffffff00"..damage.."|r|cff00ff00伤害...|r");
					return;
				end;
			end;
			for spell, creatureName, damage in string.gmatch(arg1, "你的(.+)爆击对(.+)造成(%d+)点伤害。") do
				if spell and damage > 500 then
					Oldhand_AddMessage("你的|cffffff00"..spell.."|r|cff00ff00造成|r|cffffff00"..damage.."|r|cff00ff00伤害(爆击)|r");
					return;
				end;
			end;
			for spell, creatureName, damage, damageType in string.gmatch(arg1, "你的(.+)击中(.+)造成(%d+)点(.+)伤害。") do
				if spell and damage > 500 then
					Oldhand_AddMessage("你的|cffffff00"..spell.."|r|cff00ff00造成|r|cffffff00"..damage.."|r|cff00ff00伤害...");
					return;
				end;
			end;
			for spell, creatureName, damage, damageType in string.gmatch(arg1, "你的(.+)爆击对(.+)造成(%d+)点(.+)伤害。") do
				if spell and damage > 500 then
					Oldhand_AddMessage("你的|cffffff00"..spell.."|r|cff00ff00造成|r|cffffff00"..damage.."|r|cff00ff00伤害(爆击)|r");
					return;
				end;
			end;
	end;
		if (event == "CHAT_MSG_SPELL_SELF_BUFF" or
			event == "CHAT_MSG_SPELL_PARTY_BUFF" or
			event == "CHAT_MSG_SPELL_FRIENDLYPLAYER_BUFF" or
			event == "CHAT_MSG_SPELL_HOSTILEPLAYER_BUFF" or
			event == "CHAT_MSG_SPELL_PERIODIC_HOSTILEPLAYER_BUFFS"
			) then
			Oldhand_AddMessage(arg1);
			for playerName, spell, creatureName, damage in string.gmatch(arg1, "(.+)的(.+)发挥极效，为(.+)恢复了(%d+)点生命值。") do
				if creatureName == "你" then
					Oldhand_AddMessage("|cff00adef"..playerName.."|r|cff00ff00的|r|cffffff00"..spell.."|r|cff00ff00x给我恢复了|r|cffffff00"..damage.."|r|cff00ff00生命值...|r");
				end;
				return;
			end;
			for playerName, spell, creatureName, damage in string.gmatch(arg1, "(.+)的(.+)为(.+)恢复了(%d+)点生命值。") do
				if creatureName == "你" then
					Oldhand_AddMessage("|cff00adef"..playerName.."|r|cff00ff00的|r|cffffff00"..spell.."|r|cff00ff00给我恢复了|r|cffffff00"..damage.."|r|cff00ff00生命值...|r");
				end;
				return;
			end;
		end;
end;

function Oldhand_Input(i)
	Oldhand_DPS = Oldhand_DPS + 1;
	if (Oldhand_DPS > 3) then Oldhand_DPS = 1; end;
	
  Oldhand_AddMessage(playerClass.."进入天赋"..Oldhand_DPS.."模式(PVP适用)...");
  return;
  
	--if Oldhand_DPS == 1 then
	--	Oldhand_AddMessage("进入元素模式(PVP适用)...");
	--elseif Oldhand_DPS == 2 then
	--	Oldhand_AddMessage("进入增强模式(PVP适用)...");
	--else
	--	Oldhand_AddMessage("进入治疗模式...");
	--end
end;

function Oldhand_Msg_OnUpdate()
	
	if UnitOnTaxi("player") == 1 then return; end;
	if UnitIsDeadOrGhost("player") then
		return;
	end;
	for id=1, GetNumGroupMembers()  do
		local unit = "party"..id ;
		if UnitExists(unit) then
			local MacroIndex = GetMacroIndexByName("TargetParty"..id);
			if MacroIndex ~= 0 then
				local MacroName,MacroIcon,MacroBody = GetMacroInfo(MacroIndex);
				if MacroBody ~= "/target "..UnitName(unit) then
					-- EditMacro(MacroIndex,"TargetParty"..id, 63, "/target "..UnitName(unit), 1, 1);
					-- SetBindingMacro("CTRL-SHIFT-F".. id,"TargetParty"..id)
					-- SaveBindings(1);
				end;
			else
				-- CreateMacro("TargetParty"..id, 63, "/target "..UnitName(unit), 1, 1);
				-- SetBindingMacro("CTRL-SHIFT-F".. id,"TargetParty"..id)
				-- SaveBindings(1);
			end;
		end;
	end;
end;

function Oldhand_Frame_OnUpdate()
	if not is_valid_class then return; end;

	--if(ChatFrameEditBox:IsVisible()) then
	local activeWindow = ChatEdit_GetActiveWindow();
	if ( activeWindow ) then
		Oldhand_SetText("聊天状态",0);
		return;
	end;
	if UnitIsDeadOrGhost("player") then
	  Oldhand_SetText("死亡状态",0);
		return;
	end;
	if not UnitAffectingCombat("player") then
		Oldhand_ClearTargetTable();
	end;
	if UnitOnTaxi("player") == 1 then return; end;

	if Oldhand_TestPlayerIsHorse() then
		if IsActionInRange(Oldhand_GetActionID("Spell_Holy_SealOfMight")) ~= 1  then
		    Oldhand_SetText("骑乘状态",0);
			return;
		end;
	end;

	if (Oldhand_PlayerBU("喝水") or Oldhand_PlayerBU("进食")) and UnitAffectingCombat("player")~=1 then
		Oldhand_SetText("正在喝水",0);
		return;
	end;

	local spellname,_,displayName = UnitCastingInfo("player")
	if spellname then
	  -- Oldhand_AddMessage("UnitCastingInfo: "..spellname);
		Oldhand_SetText("施放"..spellname, 0);
		return;
	end
	
	spellname = UnitChannelInfo("player");
	if spellname then
	  Oldhand_AddMessage("UnitChannelInfo: "..spellname);
		Oldhand_SetText("引导"..spellname, 0);
		return;
	end

	-- Oldhand_playerSafe();
	TestHelpTarget = "";

	if Oldhand_Use_INV_Jewelry_TrinketPVP_02() then return; end;

	if Oldhand_NoControl_Debuff() then
		Oldhand_SetText("被控制...",0);
		return;
	end;

	--if Oldhand_NoTarget_RunCommand() then return; end;
	--if Oldhand_playerSafe() then return true; end;
	--if Oldhand_dps_playerSafe() then return; end;
	--if Oldhand_HelpTarget() then return; end;

	if not UnitExists("playertarget") and not UnitExists("target") then
		Oldhand_SetText("没有目标", 0);
		return;
	end;
	if UnitIsDead("playertarget") then
		Oldhand_SetText("目标死亡", 0);
		return;
	end;
	if not UnitCanAttack("player", "target")  then
		Oldhand_SetText("友善目标", 0);
		return;
	end;

	if UnitAffectingCombat("player") or IsCurrentAction(Oldhand_Auto_Attack()) then
	  if playerClass == "萨满祭司" then
	    Shaman_DpsOut(Oldhand_DPS);
	  elseif playerClass == "死亡骑士" then
	    DeathKnight_DpsOut(Oldhand_DPS);
	  elseif playerClass == "战士" then
	    Warrior_DpsOut(Oldhand_DPS);
	  elseif playerClass == "术士" then
	    Warlock_DpsOut(Oldhand_DPS);
	  end;
	  --oldhand_dps_module[englishClass](Oldhand_DPS);
	  
		--if Oldhand_DPS == 1 then
		--	Oldhand_DpsOut1();
		--elseif Oldhand_DPS == 2 then
		--	Oldhand_DpsOut2();
		--else
		--	Oldhand_DpsOut3();
		--end
		return;


	end
	--Oldhand_SetText("无动作",0);
end;

function Oldhand_SelectPartyTarget(unitid)
	if UnitIsUnit("target", "party"..unitid) then return false; end;
	Oldhand_SetText("选取"..unitid.."个队友",unitid+29);
	return true;	
end

function Oldhand_ClearTargetTable()
	if (target_count > 0) then
		target_count = 0;
		target_table = {};
		Oldhand_AddMessage("目标数已清零。");
	end;
end

function Oldhand_CountTarget(srcGuid, srcName, destGuid, destName)
	if UnitAffectingCombat("player") and 0~=destName then
		if not Oldhand_Test_IsFriend(destName) then
			if not target_table[destGuid] then
				target_count = target_count+1;
				target_table[destGuid] = destName;
				Oldhand_AddMessage("战斗中目标数："..target_count.." 目标名字："..destName);
			end;
		elseif not Oldhand_Test_IsFriend(srcName) then
			if target_table[srcGuid]==null then
				target_count = target_count+1;
				target_table[srcGuid] = srcName;
				Oldhand_AddMessage("战斗中目标数："..target_count.." 目标名字："..destName);
			end;
		end
	end
end

function Oldhand_TargetCount()
  return target_count;
end;

function Oldhand_RunCommand()
	if UnitAffectingCombat("player") then
		local id1 = Oldhand_GetActionID("Racial_Troll_Berserk");
		if id1~=0 and null==Oldhand_PlayerBU("狂暴") then
			if 0~=IsActionInRange(Oldhand_GetActionID("Ability_Oldhand_Lavalash")) then -- 灵界打击有效
				if (GetActionCooldown(Oldhand_GetActionID("Racial_Troll_Berserk")) == 0) then
					Oldhand_SetText("狂暴",29);
					return true;
				end
			end;
		end
	end
	--local healthperc = GetUnitHealthPercent("player");
	--if null==Oldhand_PlayerBU("闪电之盾") and null==Oldhand_PlayerBU("水之护盾") and null==Oldhand_PlayerBU("大地之盾") then
	--	local powerperc = GetUnitPowerPercent("player");
	--
	--	if powerperc < 50 then
	--		if Oldhand_CastSpell("水之护盾","Ability_Oldhand_WaterShield") then return true; end
	--	else
	--		if Oldhand_CastSpell("闪电之盾","Spell_Nature_LightningShield") then return true; end
	--	end
	--end

	return false;
end;
function Oldhand_Auto_Trinket()
	if not Oldhand_PlayerBU("水手的迅捷") then
		if Oldhand_TestTrinket("大副的怀表") and (IsActionInRange(Oldhand_GetActionID("Ability_Oldhand_Lavalash")) ~= 0)  then
			if Oldhand_CastSpell("大副的怀表","INV_Misc_PocketWatch_02") then return true; end
		end
	end
	if not Oldhand_PlayerBU("激烈怒火") then
		if Oldhand_TestTrinket("临近风暴之怒") and (IsActionInRange(Oldhand_GetActionID("Ability_Oldhand_Lavalash")) ~= 0)  then
			if Oldhand_CastSpell_IgnoreRange("临近风暴之怒", shaman_action_table["临近风暴之怒"]) then return true; end
		end
	end
	if not Oldhand_PlayerBU("银色英勇") then
		if Oldhand_TestTrinket("菲斯克的怀表") and (IsActionInRange(Oldhand_GetActionID("Ability_Oldhand_Lavalash")) ~= 0)  then
			if Oldhand_CastSpell("菲斯克的怀表","INV_Misc_AhnQirajTrinket_03") then return true; end
		end
	end
	if not Oldhand_PlayerBU("野性狂怒") then
		if Oldhand_TestTrinket("战歌的热情") and (IsActionInRange(Oldhand_GetActionID("Ability_Oldhand_Lavalash")) ~= 0)  then
			if Oldhand_CastSpell("战歌的热情","INV_Misc_Horn_02") then return true; end
		end
	end
	if not Oldhand_PlayerBU("奥术灌注") then
		if Oldhand_TestTrinket("伊萨诺斯甲虫") and (IsActionInRange(Oldhand_GetActionID("Ability_Oldhand_Lavalash")) ~= 0)  then
			if Oldhand_CastSpell_IgnoreRange("伊萨诺斯甲虫", shaman_action_table["伊萨诺斯甲虫"]) then return true; end
		end
	end

	if not Oldhand_PlayerBU("精准打击") then
		if Oldhand_TestTrinket("苔原护符") and (IsActionInRange(Oldhand_GetActionID("Ability_Oldhand_Lavalash")) ~= 0)  then
			if Oldhand_CastSpell("苔原护符","INV_Jewelcrafting_StarOfElune_03") then return true; end;
		end
	end
	if not Oldhand_PlayerBU("凶暴") then
		if Oldhand_TestTrinket("刃拳的宽容") and (IsActionInRange(Oldhand_GetActionID("Ability_Oldhand_Lavalash")) ~= 0)  then
			if Oldhand_CastSpell("刃拳的宽容","INV_DataCrystal06") then return true; end
		end
	end
	if not Oldhand_PlayerBU("燃烧之恨") then
		if Oldhand_TestTrinket("食人魔殴斗者的徽章") and (IsActionInRange(Oldhand_GetActionID("Ability_Oldhand_Lavalash")) ~= 0)  then
			if Oldhand_CastSpell("食人魔殴斗者的徽章","INV_Jewelry_Talisman_04") then return true; end
		end
	end

	--if Oldhand_GetActionID("INV_Misc_MonsterScales_15") ~= 0 then
	--	if Oldhand_TestTrinket("嗜血胸针") and (IsActionInRange(Oldhand_GetActionID("Ability_Oldhand_Lavalash")) == 1)  then
	--		if Oldhand_CastSpell("嗜血胸针","INV_Misc_MonsterScales_15") then return true; end
	--	end
	--end;
	--if  Oldhand_GetActionID("INV_ValentinePerfumeBottle") ~= 0 then
	--	if Oldhand_TestTrinket("殉难者精华") and (IsActionInRange(Oldhand_GetActionID("Spell_Holy_HolyBolt")) == 1)  then
	--		if Oldhand_CastSpell("殉难者精华","INV_ValentinePerfumeBottle") then return true; end
	--	end
	--end
	return false;
end
function Oldhand_dps_playerSafe()
	--if not Oldhand_PlayerDeBU("断筋") or not Oldhand_PlayerDeBU("减速药膏") or not Oldhand_PlayerDeBU("寒冰箭") or not Oldhand_PlayerDeBU("冰冻") or not Oldhand_PlayerDeBU("冰霜陷阱光环")
	--	or not Oldhand_PlayerDeBU("强化断筋") or not Oldhand_PlayerDeBU("减速术") or not Oldhand_PlayerDeBU("摔绊") or not Oldhand_PlayerDeBU("震荡射击")
	--   	or not Oldhand_PlayerDeBU("地缚术") or not Oldhand_PlayerDeBU("冰霜震击") or not Oldhand_PlayerDeBU("疲劳诅咒")
	--   	or not Oldhand_PlayerDeBU("冰霜新星") or not Oldhand_PlayerDeBU("纠缠根须") or not Oldhand_PlayerDeBU("霜寒刺骨")  then

	--end;
	--if not Oldhand_PlayerDeBU("偷袭") or not Oldhand_PlayerDeBU("肾击") or not Oldhand_PlayerDeBU("制裁之锤") then
	--end;
	return false;
end;

function Oldhand_PunishingBlow_Debuff()
	if not Oldhand_TargetDeBU("月火术")
	or not Oldhand_TargetDeBU("腐蚀术")
	or not Oldhand_TargetDeBU("献祭")
	or not Oldhand_TargetDeBU("暗言术：痛")
	or not Oldhand_TargetDeBU("噬灵瘟疫")
	or not Oldhand_TargetDeBU("毒蛇钉刺")
	then
		return true;
	end
	return false;
end

function Oldhand_CheckDebuffByPlayer(debuffName)
	local i = 1;
	local name, _, _, count, _, _, expirationTime, unitCaster = UnitDebuff("target", i);
	while name do
		--Oldhand_AddMessage(string.format("name: %s, debuffName: %s, unitCaster: %s", name, debuffName, unitCaster));
		if (name==debuffName) and (unitCaster=="player" or unitCaster==UnitName("player")) then
			local temp = expirationTime - GetTime();
			--Oldhand_AddMessage(debuffName.."剩余时间："..temp.." 秒");
			return true, temp, count;
		end;
		i = i+1;
		name, _, _, count, _, _, expirationTime, unitCaster = UnitDebuff("target", i);
	end
	return false, 0, 0;
end

function Oldhand_BreakCast(LossHealth)
	if UnitExists("playertarget") then
		if not UnitCanAttack("player","target") then
			if UnitIsDeadOrGhost("target") then
				--if Oldhand_CastSpell("打断施法","Ability_GolemThunderClap") then return true; end;
				Oldhand_SetText("打断施法",27);
				return true;
			end
			if (IsActionInRange(Oldhand_GetActionID("Spell_Holy_HolyBolt")) ~= 1) then
				--if Oldhand_CastSpell("打断施法","Ability_GolemThunderClap") then return true; end;
				Oldhand_SetText("打断施法",27);
				return true;
			end
			if Oldhand_GetPlayerLossHealth("target") < LossHealth then
				--if Oldhand_CastSpell("打断施法","Ability_GolemThunderClap") then return true; end;
				Oldhand_SetText("打断施法",27);
				return true;
			end
		else
			if Oldhand_GetPlayerLossHealth("player") < LossHealth then
				--if Oldhand_CastSpell("打断施法","Ability_GolemThunderClap") then return true; end;
				Oldhand_SetText("打断施法",27);
				return true;
			end
		end
	else
		if Oldhand_GetPlayerLossHealth("player") < LossHealth then
				--if Oldhand_CastSpell("打断施法","Ability_GolemThunderClap") then return true; end;
				Oldhand_SetText("打断施法",27);
				return true;
		end
	end
	return false;
end


function Oldhand_SelectPartyTarget(unitid)
	if UnitIsUnit("target", "party"..unitid) then return false; end;
	Oldhand_SetText("选取"..unitid.."个队友",unitid+29);
	return true;
end

function Oldhand_GetPlayerManaPercent(unit)
	if UnitIsDeadOrGhost("player") then return 100; end
	local mana, manamax = UnitMana("player"), UnitManaMax("player");
	local ManaPercent = floor(mana*100/manamax+0.5);
	return ManaPercent;
end

function Oldhand_GetPlayerLossHealth(unit)
	local health, healthmax  = UnitHealth(unit), UnitHealthMax(unit);
	return healthmax - health;
end

function Oldhand_GetPlayerHealthPercent(unit)
	local health, healthmax  = UnitHealth(unit), UnitHealthMax(unit);
	local healthPercent = floor(health*100/healthmax+0.5);
	return healthPercent, healthmax;
end

function Oldhand_Do_Reincarnation_CanUseAction(i)
	local _, duration, _ = GetActionCooldown(i);
	local isUsable, notEnoughMana = IsUsableAction(i);
	if ( not notEnoughMana ) and ( duration == 0) then
		if IsAttackAction(i) then
			if IsActionInRange(i) == 1 then
				return true;
			end
		else
			return true;
		end
	end
	return false;
end

function Oldhand_NoControl_Debuff()
	if not Oldhand_PlayerDeBU("心灵尖啸")
	   or not Oldhand_PlayerDeBU("精神控制")
	   or not Oldhand_PlayerDeBU("恐惧")
	   or not Oldhand_PlayerDeBU("恐惧嚎叫")
	   or not Oldhand_PlayerDeBU("女妖媚惑")
	   or not Oldhand_PlayerDeBU("破胆怒吼")
	   or not Oldhand_PlayerDeBU("休眠")
	   or not Oldhand_PlayerDeBU("逃跑")
	   or not Oldhand_PlayerDeBU("凿击")
	   or not Oldhand_PlayerDeBU("媚惑")
	   or not Oldhand_PlayerDeBU("变形术")
	   or not Oldhand_PlayerDeBU("休眠")
	   or not Oldhand_PlayerDeBU("致盲")
	   or not Oldhand_PlayerDeBU("闷棍")
	   or not Oldhand_PlayerDeBU("冰冻陷阱")
	   or not Oldhand_PlayerDeBU("肾击")
	   or not Oldhand_PlayerDeBU("忏悔")
	   or not Oldhand_PlayerDeBU("霜寒刺骨")
	   or not Oldhand_PlayerDeBU("制裁之锤")
	   or not Oldhand_PlayerDeBU("强化断筋")
	   or not Oldhand_PlayerDeBU("冲击")
	   or not Oldhand_PlayerDeBU("冰霜新星")
	   or not Oldhand_PlayerDeBU("纠缠根须")
	   or not Oldhand_PlayerDeBU("偷袭")
	then
		return true;
	end
	return false;
end


function Oldhand_IsSpellInRange(spellname, unit)
	if UnitExists(unit) then
		if UnitIsVisible(unit) then
			if IsSpellInRange(spellname,unit) == 1 then
				return true;
			end
		end
	end
	return false;
end

function Oldhand_UnitAffectingCombat()
	if UnitAffectingCombat("player") == 1 then
		return true;
	end
	if (UnitInRaid("player")) then
		for id=1, GetNumRaidMembers()  do
			local unit = "raid"..id ;
			if UnitExists(unit) then
				if UnitAffectingCombat(unit) == 1 and  UnitIsVisible(unit) then
					return true;
				end
			end
		end
	else
		for id=1, GetNumGroupMembers()  do
			local unit = "party"..id ;
			if UnitExists(unit) then
				if UnitAffectingCombat(unit) == 1 and  UnitIsVisible(unit) then
					return true;
				end
			end
		end
	end;
	return false;
end;

function Oldhand_CombatLogEvent(event,...)
	if not (playerClass=="萨满祭司") then return; end;
	local timestamp, eventType, sourceGUID, sourceName, sourceFlags, destGUID, destName, destFlags = ...
	local amount, school, resisted, blocked, absorbed, critical, glancing, crushing, missType, enviromentalType,interruptedSpellId, interruptedSpellName, interruptedSpellSchool;

	if eventType == "SPELL_CAST_SUCCESS" then
		spellId, spellName, spellSchool = select(9, ...);
		if CombatLog_Object_IsA(sourceFlags, COMBATLOG_FILTER_HOSTILE_PLAYERS) then
				if spellName == "消失" and sourceName then
					Oldhand_Warning_AddMessage("**敌对玩家>>"..sourceName.."<<使用了消失,反隐反隐!**");
					table.insert(Oldhand_Data[UnitName("player")]["Rogue"],{["Command"] = "奉献"});
					StartTimer("Ability_Oldhand_WarCry");
					return;
				end;
				if spellName == "隐形术" and sourceName then
					Oldhand_Warning_AddMessage("**敌对玩家>>"..sourceName.."<<使用了隐形术,反隐反隐!**");
					table.insert(Oldhand_Data[UnitName("player")]["Rogue"],{["Command"] = "奉献"});
					StartTimer("Ability_Oldhand_WarCry");
					return;
				end;
				if spellName == "闪避" and sourceName then
					Oldhand_Warning_AddMessage("**警告:敌对玩家>>"..sourceName.."<<获得闪避效果,效果持续8秒!**");
					return;
				end;
				if spellName == "圣盾术" and sourceName then
					Oldhand_Warning_AddMessage("**警告:敌对玩家>>"..sourceName.."<<获得".. spellName .."效果!!**");
					return;
				end;
				if spellName == "保护之手" and sourceName then
					if destName then
						Oldhand_Warning_AddMessage("**警告:敌对玩家>>"..sourceName.."<<给>>"..destName.."<<施放了保护之手!!**");
					else
						Oldhand_Warning_AddMessage("**警告:敌对玩家>>"..sourceName.."<<施放了保护之手!!**");
					end;
					return;
				end;
		end
		if CombatLog_Object_IsA(sourceFlags, COMBATLOG_FILTER_FRIENDLY_UNITS) and spellName then
			if (spellName == "嘲讽" or spellName == "正义防御" ) and sourceName and destName then
				--Oldhand_Warning_AddMessage("**>>"..sourceName.."<<对"..destName.."成功施放了"..spellName.."!**");
			end;
		end;

		return;
	end;

	if eventType == "SPELL_MISSED" then
		spellId, spellName, spellSchool, missType = select(9, ...);
		if CombatLog_Object_IsA(sourceFlags, COMBATLOG_FILTER_MINE) and spellName then
			if missType == "RESIST" then
				Oldhand_AddMessage("**>>"..destName.."<<抵抗了"..sourceName.."的"..spellName.."!**");
			elseif missType == "IMMUNE" then
				Oldhand_AddMessage("**>>"..destName.."<<免疫了"..sourceName.."的"..spellName.."!**");
				if spellName == "冰冷触摸" then mianyi1 = 1;end;
				if spellName == "心灵冰冻" then mianyi2 = 1;end;
				if sourceName == UnitName("player") then
				      local g_FindNpcName = false;
				      for k, v in pairs(Oldhand_SaveData) do
					      if v["npcname"] == destName and  v["spellname"] == spellName then
						 g_FindNpcName = true;
					      end
				      end
				      if not g_FindNpcName then
					      table.insert(Oldhand_SaveData,{["npcname"] = destName,["spellname"] = spellName,});
				      end;
				end;
				return;
			end
			return;
		end;
		if CombatLog_Object_IsA(sourceFlags, COMBATLOG_FILTER_FRIENDLY_UNITS) and spellName then
			if (spellName == "嘲讽" or spellName == "正义防御" ) and sourceName and destName then
				if missType == "RESIST" then
					Oldhand_Warning_AddMessage("**>>"..destName.."<<抵抗了"..sourceName.."的"..spellName.."!**");
				elseif missType == "IMMUNE" then
					Oldhand_Warning_AddMessage("**>>"..destName.."<<免疫了"..sourceName.."的"..spellName.."!**");
					return;
				end
				return;
			end;
			if spellName == "震荡猛击"  and sourceName and destName then
				if missType == "RESIST" then
					Oldhand_Warning_AddMessage("**>>"..destName.."<<抵抗了"..sourceName.."的"..spellName.."!**");
				elseif missType == "IMMUNE" then
					Oldhand_Warning_AddMessage("**>>"..destName.."<<免疫了"..sourceName.."的"..spellName.."!**");
					return;
				end
				return;
			end;
		end;
		return;
	end;
	if CombatLog_Object_IsA(sourceFlags, COMBATLOG_FILTER_MINE) then
		if (eventType == "SPELL_DAMAGE") then
			spellId, spellName, spellSchool, amount, school, resisted, blocked, absorbed, critical, glancing, crushing = select(9, ...)
			if spellName and amount > 500 then
				if critical then
					Oldhand_AddMessage("你的|cffffff00"..spellName.."|r|cff00ff00对|r|cffffff00"..destName.."|r|cff00ff00造成|r|cffffff00"..amount.."|r|cff00ff00伤害(|r|cffffff00爆击|r|cff00ff00)...|r");
				else
					Oldhand_AddMessage("你的|cffffff00"..spellName.."|r|cff00ff00对|r|cffffff00"..destName.."|r|cff00ff00造成|r|cffffff00"..amount.."|r|cff00ff00伤害...|r");
				end
			end
		end
	end
	if eventType == "SPELL_HEAL" then
		spellId, spellName, spellSchool, amount, critical = select(9, ...);
		if CombatLog_Object_IsA(sourceFlags, COMBATLOG_FILTER_MINE) and amount > 300 and destName and sourceName then
			if critical then
				Oldhand_AddMessage("|cff00ff00你的|cffffff00"..spellName.."|r|cff00ff00给|r|cffffff00"..destName.."|r|cff00ff00恢复|r|cffffff00"..amount.."|r|cff00ff00点生命(|r|cffffff00爆击|r|cff00ff00)...|r");
			else
				Oldhand_AddMessage("|cff00ff00你的|cffffff00"..spellName.."|r|cff00ff00给|r|cffffff00"..destName.."|r|cff00ff00恢复|r|cffffff00"..amount.."|r|cff00ff00点生命...|r");
			end
			return;
		end;
		if CombatLog_Object_IsA(destFlags, COMBATLOG_FILTER_MINE) and amount > 300 and destName and sourceName then
			if critical then
				Oldhand_AddMessage("|cffffff00"..sourceName.."|r|cff00ff00的|cffffff00"..spellName.."|r|cff00ff00给我|cff00ff00恢复|r|cffffff00"..amount.."|r|cff00ff00点生命(|r|cffffff00爆击|r|cff00ff00)...|r");
			else
				Oldhand_AddMessage("|cffffff00"..sourceName.."|r|cff00ff00的|cffffff00"..spellName.."|r|cff00ff00给我|r|cff00ff00恢复|r|cffffff00"..amount.."|r|cff00ff00点生命...|r");
			end
		end;

		return;
	end;
	if event == "COMBAT_LOG_EVENT_UNFILTERED" then
		if eventType == "SPELL_DAMAGE" then
			Oldhand_CountTarget(sourceGUID, sourceName, destGUID, destName);
		elseif eventType == "UNIT_DIED" or eventType=="UNIT_DESTROYED" then
			Oldhand_DecreaseTarget(sourceGUID, sourceName, destGUID, destName);
		end
	end
end

function Oldhand_DecreaseTarget(sourceGUID, sourceName, destGUID, destName)
	if target_count > 0 then
		if not Oldhand_Test_IsFriend(srcName) then
			if target_table[srcGuid]~=null then
				target_count = target_count-1;
				target_table[srcGuid] = null;
				Oldhand_AddMessage("战斗中目标数："..target_count.." "..destName.." 已被杀死或摧毁");
			end;
		end
	end
end

function Oldhand_Test()
	for i = 1, 120 do
		if ( HasAction(i) ) then
			local texture = GetActionTexture(i);
			local text = GetActionText(i);
			DEFAULT_CHAT_FRAME:AddMessage(i.." |cffffff00" .. texture .. "|r");
		end;
	end;

end;

function Oldhand_Use_INV_Jewelry_TrinketPVP_02()
	if UnitIsPlayer("playertarget") then
		if Oldhand_NoControl_Debuff() then
			if Oldhand_TestTrinket("部落徽记") or Oldhand_TestTrinket("部落勋章")  then
				if Oldhand_CastSpell("部落徽记", "INV_Jewelry_TrinketPVP_02") then
					--StartTimer("INV_Jewelry_TrinketPVP")
					return true;
				end
			end
			if Oldhand_TestTrinket("联盟徽记") or Oldhand_TestTrinket("联盟勋章")  then
				if Oldhand_CastSpell("联盟徽记", "INV_Jewelry_TrinketPVP_01") then
					--StartTimer("INV_Jewelry_TrinketPVP")
					return true; 
				end
			end
		end
	end
end

--INV_ValentinePerfumeBottle
--Spell_Arcane_ManaTap
--Spell_Shadow_Teleport

Warrior_SaveData = nil;
Warrior_Data = nil;

Warrior_PlayerTalentInfoDatas = {};

local dynamicMicroID = 72;
local playerClass;
local Warrior_DPS = 2; -- 默认狂怒，1武器，2狂怒，3防护
local Warrior_Reincarnation  = false;
local Warrior_Free  = false;
local Warrior_RaidFlag = 0;
local Warrior_Old_UnitPopup_OnClick;
local Warrior_AutoFollowName="";
local TestHelpTarget = "";
local target_count = 0;		-- 目标个数
local target_table = {};	

local warrior_action_table = {};

warrior_action_table["自动攻击"] = 132400;

warrior_action_table["冲锋"] = 132337;
warrior_action_table["嘲讽"] = 136080;

-- 狂怒
warrior_action_table["嗜血"] = 136012;
warrior_action_table["狂暴挥砍"] = 132367;
warrior_action_table["怒击"] = 132352;
warrior_action_table["斩杀"] = 135358;
warrior_action_table["暴怒"] = 132352;
warrior_action_table["狂怒回复"] = 132345;
warrior_action_table["拳击"] = 132938;

-- 防护
warrior_action_table["毁灭打击"] = 135291;
warrior_action_table["盾牌猛击"] = 134951;
warrior_action_table["雷霆一击"] = 136105;
warrior_action_table["乘胜追击"] = 132342;
warrior_action_table["盾牌格挡"] = 132110;
-- 饰品
warrior_action_table["临近风暴之怒"] = 236164;
warrior_action_table["伊萨诺斯甲虫"] = 236164;
local spell_table = {};
-- 51 Racial_Troll_Berserk			战争践踏
-- 100 spell_Warrior_unleashweapon_wind 风怒武器
--  Spell_Fire_FlameTounge		火舌武器

local  Warrior_IGNORELIST = {
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
	
local Warrior_SKIP_LIST = {
		["无梦睡眠"] = true,
		["强效昏睡"] = true,
		["心灵视界"] = true,
	};
local 	Warrior_CLASS_DRUID   = '德鲁伊';
local 	Warrior_CLASS_HUNTER  = '猎人';
local 	Warrior_CLASS_MAGE    = '法师';
local 	Warrior_CLASS_PALADIN = '圣骑士';
local 	Warrior_CLASS_PRIEST  = '牧师';
local 	Warrior_CLASS_ROGUE   = '盗贼';
local 	Warrior_CLASS_Warrior  = '战士';
local 	Warrior_CLASS_WARLOCK = '术士';
local 	Warrior_CLASS_Warrior_ = '战士';

local Warrior_SKIP_BY_CLASS_LIST = {
		[Warrior_CLASS_Warrior_] = {		
			["上古狂乱"]   = true,
			["点燃法力"]   = true,
			["污浊之魂"]   = true,
		};
		[Warrior_CLASS_ROGUE] = {			
			["沉默"]       = true;
			["上古狂乱"]   = true,
			["点燃法力"]   = true,
			["污浊之魂"]   = true,
			["煽动烈焰"]   = true,	
			["熔岩镣铐"]   = true,
		};
		[Warrior_CLASS_HUNTER] = {			
			["煽动烈焰"]   = true,	
		};
		[Warrior_CLASS_MAGE] = {			
			["煽动烈焰"]   = true,	
		};
		[Warrior_CLASS_DRUID]= {
			["煽动烈焰"]   = true,	
		};
		[Warrior_CLASS_PALADIN]= {
			["煽动烈焰"]   = true,	
		};
		[Warrior_CLASS_PRIEST]= {
			["煽动烈焰"]   = true,	
		};
		[Warrior_CLASS_Warrior]= {
			["煽动烈焰"]   = true,	
		};
		[Warrior_CLASS_WARLOCK]= {
			["煽动烈焰"]   = true,	
		};
	};

function Warrior_AutoSelectMode()
	if UnitAffectingCombat("player")~=1 then
	  local currentSpec = GetSpecialization();
	  Warrior_DPS = currentSpec;
	end
end

function Warrior_TestPlayerDebuff(unit)
  --local healthPercent, maxHealth = Warrior_GetPlayerHealthPercent(unit);
	--if healthPercent < 40 then return 0; end;
	local i = 1;
	while UnitDebuff(unit, i ) do
		WarriorTooltip:SetOwner(Warrior_MSG_Frame, "ANCHOR_BOTTOMRIGHT", 0, 0);
		WarriorTooltip:SetUnitDebuff(unit, i);		
		local	debuff_name = WarriorTooltipTextLeft1:GetText();
		local   debuff_type = WarriorTooltipTextRight1:GetText();				
		WarriorTooltip:Hide();
		if (debuff_name) and (debuff_type) then
			if (Warrior_IGNORELIST[debuff_name]) then
				break;
			end
			if (UnitAffectingCombat("player")) then
				if (Warrior_SKIP_LIST[debuff_name]) then
					break;
				end
				if (Warrior_SKIP_BY_CLASS_LIST[UClass]) then
					if (Warrior_SKIP_BY_CLASS_LIST[UClass][debuff_name]) then
						break;
					end
				end
			end						
			if (debuff_type) then
				if (debuff_type == Warrior_MAGIC) then							
					return 1;
				elseif (debuff_type == Warrior_DISEASE) then							
					return 2;
				elseif (debuff_type == Warrior_POISON) then							
					return 3;
				elseif (debuff_type == Warrior_CURSE) then							
					return 4;					
				end
			end	
		end;
		i = i + 1;
	end	
	return 0;
end

function Warrior_RegisterEvents(self)
	local englishClass;
	playerClass, englishClass = UnitClass("player");
	if not (playerClass=="战士") then
			HideUIPanel(Warrior_MSG_Frame);
			HideUIPanel(WarriorColorRectangle);
			return;
	end;
	self:RegisterEvent("PLAYER_ENTERING_WORLD");		
	self:RegisterEvent("UI_ERROR_MESSAGE");
	self:RegisterEvent("PLAYER_TARGET_CHANGED");
	self:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED");
	--self:RegisterEvent("INSPECT_TALENT_READY");
	
	UnitPopupButtons["WarriorPOPUP"] = { text = "智能施法跟随对象", dist = 0 };	
		
	if (UnitPopupMenus["SELF"]) then
		--table.insert( UnitPopupMenus["SELF"], "WarriorPOPUP");		
	end	
	if (UnitPopupMenus["PLAYER"]) then
		--table.insert( UnitPopupMenus["PLAYER"], "WarriorPOPUP");		
	end
	if (UnitPopupMenus["PARTY"]) then
		--table.insert( UnitPopupMenus["PARTY"], "WarriorPOPUP");		
	end
	
	--Warrior_Old_UnitPopup_OnClick = UnitPopup_OnClick;
	--UnitPopup_OnClick = Warrior_UnitPopup_OnClick;
end;

function Warrior_OnEvent(event)	
	if not (playerClass=="战士") then return; end;
	if (event=="PLAYER_ENTERING_WORLD") then
		Warrior_Data = {};
		Warrior_Data[UnitName("player")] = 
					{			
					Rogue={},
					};
		if( Warrior_SaveData == nil ) then
		    Warrior_SaveData = {};
		end
		DEFAULT_CHAT_FRAME:AddMessage("智能施法插件 2.0 (战士版)   www.oldhand.net 版权所有");			
		getglobal("WarriorColorRectangle".."NormalTexture"):SetVertexColor(0, 0, 0);
		Warrior_AutoSelectMode();	
		Warrior_CreateMacro();
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
					 Warrior_AddMessage_A("**你的目标是"..GetTalentTabInfo(s,true).."天赋的"..UnitClass("target").."**");
				   end
				   if UnitIsUnit("player","target") and UnitAffectingCombat("player") ~= 1 then
					    Warrior_CreateMacro();
				   end;
				   
			end
		end
		return;
	end;

	
	if (event=="PLAYER_TARGET_CHANGED") then
		if not UnitExists("playertarget") then	
			return; 
		end;
		if UnitAffectingCombat("player") ~= 1 and UnitIsUnit("target", "player") then
			Warrior_AutoSelectMode();	
			Warrior_CreateMacro();
		end;
		if UnitIsPlayer("target") and not UnitIsUnit("player","target") then	
			NotifyInspect("playertarget");
		end;	
	end;	

end;

function Warrior_CreateMacro()	
--	if GetMacroIndexByName("打断施法") == 0 then
--		CreateMacro("打断施法", 67, "/stopcasting", 1, 1);
--	end;	
--	PickupMacro("打断施法");
--	--PlaceAction(61);
--	ClearCursor();

	if GetMacroIndexByName("开始攻击") == 0 then
		CreateMacro("开始攻击", 60, "/startattack", 1, 1);
	end;
	--PickupMacro("开始攻击");
	--PlaceAction(1);
	--ClearCursor();

	if GetMacroIndexByName("战争践踏") == 0 then
		CreateMacro("战争践踏", 66, "/cast 战争践踏", 1, 0);
	end;

	if GetMacroIndexByName("更换模式") == 0 then
		CreateMacro("更换模式", 61, "/script Warrior_Input(1);", 1, 1);
	end;	
	PickupMacro("更换模式");
	PlaceAction(49);
	ClearCursor();	
	if Warrior_DPS == 2 then
		if GetMacroIndexByName("武器模式") == 0 then
			CreateMacro("武器模式", 62, "/script Warrior_Input(1);", 0, 0);
		end;
		PickupMacro("武器模式");
	elseif Warrior_DPS == 1 then
		if GetMacroIndexByName("狂怒模式") == 0 then
			CreateMacro("狂怒模式", 62, "/script Warrior_Input(1);", 0, 0);
		end;
		PickupMacro("狂怒模式");
	elseif Warrior_DPS == 3 then
		if GetMacroIndexByName("防护模式") == 0 then
			CreateMacro("防护模式", 62, "/script Warrior_Input(1);", 0, 0);
		end;
		PickupMacro("防护模式");
	end
	PlaceAction(50);
	ClearCursor();

  Warrior_PutAction("自动攻击", 1);
  Warrior_PutAction("冲锋", 61);
 
  if Warrior_DPS == 1 then
  elseif Warrior_DPS == 2 then
    Warrior_PutAction("嗜血", 2);
    Warrior_PutAction("狂暴挥砍", 3);
    Warrior_PutAction("暴怒", 4);
    Warrior_PutAction("狂怒回复", 7);    
    Warrior_PutAction("斩杀", 62);
    Warrior_PutAction("怒击", 63);
    
  elseif Warrior_DPS == 3 then
    Warrior_PutAction("毁灭打击", 2);
    Warrior_PutAction("盾牌猛击", 3);
    Warrior_PutAction("雷霆一击", 4);
    Warrior_PutAction("盾牌格挡", 7);    
    Warrior_PutAction("嘲讽", 62);
    Warrior_PutAction("乘胜追击", 63);  
  end;

	if Warrior_TestTrinket("部落勋章") then
		Warrior_PutAction("部落勋章", 71);
	elseif Warrior_TestTrinket("大副的怀表") then
		Warrior_PutAction("大副的怀表", 72);
	elseif Warrior_TestTrinket("菲斯克的怀表") then
		Warrior_PutAction("菲斯克的怀表", 72);
	elseif Warrior_TestTrinket("恐惧小盒") then
		Warrior_PutAction("恐惧小盒", 71);
	elseif Warrior_TestTrinket("恐惧小盒") then
		Warrior_PutAction("战歌的热情", 71);
	elseif Warrior_TestTrinket("苔原护符") then
		Warrior_PutAction("苔原护符", 71);
	elseif Warrior_TestTrinket("食人魔殴斗者的徽章") then
		Warrior_PutAction("食人魔殴斗者的徽章", 71);
	end
	if Warrior_TestTrinket("胜利旌旗") then
		Warrior_PutAction("胜利旌旗", 72);
	elseif Warrior_TestTrinket("临近风暴之怒") then
		Warrior_PutAction("临近风暴之怒", 71);
	elseif Warrior_TestTrinket("英雄勋章") then
		Warrior_PutAction("英雄勋章", 72);
	elseif Warrior_TestTrinket("伊萨诺斯甲虫") then
		Warrior_PutAction("伊萨诺斯甲虫", 72);
	elseif Warrior_TestTrinket("刃拳的宽容") then
		Warrior_PutAction("刃拳的宽容", 72);
	end
	
	Warrior_PutAction("战争践踏", 51);

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
	
	SetBindingMacro(",","战争践踏");	-- 29
	--SetBindingMacro("\'","活力分流");	-- 28
	SetBindingMacro(";","打断施法");	-- 27
	--SetBindingMacro("\\","开始攻击");	-- 26
	
	SaveBindings(1);
end;

function Warrior_PutAction(text, index)
	if not text then return false;end;
	Warrior_AddMessage(text..index);
	if Warrior_PickupSpellByBook(text) then
		PlaceAction(index);
		ClearCursor();
		spell_table[text] = index;
		return true;
	end;
	spell_table[text] = 0;
	return false;
end;

function Warrior_NoTarget_RunCommand()
	return Warrior_RunCommand();
end;

function Warrior_Test_IsFriend(unitname)
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

function Warrior_Damage_Message(arg1, event)
	if (not arg1) then
		return;
	end;

	if event == "CHAT_MSG_SPELL_HOSTILEPLAYER_BUFF" then	
		for creatureName,creatureName1 in string.gmatch(arg1, "(.+)对(.+)使用消失。") do	
			if not Warrior_Test_IsFriend(creatureName)  then
				Warrior_AddMessage("|cff00adef"..creatureName.."|r|cff00ff00使用了消失!自动使用奉献!|r");
				table.insert(Warrior_Data[UnitName("player")]["Rogue"],{["Command"] = "奉献"});				
				StartTimer("Ability_Warrior_WarCry");
			end	
			return;
		end;
	end;
	
	local playerUnitName = UnitName("Player");	
	
	if ( event == "CHAT_MSG_SPELL_SELF_DAMAGE" ) then			
			Warrior_AddMessage(arg1);
			for spellname, creatureName, spell in string.gmatch(arg1, playerUnitName.."的(.+)打断了(.+)的(.+)。") do							       
				Warrior_AddMessage("**你的"..spellname.."打断了"..creatureName.."的"..spell.."...**");
				return;
			end;				
			for spell, creatureName, damage in string.gmatch(arg1, "你的(.+)击中(.+)造成(%d+)点伤害。") do
				if spell and damage > 500 then
					Warrior_AddMessage("你的|cffffff00"..spell.."|r|cff00ff00造成|r|cffffff00"..damage.."|r|cff00ff00伤害...|r");				       
					return;
				end;
			end;			
			for spell, creatureName, damage in string.gmatch(arg1, "你的(.+)爆击对(.+)造成(%d+)点伤害。") do
				if spell and damage > 500 then
					Warrior_AddMessage("你的|cffffff00"..spell.."|r|cff00ff00造成|r|cffffff00"..damage.."|r|cff00ff00伤害(爆击)|r");
					return;
				end;
			end;
			for spell, creatureName, damage, damageType in string.gmatch(arg1, "你的(.+)击中(.+)造成(%d+)点(.+)伤害。") do
				if spell and damage > 500 then
					Warrior_AddMessage("你的|cffffff00"..spell.."|r|cff00ff00造成|r|cffffff00"..damage.."|r|cff00ff00伤害...");
					return;
				end;
			end;
			for spell, creatureName, damage, damageType in string.gmatch(arg1, "你的(.+)爆击对(.+)造成(%d+)点(.+)伤害。") do
				if spell and damage > 500 then
					Warrior_AddMessage("你的|cffffff00"..spell.."|r|cff00ff00造成|r|cffffff00"..damage.."|r|cff00ff00伤害(爆击)|r");
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
			Warrior_AddMessage(arg1);		
			for playerName, spell, creatureName, damage in string.gmatch(arg1, "(.+)的(.+)发挥极效，为(.+)恢复了(%d+)点生命值。") do
				if creatureName == "你" then 
					Warrior_AddMessage("|cff00adef"..playerName.."|r|cff00ff00的|r|cffffff00"..spell.."|r|cff00ff00x给我恢复了|r|cffffff00"..damage.."|r|cff00ff00生命值...|r");				       
				end;
				return;
			end;
			for playerName, spell, creatureName, damage in string.gmatch(arg1, "(.+)的(.+)为(.+)恢复了(%d+)点生命值。") do
				if creatureName == "你" then 
					Warrior_AddMessage("|cff00adef"..playerName.."|r|cff00ff00的|r|cffffff00"..spell.."|r|cff00ff00给我恢复了|r|cffffff00"..damage.."|r|cff00ff00生命值...|r");				       
				end;
				return;
			end;
		end;	
end;

function Warrior_Input(i)	
	Warrior_DPS = Warrior_DPS + 1;
	if (Warrior_DPS > 3) then Warrior_DPS = 1; end;
	
	if Warrior_DPS == 1 then
		Warrior_AddMessage("进入武器模式(PVP适用)...");
	elseif Warrior_DPS == 2 then
		Warrior_AddMessage("进入狂怒模式(PVP适用)...");
	else
		Warrior_AddMessage("进入防护模式(PVP适用)...");
	end
end;

function Warrior_Msg_OnUpdate()
	if playerClass~="战士" then return; end;
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

function Warrior_Frame_OnUpdate()
	if playerClass~="战士" then return; end;

	--if(ChatFrameEditBox:IsVisible()) then
	local activeWindow = ChatEdit_GetActiveWindow();
	if ( activeWindow ) then
		Warrior_SetText("聊天状态",0);
		return;	
	end;
	if UnitIsDeadOrGhost("player") then 
	  Warrior_SetText("死亡状态",0);
		return; 
	end;
	if not UnitAffectingCombat("player") then
		Warrior_ClearTargetTable();
	end;
	if UnitOnTaxi("player") == 1 then return; end;

	if Warrior_TestPlayerIsHorse() then			
		if IsActionInRange(Warrior_GetActionID("Spell_Holy_SealOfMight")) ~= 1  then
		    Warrior_SetText("骑乘状态",0);
			return;			
		end;	
	end;
	
	if (Warrior_PlayerBU("喝水") or Warrior_PlayerBU("进食")) and UnitAffectingCombat("player")~=1 then 
		Warrior_SetText("正在喝水",0); 
		return; 
	end;
	
	local spellname = UnitCastingInfo("player")
	if spellname then
	  -- Warrior_AddMessage("UnitCastingInfo: "..spellname);
		Warrior_SetText("施放"..spellname,0);
		return;
	end
	
	-- Warrior_playerSafe();
	TestHelpTarget = "";

	if Warrior_Use_INV_Jewelry_TrinketPVP_02() then return; end;	

	if Warrior_NoControl_Debuff() then
		Warrior_SetText("被控制...",0);
		return;
	end;

	--if Warrior_NoTarget_RunCommand() then return; end;
	--if Warrior_playerSafe() then return true; end;
	--if Warrior_dps_playerSafe() then return; end;
	--if Warrior_HelpTarget() then return; end;

	if not UnitExists("playertarget") then
		Warrior_SetText("没有目标", 0);		
		return; 
	end;
	if UnitIsDead("playertarget") then
		Warrior_SetText("目标死亡", 0);
		return; 
	end;
	if not UnitCanAttack("player", "target")  then
		Warrior_SetText("友善目标", 0);		
		return;
	end;
	
	if UnitAffectingCombat("player") or IsCurrentAction(Warrior_Auto_Attack()) then
	  --Warrior_AddMessage("Warrior_DPS = "..Warrior_DPS);
	  
		if Warrior_DPS == 1 then
			Warrior_DpsOut1();
		elseif Warrior_DPS == 2 then
			Warrior_DpsOut2();
		else
			Warrior_DpsOut3();
		end
		return;
	else
		isPlague = 0;
	end
	--Warrior_SetText("无动作",0);	
end;

function Warrior_AutoDrink()	
	return false;
end

function Warrior_ClearTargetTable()
	if (target_count > 0) then
		target_count = 0;
		target_table = {};
		Warrior_AddMessage("目标数已清零。");
	end;
end
function Warrior_CountTarget(srcGuid,srcName,destGuid,destName)
	if UnitAffectingCombat("player") then
		if not Warrior_Test_IsFriend(destName) then
			if target_table[destGuid]==null then 
				target_count = target_count+1;
				target_table[destGuid] = destName; 
				Warrior_AddMessage("战斗中目标数："..target_count.." 目标名字："..destName);
			end;
		elseif not Warrior_Test_IsFriend(srcName) then
			if target_table[srcGuid]==null then 
				target_count = target_count+1;
				target_table[srcGuid] = srcName;
				Warrior_AddMessage("战斗中目标数："..target_count.." 目标名字："..destName);
			end;
		end
	end
end

function Warrior_RunCommand()
	if UnitAffectingCombat("player") then
		local id1 = Warrior_GetActionID("Racial_Troll_Berserk");
		if id1~=0 and null==Warrior_PlayerBU("战争践踏") then
			if 0~=IsActionInRange(Warrior_GetActionID("Ability_Warrior_Lavalash")) then -- 灵界打击有效
				if (GetActionCooldown(Warrior_GetActionID("Racial_Troll_Berserk")) == 0) then 
					Warrior_SetText("战争践踏",29);
					return true;
				end
			end;
		end
	end
	--local healthperc = GetUnitHealthPercent("player");
	if null==Warrior_PlayerBU("闪电之盾") and null==Warrior_PlayerBU("水之护盾") and null==Warrior_PlayerBU("大地之盾") then
		local powerperc = GetUnitPowerPercent("player");
		
		if powerperc < 50 then
			if Warrior_CastSpell("水之护盾","Ability_Warrior_WaterShield") then return true; end
		else
			if Warrior_CastSpell("闪电之盾","Spell_Nature_LightningShield") then return true; end		
		end		
	end
	
	return false;
end;
function Warrior_Auto_Trinket()
  if not Oldhand_PlayerBU("水手的迅捷") then
		if Oldhand_TestTrinket("大副的怀表") and (IsActionInRange(Oldhand_GetActionID("Ability_Warrior_Lavalash")) ~= 0)  then
			if Oldhand_CastSpell("大副的怀表", "INV_Misc_PocketWatch_02") then return true; end		
		end
	end
	if not Oldhand_PlayerBU("激烈怒火") then
		if Oldhand_TestTrinket("临近风暴之怒") and (IsActionInRange(Oldhand_GetActionID("Ability_Warrior_Lavalash")) ~= 0)  then
			if Oldhand_CastSpell_IgnoreRange("临近风暴之怒", warrior_action_table["临近风暴之怒"]) then return true; end	
		end
	end
	if not Oldhand_PlayerBU("银色英勇") then
		if Oldhand_TestTrinket("菲斯克的怀表") and (IsActionInRange(Oldhand_GetActionID("Ability_Warrior_Lavalash")) ~= 0)  then
			if Oldhand_CastSpell("菲斯克的怀表", "INV_Misc_AhnQirajTrinket_03") then return true; end		
		end
	end
	if not Oldhand_PlayerBU("野性狂怒") then
		if Oldhand_TestTrinket("战歌的热情") and (IsActionInRange(Oldhand_GetActionID("Ability_Warrior_Lavalash")) ~= 0)  then
			if Oldhand_CastSpell("战歌的热情", "INV_Misc_Horn_02") then return true; end		
		end
	end
	if not Oldhand_PlayerBU("奥术灌注") then
		if Oldhand_TestTrinket("伊萨诺斯甲虫") and (IsActionInRange(Oldhand_GetActionID("Ability_Warrior_Lavalash")) ~= 0)  then
			if Oldhand_CastSpell_IgnoreRange("伊萨诺斯甲虫", warrior_action_table["伊萨诺斯甲虫"]) then return true; end		
		end
	end
	
	if not Oldhand_PlayerBU("精准打击") then
		if Oldhand_TestTrinket("苔原护符") and (IsActionInRange(Oldhand_GetActionID("Ability_Warrior_Lavalash")) ~= 0)  then
			if Oldhand_CastSpell("苔原护符", "INV_Jewelcrafting_StarOfElune_03") then return true; end;
		end
	end
	if not Oldhand_PlayerBU("凶暴") then
		if Oldhand_TestTrinket("刃拳的宽容") and (IsActionInRange(Oldhand_GetActionID("Ability_Warrior_Lavalash")) ~= 0)  then
			if Oldhand_CastSpell("刃拳的宽容", "INV_DataCrystal06") then return true; end		
		end
	end
	if not Oldhand_PlayerBU("燃烧之恨") then
		if Oldhand_TestTrinket("食人魔殴斗者的徽章") and (IsActionInRange(Oldhand_GetActionID("Ability_Warrior_Lavalash")) ~= 0)  then
			if Oldhand_CastSpell("食人魔殴斗者的徽章", "INV_Jewelry_Talisman_04") then return true; end		
		end
	end
	
	--if Oldhand_GetActionID("INV_Misc_MonsterScales_15") ~= 0 then
	--	if Oldhand_TestTrinket("嗜血胸针") and (IsActionInRange(Oldhand_GetActionID("Ability_Warrior_Lavalash")) == 1)  then
	--		if Oldhand_CastSpell("嗜血胸针", "INV_Misc_MonsterScales_15") then return true; end		
	--	end
	--end;
	--if  Oldhand_GetActionID("INV_ValentinePerfumeBottle") ~= 0 then
	--	if Oldhand_TestTrinket("殉难者精华") and (IsActionInRange(Oldhand_GetActionID("Spell_Holy_HolyBolt")) == 1)  then
	--		if Oldhand_CastSpell("殉难者精华", "INV_ValentinePerfumeBottle") then return true; end		
	--	end
	--end  	
	return false;
end
function Warrior_dps_playerSafe()
	--if not Warrior_PlayerDeBU("断筋") or not Warrior_PlayerDeBU("减速药膏") or not Warrior_PlayerDeBU("寒冰箭") or not Warrior_PlayerDeBU("冰冻") or not Warrior_PlayerDeBU("冰霜陷阱光环")
	--	or not Warrior_PlayerDeBU("强化断筋") or not Warrior_PlayerDeBU("减速术") or not Warrior_PlayerDeBU("摔绊") or not Warrior_PlayerDeBU("震荡射击")
	--   	or not Warrior_PlayerDeBU("地缚术") or not Warrior_PlayerDeBU("冰霜震击") or not Warrior_PlayerDeBU("疲劳诅咒") 
	--   	or not Warrior_PlayerDeBU("冰霜新星") or not Warrior_PlayerDeBU("纠缠根须") or not Warrior_PlayerDeBU("霜寒刺骨")  then
	   	
	--end;
	--if not Warrior_PlayerDeBU("偷袭") or not Warrior_PlayerDeBU("肾击") or not Warrior_PlayerDeBU("制裁之锤") then
	--end;
	return false;
end;

function Warrior_PunishingBlow_Debuff()
	if not Warrior_TargetDeBU("月火术") 
	or not Warrior_TargetDeBU("腐蚀术")
	or not Warrior_TargetDeBU("献祭")  
	or not Warrior_TargetDeBU("暗言术：痛") 
	or not Warrior_TargetDeBU("噬灵瘟疫") 
	or not Warrior_TargetDeBU("毒蛇钉刺") 
	then
		return true;
	end
	return false;
end

function Warrior_CheckDebuffByPlayer(debuffName)
	local i = 1;
	local name, _, _, count, _, _, expirationTime, unitCaster = UnitDebuff("target", i);
	while name do 
		--Warrior_AddMessage(string.format("name: %s, debuffName: %s, unitCaster: %s", name, debuffName, unitCaster));
		if (name==debuffName) and (unitCaster=="player" or unitCaster==UnitName("player")) then
			local temp = expirationTime - GetTime();
			--Warrior_AddMessage(debuffName.."剩余时间："..temp.." 秒");
			return true, temp, count;
		end;
		i = i+1;
		name, _, _, count, _, _, expirationTime, unitCaster = UnitDebuff("target", i);
	end 
	return false, 0, 0;
end

-- 武器模式
function Warrior_DpsOut1()
  if Warrior_Test_Target_Debuff() then 
		Warrior_AddMessage(UnitName("target").."目标已经被控制...");			
    Warrior_SetText("目标已经被控制",0);
		return;
	end
	
	if not Warrior_TargetDeBU("飓风术") or not Warrior_TargetBU("圣盾术") or not  Warrior_TargetBU("保护之手") or  not Warrior_TargetBU("寒冰屏障") or not  Warrior_TargetBU("法术反射") or not  Warrior_TargetDeBU("放逐术") then
		Warrior_SetText("目标无法攻击",0);
		return ;
	end;
	
	if (not IsCurrentAction(Warrior_Auto_Attack())) and (not Warrior_Test_Target_Debuff()) then
		--Warrior_SetText("开始攻击",26);	
		Warrior_SetText("攻击", 1);
		return true;
	end;
  
	if Warrior_playerSafe() then return true; end;
	
	if 0~=IsActionInRange(Warrior_GetActionID(warrior_action_table["风剪"])) then
		local spellname = UnitCastingInfo("target") 
		if null~=spellname then
			if Warrior_CastSpell("风剪", warrior_action_table["风剪"]) then return true; end;
		end;
	end;
	
	if UnitIsPlayer("target") and UnitCanAttack("player","target") then
		if Warrior_TargetDeBU("冰霜震击") then
			if Warrior_CastSpell("冰霜震击", warrior_action_table["冰霜震击"]) then return true; end;
		end;
	end;
	
	-- 增强	Buff
	if Warrior_RunCommand() then return true; end;
  
	-- 增强饰品
	if Warrior_Auto_Trinket() then return true; end;

  local partyNum = GetNumGroupMembers();
	local power = UnitPower("player");
	if (partyNum >= 1 and power >= 20) or power >= 40 then
	  if Warrior_CastSpell("大地震击", warrior_action_table["大地震击"]) then return true; end;
	end;

	local debuff1, remainTime1 = Warrior_CheckDebuffByPlayer("烈焰震击");
	
	if (not debuff1 or remainTime1 < 5) then
	  --Warrior_AddMessage("烈焰震击 remainTime1: "..remainTime1);
	  if Warrior_CastSpell("烈焰震击", warrior_action_table["烈焰震击"]) then return true; end;
	end
	
	local buff1, remainTime1, count1 = Warrior_PlayerBU("熔岩奔腾");
	if buff1 then
	  if Warrior_CastSpell("熔岩爆裂", warrior_action_table["熔岩爆裂"]) then return true; end;
	end;
	
	local healthPercent1, maxHealth1 = Warrior_GetPlayerHealthPercent("player");
	local healthPercent2, maxHealth2 = Warrior_GetPlayerHealthPercent("target");
	
	if maxHealth2 > maxHealth1 then
	  if Warrior_CastSpell_IgnoreRange("火元素", warrior_action_table["火元素"]) then return true; end;
	end;
  
	if Warrior_CastSpell_IgnoreRange("元素冲击", warrior_action_table["元素冲击"]) then return true; end;
	
	if Warrior_CastSpell("熔岩爆裂", warrior_action_table["熔岩爆裂"]) then return true; end;
	
	
	--Warrior_AddMessage("tuandui : "..partyNum);
	if partyNum >= 1 then
	  if Warrior_CastSpell("闪电链", warrior_action_table["闪电链"]) then return true; end;
	else
	  if Warrior_CastSpell("闪电箭", warrior_action_table["闪电箭"]) then return true; end;
	end;
	
	Warrior_SetText("无动作",0);
	return;		

end;

-- 狂怒模式
function Warrior_DpsOut2()
    if Warrior_Test_Target_Debuff() then 
		Warrior_AddMessage(UnitName("target").."目标已经被控制...");			
		Warrior_SetText("目标已经被控制",0);
		return;
	end
	
	if (not IsCurrentAction(Warrior_Auto_Attack())) and (not Warrior_Test_Target_Debuff()) then
		--Warrior_SetText("开始攻击",26);	
		Warrior_SetText("自动攻击", 1);
		return true;
	end;
	if not Warrior_TargetDeBU("飓风术") or not Warrior_TargetBU("圣盾术") or not  Warrior_TargetBU("保护之手") or  not Warrior_TargetBU("寒冰屏障") or not  Warrior_TargetBU("法术反射") or not  Warrior_TargetDeBU("放逐术") then
		Warrior_SetText("目标无法攻击",0);
		return ;
	end;
	if Warrior_playerSafe() then return true;end;
	
	local power = UnitPower("player");
	
	local target_health_percent, target_health = Warrior_GetPlayerHealthPercent("target");
	if target_health_percent <= 20 and power >= 25 then
  	if Warrior_CastSpell("斩杀", warrior_action_table["斩杀"]) then return true; end;
  end;
  
	local spellname = UnitCastingInfo("target") 
	if null~=spellname then
		if Warrior_CastSpell("拳击", warrior_action_table["拳击"]) then return true; end;
	end;
	
	-- 狂怒	Buff
	if Warrior_RunCommand() then return true; end;

	-- 狂怒饰品
	if Warrior_Auto_Trinket() then return true; end;

  local partyNum = GetNumGroupMembers();
    
--  local buff1, remainTime1, count1 = Warrior_PlayerBU("激怒");
--  if buff1 then
--    Warrior_AddMessage("发脾气,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,");
--    if Warrior_CastSpell("怒击", warrior_action_table["怒击"]) then return true; end;
--  end;
	if Warrior_PlayerBU("激怒") then
		if Warrior_CastSpell("怒击", warrior_action_table["怒击"]) then return true; end;
	end
	  
  if power >= 85 then
    if Warrior_CastSpell("暴怒", warrior_action_table["暴怒"]) then return true; end;
  elseif power >= 60 then
    if Warrior_CastSpell("毁灭闪电", warrior_action_table["毁灭闪电"]) then return true; end;
  elseif power >= 20 then
    if Warrior_CastSpell("风暴打击", warrior_action_table["风暴打击"]) then return true; end;
  end

  if Warrior_CastSpell("嗜血", warrior_action_table["嗜血"]) then return true; end;
  if Warrior_CastSpell("狂暴挥砍", warrior_action_table["狂暴挥砍"]) then return true; end;

	Warrior_SetText("无动作",0);
	return;

end;

-- 防护模式
function Warrior_DpsOut3()
    if Warrior_Test_Target_Debuff() then 
		Warrior_AddMessage(UnitName("target").."目标已经被控制...");			
		Warrior_SetText("目标已经被控制",0);
		return;
	end
	
	if (not IsCurrentAction(Warrior_Auto_Attack())) and (not Warrior_Test_Target_Debuff()) then
		mianyi1 = 0; mianyi2 = 0; isPlague = 0;
		--Warrior_SetText("开始攻击",26);	
		Warrior_SetText("自动攻击", 1);
		return true;
	end;
	if not Warrior_TargetDeBU("飓风术") or not Warrior_TargetBU("圣盾术") or not  Warrior_TargetBU("保护之手") or  not Warrior_TargetBU("寒冰屏障") or not  Warrior_TargetBU("法术反射") or not  Warrior_TargetDeBU("放逐术") then
		Warrior_SetText("目标无法攻击",0);
		return ;
	end;
	if Warrior_playerSafe() then return true; end;
	
	if 0~=IsActionInRange(Warrior_GetActionID("Spell_Nature_EarthShock")) then
		local spellname = UnitCastingInfo("target") 
		if null~=spellname then
			if Warrior_CastSpell("风剪", "Spell_Nature_Cyclone") then return true; end;
		end;
	end;
	
	-- 增强	Buff
	if Warrior_RunCommand() then return true; end;

	-- 增强饰品
	if Warrior_Auto_Trinket() then return true; end;

	local spell_name,_,_,count = UnitBuff("player", "漩涡武器");
	if spell_name~=null then
		if count>4 then
			if Warrior_CastSpell("闪电箭","Spell_Nature_Lightning") then return true; end;
			if Warrior_CastSpell("闪电链","Spell_Nature_ChainLightning") then return true; end;
		end
	end
	if null~=Warrior_PlayerBU("节能施法") then 
		if Warrior_CastSpell("大地震击","Spell_Nature_EarthShock") then return true; end;
	end
	if Warrior_TargetDeBU("烈焰震击") then
		if Warrior_CastSpell("烈焰震击","Spell_Fire_FlameShock") then return true; end;
		--if Warrior_CastSpell("冰霜震击","Spell_Frost_FrostShock") then return true; end;
	else
		
	end;
	if 0~=IsActionInRange(Warrior_GetActionID("Ability_Warrior_Lavalash")) then
		if Warrior_CastSpell("熔岩猛击","Ability_Warrior_Lavalash") then return true; end;
		if Warrior_CastSpell("风暴打击","Ability_Warrior_Stormstrike") then return true; end;
	end
	if 0~=IsActionInRange(Warrior_GetActionID("Spell_Nature_EarthShock")) then
		if Warrior_CastSpell("大地震击","Spell_Nature_EarthShock") then return true; end;
		--if Warrior_CastSpell("冰霜震击","Spell_Frost_FrostShock") then return true; end;
	else
		if not Warrior_TargetDeBU("烈焰震击") then
			if Warrior_CastSpell("熔岩爆裂","Spell_Warrior_LavaBurst") then return true; end;
		end
		if Warrior_CastSpell("闪电箭","Spell_Nature_Lightning") then return true; end;
	end
	if UnitCanAttack("player", "target") and UnitName("player")~=tt_name and tt_name~=null then
		
		if Warrior_CastSpell("闪电箭","Spell_Nature_Lightning") then return true; end;
	end
	
	local tt_name = UnitName("targettarget");
	
	Warrior_SetText("无动作",0);
	return;		

end;

function Warrior_BreakCast(LossHealth)
	if UnitExists("playertarget") then
		if not UnitCanAttack("player","target") then
			if UnitIsDeadOrGhost("target") then
				--if Warrior_CastSpell("打断施法","Ability_GolemThunderClap") then return true; end;
				Warrior_SetText("打断施法",27);	
				return true;
			end			
			if (IsActionInRange(Warrior_GetActionID("Spell_Holy_HolyBolt")) ~= 1) then
				--if Warrior_CastSpell("打断施法","Ability_GolemThunderClap") then return true; end;
				Warrior_SetText("打断施法",27);	
				return true;
			end	
			if Warrior_GetPlayerLossHealth("target") < LossHealth then
				--if Warrior_CastSpell("打断施法","Ability_GolemThunderClap") then return true; end;
				Warrior_SetText("打断施法",27);	
				return true;
			end
		else
			if Warrior_GetPlayerLossHealth("player") < LossHealth then
				--if Warrior_CastSpell("打断施法","Ability_GolemThunderClap") then return true; end;
				Warrior_SetText("打断施法",27);	
				return true;
			end
		end
	else
		if Warrior_GetPlayerLossHealth("player") < LossHealth then
				--if Warrior_CastSpell("打断施法","Ability_GolemThunderClap") then return true; end;
				Warrior_SetText("打断施法",27);	
				return true;
		end
	end
	return false;
end

function Warrior_playerSafe()
	local debufftype = Warrior_TestPlayerDebuff("player");
--	if debufftype==3 or debufftype==2 then
--		if Warrior_CastSpell("驱毒术","Spell_Nature_NullifyPoison") then return true; end;
--	end
--	if debufftype==3 or debufftype==2 then
--		if Warrior_CastSpell("净化术", warrior_action_table["净化术"]) then return true; end;
--	end
	if debufftype==1 or debufftype==4 then
		if Warrior_CastSpell("净化灵魂", warrior_action_table["净化灵魂"]) then return true; end;
	end
	
	local HealthPercent, maxHealth = Warrior_GetPlayerHealthPercent("player");
	--Warrior_AddMessage("player health percent: "..HealthPercent);
	if HealthPercent < 60 then
		if Warrior_CastSpell("星界转移", warrior_action_table["星界转移"]) then return true; end;
	end;
	
	if Warrior_DPS == 1 then
  	if HealthPercent < 50 then
  		if Warrior_CastSpell("治疗之涌", warrior_action_table["治疗之涌"]) then return true; end;
  	end;
  elseif Warrior_DPS == 2 then
  
  else
    local spell_name,_,_,count = UnitBuff("player", "漩涡武器");
  	if UnitIsPlayer("playertarget") or HealthPercent < 55 then
  		if (spell_name~=null and count>4) or UnitAffectingCombat("player")==0 then
  			if Warrior_CastSpell("治疗波", warrior_action_table["治疗波"]) then return true; end;
  		end
  	end;
  	if HealthPercent < 60 then
  		if (spell_name~=null and count>3) or UnitAffectingCombat("player")==0 then
  			if Warrior_CastSpell("次级治疗波", warrior_action_table["次级治疗波"]) then return true; end;
  		end		
  	end
  	if HealthPercent < 70 then
  		if UnitAffectingCombat("player")==0 then
  			if Warrior_CastSpell("治疗波", warrior_action_table["治疗波"]) then return true; end;
  		end	
  	end
  	if HealthPercent < 80 then
  		
  	end
  	if HealthPercent < 90 then
  		if (Warrior_TestTrinket("英雄勋章")) then
  			if Warrior_CastSpell("英雄勋章","INV_Jewelry_Talisman_07") then return true; end;
  		end
  	end;
	end;
	return false;
end;

function Warrior_SelectPartyTarget(unitid)
	if UnitIsUnit("target", "party"..unitid) then return false; end;
	Warrior_SetText("选取"..unitid.."个队友",unitid+29);
	return true;	
end
function Warrior_GetPlayerManaPercent(unit)
	if UnitIsDeadOrGhost("player") then return 100; end
	local mana, manamax = UnitMana("player"), UnitManaMax("player");
	local ManaPercent = floor(mana*100/manamax+0.5);
	return ManaPercent;	
end
function Warrior_GetPlayerLossHealth(unit)	
	local health, healthmax  = UnitHealth(unit), UnitHealthMax(unit);
	return healthmax - health;	
end
function Warrior_GetPlayerHealthPercent(unit)	
	local health, healthmax  = UnitHealth(unit), UnitHealthMax(unit);
	local healthPercent = floor(health*100/healthmax+0.5);	
	return healthPercent, healthmax;	
end
function Warrior_Do_Reincarnation_CanUseAction(i) 
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

function Warrior_NoControl_Debuff()
	if not Warrior_PlayerDeBU("心灵尖啸") 
	   or not Warrior_PlayerDeBU("精神控制") 
	   or not Warrior_PlayerDeBU("恐惧")
	   or not Warrior_PlayerDeBU("恐惧嚎叫") 	 
	   or not Warrior_PlayerDeBU("女妖媚惑") 
	   or not Warrior_PlayerDeBU("破胆怒吼") 
	   or not Warrior_PlayerDeBU("休眠") 		 
	   or not Warrior_PlayerDeBU("逃跑")
	   or not Warrior_PlayerDeBU("凿击")
	   or not Warrior_PlayerDeBU("媚惑")  
	   or not Warrior_PlayerDeBU("变形术") 
	   or not Warrior_PlayerDeBU("休眠")  
	   or not Warrior_PlayerDeBU("致盲")  		
	   or not Warrior_PlayerDeBU("闷棍") 				
	   or not Warrior_PlayerDeBU("冰冻陷阱") 
	   or not Warrior_PlayerDeBU("肾击") 
	   or not Warrior_PlayerDeBU("忏悔") 
	   or not Warrior_PlayerDeBU("霜寒刺骨")
	   or not Warrior_PlayerDeBU("制裁之锤")	
	   or not Warrior_PlayerDeBU("强化断筋")
	   or not Warrior_PlayerDeBU("冲击")
	   or not Warrior_PlayerDeBU("冰霜新星") 
	   or not Warrior_PlayerDeBU("纠缠根须")
	   or not Warrior_PlayerDeBU("偷袭")
	then
		return true;
	end
	return false;	
end	


function Warrior_IsSpellInRange(spellname,unit)
	if UnitExists(unit) then
		if UnitIsVisible(unit) then
			if IsSpellInRange(spellname,unit) == 1 then
				return true;
			end
		end
	end
	return false;
end
function Warrior_UnitAffectingCombat()
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


function Warrior_CombatLogEvent(event,...)
	if not (playerClass=="战士") then return; end;
	local timestamp, eventType, sourceGUID, sourceName, sourceFlags, destGUID, destName, destFlags = ...
	local amount, school, resisted, blocked, absorbed, critical, glancing, crushing, missType, enviromentalType,interruptedSpellId, interruptedSpellName, interruptedSpellSchool;

	if eventType == "SPELL_CAST_SUCCESS" then
		spellId, spellName, spellSchool = select(9, ...);
		if CombatLog_Object_IsA(sourceFlags, COMBATLOG_FILTER_HOSTILE_PLAYERS) then
				if spellName == "消失" and sourceName then
					Warrior_Warning_AddMessage("**敌对玩家>>"..sourceName.."<<使用了消失,反隐反隐!**");					
					table.insert(Warrior_Data[UnitName("player")]["Rogue"],{["Command"] = "奉献"});				
					StartTimer("Ability_Warrior_WarCry");					
					return;
				end;
				if spellName == "隐形术" and sourceName then
					Warrior_Warning_AddMessage("**敌对玩家>>"..sourceName.."<<使用了隐形术,反隐反隐!**");					
					table.insert(Warrior_Data[UnitName("player")]["Rogue"],{["Command"] = "奉献"});				
					StartTimer("Ability_Warrior_WarCry");					
					return;
				end;
				if spellName == "闪避" and sourceName then
					Warrior_Warning_AddMessage("**警告:敌对玩家>>"..sourceName.."<<获得闪避效果,效果持续8秒!**");
					return;	
				end;
				if spellName == "圣盾术" and sourceName then					
					Warrior_Warning_AddMessage("**警告:敌对玩家>>"..sourceName.."<<获得".. spellName .."效果!!**");					
					return;	
				end;
				if spellName == "保护之手" and sourceName then
					if destName then
						Warrior_Warning_AddMessage("**警告:敌对玩家>>"..sourceName.."<<给>>"..destName.."<<施放了保护之手!!**");
					else
						Warrior_Warning_AddMessage("**警告:敌对玩家>>"..sourceName.."<<施放了保护之手!!**");
					end;
					return;	
				end;
		end
		if CombatLog_Object_IsA(sourceFlags, COMBATLOG_FILTER_FRIENDLY_UNITS) and spellName then			
			if (spellName == "嘲讽" or spellName == "正义防御" ) and sourceName and destName then
				--Warrior_Warning_AddMessage("**>>"..sourceName.."<<对"..destName.."成功施放了"..spellName.."!**");
			end;			
		end;	
		
		return;
	end;	
	
	if eventType == "SPELL_MISSED" then
		spellId, spellName, spellSchool, missType = select(9, ...);	
		if CombatLog_Object_IsA(sourceFlags, COMBATLOG_FILTER_MINE) and spellName then			
			if missType == "RESIST" then
				Warrior_AddMessage("**>>"..destName.."<<抵抗了"..sourceName.."的"..spellName.."!**");
			elseif missType == "IMMUNE" then
				Warrior_AddMessage("**>>"..destName.."<<免疫了"..sourceName.."的"..spellName.."!**");
				if spellName == "冰冷触摸" then mianyi1 = 1;end;
				if spellName == "心灵冰冻" then mianyi2 = 1;end;
				if sourceName == UnitName("player") then
				      local g_FindNpcName = false;
				      for k, v in pairs(Warrior_SaveData) do		       
					      if v["npcname"] == destName and  v["spellname"] == spellName then  
						 g_FindNpcName = true;
					      end
				      end
				      if not g_FindNpcName then
					      table.insert(Warrior_SaveData,{["npcname"] = destName,["spellname"] = spellName,});
				      end;
				end;
				return;
			end			
			return;		
		end;
		if CombatLog_Object_IsA(sourceFlags, COMBATLOG_FILTER_FRIENDLY_UNITS) and spellName then			
			if (spellName == "嘲讽" or spellName == "正义防御" ) and sourceName and destName then
				if missType == "RESIST" then
					Warrior_Warning_AddMessage("**>>"..destName.."<<抵抗了"..sourceName.."的"..spellName.."!**");
				elseif missType == "IMMUNE" then
					Warrior_Warning_AddMessage("**>>"..destName.."<<免疫了"..sourceName.."的"..spellName.."!**");					
					return;
				end			
				return;
			end;
			if spellName == "震荡猛击"  and sourceName and destName then
				if missType == "RESIST" then
					Warrior_Warning_AddMessage("**>>"..destName.."<<抵抗了"..sourceName.."的"..spellName.."!**");
				elseif missType == "IMMUNE" then
					Warrior_Warning_AddMessage("**>>"..destName.."<<免疫了"..sourceName.."的"..spellName.."!**");					
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
					Warrior_AddMessage("你的|cffffff00"..spellName.."|r|cff00ff00对|r|cffffff00"..destName.."|r|cff00ff00造成|r|cffffff00"..amount.."|r|cff00ff00伤害(|r|cffffff00爆击|r|cff00ff00)...|r");				       
				else
					Warrior_AddMessage("你的|cffffff00"..spellName.."|r|cff00ff00对|r|cffffff00"..destName.."|r|cff00ff00造成|r|cffffff00"..amount.."|r|cff00ff00伤害...|r");				       
				end
			end
		end
	end
	if eventType == "SPELL_HEAL" then
		spellId, spellName, spellSchool, amount, critical = select(9, ...);
		if CombatLog_Object_IsA(sourceFlags, COMBATLOG_FILTER_MINE) and amount > 300 and destName and sourceName then
			if critical then
				Warrior_AddMessage("|cff00ff00你的|cffffff00"..spellName.."|r|cff00ff00给|r|cffffff00"..destName.."|r|cff00ff00恢复|r|cffffff00"..amount.."|r|cff00ff00点生命(|r|cffffff00爆击|r|cff00ff00)...|r");				       
			else
				Warrior_AddMessage("|cff00ff00你的|cffffff00"..spellName.."|r|cff00ff00给|r|cffffff00"..destName.."|r|cff00ff00恢复|r|cffffff00"..amount.."|r|cff00ff00点生命...|r");				       
			end	
			return;
		end;
		if CombatLog_Object_IsA(destFlags, COMBATLOG_FILTER_MINE) and amount > 300 and destName and sourceName then
			if critical then
				Warrior_AddMessage("|cffffff00"..sourceName.."|r|cff00ff00的|cffffff00"..spellName.."|r|cff00ff00给我|cff00ff00恢复|r|cffffff00"..amount.."|r|cff00ff00点生命(|r|cffffff00爆击|r|cff00ff00)...|r");				       
			else
				Warrior_AddMessage("|cffffff00"..sourceName.."|r|cff00ff00的|cffffff00"..spellName.."|r|cff00ff00给我|r|cff00ff00恢复|r|cffffff00"..amount.."|r|cff00ff00点生命...|r");				       
			end			
		end;
		return;
	end;
end

function Warrior_Test()	
	for i = 1, 120 do
		if ( HasAction(i) ) then
			local texture = GetActionTexture(i);
			local text = GetActionText(i);
			DEFAULT_CHAT_FRAME:AddMessage(i.." |cffffff00" .. texture .. "|r");
		end;		
	end;
	
end;

function Warrior_Use_INV_Jewelry_TrinketPVP_02()
	if UnitIsPlayer("playertarget") then 
		if Warrior_NoControl_Debuff() then
			if Warrior_TestTrinket("部落徽记") or Warrior_TestTrinket("部落勋章")  then 
				if Warrior_CastSpell("部落徽记","INV_Jewelry_TrinketPVP_02") then 
					--StartTimer("INV_Jewelry_TrinketPVP")
					return true; 
				end		
			end	
			if Warrior_TestTrinket("联盟徽记") or Warrior_TestTrinket("联盟勋章")  then
				if Warrior_CastSpell("联盟徽记","INV_Jewelry_TrinketPVP_01") then 
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
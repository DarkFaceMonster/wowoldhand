
Shaman_SaveData = nil;
Shaman_Data = nil;
local Shaman_Buttons = {};
Shaman_PlayerTalentInfoDatas = {};

local dynamicMicroID = 72;
local playerClass;
local Shaman_DPS = 1; -- 默认元素，1元素，2增强，3治疗
local Shaman_Reincarnation  = false;
local Shaman_Free  = false;
local Shaman_RaidFlag = 0;
local Shaman_Old_UnitPopup_OnClick;
local Shaman_AutoFollowName="";
local TestHelpTarget = "";
local target_count = 0;		-- 目标个数
local target_table = {};	

local   Shaman_DISEASE = '疾病';
local 	Shaman_MAGIC   = '魔法';
local 	Shaman_POISON  = '中毒';
local 	Shaman_CURSE   = '诅咒';

-- 2 Ability_Shaman_Lavalash		熔岩猛击
-- 3 Ability_Shaman_Stormstrike 	风暴打击
-- 4 Spell_Nature_EarthShock		大地震击
--   5 Spell_Frost_FrostShock		--冰霜震击
-- 5 Spell_Shaman_LavaBurst			熔岩爆裂
--   6 Spell_Nature_HealingWaveLesser	--次级治疗波
-- 6 Spell_Nature_HealingWay		治疗之涌
-- 7 Spell_Nature_MagicImmunity		--治疗波
-- 7 spell_shaman_primalstrike		根源打击
-- 8 Spell_Nature_HealingWaveGreater	治疗链
--   9 Spell_Nature_NullifyPoison			--驱毒术
-- 9 Ability_Shaman_CleanseSpirit		净化灵魂
-- 10 Spell_Nature_Lightning			闪电箭
-- 11 Spell_Nature_ChainLightning		闪电链
-- 12 Spell_Nature_LightningShield		闪电之盾
-- 
-- 61 Spell_Shaman_FeralSpirit		野性狼魂
-- 62 Spell_Fire_SelfDestruct		--熔岩图腾
-- 62 Spell_Fire_SearingTotem		灼热图腾
-- 63 Spell_Nature_Cyclone			风剪
-- 64 Spell_Fire_SelfOfFire			--火焰新星图腾
-- 64 spell_shaman_firenova			火焰新星
-- 65 Spell_Fire_FlameShock			烈焰震击
-- 66 Spell_Nature_Purge			净化术
-- 67 Spell_Nature_ShamanRage		萨满之怒
-- 68 Spell_Nature_GroundingTotem	根基图腾
-- 69 Ability_Shaman_WaterShield	水之护盾
-- 70 Spell_Nature_Regenerate		先祖之魂

shaman_action_table = {};

shaman_action_table["自动攻击"] = 135609;
shaman_action_table["治疗之涌"] = 136044;
shaman_action_table["先祖之魂"] = 136077;

shaman_action_table["打断施法"] = 236164;
shaman_action_table["嗜血"] = 136012;
shaman_action_table["星界转移"] = 538565;
shaman_action_table["风剪"] = 136018;
shaman_action_table["陷地图腾"] = 136100;

shaman_action_table["净化术"] = 136075;
shaman_action_table["净化灵魂"] = 236288;

-- 元素
shaman_action_table["闪电箭"] = 136048;
shaman_action_table["烈焰震击"] = 135813;
shaman_action_table["熔岩爆裂"] = 237582;
shaman_action_table["大地震击"] = 136026;
shaman_action_table["冰霜震击"] = 135849;

shaman_action_table["闪电链"] = 136015;
shaman_action_table["雷霆风暴"] = 237589;
shaman_action_table["元素冲击"] = 651244;


shaman_action_table["图腾掌握"] = 511726;



shaman_action_table["震地图腾"] = 451165;
shaman_action_table["土元素"] = 136024;
shaman_action_table["火元素"] = 135790;


-- 增强
shaman_action_table["火舌"] = 135814;
shaman_action_table["石拳"] = 1016351;
shaman_action_table["冰封"] = 462327;
shaman_action_table["熔岩猛击"] = 236289;
shaman_action_table["风暴打击"] = 132314;

shaman_action_table["毁灭闪电"] = 1370984;

shaman_action_table["野性狼魂"] = 237577;
shaman_action_table["降雨"] = 136037;
shaman_action_table["幽魂步"] = 132328;

-- 饰品
shaman_action_table["临近风暴之怒"] = 236164;
shaman_action_table["伊萨诺斯甲虫"] = 236164;

-- 51 Racial_Troll_Berserk			狂暴
-- 100 spell_shaman_unleashweapon_wind 风怒武器
--  Spell_Fire_FlameTounge		火舌武器

local  Shaman_IGNORELIST = {
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
	
local Shaman_SKIP_LIST = {
		["无梦睡眠"] = true,
		["强效昏睡"] = true,
		["心灵视界"] = true,
	};
local 	Shaman_CLASS_DRUID   = '德鲁伊';
local 	Shaman_CLASS_HUNTER  = '猎人';
local 	Shaman_CLASS_MAGE    = '法师';
local 	Shaman_CLASS_PALADIN = '圣骑士';
local 	Shaman_CLASS_PRIEST  = '牧师';
local 	Shaman_CLASS_ROGUE   = '盗贼';
local 	Shaman_CLASS_SHAMAN  = '萨满祭司';
local 	Shaman_CLASS_WARLOCK = '术士';
local 	Shaman_CLASS_Shaman_ = '战士';

local Shaman_SKIP_BY_CLASS_LIST = {
		[Shaman_CLASS_Shaman_] = {		
			["上古狂乱"]   = true,
			["点燃法力"]   = true,
			["污浊之魂"]   = true,
		};
		[Shaman_CLASS_ROGUE] = {			
			["沉默"]       = true;
			["上古狂乱"]   = true,
			["点燃法力"]   = true,
			["污浊之魂"]   = true,
			["煽动烈焰"]   = true,	
			["熔岩镣铐"]   = true,
		};
		[Shaman_CLASS_HUNTER] = {			
			["煽动烈焰"]   = true,	
		};
		[Shaman_CLASS_MAGE] = {			
			["煽动烈焰"]   = true,	
		};
		[Shaman_CLASS_DRUID]= {
			["煽动烈焰"]   = true,	
		};
		[Shaman_CLASS_PALADIN]= {
			["煽动烈焰"]   = true,	
		};
		[Shaman_CLASS_PRIEST]= {
			["煽动烈焰"]   = true,	
		};
		[Shaman_CLASS_SHAMAN]= {
			["煽动烈焰"]   = true,	
		};
		[Shaman_CLASS_WARLOCK]= {
			["煽动烈焰"]   = true,	
		};
	};

local spell_table = {};
spell_table["临近风暴之怒"] = 72;
spell_table["大副的怀表"] = 71;

function Shaman_AutoSelectMode()
	if UnitAffectingCombat("player")~=1 then
	  local currentSpec = GetSpecialization();
	  Shaman_DPS = currentSpec;
	end
end

function Shaman_BreakCasting(myspell)
	local target_name = UnitName("target");
	local spell, _, displayName, _, startTime, endTime, _, _, notInterruptible = UnitCastingInfo("target");
	if (spell == null) then currTargetCasting = null; return 0; end;
	if (spell ~= null and spell ~= currTargetCasting) then
	  if (notInterruptible) then
	    --DeathKnight_AddMessage(string.format("目标 正在施放 %s 。。。无法打断", spell));
	    return 0;
	  else
	    DeathKnight_AddMessage(string.format("目标 正在施放 %s 。。。", spell));
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

function Oldhand_TestPlayerDebuff(unit)
  --local healthPercent, maxHealth = Shaman_GetPlayerHealthPercent(unit);
	--if healthPercent < 40 then return 0; end;
	local i = 1;
	while UnitDebuff(unit, i ) do
		ShamanTooltip:SetOwner(Shaman_MSG_Frame, "ANCHOR_BOTTOMRIGHT", 0, 0);
		ShamanTooltip:SetUnitDebuff(unit, i);		
		local	debuff_name = ShamanTooltipTextLeft1:GetText();
		local   debuff_type = ShamanTooltipTextRight1:GetText();				
		ShamanTooltip:Hide();
		if (debuff_name) and (debuff_type) then
			if (Shaman_IGNORELIST[debuff_name]) then
				break;
			end
			if (UnitAffectingCombat("player")) then
				if (Shaman_SKIP_LIST[debuff_name]) then
					break;
				end
				if (Shaman_SKIP_BY_CLASS_LIST[UClass]) then
					if (Shaman_SKIP_BY_CLASS_LIST[UClass][debuff_name]) then
						break;
					end
				end
			end						
			if (debuff_type) then
				if (debuff_type == Shaman_MAGIC) then							
					return 1;
				elseif (debuff_type == Shaman_DISEASE) then							
					return 2;
				elseif (debuff_type == Shaman_POISON) then							
					return 3;
				elseif (debuff_type == Shaman_CURSE) then							
					return 4;					
				end
			end	
		end;
		i = i + 1;
	end	
	return 0;
end

function Shaman_RegisterEvents(self)
	local englishClass;
	playerClass, englishClass = UnitClass("player");
	if not (playerClass=="萨满祭司") then
			HideUIPanel(Shaman_MSG_Frame);
			HideUIPanel(ShamanColorRectangle);
			return;
	end;
	self:RegisterEvent("PLAYER_ENTERING_WORLD");		
	self:RegisterEvent("UI_ERROR_MESSAGE");
	self:RegisterEvent("PLAYER_TARGET_CHANGED");
	self:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED");
	--self:RegisterEvent("INSPECT_TALENT_READY");
	
	UnitPopupButtons["ShamanPOPUP"] = { text = "智能施法跟随对象", dist = 0 };	
		
	if (UnitPopupMenus["SELF"]) then
		--table.insert( UnitPopupMenus["SELF"], "ShamanPOPUP");		
	end	
	if (UnitPopupMenus["PLAYER"]) then
		--table.insert( UnitPopupMenus["PLAYER"], "ShamanPOPUP");		
	end
	if (UnitPopupMenus["PARTY"]) then
		--table.insert( UnitPopupMenus["PARTY"], "ShamanPOPUP");		
	end
	
	--Shaman_Old_UnitPopup_OnClick = UnitPopup_OnClick;
	--UnitPopup_OnClick = Shaman_UnitPopup_OnClick;
end;
function Shaman_UnitPopup_OnClick()
	local index = this.value;
	local dropdownFrame = getglobal(UIDROPDOWNMENU_INIT_MENU);
	local button =  this.value;	
	local name = dropdownFrame.name;

	if ( button == "ShamanPOPUP" ) then
		Shaman_AutoFollowName = name;
		PlaySound("UChatScrollButton");
		DEFAULT_CHAT_FRAME:AddMessage("("..Shaman_AutoFollowName..")目前为跟随对象!");
	else
		Shaman_Old_UnitPopup_OnClick();
	end
end
function Shaman_OnEvent(event)	
	if not (playerClass=="萨满祭司") then return; end;
	if (event=="PLAYER_ENTERING_WORLD") then
		Shaman_Data = {};
		Shaman_Data[UnitName("player")] = 
					{			
					Rogue={},
					};
		if( Shaman_SaveData == nil ) then
		    Shaman_SaveData = {};
		end
		DEFAULT_CHAT_FRAME:AddMessage("智能施法插件 2.0 (萨满祭司版)   www.oldhand.net 版权所有");			
		getglobal("ShamanColorRectangle".."NormalTexture"):SetVertexColor(0, 0, 0);
		Shaman_AutoSelectMode();	
		Shaman_CreateMacro();
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
					 Shaman_AddMessage_A("**你的目标是"..GetTalentTabInfo(s,true).."天赋的"..UnitClass("target").."**");
				   end
				   if UnitIsUnit("player","target") and UnitAffectingCombat("player") ~= 1 then
					Shaman_CreateMacro();
				   end;
				   if not UnitCanAttack("player","target")  then
						if UnitClass("target") == "德鲁伊" and GetTalentTabInfo(s,true) == "野性战斗" then
							Shaman_AddPlayerTalent(UnitName("target"));
						end;
						if UnitClass("target") == "圣骑士" and GetTalentTabInfo(s,true) == "防护" then
							Shaman_AddPlayerTalent(UnitName("target"));
						end;
						if UnitClass("target") == "战士" and GetTalentTabInfo(s,true) == "防护" then
							Shaman_AddPlayerTalent(UnitName("target"));
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
			Shaman_AutoSelectMode();	
			Shaman_CreateMacro();
		end;
		if UnitIsPlayer("target") and not UnitIsUnit("player","target") then	
			NotifyInspect("playertarget");
		end;	
	end;	

end;

function Shaman_AddPlayerTalent(playername)
	for k, v in pairs(Shaman_PlayerTalentInfoDatas) do							
		if(playername == v["Name"]) then
			return;
		end		
	end

	table.insert(Shaman_PlayerTalentInfoDatas,
		{
		["Name"] = playername,
		});
end
function Shaman_GetPlayerTalent(playername)
	for k, v in pairs(Shaman_PlayerTalentInfoDatas) do							
		if(playername == v["Name"]) then
			return true;
		end		
	end
	return false;
end
function Shaman_CreateMacro()	
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
		CreateMacro("更换模式", 61, "/script Shaman_Input(1);", 1, 1);
	end;	
	PickupMacro("更换模式");
	PlaceAction(49);
	ClearCursor();	
	if Shaman_DPS == 2 then
		if GetMacroIndexByName("增强模式") == 0 then
			CreateMacro("增强模式", 62, "/script Shaman_Input(1);", 0, 0);
		end;
		PickupMacro("增强模式");
	elseif Shaman_DPS == 1 then
		if GetMacroIndexByName("元素模式") == 0 then
			CreateMacro("元素模式", 62, "/script Shaman_Input(1);", 0, 0);
		end;
		PickupMacro("元素模式");
	elseif Shaman_DPS == 3 then
		if GetMacroIndexByName("治疗模式") == 0 then
			CreateMacro("治疗模式", 62, "/script Shaman_Input(1);", 0, 0);
		end;
		PickupMacro("治疗模式");
	end
	PlaceAction(50);
	ClearCursor();

  Shaman_PutAction("自动攻击", 1);
  Shaman_PutAction("治疗之涌", 7);
  Shaman_PutAction("先祖之魂", 11);
  
  Shaman_PutAction("嗜血", 62);
  Shaman_PutAction("星界转移", 63);
  Shaman_PutAction("风剪", 64);
  Shaman_PutAction("陷地图腾", 65);
  Shaman_PutAction("净化术", 69);
  Shaman_PutAction("净化灵魂", 70);
  
  if Shaman_DPS == 1 then
    Shaman_PutAction("闪电箭", 2);
    Shaman_PutAction("烈焰震击", 3);
    Shaman_PutAction("熔岩爆裂", 4);
    Shaman_PutAction("大地震击", 5);
    Shaman_PutAction("冰霜震击", 6);
    Shaman_PutAction("闪电链", 8);
    Shaman_PutAction("雷霆风暴", 9);
    Shaman_PutAction("元素冲击", 10);
    
    Shaman_PutAction("图腾掌握", 12);
    
    
    Shaman_PutAction("震地图腾", 66);
    Shaman_PutAction("土元素", 67);
    Shaman_PutAction("火元素", 68);
  elseif Shaman_DPS == 2 then
    Shaman_PutAction("火舌", 2);
    Shaman_PutAction("石拳", 3);
    Shaman_PutAction("冰封", 4);
    Shaman_PutAction("熔岩猛击", 5);
    Shaman_PutAction("风暴打击", 6);
    Shaman_PutAction("闪电箭", 8);
    Shaman_PutAction("毁灭闪电", 9);
    
    Shaman_PutAction("野性狼魂", 66);
    Shaman_PutAction("降雨", 67);
    Shaman_PutAction("幽魂步", 68);  
  elseif Shaman_DPS == 3 then
  
  end;

	if Shaman_TestTrinket("部落勋章") then
		Shaman_PutAction("部落勋章", 71);
	elseif Shaman_TestTrinket("大副的怀表") then
		Shaman_PutAction("大副的怀表", 72);
	elseif Shaman_TestTrinket("菲斯克的怀表") then
		Shaman_PutAction("菲斯克的怀表", 72);
	elseif Shaman_TestTrinket("恐惧小盒") then
		Shaman_PutAction("恐惧小盒", 71);
	elseif Shaman_TestTrinket("恐惧小盒") then
		Shaman_PutAction("战歌的热情", 71);
	elseif Shaman_TestTrinket("苔原护符") then
		Shaman_PutAction("苔原护符", 71);
	elseif Shaman_TestTrinket("食人魔殴斗者的徽章") then
		Shaman_PutAction("食人魔殴斗者的徽章", 71);
	end
	if Shaman_TestTrinket("胜利旌旗") then
		Shaman_PutAction("胜利旌旗", 72);
	elseif Shaman_TestTrinket("临近风暴之怒") then
		Shaman_PutAction("临近风暴之怒", 71);
	elseif Shaman_TestTrinket("英雄勋章") then
		Shaman_PutAction("英雄勋章", 72);
	elseif Shaman_TestTrinket("伊萨诺斯甲虫") then
		Shaman_PutAction("伊萨诺斯甲虫", 72);
	elseif Shaman_TestTrinket("刃拳的宽容") then
		Shaman_PutAction("刃拳的宽容", 72);
	end
	
	Shaman_PutAction("狂暴", 51);

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

function Shaman_PutAction(text, index)
	if not text then return false;end;
	Shaman_AddMessage(text..index);
	if Shaman_PickupSpellByBook(text) then
		PlaceAction(index);
		ClearCursor();
		spell_table[text] = index;
		return true;
	end;
	spell_table[text] = 0;
	return false;
end;

function Shaman_NoTarget_RunCommand()
	return Shaman_RunCommand();
end;

function Shaman_Test_IsFriend(unitname)
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

function Shaman_Damage_Message(arg1, event)
	if (not arg1) then
		return;
	end;

	if event == "CHAT_MSG_SPELL_HOSTILEPLAYER_BUFF" then	
		for creatureName,creatureName1 in string.gmatch(arg1, "(.+)对(.+)使用消失。") do	
			if not Shaman_Test_IsFriend(creatureName)  then
				Shaman_AddMessage("|cff00adef"..creatureName.."|r|cff00ff00使用了消失!自动使用奉献!|r");
				table.insert(Shaman_Data[UnitName("player")]["Rogue"],{["Command"] = "奉献"});				
				StartTimer("Ability_Shaman_WarCry");
			end	
			return;
		end;
	end;
	
	local playerUnitName = UnitName("Player");	
	
	if ( event == "CHAT_MSG_SPELL_SELF_DAMAGE" ) then			
			Shaman_AddMessage(arg1);
			for spellname, creatureName, spell in string.gmatch(arg1, playerUnitName.."的(.+)打断了(.+)的(.+)。") do							       
				Shaman_AddMessage("**你的"..spellname.."打断了"..creatureName.."的"..spell.."...**");
				return;
			end;				
			for spell, creatureName, damage in string.gmatch(arg1, "你的(.+)击中(.+)造成(%d+)点伤害。") do
				if spell and damage > 500 then
					Shaman_AddMessage("你的|cffffff00"..spell.."|r|cff00ff00造成|r|cffffff00"..damage.."|r|cff00ff00伤害...|r");				       
					return;
				end;
			end;			
			for spell, creatureName, damage in string.gmatch(arg1, "你的(.+)爆击对(.+)造成(%d+)点伤害。") do
				if spell and damage > 500 then
					Shaman_AddMessage("你的|cffffff00"..spell.."|r|cff00ff00造成|r|cffffff00"..damage.."|r|cff00ff00伤害(爆击)|r");
					return;
				end;
			end;
			for spell, creatureName, damage, damageType in string.gmatch(arg1, "你的(.+)击中(.+)造成(%d+)点(.+)伤害。") do
				if spell and damage > 500 then
					Shaman_AddMessage("你的|cffffff00"..spell.."|r|cff00ff00造成|r|cffffff00"..damage.."|r|cff00ff00伤害...");
					return;
				end;
			end;
			for spell, creatureName, damage, damageType in string.gmatch(arg1, "你的(.+)爆击对(.+)造成(%d+)点(.+)伤害。") do
				if spell and damage > 500 then
					Shaman_AddMessage("你的|cffffff00"..spell.."|r|cff00ff00造成|r|cffffff00"..damage.."|r|cff00ff00伤害(爆击)|r");
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
			Shaman_AddMessage(arg1);		
			for playerName, spell, creatureName, damage in string.gmatch(arg1, "(.+)的(.+)发挥极效，为(.+)恢复了(%d+)点生命值。") do
				if creatureName == "你" then 
					Shaman_AddMessage("|cff00adef"..playerName.."|r|cff00ff00的|r|cffffff00"..spell.."|r|cff00ff00x给我恢复了|r|cffffff00"..damage.."|r|cff00ff00生命值...|r");				       
				end;
				return;
			end;
			for playerName, spell, creatureName, damage in string.gmatch(arg1, "(.+)的(.+)为(.+)恢复了(%d+)点生命值。") do
				if creatureName == "你" then 
					Shaman_AddMessage("|cff00adef"..playerName.."|r|cff00ff00的|r|cffffff00"..spell.."|r|cff00ff00给我恢复了|r|cffffff00"..damage.."|r|cff00ff00生命值...|r");				       
				end;
				return;
			end;
		end;	
end;

function Shaman_Input(i)	
	Shaman_DPS = Shaman_DPS + 1;
	if (Shaman_DPS > 3) then Shaman_DPS = 1; end;
	
	if Shaman_DPS == 1 then
		Shaman_AddMessage("进入元素模式(PVP适用)...");
	elseif Shaman_DPS == 2 then
		Shaman_AddMessage("进入增强模式(PVP适用)...");
	else
		Shaman_AddMessage("进入治疗模式...");
	end
end;

function Shaman_Msg_OnUpdate()
	if playerClass~="萨满祭司" then return; end;
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

function Shaman_Frame_OnUpdate()
	if playerClass~="萨满祭司" then return; end;

	--if(ChatFrameEditBox:IsVisible()) then
	local activeWindow = ChatEdit_GetActiveWindow();
	if ( activeWindow ) then
		Shaman_SetText("聊天状态",0);
		return;	
	end;
	if UnitIsDeadOrGhost("player") then 
	  Shaman_SetText("死亡状态",0);
		return; 
	end;
	if not UnitAffectingCombat("player") then
		Shaman_ClearTargetTable();
	end;
	if UnitOnTaxi("player") == 1 then return; end;

	if Shaman_TestPlayerIsHorse() then			
		if IsActionInRange(Shaman_GetActionID("Spell_Holy_SealOfMight")) ~= 1  then
		    Shaman_SetText("骑乘状态",0);
			return;			
		end;	
	end;
	
	if (Shaman_PlayerBU("喝水") or Shaman_PlayerBU("进食")) and UnitAffectingCombat("player")~=1 then 
		Shaman_SetText("正在喝水",0); 
		return; 
	end;
	
	local spellname = UnitCastingInfo("player")
	if spellname then
	  -- Shaman_AddMessage("UnitCastingInfo: "..spellname);
		Shaman_SetText("施放"..spellname,0);
		return;
	end
	
	-- Shaman_playerSafe();
	TestHelpTarget = "";

	if Shaman_Use_INV_Jewelry_TrinketPVP_02() then return; end;	

	if Shaman_NoControl_Debuff() then
		Shaman_SetText("被控制...",0);
		return;
	end;

	--if Shaman_NoTarget_RunCommand() then return; end;
	--if Shaman_playerSafe() then return true; end;
	--if Shaman_dps_playerSafe() then return; end;
	--if Shaman_HelpTarget() then return; end;

	if not UnitExists("playertarget") then
		Shaman_SetText("没有目标", 0);		
		return; 
	end;
	if UnitIsDead("playertarget") then
		Shaman_SetText("目标死亡", 0);
		return; 
	end;
	if not UnitCanAttack("player", "target")  then
		Shaman_SetText("友善目标", 0);		
		return;
	end;
	
	if UnitAffectingCombat("player") or IsCurrentAction(Shaman_Auto_Attack()) then
	  --Shaman_AddMessage("Shaman_DPS = "..Shaman_DPS);
	  
		if Shaman_DPS == 1 then
			Shaman_DpsOut1();
		elseif Shaman_DPS == 2 then
			Shaman_DpsOut2();
		else
			Shaman_DpsOut3();
		end
		return;
	else
		isPlague = 0;
	end
	--Shaman_SetText("无动作",0);	
end;
function  Shaman_PlayerVsPlayer()
	return;
end;
function Shaman_AutoDrink()	
	return false;
end

function Shaman_ClearTargetTable()
	if (target_count > 0) then
		target_count = 0;
		target_table = {};
		Shaman_AddMessage("目标数已清零。");
	end;
end
function Shaman_CountTarget(srcGuid,srcName,destGuid,destName)
	if UnitAffectingCombat("player") then
		if not Shaman_Test_IsFriend(destName) then
			if not target_table[destGuid] then 
				target_count = target_count+1;
				target_table[destGuid] = destName; 
				Shaman_AddMessage("战斗中目标数："..target_count.." 目标名字："..destName);
			end;
		elseif not Shaman_Test_IsFriend(srcName) then
			if target_table[srcGuid]==null then 
				target_count = target_count+1;
				target_table[srcGuid] = srcName;
				Shaman_AddMessage("战斗中目标数："..target_count.." 目标名字："..destName);
			end;
		end
	end
end

function Shaman_RunCommand()
	if UnitAffectingCombat("player") then
		local id1 = Shaman_GetActionID("Racial_Troll_Berserk");
		if id1~=0 and null==Shaman_PlayerBU("狂暴") then
			if 0~=IsActionInRange(Shaman_GetActionID("Ability_Shaman_Lavalash")) then -- 灵界打击有效
				if (GetActionCooldown(Shaman_GetActionID("Racial_Troll_Berserk")) == 0) then 
					Shaman_SetText("狂暴",29);
					return true;
				end
			end;
		end
	end
	--local healthperc = GetUnitHealthPercent("player");
	--if null==Shaman_PlayerBU("闪电之盾") and null==Shaman_PlayerBU("水之护盾") and null==Shaman_PlayerBU("大地之盾") then
	--	local powerperc = GetUnitPowerPercent("player");
	--	
	--	if powerperc < 50 then
	--		if Shaman_CastSpell("水之护盾","Ability_Shaman_WaterShield") then return true; end
	--	else
	--		if Shaman_CastSpell("闪电之盾","Spell_Nature_LightningShield") then return true; end		
	--	end		
	--end
	
	return false;
end;
function Shaman_Auto_Trinket()
	if not Shaman_PlayerBU("水手的迅捷") then
		if Shaman_TestTrinket("大副的怀表") and (IsActionInRange(Shaman_GetActionID("Ability_Shaman_Lavalash")) ~= 0)  then
			if Shaman_CastSpell("大副的怀表","INV_Misc_PocketWatch_02") then return true; end		
		end
	end
	if not Shaman_PlayerBU("激烈怒火") then
		if Shaman_TestTrinket("临近风暴之怒") and (IsActionInRange(Shaman_GetActionID("Ability_Shaman_Lavalash")) ~= 0)  then
			if Shaman_CastSpell_IgnoreRange("临近风暴之怒", shaman_action_table["临近风暴之怒"]) then return true; end	
		end
	end
	if not Shaman_PlayerBU("银色英勇") then
		if Shaman_TestTrinket("菲斯克的怀表") and (IsActionInRange(Shaman_GetActionID("Ability_Shaman_Lavalash")) ~= 0)  then
			if Shaman_CastSpell("菲斯克的怀表","INV_Misc_AhnQirajTrinket_03") then return true; end		
		end
	end
	if not Shaman_PlayerBU("野性狂怒") then
		if Shaman_TestTrinket("战歌的热情") and (IsActionInRange(Shaman_GetActionID("Ability_Shaman_Lavalash")) ~= 0)  then
			if Shaman_CastSpell("战歌的热情","INV_Misc_Horn_02") then return true; end		
		end
	end
	if not Shaman_PlayerBU("奥术灌注") then
		if Shaman_TestTrinket("伊萨诺斯甲虫") and (IsActionInRange(Shaman_GetActionID("Ability_Shaman_Lavalash")) ~= 0)  then
			if Shaman_CastSpell_IgnoreRange("伊萨诺斯甲虫", shaman_action_table["伊萨诺斯甲虫"]) then return true; end		
		end
	end
	
	if not Shaman_PlayerBU("精准打击") then
		if Shaman_TestTrinket("苔原护符") and (IsActionInRange(Shaman_GetActionID("Ability_Shaman_Lavalash")) ~= 0)  then
			if Shaman_CastSpell("苔原护符","INV_Jewelcrafting_StarOfElune_03") then return true; end;
		end
	end
	if not Shaman_PlayerBU("凶暴") then
		if Shaman_TestTrinket("刃拳的宽容") and (IsActionInRange(Shaman_GetActionID("Ability_Shaman_Lavalash")) ~= 0)  then
			if Shaman_CastSpell("刃拳的宽容","INV_DataCrystal06") then return true; end		
		end
	end
	if not Shaman_PlayerBU("燃烧之恨") then
		if Shaman_TestTrinket("食人魔殴斗者的徽章") and (IsActionInRange(Shaman_GetActionID("Ability_Shaman_Lavalash")) ~= 0)  then
			if Shaman_CastSpell("食人魔殴斗者的徽章","INV_Jewelry_Talisman_04") then return true; end		
		end
	end
	
	--if Shaman_GetActionID("INV_Misc_MonsterScales_15") ~= 0 then
	--	if Shaman_TestTrinket("嗜血胸针") and (IsActionInRange(Shaman_GetActionID("Ability_Shaman_Lavalash")) == 1)  then
	--		if Shaman_CastSpell("嗜血胸针","INV_Misc_MonsterScales_15") then return true; end		
	--	end
	--end;
	--if  Shaman_GetActionID("INV_ValentinePerfumeBottle") ~= 0 then
	--	if Shaman_TestTrinket("殉难者精华") and (IsActionInRange(Shaman_GetActionID("Spell_Holy_HolyBolt")) == 1)  then
	--		if Shaman_CastSpell("殉难者精华","INV_ValentinePerfumeBottle") then return true; end		
	--	end
	--end  	
	return false;
end
function Shaman_dps_playerSafe()
	--if not Shaman_PlayerDeBU("断筋") or not Shaman_PlayerDeBU("减速药膏") or not Shaman_PlayerDeBU("寒冰箭") or not Shaman_PlayerDeBU("冰冻") or not Shaman_PlayerDeBU("冰霜陷阱光环")
	--	or not Shaman_PlayerDeBU("强化断筋") or not Shaman_PlayerDeBU("减速术") or not Shaman_PlayerDeBU("摔绊") or not Shaman_PlayerDeBU("震荡射击")
	--   	or not Shaman_PlayerDeBU("地缚术") or not Shaman_PlayerDeBU("冰霜震击") or not Shaman_PlayerDeBU("疲劳诅咒") 
	--   	or not Shaman_PlayerDeBU("冰霜新星") or not Shaman_PlayerDeBU("纠缠根须") or not Shaman_PlayerDeBU("霜寒刺骨")  then
	   	
	--end;
	--if not Shaman_PlayerDeBU("偷袭") or not Shaman_PlayerDeBU("肾击") or not Shaman_PlayerDeBU("制裁之锤") then
	--end;
	return false;
end;

function Shaman_PunishingBlow_Debuff()
	if not Shaman_TargetDeBU("月火术") 
	or not Shaman_TargetDeBU("腐蚀术")
	or not Shaman_TargetDeBU("献祭")  
	or not Shaman_TargetDeBU("暗言术：痛") 
	or not Shaman_TargetDeBU("噬灵瘟疫") 
	or not Shaman_TargetDeBU("毒蛇钉刺") 
	then
		return true;
	end
	return false;
end

function Shaman_CheckDebuffByPlayer(debuffName)
	local i = 1;
	local name, _, _, count, _, _, expirationTime, unitCaster = UnitDebuff("target", i);
	while name do 
		--Shaman_AddMessage(string.format("name: %s, debuffName: %s, unitCaster: %s", name, debuffName, unitCaster));
		if (name==debuffName) and (unitCaster=="player" or unitCaster==UnitName("player")) then
			local temp = expirationTime - GetTime();
			--Shaman_AddMessage(debuffName.."剩余时间："..temp.." 秒");
			return true, temp, count;
		end;
		i = i+1;
		name, _, _, count, _, _, expirationTime, unitCaster = UnitDebuff("target", i);
	end 
	return false, 0, 0;
end

-- 元素模式
function Shaman_DpsOut1()
  if Shaman_Test_Target_Debuff() then 
		Shaman_AddMessage(UnitName("target").."目标已经被控制...");			
    Shaman_SetText("目标已经被控制",0);
		return;
	end
	
	if not Shaman_TargetDeBU("飓风术") or not Shaman_TargetBU("圣盾术") or not  Shaman_TargetBU("保护之手") or  not Shaman_TargetBU("寒冰屏障") or not  Shaman_TargetBU("法术反射") or not  Shaman_TargetDeBU("放逐术") then
		Shaman_SetText("目标无法攻击",0);
		return ;
	end;
	
	if (not IsCurrentAction(Shaman_Auto_Attack())) and (not Shaman_Test_Target_Debuff()) then
		--Shaman_SetText("开始攻击",26);	
		Shaman_SetText("攻击", 1);
		return true;
	end;

	if Shaman_playerSafe() then return true; end;
	
  if Shaman_BreakCasting("风剪")==1 and Shaman_CastSpell("风剪", shaman_action_table["风剪"]) then return true; end;

	if UnitIsPlayer("target") and UnitCanAttack("player","target") then
		if Shaman_TargetDeBU("冰霜震击") then
			if Shaman_CastSpell("冰霜震击", shaman_action_table["冰霜震击"]) then return true; end;
		end;
	end;

	-- 增强	Buff
	if Shaman_RunCommand() then return true; end;

	-- 增强饰品
	if Shaman_Auto_Trinket() then return true; end;

  local partyNum = GetNumGroupMembers();
	local power = UnitPower("player");
	if (partyNum >= 1 and power >= 20) or power >= 40 then
	  if Shaman_CastSpell("大地震击", shaman_action_table["大地震击"]) then return true; end;
	end;

	local debuff1, remainTime1 = Shaman_CheckDebuffByPlayer("烈焰震击");

	if (not debuff1 or remainTime1 < 5) then
	  if Shaman_CastSpell("烈焰震击", shaman_action_table["烈焰震击"]) then return true; end;
	end
	
	local buff1, remainTime1, count1 = Shaman_PlayerBU("熔岩奔腾");
	if buff1 then
	  if Shaman_CastSpell("熔岩爆裂", shaman_action_table["熔岩爆裂"]) then return true; end;
	end;
	
	local healthPercent1, maxHealth1 = Shaman_GetPlayerHealthPercent("player");
	local healthPercent2, maxHealth2 = Shaman_GetPlayerHealthPercent("target");
	
	if maxHealth2 > maxHealth1 then
	  if Shaman_CastSpell_IgnoreRange("火元素", shaman_action_table["火元素"]) then return true; end;
	end;
  
	if Shaman_CastSpell_IgnoreRange("元素冲击", shaman_action_table["元素冲击"]) then return true; end;
	
	if Shaman_CastSpell("熔岩爆裂", shaman_action_table["熔岩爆裂"]) then return true; end;
	
	
	--Shaman_AddMessage("tuandui : "..partyNum);
	if partyNum >= 1 then
	  if Shaman_CastSpell("闪电链", shaman_action_table["闪电链"]) then return true; end;
	else
	  if Shaman_CastSpell("闪电箭", shaman_action_table["闪电箭"]) then return true; end;
	end;
	
	Shaman_SetText("无动作",0);
	return;		

end;

-- 增强模式
function Shaman_DpsOut2()
    if Shaman_Test_Target_Debuff() then 
		Shaman_AddMessage(UnitName("target").."目标已经被控制...");			
		Shaman_SetText("目标已经被控制",0);
		return;
	end
	
	if (not IsCurrentAction(Shaman_Auto_Attack())) and (not Shaman_Test_Target_Debuff()) then
		--Shaman_SetText("开始攻击",26);	
		Shaman_SetText("自动攻击", 1);
		return true;
	end;
	if not Shaman_TargetDeBU("飓风术") or not Shaman_TargetBU("圣盾术") or not  Shaman_TargetBU("保护之手") or  not Shaman_TargetBU("寒冰屏障") or not  Shaman_TargetBU("法术反射") or not  Shaman_TargetDeBU("放逐术") then
		Shaman_SetText("目标无法攻击",0);
		return ;
	end;
	if Shaman_playerSafe() then return true; end;
	
	if (IsCurrentAction(Shaman_GetActionID(shaman_action_table["降雨"]))) then 
		Shaman_SetText("降雨",0);
		return true; 
	end;
	
	if Shaman_BreakCasting("风剪")==1 and Shaman_CastSpell("风剪", shaman_action_table["风剪"]) then return true; end;
	
	-- 增强	Buff
	if Shaman_RunCommand() then return true; end;

	-- 增强饰品
	if Shaman_Auto_Trinket() then return true; end;

  local partyNum = GetNumGroupMembers();
	local power = UnitPower("player");
	
	if target_count >= 3 and power >= 20 then
	  if Shaman_CastSpell("毁灭闪电", shaman_action_table["毁灭闪电"]) then return true; end;
	end;

  local buff2, remainTime2, count2 = Shaman_PlayerBU("石拳");
  if not buff2 or remainTime2 < 1 then
    if Shaman_CastSpell("石拳", shaman_action_table["石拳"]) then return true; end;
  end;
  
  local buff3, remainTime3, count3 = Shaman_PlayerBU("火舌");
  if not buff3 then
    if Shaman_CastSpell("火舌", shaman_action_table["火舌"]) then return true; end;
  end;
    
  local buff1, remainTime1, count1 = Shaman_PlayerBU("风暴使者");
  if buff1 or power >= 40 then
    if Shaman_CastSpell("风暴打击", shaman_action_table["风暴打击"]) then return true; end;
  end;
  
  if power >= 70 then
    if Shaman_CastSpell("熔岩猛击", shaman_action_table["熔岩猛击"]) then return true; end;
  elseif power >= 20 then
    if Shaman_CastSpell("风暴打击", shaman_action_table["风暴打击"]) then return true; end;
  end
  
  
  if Shaman_CastSpell("闪电箭", shaman_action_table["闪电箭"]) then return true; end;

	Shaman_SetText("无动作",0);
	return;		

end;

-- 治疗模式
function Shaman_DpsOut3()
    if Shaman_Test_Target_Debuff() then 
		Shaman_AddMessage(UnitName("target").."目标已经被控制...");			
		Shaman_SetText("目标已经被控制",0);
		return;
	end
	
	if (not IsCurrentAction(Shaman_Auto_Attack())) and (not Shaman_Test_Target_Debuff()) then
		mianyi1 = 0; mianyi2 = 0; isPlague = 0;
		--Shaman_SetText("开始攻击",26);	
		Shaman_SetText("自动攻击", 1);
		return true;
	end;
	if not Shaman_TargetDeBU("飓风术") or not Shaman_TargetBU("圣盾术") or not  Shaman_TargetBU("保护之手") or  not Shaman_TargetBU("寒冰屏障") or not  Shaman_TargetBU("法术反射") or not  Shaman_TargetDeBU("放逐术") then
		Shaman_SetText("目标无法攻击",0);
		return ;
	end;
	if Shaman_playerSafe() then return true; end;
	
	if Shaman_BreakCasting("风剪")==1 and Shaman_CastSpell("风剪", shaman_action_table["风剪"]) then return true; end;
	
	-- 增强	Buff
	if Shaman_RunCommand() then return true; end;

	-- 增强饰品
	if Shaman_Auto_Trinket() then return true; end;

	local spell_name,_,_,count = UnitBuff("player", "漩涡武器");
	if spell_name~=null then
		if count>4 then
			if Shaman_CastSpell("闪电箭","Spell_Nature_Lightning") then return true; end;
			if Shaman_CastSpell("闪电链","Spell_Nature_ChainLightning") then return true; end;
		end
	end
	if null~=Shaman_PlayerBU("节能施法") then 
		if Shaman_CastSpell("大地震击","Spell_Nature_EarthShock") then return true; end;
	end
	if Shaman_TargetDeBU("烈焰震击") then
		if Shaman_CastSpell("烈焰震击","Spell_Fire_FlameShock") then return true; end;
		--if Shaman_CastSpell("冰霜震击","Spell_Frost_FrostShock") then return true; end;
	end;
	if 0~=IsActionInRange(Shaman_GetActionID("Ability_Shaman_Lavalash")) then
		if Shaman_CastSpell("熔岩猛击","Ability_Shaman_Lavalash") then return true; end;
		if Shaman_CastSpell("风暴打击","Ability_Shaman_Stormstrike") then return true; end;
	end
	if 0~=IsActionInRange(Shaman_GetActionID("Spell_Nature_EarthShock")) then
		if Shaman_CastSpell("大地震击","Spell_Nature_EarthShock") then return true; end;
		--if Shaman_CastSpell("冰霜震击","Spell_Frost_FrostShock") then return true; end;
	else
		if not Shaman_TargetDeBU("烈焰震击") then
			if Shaman_CastSpell("熔岩爆裂","Spell_Shaman_LavaBurst") then return true; end;
		end
		if Shaman_CastSpell("闪电箭","Spell_Nature_Lightning") then return true; end;
	end
	if UnitCanAttack("player", "target") and UnitName("player")~=tt_name and tt_name~=null then
		
		if Shaman_CastSpell("闪电箭","Spell_Nature_Lightning") then return true; end;
	end
	
	local tt_name = UnitName("targettarget");
	
	Shaman_SetText("无动作",0);
	return;		

end;

function Shaman_BreakCast(LossHealth)
	if UnitExists("playertarget") then
		if not UnitCanAttack("player","target") then
			if UnitIsDeadOrGhost("target") then
				--if Shaman_CastSpell("打断施法","Ability_GolemThunderClap") then return true; end;
				Shaman_SetText("打断施法",27);	
				return true;
			end			
			if (IsActionInRange(Shaman_GetActionID("Spell_Holy_HolyBolt")) ~= 1) then
				--if Shaman_CastSpell("打断施法","Ability_GolemThunderClap") then return true; end;
				Shaman_SetText("打断施法",27);	
				return true;
			end	
			if Shaman_GetPlayerLossHealth("target") < LossHealth then
				--if Shaman_CastSpell("打断施法","Ability_GolemThunderClap") then return true; end;
				Shaman_SetText("打断施法",27);	
				return true;
			end
		else
			if Shaman_GetPlayerLossHealth("player") < LossHealth then
				--if Shaman_CastSpell("打断施法","Ability_GolemThunderClap") then return true; end;
				Shaman_SetText("打断施法",27);	
				return true;
			end
		end
	else
		if Shaman_GetPlayerLossHealth("player") < LossHealth then
				--if Shaman_CastSpell("打断施法","Ability_GolemThunderClap") then return true; end;
				Shaman_SetText("打断施法",27);	
				return true;
		end
	end
	return false;
end

function Shaman_playerSafe()
	local debufftype = Oldhand_TestPlayerDebuff("player");
--	if debufftype==3 or debufftype==2 then
--		if Shaman_CastSpell("驱毒术","Spell_Nature_NullifyPoison") then return true; end;
--	end
--	if debufftype==3 or debufftype==2 then
--		if Shaman_CastSpell("净化术", shaman_action_table["净化术"]) then return true; end;
--	end
	if debufftype==1 or debufftype==4 then
		if Shaman_CastSpell("净化灵魂", shaman_action_table["净化灵魂"]) then return true; end;
	end
	
	local HealthPercent, maxHealth = Shaman_GetPlayerHealthPercent("player");
	--Shaman_AddMessage("player health percent: "..HealthPercent);
	if HealthPercent < 60 then
		if Shaman_CastSpell_IgnoreRange("星界转移", shaman_action_table["星界转移"]) then return true; end;
	end;
	
	if Shaman_DPS == 1 or Shaman_DPS == 2 then
  	if HealthPercent < 50 then
  		if Shaman_CastSpell_IgnoreRange("治疗之涌", shaman_action_table["治疗之涌"]) then return true; end;
  	end;
  else
    local spell_name,_,_,count = UnitBuff("player", "漩涡武器");
  	if UnitIsPlayer("playertarget") or HealthPercent < 55 then
  		if (spell_name~=null and count>4) or UnitAffectingCombat("player")==0 then
  			if Shaman_CastSpell("治疗波", shaman_action_table["治疗波"]) then return true; end;
  		end
  	end;
  	if HealthPercent < 60 then
  		if (spell_name~=null and count>3) or UnitAffectingCombat("player")==0 then
  			if Shaman_CastSpell("次级治疗波", shaman_action_table["次级治疗波"]) then return true; end;
  		end		
  	end
  	if HealthPercent < 70 then
  		if UnitAffectingCombat("player")==0 then
  			if Shaman_CastSpell("治疗波", shaman_action_table["治疗波"]) then return true; end;
  		end	
  	end
  	if HealthPercent < 80 then
  		
  	end
  	if HealthPercent < 90 then
  		if (Shaman_TestTrinket("英雄勋章")) then
  			if Shaman_CastSpell("英雄勋章","INV_Jewelry_Talisman_07") then return true; end;
  		end
  	end;
	end;
	return false;
end;

function Shaman_SelectPartyTarget(unitid)
	if UnitIsUnit("target", "party"..unitid) then return false; end;
	Shaman_SetText("选取"..unitid.."个队友",unitid+29);
	return true;	
end
function Shaman_GetPlayerManaPercent(unit)
	if UnitIsDeadOrGhost("player") then return 100; end
	local mana, manamax = UnitMana("player"), UnitManaMax("player");
	local ManaPercent = floor(mana*100/manamax+0.5);
	return ManaPercent;	
end
function Shaman_GetPlayerLossHealth(unit)	
	local health, healthmax  = UnitHealth(unit), UnitHealthMax(unit);
	return healthmax - health;	
end
function Shaman_GetPlayerHealthPercent(unit)	
	local health, healthmax  = UnitHealth(unit), UnitHealthMax(unit);
	local healthPercent = floor(health*100/healthmax+0.5);	
	return healthPercent, healthmax;	
end
function Shaman_Do_Reincarnation_CanUseAction(i) 
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

function Shaman_NoControl_Debuff()
	if not Shaman_PlayerDeBU("心灵尖啸") 
	   or not Shaman_PlayerDeBU("精神控制") 
	   or not Shaman_PlayerDeBU("恐惧")
	   or not Shaman_PlayerDeBU("恐惧嚎叫") 	 
	   or not Shaman_PlayerDeBU("女妖媚惑") 
	   or not Shaman_PlayerDeBU("破胆怒吼") 
	   or not Shaman_PlayerDeBU("休眠") 		 
	   or not Shaman_PlayerDeBU("逃跑")
	   or not Shaman_PlayerDeBU("凿击")
	   or not Shaman_PlayerDeBU("媚惑")  
	   or not Shaman_PlayerDeBU("变形术") 
	   or not Shaman_PlayerDeBU("休眠")  
	   or not Shaman_PlayerDeBU("致盲")  		
	   or not Shaman_PlayerDeBU("闷棍") 				
	   or not Shaman_PlayerDeBU("冰冻陷阱") 
	   or not Shaman_PlayerDeBU("肾击") 
	   or not Shaman_PlayerDeBU("忏悔") 
	   or not Shaman_PlayerDeBU("霜寒刺骨")
	   or not Shaman_PlayerDeBU("制裁之锤")	
	   or not Shaman_PlayerDeBU("强化断筋")
	   or not Shaman_PlayerDeBU("冲击")
	   or not Shaman_PlayerDeBU("冰霜新星") 
	   or not Shaman_PlayerDeBU("纠缠根须")
	   or not Shaman_PlayerDeBU("偷袭")
	then
		return true;
	end
	return false;	
end	


function Shaman_IsSpellInRange(spellname,unit)
	if UnitExists(unit) then
		if UnitIsVisible(unit) then
			if IsSpellInRange(spellname,unit) == 1 then
				return true;
			end
		end
	end
	return false;
end
function Shaman_UnitAffectingCombat()
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


function Shaman_CombatLogEvent(event,...)
	if not (playerClass=="萨满祭司") then return; end;
	local timestamp, eventType, sourceGUID, sourceName, sourceFlags, destGUID, destName, destFlags = ...
	local amount, school, resisted, blocked, absorbed, critical, glancing, crushing, missType, enviromentalType,interruptedSpellId, interruptedSpellName, interruptedSpellSchool;

	if eventType == "SPELL_CAST_SUCCESS" then
		spellId, spellName, spellSchool = select(9, ...);
		if CombatLog_Object_IsA(sourceFlags, COMBATLOG_FILTER_HOSTILE_PLAYERS) then
				if spellName == "消失" and sourceName then
					Shaman_Warning_AddMessage("**敌对玩家>>"..sourceName.."<<使用了消失,反隐反隐!**");					
					table.insert(Shaman_Data[UnitName("player")]["Rogue"],{["Command"] = "奉献"});				
					StartTimer("Ability_Shaman_WarCry");					
					return;
				end;
				if spellName == "隐形术" and sourceName then
					Shaman_Warning_AddMessage("**敌对玩家>>"..sourceName.."<<使用了隐形术,反隐反隐!**");					
					table.insert(Shaman_Data[UnitName("player")]["Rogue"],{["Command"] = "奉献"});				
					StartTimer("Ability_Shaman_WarCry");					
					return;
				end;
				if spellName == "闪避" and sourceName then
					Shaman_Warning_AddMessage("**警告:敌对玩家>>"..sourceName.."<<获得闪避效果,效果持续8秒!**");
					return;	
				end;
				if spellName == "圣盾术" and sourceName then					
					Shaman_Warning_AddMessage("**警告:敌对玩家>>"..sourceName.."<<获得".. spellName .."效果!!**");					
					return;	
				end;
				if spellName == "保护之手" and sourceName then
					if destName then
						Shaman_Warning_AddMessage("**警告:敌对玩家>>"..sourceName.."<<给>>"..destName.."<<施放了保护之手!!**");
					else
						Shaman_Warning_AddMessage("**警告:敌对玩家>>"..sourceName.."<<施放了保护之手!!**");
					end;
					return;	
				end;
		end
		if CombatLog_Object_IsA(sourceFlags, COMBATLOG_FILTER_FRIENDLY_UNITS) and spellName then			
			if (spellName == "嘲讽" or spellName == "正义防御" ) and sourceName and destName then
				--Shaman_Warning_AddMessage("**>>"..sourceName.."<<对"..destName.."成功施放了"..spellName.."!**");
			end;			
		end;	
		
		return;
	end;	
	
	if eventType == "SPELL_MISSED" then
		spellId, spellName, spellSchool, missType = select(9, ...);	
		if CombatLog_Object_IsA(sourceFlags, COMBATLOG_FILTER_MINE) and spellName then			
			if missType == "RESIST" then
				Shaman_AddMessage("**>>"..destName.."<<抵抗了"..sourceName.."的"..spellName.."!**");
			elseif missType == "IMMUNE" then
				Shaman_AddMessage("**>>"..destName.."<<免疫了"..sourceName.."的"..spellName.."!**");
				if spellName == "冰冷触摸" then mianyi1 = 1;end;
				if spellName == "心灵冰冻" then mianyi2 = 1;end;
				if sourceName == UnitName("player") then
				      local g_FindNpcName = false;
				      for k, v in pairs(Shaman_SaveData) do		       
					      if v["npcname"] == destName and  v["spellname"] == spellName then  
						 g_FindNpcName = true;
					      end
				      end
				      if not g_FindNpcName then
					      table.insert(Shaman_SaveData,{["npcname"] = destName,["spellname"] = spellName,});
				      end;
				end;
				return;
			end			
			return;		
		end;
		if CombatLog_Object_IsA(sourceFlags, COMBATLOG_FILTER_FRIENDLY_UNITS) and spellName then			
			if (spellName == "嘲讽" or spellName == "正义防御" ) and sourceName and destName then
				if missType == "RESIST" then
					Shaman_Warning_AddMessage("**>>"..destName.."<<抵抗了"..sourceName.."的"..spellName.."!**");
				elseif missType == "IMMUNE" then
					Shaman_Warning_AddMessage("**>>"..destName.."<<免疫了"..sourceName.."的"..spellName.."!**");					
					return;
				end			
				return;
			end;
			if spellName == "震荡猛击"  and sourceName and destName then
				if missType == "RESIST" then
					Shaman_Warning_AddMessage("**>>"..destName.."<<抵抗了"..sourceName.."的"..spellName.."!**");
				elseif missType == "IMMUNE" then
					Shaman_Warning_AddMessage("**>>"..destName.."<<免疫了"..sourceName.."的"..spellName.."!**");					
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
					Shaman_AddMessage("你的|cffffff00"..spellName.."|r|cff00ff00对|r|cffffff00"..destName.."|r|cff00ff00造成|r|cffffff00"..amount.."|r|cff00ff00伤害(|r|cffffff00爆击|r|cff00ff00)...|r");				       
				else
					Shaman_AddMessage("你的|cffffff00"..spellName.."|r|cff00ff00对|r|cffffff00"..destName.."|r|cff00ff00造成|r|cffffff00"..amount.."|r|cff00ff00伤害...|r");				       
				end
			end
		end
	end
	if eventType == "SPELL_HEAL" then
		spellId, spellName, spellSchool, amount, critical = select(9, ...);
		if CombatLog_Object_IsA(sourceFlags, COMBATLOG_FILTER_MINE) and amount > 300 and destName and sourceName then
			if critical then
				Shaman_AddMessage("|cff00ff00你的|cffffff00"..spellName.."|r|cff00ff00给|r|cffffff00"..destName.."|r|cff00ff00恢复|r|cffffff00"..amount.."|r|cff00ff00点生命(|r|cffffff00爆击|r|cff00ff00)...|r");				       
			else
				Shaman_AddMessage("|cff00ff00你的|cffffff00"..spellName.."|r|cff00ff00给|r|cffffff00"..destName.."|r|cff00ff00恢复|r|cffffff00"..amount.."|r|cff00ff00点生命...|r");				       
			end	
			return;
		end;
		if CombatLog_Object_IsA(destFlags, COMBATLOG_FILTER_MINE) and amount > 300 and destName and sourceName then
			if critical then
				Shaman_AddMessage("|cffffff00"..sourceName.."|r|cff00ff00的|cffffff00"..spellName.."|r|cff00ff00给我|cff00ff00恢复|r|cffffff00"..amount.."|r|cff00ff00点生命(|r|cffffff00爆击|r|cff00ff00)...|r");				       
			else
				Shaman_AddMessage("|cffffff00"..sourceName.."|r|cff00ff00的|cffffff00"..spellName.."|r|cff00ff00给我|r|cff00ff00恢复|r|cffffff00"..amount.."|r|cff00ff00点生命...|r");				       
			end			
		end;
		
		return;
	end;
	if event == "COMBAT_LOG_EVENT_UNFILTERED" then
		if eventType == "SPELL_DAMAGE" then
			Shaman_CountTarget(sourceGUID, sourceName, destGUID, destName);
		elseif eventType == "UNIT_DIED" or eventType=="UNIT_DESTROYED" then
			Shaman_DecreaseTarget(sourceGUID, sourceName, destGUID, destName);
		end
	end
end

function Shaman_DecreaseTarget(sourceGUID, sourceName, destGUID, destName)
	if target_count > 0 then
		if not Shaman_Test_IsFriend(srcName) then
			if target_table[srcGuid]~=null then 
				target_count = target_count-1;
				target_table[srcGuid] = null;
				Shaman_AddMessage("战斗中目标数："..target_count.." "..destName.." 已被杀死或摧毁");
			end;
		end
	end
end

function Shaman_Test()	
	for i = 1, 120 do
		if ( HasAction(i) ) then
			local texture = GetActionTexture(i);
			local text = GetActionText(i);
			DEFAULT_CHAT_FRAME:AddMessage(i.." |cffffff00" .. texture .. "|r");
		end;		
	end;
	
end;

function Shaman_Use_INV_Jewelry_TrinketPVP_02()
	if UnitIsPlayer("playertarget") then 
		if Shaman_NoControl_Debuff() then
			if Shaman_TestTrinket("部落徽记") or Shaman_TestTrinket("部落勋章")  then 
				if Shaman_CastSpell("部落徽记","INV_Jewelry_TrinketPVP_02") then 
					--StartTimer("INV_Jewelry_TrinketPVP")
					return true; 
				end		
			end	
			if Shaman_TestTrinket("联盟徽记") or Shaman_TestTrinket("联盟勋章")  then
				if Shaman_CastSpell("联盟徽记","INV_Jewelry_TrinketPVP_01") then 
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
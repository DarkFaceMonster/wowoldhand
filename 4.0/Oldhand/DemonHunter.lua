
DemonHunter_SaveData = nil;
DemonHunter_Data = nil;

DemonHunter_PlayerTalentInfoDatas = {};

local dynamicMicroID = 72;
local playerClass;
local DemonHunter_DPS = 1; -- 默认浩劫，1浩劫，2复仇，3
local DemonHunter_Reincarnation  = false;
local DemonHunter_Free  = false;
local DemonHunter_RaidFlag = 0;
local DemonHunter_Old_UnitPopup_OnClick;
local DemonHunter_AutoFollowName="";
local TestHelpTarget = "";
local target_count = 0;		-- 目标个数
local target_table = {};	

local DemonHunter_action_table = {};

DemonHunter_action_table["自动攻击"] = 1278164;

-- 浩劫
DemonHunter_action_table["恶魔之咬"] = 135561;
DemonHunter_action_table["混乱打击"] = 1305152;
DemonHunter_action_table["毁灭"] = 1303275;
DemonHunter_action_table["幽灵视觉"] = 1247266;
DemonHunter_action_table["眼棱"] = 1305156;
DemonHunter_action_table["邪能冲撞"] = 1247261;
DemonHunter_action_table["投掷利刃"] = 1305159;
DemonHunter_action_table["刃舞"] = 1305149;
DemonHunter_action_table["死亡横扫"] = 1309099;
DemonHunter_action_table["吞噬魔法"] = 1305153;
DemonHunter_action_table["恶魔变形"] = 1247262;
DemonHunter_action_table["疾影"] = 1305150;
DemonHunter_action_table["幻影打击"] = 1305154;
DemonHunter_action_table["混乱新星"] = 1305159;
DemonHunter_action_table["献祭光环"] = 1344649;
--DemonHunter_action_table["伊利达雷之怒"] = 1117778;

-- 复仇
DemonHunter_action_table["裂魂"] = 1344648;
DemonHunter_action_table["灵魂裂劈"] = 1344653;
DemonHunter_action_table["折磨"] = 1344654;
DemonHunter_action_table["恶魔尖刺"] = 1344645;
DemonHunter_action_table["恶魔变形"] = 1247263;
DemonHunter_action_table["邪能之刃"] = 1344646;
DemonHunter_action_table["献祭光环"] = 1344649;
DemonHunter_action_table["烈火烙印"] = 1344647;
DemonHunter_action_table["瓦解"] = 1305153;
DemonHunter_action_table["投掷利刃"] = 1305159;
DemonHunter_action_table["沉默咒符"] = 1418288;
DemonHunter_action_table["烈焰咒符"] = 1344652;
DemonHunter_action_table["悲苦咒符"] = 1418287;
DemonHunter_action_table["灵魂壁障"] = 2065625;


-- 饰品
DemonHunter_action_table["临近风暴之怒"] = 236164;
DemonHunter_action_table["伊萨诺斯甲虫"] = 236164;

DemonHunter_action_table["治疗石"] = 538745;

function DemonHunter_CreateMacro()	
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

	if GetMacroIndexByName("法术洪流") == 0 then
		CreateMacro("法术洪流", 53, "/cast 法术洪流", 1, 0);
	end;

	if GetMacroIndexByName("更换模式") == 0 then
		CreateMacro("更换模式", 61, "/script DemonHunter_Input(1);", 1, 1);
	end;	
	PickupMacro("更换模式");
	PlaceAction(49);
	ClearCursor();	
	if DemonHunter_DPS == 1 then
		if GetMacroIndexByName("浩劫模式") == 0 then
			CreateMacro("浩劫模式", 62, "/script DemonHunter_Input(1);", 0, 0);
		end;
		PickupMacro("浩劫模式");
	elseif DemonHunter_DPS == 1 then
		if GetMacroIndexByName("复仇模式") == 0 then
			CreateMacro("复仇模式", 62, "/script DemonHunter_Input(1);", 0, 0);
		end;
		PickupMacro("复仇模式");
	end
	PlaceAction(50);
	ClearCursor();

  Oldhand_PutAction("自动攻击", 1);
 
  if DemonHunter_DPS == 1 then

  elseif DemonHunter_DPS == 2 then

  --elseif DemonHunter_DPS == 3 then

  end;

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
	
	Oldhand_PutAction("奥术洪流", 51);

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
	--SetBindingMacro(";","打断施法");	-- 27
	--SetBindingMacro("\\","开始攻击");	-- 26
	
	SaveBindings(1);
end;

function DemonHunter_NoTarget_RunCommand()
	return DemonHunter_RunCommand();
end;

function DemonHunter_AutoDrink()	
	return false;
end

function DemonHunter_RunCommand()
	if UnitAffectingCombat("player") then
		local id1 = Oldhand_GetActionID("Racial_Troll_Berserk");
		if id1~=0 and null==Oldhand_PlayerBU("战争践踏") then
			if 0~=IsActionInRange(Oldhand_GetActionID("Ability_DemonHunter_Lavalash")) then -- 灵界打击有效
				if (GetActionCooldown(Oldhand_GetActionID("Racial_Troll_Berserk")) == 0) then 
					Oldhand_SetText("战争践踏",29);
					return true;
				end
			end;
		end
	end
	return false;
end;

function DemonHunter_Auto_Trinket()
  if not Oldhand_PlayerBU("水手的迅捷") then
		if Oldhand_TestTrinket("大副的怀表") and (IsActionInRange(Oldhand_GetActionID("Ability_DemonHunter_Lavalash")) ~= 0)  then
			if Oldhand_CastSpell("大副的怀表", "INV_Misc_PocketWatch_02") then return true; end		
		end
	end
	if not Oldhand_PlayerBU("激烈怒火") then
		if Oldhand_TestTrinket("临近风暴之怒") and (IsActionInRange(Oldhand_GetActionID("Ability_DemonHunter_Lavalash")) ~= 0)  then
			if Oldhand_CastSpell_IgnoreRange("临近风暴之怒", DemonHunter_action_table["临近风暴之怒"]) then return true; end	
		end
	end
	if not Oldhand_PlayerBU("银色英勇") then
		if Oldhand_TestTrinket("菲斯克的怀表") and (IsActionInRange(Oldhand_GetActionID("Ability_DemonHunter_Lavalash")) ~= 0)  then
			if Oldhand_CastSpell("菲斯克的怀表", "INV_Misc_AhnQirajTrinket_03") then return true; end		
		end
	end
	if not Oldhand_PlayerBU("野性狂怒") then
		if Oldhand_TestTrinket("战歌的热情") and (IsActionInRange(Oldhand_GetActionID("Ability_DemonHunter_Lavalash")) ~= 0)  then
			if Oldhand_CastSpell("战歌的热情", "INV_Misc_Horn_02") then return true; end		
		end
	end
	if not Oldhand_PlayerBU("奥术灌注") then
		if Oldhand_TestTrinket("伊萨诺斯甲虫") and (IsActionInRange(Oldhand_GetActionID("Ability_DemonHunter_Lavalash")) ~= 0)  then
			if Oldhand_CastSpell_IgnoreRange("伊萨诺斯甲虫", DemonHunter_action_table["伊萨诺斯甲虫"]) then return true; end		
		end
	end
	
	if not Oldhand_PlayerBU("精准打击") then
		if Oldhand_TestTrinket("苔原护符") and (IsActionInRange(Oldhand_GetActionID("Ability_DemonHunter_Lavalash")) ~= 0)  then
			if Oldhand_CastSpell("苔原护符", "INV_Jewelcrafting_StarOfElune_03") then return true; end;
		end
	end
	if not Oldhand_PlayerBU("凶暴") then
		if Oldhand_TestTrinket("刃拳的宽容") and (IsActionInRange(Oldhand_GetActionID("Ability_DemonHunter_Lavalash")) ~= 0)  then
			if Oldhand_CastSpell("刃拳的宽容", "INV_DataCrystal06") then return true; end		
		end
	end
	if not Oldhand_PlayerBU("燃烧之恨") then
		if Oldhand_TestTrinket("食人魔殴斗者的徽章") and (IsActionInRange(Oldhand_GetActionID("Ability_DemonHunter_Lavalash")) ~= 0)  then
			if Oldhand_CastSpell("食人魔殴斗者的徽章", "INV_Jewelry_Talisman_04") then return true; end		
		end
	end
	
	--if Oldhand_GetActionID("INV_Misc_MonsterScales_15") ~= 0 then
	--	if Oldhand_TestTrinket("嗜血胸针") and (IsActionInRange(Oldhand_GetActionID("Ability_DemonHunter_Lavalash")) == 1)  then
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

function DemonHunter_dps_playerSafe()
	--if not DemonHunter_PlayerDeBU("断筋") or not DemonHunter_PlayerDeBU("减速药膏") or not DemonHunter_PlayerDeBU("寒冰箭") or not DemonHunter_PlayerDeBU("冰冻") or not DemonHunter_PlayerDeBU("冰霜陷阱光环")
	--	or not DemonHunter_PlayerDeBU("强化断筋") or not DemonHunter_PlayerDeBU("减速术") or not DemonHunter_PlayerDeBU("摔绊") or not DemonHunter_PlayerDeBU("震荡射击")
	--   	or not DemonHunter_PlayerDeBU("地缚术") or not DemonHunter_PlayerDeBU("冰霜震击") or not DemonHunter_PlayerDeBU("疲劳诅咒") 
	--   	or not DemonHunter_PlayerDeBU("冰霜新星") or not DemonHunter_PlayerDeBU("纠缠根须") or not DemonHunter_PlayerDeBU("霜寒刺骨")  then
	   	
	--end;
	--if not DemonHunter_PlayerDeBU("偷袭") or not DemonHunter_PlayerDeBU("肾击") or not DemonHunter_PlayerDeBU("制裁之锤") then
	--end;
	return false;
end;

--function DemonHunter_PunishingBlow_Debuff()
--	if not Oldhand_TargetDeBU("月火术") 
--	or not Oldhand_TargetDeBU("腐蚀术")
--	or not Oldhand_TargetDeBU("献祭")  
--	or not Oldhand_TargetDeBU("暗言术：痛") 
--	or not Oldhand_TargetDeBU("噬灵瘟疫") 
--	or not Oldhand_TargetDeBU("毒蛇钉刺") 
--	then
--		return true;
--	end
--	return false;
--end

function DemonHunter_DpsOut(dps_mode)
  DemonHunter_DPS = dps_mode;
  if dps_mode == 1 then
    DemonHunter_DpsOut1();
  elseif dps_mode == 2 then
    DemonHunter_DpsOut2();
  else
    Oldhand_AddMessage("错误的天赋模式："..dps_mode);
  end;
end;

-- 浩劫模式
function DemonHunter_DpsOut1()
  if Oldhand_Test_Target_Debuff() then 
		Oldhand_AddMessage(UnitName("target").."目标已经被控制...");			
		Oldhand_SetText("目标已经被控制", 0);
		return;
	end
	
	if (not IsCurrentAction(Oldhand_Auto_Attack())) and (not Oldhand_Test_Target_Debuff()) then
		--Oldhand_SetText("开始攻击",26);	
		Oldhand_SetText("自动攻击", 1);
		return true;
	end;
	if not Oldhand_TargetDeBU("飓风术") or not Oldhand_TargetBU("圣盾术") or not  Oldhand_TargetBU("保护之手") or  not Oldhand_TargetBU("寒冰屏障") or not  Oldhand_TargetBU("法术反射") or not  Oldhand_TargetDeBU("放逐术") then
		Oldhand_SetText("目标无法攻击", 0);
		return ;
	end;
	if DemonHunter_playerSafe() then return true;end;
	
	local power = UnitPower("player");
	
	-- 浩劫	Buff
	if DemonHunter_RunCommand() then return true; end;

	-- 浩劫饰品
	if DemonHunter_Auto_Trinket() then return true; end;
	
	-- 近战范围		
	local isNearAction = IsActionInRange(Oldhand_GetActionID(DemonHunter_action_table["恶魔之咬"]));
	
	if Oldhand_BreakCasting("瓦解")==1 then
	  if Oldhand_CastSpell("瓦解", DemonHunter_action_table["瓦解"]) then return true; end;
	end;
	
	if not isNearAction then
	  if Oldhand_CastSpell("投掷利刃", DemonHunter_action_table["投掷利刃"]) then return true; end;
	else
  	-- local partyNum = GetNumGroupMembers();
    if Oldhand_CastSpell_IgnoreRange("献祭光环", DemonHunter_action_table["献祭光环"]) then return true; end;
    
    if (isNearAction and power >= 30) then
  	   if Oldhand_CastSpell_IgnoreRange("眼棱", DemonHunter_action_table["眼棱"]) then return true; end;
  	   if Oldhand_CastSpell_IgnoreRange("死亡横扫", DemonHunter_action_table["死亡横扫"]) then return true; end;
  	   if Oldhand_CastSpell_IgnoreRange("刃舞", DemonHunter_action_table["刃舞"]) then return true; end;  	   
    end;	
  	
    if power >= 40 then
       if Oldhand_CastSpell("毁灭", DemonHunter_action_table["毁灭"]) then return true; end;
       if Oldhand_CastSpell("混乱打击", DemonHunter_action_table["混乱打击"]) then return true; end;      
    end
    
----if not Oldhand_PlayerBU("战吼") then
----	if Oldhand_CastSpell_IgnoreRange("战吼", DemonHunter_action_table["战吼"]) then return true; end;
----end  
    
    if Oldhand_CastSpell("恶魔之咬", DemonHunter_action_table["恶魔之咬"]) then return true; end;
    
    if Oldhand_CastSpell("投掷利刃", DemonHunter_action_table["投掷利刃"]) then return true; end;

	end;
 
	Oldhand_SetText("无动作",0);
	return;

end;

-- 复仇模式
function DemonHunter_DpsOut2()
  if Oldhand_Test_Target_Debuff() then 
		Oldhand_AddMessage(UnitName("target").."目标已经被控制...");			
		Oldhand_SetText("目标已经被控制", 0);
		return;
	end
	
	if (not IsCurrentAction(Oldhand_Auto_Attack())) and (not Oldhand_Test_Target_Debuff()) then
		--Oldhand_SetText("开始攻击",26);	
		Oldhand_SetText("自动攻击", 1);
		return true;
	end;
	if not Oldhand_TargetDeBU("飓风术") or not Oldhand_TargetBU("圣盾术") or not  Oldhand_TargetBU("保护之手") or  not Oldhand_TargetBU("寒冰屏障") or not  Oldhand_TargetBU("法术反射") or not  Oldhand_TargetDeBU("放逐术") then
		Oldhand_SetText("目标无法攻击", 0);
		return ;
	end;
	if DemonHunter_playerSafe() then return true;end;
	
	local power = UnitPower("player");
  
	local spellname = UnitCastingInfo("target") 
	
	-- 复仇	Buff
	if DemonHunter_RunCommand() then return true; end;

	-- 复仇饰品
	if DemonHunter_Auto_Trinket() then return true; end;
	
	-- 近战范围		
	local isNearAction = IsActionInRange(Oldhand_GetActionID(DemonHunter_action_table["裂魂"]));
	
	if Oldhand_BreakCasting("瓦解")==1 then
	  if Oldhand_CastSpell("瓦解", DemonHunter_action_table["瓦解"]) then return true; end;
	end;
	
	if not isNearAction then
    if Oldhand_CastSpell("邪能之刃", DemonHunter_action_table["邪能之刃"]) then return true; end;     
    if Oldhand_CastSpell("投掷利刃", DemonHunter_action_table["投掷利刃"]) then return true; end;
    if Oldhand_CastSpell("烈火烙印", DemonHunter_action_table["烈火烙印"]) then return true; end;
	else
	
    if Oldhand_CastSpell("烈火烙印", DemonHunter_action_table["烈火烙印"]) then return true; end;
	
	  if Oldhand_CastSpell_IgnoreRange("献祭光环", DemonHunter_action_table["献祭光环"]) then return true; end;
	  
	  if Oldhand_CastSpell_IgnoreRange("沉默咒符", DemonHunter_action_table["沉默咒符"]) then return true; end;

	  if power >= 30 then
       if Oldhand_CastSpell("灵魂裂劈", DemonHunter_action_table["灵魂裂劈"]) then return true; end;
    end
  	  
    if Oldhand_CastSpell("投掷利刃", DemonHunter_action_table["投掷利刃"]) then return true; end;
    
    if Oldhand_CastSpell_IgnoreRange("烈焰咒符", DemonHunter_action_table["烈焰咒符"]) then return true; end;

    if Oldhand_CastSpell("邪能之刃", DemonHunter_action_table["邪能之刃"]) then return true; end;
    	    
    if Oldhand_CastSpell("裂魂", DemonHunter_action_table["裂魂"]) then return true; end;	  
	
	end;
 
	Oldhand_SetText("无动作",0);
	return;

end;

function DemonHunter_DpsOut3()

end;

function DemonHunter_playerSafe()
  local HealthPercent = Oldhand_GetPlayerHealthPercent("player");
  if HealthPercent < 70 then
    if Oldhand_CastSpell_IgnoreRange("治疗石", DemonHunter_action_table["治疗石"]) then return true; end;
  end;
  if (DemonHunter_DPS == 1) then
    if (HealthPercent < 70) then  
  	  if Oldhand_CastSpellIgnoreRange("疾影", DemonHunter_action_table["疾影"]) then return true; end;
  	end;
    if (HealthPercent < 60) then
  	  if Oldhand_CastSpellIgnoreRange("幻影打击", DemonHunter_action_table["幻影打击"]) then return true; end;
  	end;
    if (HealthPercent < 50) then
  	  if Oldhand_CastSpellIgnoreRange("混乱新星", DemonHunter_action_table["混乱新星"]) then return true; end;
  	end;
	end;
	
	if (DemonHunter_DPS == 2) then
  	if (HealthPercent < 50) then
  	  if Oldhand_CastSpellIgnoreRange("悲苦咒符", DemonHunter_action_table["悲苦咒符"]) then return true; end;
  	end;
  	if (HealthPercent < 60) then	    
  	  if Oldhand_CastSpellIgnoreRange("恶魔变形", DemonHunter_action_table["恶魔变形"]) then return true; end;
  	end;
  	if (HealthPercent < 80) then
  	  if Oldhand_CastSpellIgnoreRange("灵魂壁障", DemonHunter_action_table["灵魂壁障"]) then return true; end;
  	end;
  	if (HealthPercent < 90) then
  	  if Oldhand_CastSpellIgnoreRange("恶魔尖刺", DemonHunter_action_table["恶魔尖刺"]) then return true; end;
  	end;
	end;
	return false;
end;

function DemonHunter_Do_Reincarnation_CanUseAction(i) 
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

function DemonHunter_UnitAffectingCombat()
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

function DemonHunter_Use_INV_Jewelry_TrinketPVP_02()
	if UnitIsPlayer("playertarget") then 
		if DemonHunter_NoControl_Debuff() then
			if Oldhand_TestTrinket("部落徽记") or Oldhand_TestTrinket("部落勋章")  then 
				if Oldhand_CastSpell("部落徽记","INV_Jewelry_TrinketPVP_02") then 
					--StartTimer("INV_Jewelry_TrinketPVP")
					return true; 
				end		
			end	
			if Oldhand_TestTrinket("联盟徽记") or Oldhand_TestTrinket("联盟勋章")  then
				if Oldhand_CastSpell("联盟徽记","INV_Jewelry_TrinketPVP_01") then 
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
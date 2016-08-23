
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
shaman_action_table["升腾"] = 135791;


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

local spell_table = {};
spell_table["临近风暴之怒"] = 72;
spell_table["大副的怀表"] = 71;

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


  Oldhand_PutAction("治疗之涌", 7);
  Oldhand_PutAction("先祖之魂", 11);
  
  Oldhand_PutAction("嗜血", 62);
  Oldhand_PutAction("星界转移", 63);
  Oldhand_PutAction("风剪", 64);
  Oldhand_PutAction("陷地图腾", 65);
  Oldhand_PutAction("净化术", 69);
  Oldhand_PutAction("净化灵魂", 70);
  
  if Shaman_DPS == 1 then
    Oldhand_PutAction("闪电箭", 2);
    Oldhand_PutAction("烈焰震击", 3);
    Oldhand_PutAction("熔岩爆裂", 4);
    Oldhand_PutAction("大地震击", 5);
    Oldhand_PutAction("冰霜震击", 6);
    Oldhand_PutAction("闪电链", 8);
    Oldhand_PutAction("雷霆风暴", 9);
    Oldhand_PutAction("元素冲击", 10);
    
    Oldhand_PutAction("图腾掌握", 12);
    
    Oldhand_PutAction("升腾", 65);
    Oldhand_PutAction("震地图腾", 66);
    Oldhand_PutAction("土元素", 67);
    Oldhand_PutAction("火元素", 68);
  elseif Shaman_DPS == 2 then
    Oldhand_PutAction("火舌", 2);
    Oldhand_PutAction("石拳", 3);
    Oldhand_PutAction("冰封", 4);
    Oldhand_PutAction("熔岩猛击", 5);
    Oldhand_PutAction("风暴打击", 6);
    Oldhand_PutAction("闪电箭", 8);
    Oldhand_PutAction("毁灭闪电", 9);
    
    Oldhand_PutAction("野性狼魂", 66);
    Oldhand_PutAction("降雨", 67);
    Oldhand_PutAction("幽魂步", 68);  
  elseif Shaman_DPS == 3 then
  
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

function Shaman_NoTarget_RunCommand()
	return Shaman_RunCommand();
end;

function Shaman_AutoDrink()	
	return false;
end

function Shaman_RunCommand()
	if UnitAffectingCombat("player") then
		local id1 = Oldhand_GetActionID("Racial_Troll_Berserk");
		if id1~=0 and null==Oldhand_PlayerBU("狂暴") then
			if 0~=IsActionInRange(Oldhand_GetActionID("Ability_Shaman_Lavalash")) then -- 灵界打击有效
				if (GetActionCooldown(Oldhand_GetActionID("Racial_Troll_Berserk")) == 0) then 
					Oldhand_SetText("狂暴",29);
					return true;
				end
			end;
		end
	end	
	return false;
end;

function Shaman_Auto_Trinket()
	if not Oldhand_PlayerBU("水手的迅捷") then
		if Oldhand_TestTrinket("大副的怀表") and (IsActionInRange(Oldhand_GetActionID("Ability_Shaman_Lavalash")) ~= 0)  then
			if Oldhand_CastSpell("大副的怀表","INV_Misc_PocketWatch_02") then return true; end		
		end
	end
	if not Oldhand_PlayerBU("激烈怒火") then
		if Oldhand_TestTrinket("临近风暴之怒") and (IsActionInRange(Oldhand_GetActionID("Ability_Shaman_Lavalash")) ~= 0)  then
			if Oldhand_CastSpell_IgnoreRange("临近风暴之怒", shaman_action_table["临近风暴之怒"]) then return true; end	
		end
	end
	if not Oldhand_PlayerBU("银色英勇") then
		if Oldhand_TestTrinket("菲斯克的怀表") and (IsActionInRange(Oldhand_GetActionID("Ability_Shaman_Lavalash")) ~= 0)  then
			if Oldhand_CastSpell("菲斯克的怀表","INV_Misc_AhnQirajTrinket_03") then return true; end		
		end
	end
	if not Oldhand_PlayerBU("野性狂怒") then
		if Oldhand_TestTrinket("战歌的热情") and (IsActionInRange(Oldhand_GetActionID("Ability_Shaman_Lavalash")) ~= 0)  then
			if Oldhand_CastSpell("战歌的热情","INV_Misc_Horn_02") then return true; end		
		end
	end
	if not Oldhand_PlayerBU("奥术灌注") then
		if Oldhand_TestTrinket("伊萨诺斯甲虫") and (IsActionInRange(Oldhand_GetActionID("Ability_Shaman_Lavalash")) ~= 0)  then
			if Oldhand_CastSpell_IgnoreRange("伊萨诺斯甲虫", shaman_action_table["伊萨诺斯甲虫"]) then return true; end		
		end
	end
	
	if not Oldhand_PlayerBU("精准打击") then
		if Oldhand_TestTrinket("苔原护符") and (IsActionInRange(Oldhand_GetActionID("Ability_Shaman_Lavalash")) ~= 0)  then
			if Oldhand_CastSpell("苔原护符","INV_Jewelcrafting_StarOfElune_03") then return true; end;
		end
	end
	if not Oldhand_PlayerBU("凶暴") then
		if Oldhand_TestTrinket("刃拳的宽容") and (IsActionInRange(Oldhand_GetActionID("Ability_Shaman_Lavalash")) ~= 0)  then
			if Oldhand_CastSpell("刃拳的宽容","INV_DataCrystal06") then return true; end		
		end
	end
	if not Oldhand_PlayerBU("燃烧之恨") then
		if Oldhand_TestTrinket("食人魔殴斗者的徽章") and (IsActionInRange(Oldhand_GetActionID("Ability_Shaman_Lavalash")) ~= 0)  then
			if Oldhand_CastSpell("食人魔殴斗者的徽章","INV_Jewelry_Talisman_04") then return true; end		
		end
	end
	
	--if Oldhand_GetActionID("INV_Misc_MonsterScales_15") ~= 0 then
	--	if Oldhand_TestTrinket("嗜血胸针") and (IsActionInRange(Oldhand_GetActionID("Ability_Shaman_Lavalash")) == 1)  then
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

function Shaman_DpsOut(dps_mode)
  Shaman_DPS = dps_mode;
  if dps_mode == 1 then
    Shaman_DpsOut1();
  elseif dps_mode == 2 then
    Shaman_DpsOut2();
  elseif dps_mode == 3 then
    Shaman_DpsOut3();
  else
    Oldhand_AddMessage("错误的天赋模式："..dps_mode);
  end;
end;

-- 元素模式
function Shaman_DpsOut1()
  if Oldhand_Test_Target_Debuff() then 
		Oldhand_AddMessage(UnitName("target").."目标已经被控制...");			
    Oldhand_SetText("目标已经被控制",0);
		return;
	end
	
	if not Oldhand_TargetDeBU("飓风术") or not Oldhand_TargetBU("圣盾术") or not  Oldhand_TargetBU("保护之手") or  not Oldhand_TargetBU("寒冰屏障") or not  Oldhand_TargetBU("法术反射") or not  Oldhand_TargetDeBU("放逐术") then
		Oldhand_SetText("目标无法攻击",0);
		return ;
	end;
	
	if (not IsCurrentAction(Oldhand_Auto_Attack())) and (not Oldhand_Test_Target_Debuff()) then
		--Oldhand_SetText("开始攻击",26);	
		Oldhand_SetText("攻击", 1);
		return true;
	end;

	if Shaman_playerSafe() then return true; end;
	
  if Oldhand_BreakCasting("风剪")==1 and Oldhand_CastSpell("风剪", shaman_action_table["风剪"]) then return true; end;

	if UnitIsPlayer("target") and UnitCanAttack("player","target") then
		if Oldhand_TargetDeBU("冰霜震击") then
			if Oldhand_CastSpell("冰霜震击", shaman_action_table["冰霜震击"]) then return true; end;
		end;
	end;

	-- 增强	Buff
	if Shaman_RunCommand() then return true; end;

	-- 增强饰品
	if Shaman_Auto_Trinket() then return true; end;

  local partyNum = GetNumGroupMembers();
	local power = UnitPower("player");
	if (partyNum >= 1 and power >= 20) or power >= 40 then
	  if Oldhand_CastSpell("大地震击", shaman_action_table["大地震击"]) then return true; end;
	end;

	local debuff1, remainTime1 = Oldhand_CheckDebuffByPlayer("烈焰震击");

	if (not debuff1 or remainTime1 < 5) then
	  if Oldhand_CastSpell("烈焰震击", shaman_action_table["烈焰震击"]) then return true; end;
	end
	
	if Oldhand_CastSpell_IgnoreRange("升腾", shaman_action_table["升腾"]) then return true; end;
	
	local buff1, remainTime1, count1 = Oldhand_PlayerBU("熔岩奔腾");
	if buff1 then
	  if Oldhand_CastSpell("熔岩爆裂", shaman_action_table["熔岩爆裂"]) then return true; end;
	end;
	
	local healthPercent1, maxHealth1 = Oldhand_GetPlayerHealthPercent("player");
	local healthPercent2, maxHealth2 = Oldhand_GetPlayerHealthPercent("target");
	
	if maxHealth2 > maxHealth1 or partyNum >= 1 then
	  if Oldhand_CastSpell_IgnoreRange("火元素", shaman_action_table["火元素"]) then return true; end;
	end;

	local haveTotem, totemName, startTime, duration = GetTotemInfo(1);
	if ""==totemName and startTime == 0 and maxHealth2 > maxHealth1 * 3 then
	  --local id = Oldhand_GetActionID(shaman_action_table["图腾掌握"]);
	  --Oldhand_AddMessage("id: "..id);
	  --if id >= 61 then id = id - 48; end;
	  --Oldhand_SetText("图腾掌握", id);
	  if Oldhand_CastSpell_IgnoreRange("图腾掌握", shaman_action_table["图腾掌握"]) then return true; end;
	end;
	  
	if Oldhand_CastSpell("元素冲击", shaman_action_table["元素冲击"]) then return true; end;
	
	if Oldhand_CastSpell("熔岩爆裂", shaman_action_table["熔岩爆裂"]) then return true; end;
	
	--Oldhand_AddMessage("tuandui : "..partyNum);
	if partyNum >= 1 then
	  if Oldhand_CastSpell("闪电链", shaman_action_table["闪电链"]) then return true; end;
	else
	  if Oldhand_CastSpell("闪电箭", shaman_action_table["闪电箭"]) then return true; end;
	end;
	

	 
	Oldhand_SetText("无动作",0);
	return;		

end;

-- 增强模式
function Shaman_DpsOut2()
    if Oldhand_Test_Target_Debuff() then 
		Oldhand_AddMessage(UnitName("target").."目标已经被控制...");			
		Oldhand_SetText("目标已经被控制",0);
		return;
	end
	
	if (not IsCurrentAction(Oldhand_Auto_Attack())) and (not Oldhand_Test_Target_Debuff()) then
		--Oldhand_SetText("开始攻击",26);	
		Oldhand_SetText("自动攻击", 1);
		return true;
	end;
	if not Oldhand_TargetDeBU("飓风术") or not Oldhand_TargetBU("圣盾术") or not  Oldhand_TargetBU("保护之手") or  not Oldhand_TargetBU("寒冰屏障") or not  Oldhand_TargetBU("法术反射") or not  Oldhand_TargetDeBU("放逐术") then
		Oldhand_SetText("目标无法攻击",0);
		return ;
	end;
	if Shaman_playerSafe() then return true; end;
	
	if (IsCurrentAction(Oldhand_GetActionID(shaman_action_table["降雨"]))) then 
		Oldhand_SetText("降雨",0);
		return true; 
	end;
	
	if Oldhand_BreakCasting("风剪")==1 and Oldhand_CastSpell("风剪", shaman_action_table["风剪"]) then return true; end;
	
	-- 增强	Buff
	if Shaman_RunCommand() then return true; end;

	-- 增强饰品
	if Shaman_Auto_Trinket() then return true; end;

  local partyNum = GetNumGroupMembers();
	local power = UnitPower("player");
	
	if Oldhand_TargetCount() >= 3 and power >= 20 then
	  if Oldhand_CastSpell("毁灭闪电", shaman_action_table["毁灭闪电"]) then return true; end;
	end;

  local buff2, remainTime2, count2 = Oldhand_PlayerBU("石拳");
  if not buff2 or remainTime2 < 1 then
    if Oldhand_CastSpell("石拳", shaman_action_table["石拳"]) then return true; end;
  end;
  
  local buff3, remainTime3, count3 = Oldhand_PlayerBU("火舌");
  if not buff3 then
    if Oldhand_CastSpell("火舌", shaman_action_table["火舌"]) then return true; end;
  end;
    
  local buff1, remainTime1, count1 = Oldhand_PlayerBU("风暴使者");
  if buff1 or power >= 40 then
    if Oldhand_CastSpell("风暴打击", shaman_action_table["风暴打击"]) then return true; end;
  end;
  
  if power >= 70 then
    if Oldhand_CastSpell("熔岩猛击", shaman_action_table["熔岩猛击"]) then return true; end;
  elseif power >= 20 then
    if Oldhand_CastSpell("风暴打击", shaman_action_table["风暴打击"]) then return true; end;
  end
  
  
  if Oldhand_CastSpell("闪电箭", shaman_action_table["闪电箭"]) then return true; end;

	Oldhand_SetText("无动作",0);
	return;		

end;

-- 治疗模式
function Shaman_DpsOut3()
    if Oldhand_Test_Target_Debuff() then 
		Oldhand_AddMessage(UnitName("target").."目标已经被控制...");			
		Oldhand_SetText("目标已经被控制",0);
		return;
	end
	
	if (not IsCurrentAction(Oldhand_Auto_Attack())) and (not Oldhand_Test_Target_Debuff()) then
		mianyi1 = 0; mianyi2 = 0; isPlague = 0;
		--Oldhand_SetText("开始攻击",26);	
		Oldhand_SetText("自动攻击", 1);
		return true;
	end;
	if not Oldhand_TargetDeBU("飓风术") or not Oldhand_TargetBU("圣盾术") or not  Oldhand_TargetBU("保护之手") or  not Oldhand_TargetBU("寒冰屏障") or not  Oldhand_TargetBU("法术反射") or not  Oldhand_TargetDeBU("放逐术") then
		Oldhand_SetText("目标无法攻击",0);
		return ;
	end;
	if Shaman_playerSafe() then return true; end;
	
	if Oldhand_BreakCasting("风剪")==1 and Oldhand_CastSpell("风剪", shaman_action_table["风剪"]) then return true; end;
	
	-- 增强	Buff
	if Shaman_RunCommand() then return true; end;

	-- 增强饰品
	if Shaman_Auto_Trinket() then return true; end;

	local spell_name,_,_,count = UnitBuff("player", "漩涡武器");
	if spell_name~=null then
		if count>4 then
			if Oldhand_CastSpell("闪电箭","Spell_Nature_Lightning") then return true; end;
			if Oldhand_CastSpell("闪电链","Spell_Nature_ChainLightning") then return true; end;
		end
	end
	if null~=Oldhand_PlayerBU("节能施法") then 
		if Oldhand_CastSpell("大地震击","Spell_Nature_EarthShock") then return true; end;
	end
	if Oldhand_TargetDeBU("烈焰震击") then
		if Oldhand_CastSpell("烈焰震击","Spell_Fire_FlameShock") then return true; end;
		--if Oldhand_CastSpell("冰霜震击","Spell_Frost_FrostShock") then return true; end;
	end;
	if 0~=IsActionInRange(Oldhand_GetActionID("Ability_Shaman_Lavalash")) then
		if Oldhand_CastSpell("熔岩猛击","Ability_Shaman_Lavalash") then return true; end;
		if Oldhand_CastSpell("风暴打击","Ability_Shaman_Stormstrike") then return true; end;
	end
	if 0~=IsActionInRange(Oldhand_GetActionID("Spell_Nature_EarthShock")) then
		if Oldhand_CastSpell("大地震击","Spell_Nature_EarthShock") then return true; end;
		--if Oldhand_CastSpell("冰霜震击","Spell_Frost_FrostShock") then return true; end;
	else
		if not Oldhand_TargetDeBU("烈焰震击") then
			if Oldhand_CastSpell("熔岩爆裂","Spell_Shaman_LavaBurst") then return true; end;
		end
		if Oldhand_CastSpell("闪电箭","Spell_Nature_Lightning") then return true; end;
	end
	if UnitCanAttack("player", "target") and UnitName("player")~=tt_name and tt_name~=null then
		
		if Oldhand_CastSpell("闪电箭", "Spell_Nature_Lightning") then return true; end;
	end
	
	local tt_name = UnitName("targettarget");
	
	Oldhand_SetText("无动作",0);
	return;		

end;

function Shaman_playerSafe()
	local debufftype = Oldhand_TestPlayerDebuff("player");
--	if debufftype==3 or debufftype==2 then
--		if Oldhand_CastSpell("驱毒术","Spell_Nature_NullifyPoison") then return true; end;
--	end
--	if debufftype==3 or debufftype==2 then
--		if Oldhand_CastSpell("净化术", shaman_action_table["净化术"]) then return true; end;
--	end
	if debufftype==1 or debufftype==4 then
		if Oldhand_CastSpell("净化灵魂", shaman_action_table["净化灵魂"]) then return true; end;
	end
	
	local HealthPercent, maxHealth = Oldhand_GetPlayerHealthPercent("player");
	--Oldhand_AddMessage("player health percent: "..HealthPercent);
	if HealthPercent < 60 then
		if Oldhand_CastSpell_IgnoreRange("星界转移", shaman_action_table["星界转移"]) then return true; end;
	end;
	
	if Shaman_DPS == 1 or Shaman_DPS == 2 then
  	if HealthPercent < 50 then
  		if Oldhand_CastSpell_IgnoreRange("治疗之涌", shaman_action_table["治疗之涌"]) then return true; end;
  	end;
  else
    local spell_name,_,_,count = UnitBuff("player", "漩涡武器");
  	if UnitIsPlayer("playertarget") or HealthPercent < 55 then
  		if (spell_name~=null and count>4) or UnitAffectingCombat("player")==0 then
  			if Oldhand_CastSpell("治疗波", shaman_action_table["治疗波"]) then return true; end;
  		end
  	end;
  	if HealthPercent < 60 then
  		if (spell_name~=null and count>3) or UnitAffectingCombat("player")==0 then
  			if Oldhand_CastSpell("次级治疗波", shaman_action_table["次级治疗波"]) then return true; end;
  		end		
  	end
  	if HealthPercent < 70 then
  		if UnitAffectingCombat("player")==0 then
  			if Oldhand_CastSpell("治疗波", shaman_action_table["治疗波"]) then return true; end;
  		end	
  	end
  	if HealthPercent < 80 then
  		
  	end
  	if HealthPercent < 90 then
  		if (Oldhand_TestTrinket("英雄勋章")) then
  			if Oldhand_CastSpell("英雄勋章","INV_Jewelry_Talisman_07") then return true; end;
  		end
  	end;
	end;
	return false;
end;


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

function Shaman_Use_INV_Jewelry_TrinketPVP_02()
	if UnitIsPlayer("playertarget") then 
		if Shaman_NoControl_Debuff() then
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
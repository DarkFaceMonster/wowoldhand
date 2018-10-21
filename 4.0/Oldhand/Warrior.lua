
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
warrior_action_table["旋风斩"] = 132369;
--  warrior_action_table["战吼"] = 458972;
warrior_action_table["命令怒吼"] = 132351;
warrior_action_table["战斗怒吼"] = 132333;
warrior_action_table["拳击"] = 132938;
warrior_action_table["压制"] = 132223;
warrior_action_table["狂暴之怒"] = 136009;

-- 武器
warrior_action_table["致死打击"] = 132355;
warrior_action_table["横扫攻击"] = 132306;
warrior_action_table["巨人打击"] = 464973;
warrior_action_table["猛击"] = 132340;
warrior_action_table["顺劈斩"] = 132338;
warrior_action_table["剑在人在"] = 132336;
warrior_action_table["风暴之锤"] = 613635;
--  warrior_action_table["战吼"] = 458972;
warrior_action_table["剑刃风暴"] = 236303;
warrior_action_table["乘胜追击"] = 132342;
warrior_action_table["破胆怒吼"] = 132154;
--  warrior_action_table["灭战者"] = 1257950;
warrior_action_table["天神下凡"] = 613534;
--  warrior_action_table["怒火聚焦"] = 132345;
-- 狂怒
warrior_action_table["嗜血"] = 136012;
warrior_action_table["狂暴挥砍"] = 132367;
warrior_action_table["怒击"] = 589119;
warrior_action_table["斩杀"] = 135358;
warrior_action_table["暴怒"] = 132352;
warrior_action_table["狂怒回复"] = 132345;
warrior_action_table["英勇投掷"] = 132453;
warrior_action_table["浴血奋战"] = 236304;

-- 防护
warrior_action_table["毁灭打击"] = 135291;
warrior_action_table["盾牌猛击"] = 134951;
warrior_action_table["雷霆一击"] = 136105;
warrior_action_table["乘胜追击"] = 132342;
warrior_action_table["盾牌格挡"] = 132110;

warrior_action_table["无视苦痛"] = 1377132;
warrior_action_table["震荡波"] = 236312;
warrior_action_table["盾墙"] = 132362;
warrior_action_table["拦截"] = 132365;
warrior_action_table["复仇"] = 132353;
warrior_action_table["集结呐喊"] = 132351;

-- 饰品
warrior_action_table["临近风暴之怒"] = 236164;
warrior_action_table["伊萨诺斯甲虫"] = 236164;
warrior_action_table["霸权印记"] = 134086;
warrior_action_table["残次的反制机关"] = 237468;
warrior_action_table["活性血瓶"] = 1387657;

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

  Oldhand_PutAction("自动攻击", 1);
  Oldhand_PutAction("冲锋", 61);
 
  if Warrior_DPS == 1 then
  elseif Warrior_DPS == 2 then
    Oldhand_PutAction("嗜血", 2);
    Oldhand_PutAction("狂暴挥砍", 3);
    Oldhand_PutAction("暴怒", 4);
    Oldhand_PutAction("狂怒回复", 7);    
    Oldhand_PutAction("斩杀", 62);
    Oldhand_PutAction("怒击", 63);
    
  elseif Warrior_DPS == 3 then
    --Oldhand_PutAction("毁灭打击", 2);
    --Oldhand_PutAction("盾牌猛击", 3);
    --Oldhand_PutAction("雷霆一击", 4);
    --Oldhand_PutAction("盾牌格挡", 7);    
    --Oldhand_PutAction("嘲讽", 62);
    --Oldhand_PutAction("乘胜追击", 63);  
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
	
	Oldhand_PutAction("战争践踏", 51);

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

function Warrior_NoTarget_RunCommand()
	return Warrior_RunCommand();
end;

function Warrior_AutoDrink()	
	return false;
end

function Warrior_RunCommand(isInRange)
  isInRange = isInRange or false;
  local buff = Oldhand_PlayerBU("战斗怒吼");
  if not buff then
    Oldhand_AddMessage("战斗怒吼");
  	if Oldhand_CastSpellByIdIgnoreRange("战斗怒吼", Oldhand_GetActionID(warrior_action_table["战斗怒吼"])) then return true; end;
  end;
	if UnitAffectingCombat("player") then
	  if Oldhand_CastSpellByIdIgnoreRange("天神下凡", Oldhand_GetActionID(warrior_action_table["天神下凡"])) then return true; end;
	  buff = Oldhand_PlayerBU("狂怒");
  	if not buff then
  		if Oldhand_CastSpellByIdIgnoreRange("霸权印记", Oldhand_GetActionID(warrior_action_table["霸权印记"])) then return true; end;
  	end;
    -- if Oldhand_CastSpellByIdIgnoreRange("残次的反制机关", Oldhand_GetActionID(warrior_action_table["残次的反制机关"])) then return true; end;
    
		local id1 = Oldhand_GetActionID("Racial_Troll_Berserk");
		if id1~=0 and null==Oldhand_PlayerBU("战争践踏") then
			if 0~=IsActionInRange(Oldhand_GetActionID("Ability_Warrior_Lavalash")) then -- 灵界打击有效
				if (GetActionCooldown(Oldhand_GetActionID("Racial_Troll_Berserk")) == 0) then 
					Oldhand_SetText("战争践踏",29);
					return true;
				end
			end;
		end
	end
	return false;
end;

function Warrior_Auto_Trinket()
  -- 是否近战范围
  local isNearAction = IsActionInRange(Oldhand_GetActionID(warrior_action_table["斩杀"])) == true;
  
  -- if (isNearAction) then
    if not Oldhand_PlayerBU("狂怒") then         
		  if Oldhand_CastSpellByIdIgnoreRange("霸权印记", warrior_action_table["霸权印记"]) then return true; end;
    end;
	-- end
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

--function Warrior_PunishingBlow_Debuff()
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

function Warrior_DpsOut(dps_mode)
  Warrior_DPS = dps_mode;
  if dps_mode == 1 then
    Warrior_DpsOut1();
  elseif dps_mode == 2 then
    Warrior_DpsOut2();
  elseif dps_mode == 3 then
    Warrior_DpsOut3();
  else
    Oldhand_AddMessage("错误的天赋模式："..dps_mode);
  end;
end;

-- 武器模式
function Warrior_DpsOut1()
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
	if Warrior_playerSafe() then return true;end;

	local power = UnitPower("player");
	
  local partyNum = GetNumGroupMembers();
  local target_count = Oldhand_TargetCount()
	
	-- 近战范围		
	local isNearAction = IsActionInRange(Oldhand_GetActionID(warrior_action_table["猛击"]));
	
	local target_health_percent, target_health = Oldhand_GetPlayerHealthPercent("target");
	local player_health_percent, player_health = Oldhand_GetPlayerHealthPercent("player");
  
	if Oldhand_BreakCasting("拳击")==1 then
	  if Oldhand_CastSpell("拳击", warrior_action_table["拳击"]) then return true; end;
	end;
	
	-- 狂怒	Buff
	if Warrior_RunCommand(isNearAction) then return true; end;

	-- 狂怒饰品
	if Warrior_Auto_Trinket() then return true; end;
	
	-- local buff2, remain_time2, count2 = Oldhand_PlayerBU("怒火聚焦");
  -- if power >= 28 and (not buff2 or count2 < 3) then
  --   if Oldhand_CastSpell_IgnoreRange("怒火聚焦", warrior_action_table["怒火聚焦"]) then return true; end;
  -- end;
  
	-- if not isNearAction and partyNum <= 1 then
	if not isNearAction then
	  if partyNum <= 1 or target_health_percent < 100 and player_health_percent > 50 then
      if Oldhand_CastSpell("冲锋", warrior_action_table["冲锋"]) then return true; end;
	    if Oldhand_CastSpell("英勇投掷", warrior_action_table["英勇投掷"]) then return true; end;
	  end
	else
	  
	  if Oldhand_TestTrinket("活性血瓶") then
    	local buff = Oldhand_PlayerBU("我敌之血");
    	if not buff then
    		if Oldhand_CastSpellIgnoreRange("活性血瓶", warrior_action_table["活性血瓶"]) then return true; end;
    	end;
    end
	  if target_count >= 5 then
      if Oldhand_CastSpell_IgnoreRange("剑刃风暴", warrior_action_table["剑刃风暴"]) then return true; end;
    end;
	  if target_count >= 2 then
  	  if not Oldhand_PlayerBU("横扫攻击") then
  	    if Oldhand_CastSpell_IgnoreRange("横扫攻击", warrior_action_table["横扫攻击"]) then return true; end;
  	  end; 	     
    end;
    
	  local debuff1, remainTime1 = Oldhand_CheckDebuffByPlayer("巨人打击");
    if not debuff1 then
      if Oldhand_CastSpell("巨人打击", warrior_action_table["巨人打击"]) then return true; end;
    end;

    if Oldhand_PlayerBU("猝死") or (target_health_percent < 35 and power >= 28) then
  	  if Oldhand_CastSpell_IgnoreRange("斩杀", warrior_action_table["斩杀"]) then return true; end;
    end;
    
    if target_count >= 4 then
      if Oldhand_CastSpell_IgnoreRange("剑刃风暴", warrior_action_table["剑刃风暴"]) then return true; end;
    end;
    
    if Oldhand_PlayerBU("碾压突袭") then
  	 if Oldhand_CastSpell_IgnoreRange("猛击", warrior_action_table["猛击"]) then return true; end;
  	end;

    if Oldhand_CastSpell("巨人打击", warrior_action_table["巨人打击"]) then return true; end;
    
    if target_count >= 5 then
      if Oldhand_CastSpell_IgnoreRange("旋风斩", warrior_action_table["旋风斩"]) then return true; end;
    end;

    -- if not debuff1 then
    --   if Oldhand_CastSpell("巨人打击", warrior_action_table["巨人打击"]) then return true; end;
    -- end;
    

    if Oldhand_CastSpell("致死打击", warrior_action_table["致死打击"]) then return true; end;

    if Oldhand_CastSpell("压制", warrior_action_table["压制"]) then return true; end;
    
    if Oldhand_CastSpell("猛击", warrior_action_table["猛击"]) then return true; end;

	end;
 
	Oldhand_SetText("无动作",0);
	return;

end;

-- 狂怒模式
function Warrior_DpsOut2()
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
	if Warrior_playerSafe() then return true;end;
	
	local power = UnitPower("player");
	
	local target_health_percent, target_health = Oldhand_GetPlayerHealthPercent("target");
	if target_health_percent <= 20 and power >= 25 then
  	if Oldhand_CastSpell("斩杀", warrior_action_table["斩杀"]) then return true; end;
  end;
  
	local spellname = UnitCastingInfo("target") 
	if null~=spellname then
		if Oldhand_CastSpell("拳击", warrior_action_table["拳击"]) then return true; end;
	end;
	
	-- 狂怒	Buff
	if Warrior_RunCommand() then return true; end;

	-- 狂怒饰品
	if Warrior_Auto_Trinket() then return true; end;
	
	-- 近战范围		
	local isNearAction = IsActionInRange(Oldhand_GetActionID(warrior_action_table["狂暴挥砍"]));
	
	if not isNearAction then
	  if Oldhand_CastSpell("冲锋", warrior_action_table["冲锋"]) then return true; end;
	  if Oldhand_CastSpell("英勇投掷", warrior_action_table["英勇投掷"]) then return true; end;
	else
  	-- local partyNum = GetNumGroupMembers();
  	
  	if not Oldhand_PlayerBU("战吼") then
  		if Oldhand_CastSpell_IgnoreRange("战吼", warrior_action_table["战吼"]) then return true; end;
  	end
  	
   	if not Oldhand_PlayerBU("浴血奋战") then
  		if Oldhand_CastSpell_IgnoreRange("浴血奋战", warrior_action_table["浴血奋战"]) then return true; end;
  	end
  	
    if power >= 85 then
      if Oldhand_CastSpell("暴怒", warrior_action_table["暴怒"]) then return true; end;
    end
    
  	if Oldhand_PlayerBU("摧枯拉朽") then
  	  if Oldhand_CastSpell_IgnoreRange("旋风斩", warrior_action_table["旋风斩"]) then return true; end;
  	end;  	
  	
    if Oldhand_PlayerBU("血肉顺劈") then
  		if Oldhand_CastSpell("嗜血", warrior_action_table["嗜血"]) then return true; end;
  	end
      
  	if Oldhand_PlayerBU("激怒") then
  	  --Oldhand_AddMessage("发脾气.................................")
  		if Oldhand_CastSpell("怒击", warrior_action_table["怒击"]) then return true; end;
  	end
  	
  	if (isNearAction and Oldhand_TargetCount() >= 3 and not Oldhand_PlayerBU("血肉顺劈")) or Oldhand_PlayerBU("摧枯拉朽") then
  	  if Oldhand_CastSpell_IgnoreRange("旋风斩", warrior_action_table["旋风斩"]) then return true; end;
  	end;	  
  
    if Oldhand_CastSpell("嗜血", warrior_action_table["嗜血"]) then return true; end;
    
    if Oldhand_TargetCount() >= 4 then
      if Oldhand_CastSpell_IgnoreRange("旋风斩", warrior_action_table["旋风斩"]) then return true; end;
    end;
    if Oldhand_CastSpell("狂暴挥砍", warrior_action_table["狂暴挥砍"]) then return true; end;
	end;

  if Oldhand_TargetCount() >= 4 then
    if Oldhand_CastSpell_IgnoreRange("旋风斩", warrior_action_table["旋风斩"]) then return true; end;
  end;
  
	Oldhand_SetText("无动作",0);
	return;

end;

-- 防护模式
function Warrior_DpsOut3()
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
	if Warrior_playerSafe() then return true; end;
	
	local power = UnitPower("player");
	
  local partyNum = GetNumGroupMembers();
  local target_count = Oldhand_TargetCount()
  
  Oldhand_AddMessage(power.." "..target_count);
  
  -- 近战范围
	local isNearAction = IsActionInRange(Oldhand_GetActionID(warrior_action_table["盾牌猛击"])) or IsActionInRange(Oldhand_GetActionID(warrior_action_table["复仇"]));
	
	local target_health_percent, target_health = Oldhand_GetPlayerHealthPercent("target");
	local player_health_percent, player_health = Oldhand_GetPlayerHealthPercent("player");
  
	if Oldhand_BreakCasting("拳击")==1 then
	  if Oldhand_CastSpell("拳击", warrior_action_table["拳击"]) then return true; end;
	end;
	
	-- 狂怒	Buff
	if Warrior_RunCommand(isNearAction) then return true; end;

	-- 狂怒饰品
	if Warrior_Auto_Trinket() then return true; end;
	
	if player_health_percent < 50 then
	  if Oldhand_CastSpell("破斧沉舟", warrior_action_table["破斧沉舟"]) then return true; end;
	end;
	if player_health_percent < 60 then
	  if Oldhand_CastSpell("盾墙", warrior_action_table["盾墙"]) then return true; end;
	end;
	if player_health_percent < 70 then
	  if Oldhand_CastSpell("法术反射", warrior_action_table["法术反射"]) then return true; end;
	end;
	if player_health_percent < 80 then
	  if Oldhand_CastSpell("集结呐喊", warrior_action_table["集结呐喊"]) then return true; end;
	  if Oldhand_CastSpell("乘胜追击", warrior_action_table["乘胜追击"]) then return true; end;
	end;
	
	if isNearAction and (Oldhand_PlayerBU("复仇！") or power > 90) then
	  if Oldhand_CastSpell("复仇", warrior_action_table["复仇"]) then return true; end;
	end;
	
	if player_health_percent < 90 then
	  if Oldhand_CastSpell("无视苦痛", warrior_action_table["无视苦痛"]) then return true; end;
	end;

  if target_count >= 4 then
    if Oldhand_CastSpell("震荡波", warrior_action_table["震荡波"]) then return true; end;
  end;
  if target_count >= 3 then
    if Oldhand_CastSpell("雷霆一击", warrior_action_table["雷霆一击"]) then return true; end;
  end;
  
  if power >= 30 and isNearAction then
    if Oldhand_CastSpellIgnoreRange("盾牌格挡", warrior_action_table["盾牌格挡"]) then return true; end;
    if target_count >= 3 then
      if Oldhand_CastSpell("复仇", warrior_action_table["复仇"]) then return true; end;
    end
  end;
  
  if Oldhand_CastSpellIgnoreRange("天神下凡", warrior_action_table["天神下凡"]) then return true; end;
  
  if isNearAction then
	  if Oldhand_CastSpell("盾牌猛击", warrior_action_table["盾牌猛击"]) then return true; end;
	  if Oldhand_CastSpell("复仇", warrior_action_table["复仇"]) then return true; end;
	end;
	
	if Oldhand_CastSpellIgnoreRange("雷霆一击", warrior_action_table["雷霆一击"]) then return true; end;
	
	if isNearAction and power > 40 then
    if Oldhand_CastSpell("复仇", warrior_action_table["复仇"]) then return true; end;
  end
  
  if Oldhand_CastSpellIgnoreRange("震荡波", warrior_action_table["震荡波"]) then return true; end;
    
	Oldhand_SetText("无动作",0);
	return;		

end;

function Warrior_playerSafe()
  local HealthPercent = Oldhand_GetPlayerHealthPercent("player");
	if (UnitIsPlayer("target") and UnitCanAttack("player", "target")) then
		if null==Oldhand_PlayerBU("狂暴之怒") then
			if Oldhand_CastSpellIgnoreRange("狂暴之怒", warrior_action_table["狂暴之怒"]) then return true; end;
    end
	end;
  if (Warrior_DPS == 1 and HealthPercent < 50) then
	  Oldhand_AddMessage('血量过低 '..HealthPercent);
	  if Oldhand_CastSpellIgnoreRange("剑在人在", warrior_action_table["剑在人在"]) then return true; end;
	end;
  if (Warrior_DPS == 2 and HealthPercent < 50) then
	  Oldhand_AddMessage('血量过低 '..HealthPercent);
	  if Oldhand_CastSpellIgnoreRange("狂怒回复", warrior_action_table["狂怒回复"]) then return true; end;
	end;
	if HealthPercent < 40 then
	  Oldhand_AddMessage('血量过低 '..HealthPercent);
	  if Oldhand_CastSpellIgnoreRange("命令怒吼", warrior_action_table["命令怒吼"]) then return true; end;
	end;
	if HealthPercent < 30 then
	  Oldhand_AddMessage('血量过低 '..HealthPercent);
	  if Oldhand_CastSpellIgnoreRange("破胆怒吼", warrior_action_table["破胆怒吼"]) then return true; end;
	end;
	if HealthPercent < 90 and Oldhand_PlayerBU("胜利") then
		if Oldhand_CastSpell("乘胜追击", warrior_action_table["乘胜追击"]) then return true; end;
  end
	return false;
end;

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

function Warrior_Use_INV_Jewelry_TrinketPVP_02()
	if UnitIsPlayer("playertarget") then 
		if Warrior_NoControl_Debuff() then
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
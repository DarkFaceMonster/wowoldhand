DeathKnight_ActionTable = nil;
DeathKnight_SaveData = nil;
DeathKnight_Data = nil;
local DeathKnight_Buttons = {};
DeathKnight_PlayerTalentInfoDatas = {};

local info = GetInterfaceInfo();

local mianyi1 = 0;	-- 冰冷触摸
local plagueTime = 0; -- 上次传染时间
local plagueMode = 0; -- 是否允许传染
local plageRune = 0; -- 使用哪个符文传染 
local isAnimateDeading = 0; -- 是否正在使用活力分流
local step = 0;	-- 循环步骤
local target_spellname = "";	-- 目标正在施法的法术名称
local needBloodTap = 0;  -- 需要活力分流

local dynamicMicroID = 72;
local playerClass;
local DeathKnight_DPS = 3; -- 0,1鲜血坦克，2冰霜，3邪恶
local DeathKnight_Reincarnation  = false;
local DeathKnight_Free  = false;
local DeathKnight_RaidFlag = 0;
local DeathKnight_Old_UnitPopup_OnClick;
local DeathKnight_AutoFollowName="";
local TestHelpTarget = "";

local   DeathKnight_DISEASE = '疾病';
local 	DeathKnight_MAGIC   = '魔法';
local 	DeathKnight_POISON  = '中毒';
local 	DeathKnight_CURSE   = '诅咒';

-- 2 function DeathKnight_ClassIcon
-- 2 spell_deathknight_defile             亵渎
-- 3 Spell_Frost_ArcticWinds		                                           
-- 4 Spell_DeathKnight_EmpowerRuneBlade		                                   
-- 5 Spell_Deathknight_DeathStrike                                             
-- 5 Spell_Nature_DeathKnightRage  黑暗命令                                         
-- 6 Spell_Shadow_DeathCoil
-- 6 ability_deathknight_soulreaper  灵魂收割
-- 7 Spell_DeathKnight_Butcher2                                                
-- 8 Spell_DeathKnight_MindFreeze
-- 8 ability_deathknight_pillaroffrost   冰霜之柱
-- 9 ability_deathknight_remoreslesswinters2   冰霜之柱
-- 9 INV_Weapon_Shortblade_40     	心脏打击                                             
-- 9 Spell_DeathKnight_ScourgeStrike 天灾打击    Spell_Frost_ArcticWinds  凛风冲击                    
-- 10 Spell_Shadow_SoulLeech_3                                                 
-- 11 Spell_Shadow_AntiMagicShell 反魔法护盾                                   
-- 12 Spell_DeathKnight_BloodBoil                                              
-- 11 Racial_Orc_BerserkerStrenth	血性狂怒                                   
--  INV_Jewelcrafting_StarOfElune_02 苔原护符                                  
-- 52 Spell_Shadow_AnimateDead		亡者复生                                   
-- 53 Spell_Nature_WispSplodeGreen                                             
-- 54 Spell_DeathKnight_RuneTap                                                
                                                    
-- 61 	Spell_DeathKnight_BloodTap 活力分流 
--		INV_Chest_Leather_13 白骨之盾
--		INV_Armor_Helm_Plate_Naxxramas_RaidWarrior_C_01 铜墙铁壁
-- 62 Spell_Shadow_LifeDrain 吸血鬼之血  Spell_Shadow_PlagueCloud 传染  Spell_DeathKnight_BloodBoil 血液沸腾
-- 63 Ability_Hunter_RapidKilling    
--		Spell_Shadow_SoulLeech_2	黑锋冰寒                                      
-- 64 Spell_Frost_ChainsOfIce                                                  
-- 65 Spell_DeathKnight_ClassIcon                                              
-- 65 Ability_Hunter_Pet_Bat		召唤石像鬼                            
-- 68 ability_deathknight_pillaroffrost		冰霜之柱
-- 69 Spell_Shadow_DeathPact                                                   
-- 70 Spell_DeathKnight_DarkConviction                                         
-- 71 INV_Misc_Horn_02			寒冬号角，战歌的热情，伊萨诺斯甲虫 
-- 71 Spell_DeathKnight_BladedArmor			狂乱
-- 71 inv_hammer_04 卡德罗斯的印记
-- 72 INV_Jewelry_Talisman_07 英雄勋章,                                        
-- 72 INV_Misc_AhnQirajTrinket_03 菲斯克的怀表  
--		Spell_DeathKnight_EmpowerRuneBlade2 	冰霜打击  
--		inv_misc_gem_bloodstone_03    霸权印记     
--    INV_Stone_SharpeningStone_05  磁力之镜                    
-- 传染 Spell_Shadow_PlagueCloud 
-- 枯萎凋萎 Spell_Shadow_DeathAndDecay


local deathknight_action_table = {};

deathknight_action_table["自动攻击"] = 1087637;
deathknight_action_table["血性狂怒"] = 135726;
deathknight_action_table["天启"] = 1392565;

-- 鲜血

-- 冰霜
deathknight_action_table["湮灭"] = 135771;
deathknight_action_table["凛风冲击"] = 135833;
deathknight_action_table["冰霜之镰"] = 1060569;
deathknight_action_table["冰霜打击"] = 237520;
deathknight_action_table["冰霜之柱"] = 458718;
deathknight_action_table["符文武器增效"] = 135372;
deathknight_action_table["冰霜突进"] = 537514;

-- 邪恶
deathknight_action_table["暗影之爪"] = 615099;
deathknight_action_table["脓疮打击"] = 879926;
deathknight_action_table["凋零缠绕"] = 136145;
deathknight_action_table["灵魂收割"] = 636333;
deathknight_action_table["灵界打击"] = 237517;
deathknight_action_table["黑暗突变"] = 342913;
deathknight_action_table["反魔法护罩"] = 136120;

deathknight_action_table["死亡之握"] = 237532;
deathknight_action_table["爆发"] = 348565;
deathknight_action_table["心灵冰冻"] = 237527;
deathknight_action_table["寒冰锁链"] = 135834;

deathknight_action_table["冰封之韧"] = 237525;
deathknight_action_table["黑暗仲裁者"] = 298674;
deathknight_action_table["召唤石像鬼"] = 458967;
deathknight_action_table["战斗的召唤"] = 132485;
deathknight_action_table["幽魂步"] = 110041;
deathknight_action_table["亡者复生"] = 136119;


-- 饰品
deathknight_action_table["霸权印记"] = 134086;
deathknight_action_table["奥拉留斯的疯狂耳语"] = 340336;

local spell_table = {};
spell_table["自动攻击"] = 1;
spell_table["灵魂收割"] = 6;
spell_table["奥拉留斯的低语水晶"] = 12;    -- 340336
spell_table["霸权印记"] = 72;             -- 140086
--spell_table["寒冬号角"] = 11;
--spell_table["伊萨诺斯甲虫"] = 72;
--spell_table["战歌的热情"] = 71;
--spell_table["外交徽记"] = 71;
--spell_table["克瓦迪尔战旗"] = 71;
--spell_table["卡德罗斯的印记"] = 71;
--spell_table["海洋之力"] = 72;

-- 打断施法
local currTargetCasting = "";

function DeathKnight_UnitPopup_OnClick()
	local index = this.value;
	local dropdownFrame = getglobal(UIDROPDOWNMENU_INIT_MENU);
	local button =  this.value;	
	local name = dropdownFrame.name;

	if ( button == "DeathKnightPOPUP" ) then
		DeathKnight_AutoFollowName = name;
		PlaySound("UChatScrollButton");
		DEFAULT_CHAT_FRAME:AddMessage("("..DeathKnight_AutoFollowName..")目前为跟随对象!");
	else
		DeathKnight_Old_UnitPopup_OnClick();
	end
end

function DeathKnight_CreateMacro()	
	if GetMacroIndexByName("打断施法") == 0 then
		CreateMacro("打断施法", 67, "/stopcasting", 1, 1);
	end;	
	--PickupMacro("打断施法");
	--PlaceAction(61);
	--ClearCursor();

	if GetMacroIndexByName("开始攻击") == 0 then
		CreateMacro("开始攻击", 60, "/startattack", 1, 1);
	end;
	--PickupMacro("开始攻击");
	--PlaceAction(1);
	--ClearCursor();

	if GetMacroIndexByName("血性狂怒") == 0 then
		CreateMacro("血性狂怒", 66, "/cast 血性狂怒", 1, 1);
	end;
	
	if GetMacroIndexByName("活力分流") == 0 then
		CreateMacro("活力分流", 943, "/cast 活力分流", 1, 0);
	end;

	if GetMacroIndexByName("更换模式") == 0 then
		CreateMacro("更换模式", 61, "/script DeathKnight_Input(1);", 1, 1);
	end;	
	PickupMacro("更换模式");
	PlaceAction(49);
	ClearCursor();	

	if DeathKnight_DPS == 0 then
		if GetMacroIndexByName("鲜血模式") == 0 then
			CreateMacro("鲜血模式", 62, "/script DeathKnight_Input(1);", 0, 0);
		end;
		PickupMacro("鲜血模式");
  elseif DeathKnight_DPS==1 then
		if GetMacroIndexByName("坦克模式") == 0 then
			CreateMacro("坦克模式", 62, "/script DeathKnight_Input(1);", 0, 0);
		end
		PickupMacro("坦克模式");
	elseif DeathKnight_DPS == 2 then
		if GetMacroIndexByName("冰霜模式") == 0 then
			CreateMacro("冰霜模式", 62, "/script DeathKnight_Input(1);", 0, 0);
		end;
		PickupMacro("冰霜模式");
	elseif DeathKnight_DPS == 3 then
		if GetMacroIndexByName("邪恶模式") == 0 then
			CreateMacro("邪恶模式", 62, "/script DeathKnight_Input(1);", 0, 0);
		end;
		PickupMacro("邪恶模式");
	end
	PlaceAction(50);
	ClearCursor();
	
	--if Oldhand_PickupSpellByBook("攻击") then
	--	PlaceAction(1);
	--	ClearCursor();	
	--end;
	Oldhand_PutAction("灵界打击", 7);
	
	Oldhand_PutAction("反魔法护罩", 11);

	Oldhand_PutAction("死亡之握", 61);

	Oldhand_PutAction("心灵冰冻", 64);

	Oldhand_PutAction("幽魂步", 69);
		
	if DeathKnight_DPS==1 then
		Oldhand_PutAction("冰冷触摸", 3);
		Oldhand_PutAction("符文刃舞", 71);
	elseif DeathKnight_DPS==2 then
	  Oldhand_PutAction("湮没", 2);
		Oldhand_PutAction("凛风冲击", 3);
		Oldhand_PutAction("冰霜打击", 5);
		Oldhand_PutAction("冰霜之柱", 8);
		Oldhand_PutAction("冷酷严冬", 9);
	elseif DeathKnight_DPS==3 then
		Oldhand_PutAction("暗影之爪", 2);   -- 615099
		Oldhand_PutAction("脓疮打击", 3);   -- 879926
		Oldhand_PutAction("凋零缠绕", 4);   -- 136145
	  Oldhand_PutAction("灵魂收割", 6);
		Oldhand_PutAction("白骨之盾", 8);
		Oldhand_PutAction("黑暗突变", 10);
		Oldhand_PutAction("传染", 62);
		Oldhand_PutAction("爆发", 63);  -- spell_deathvortex
		Oldhand_PutAction("召唤石像鬼", 67);
		Oldhand_PutAction("亡者复生", 70);
		
	else
		Oldhand_PutAction("凋零缠绕", 4);
		Oldhand_PutAction("黑暗命令", 5);
		Oldhand_PutAction("邪恶虫群", 9);
		Oldhand_PutAction("白骨之盾", 67);
	end

	if DeathKnight_DPS==0 or DeathKnight_DPS==1 then
		if not Oldhand_PutAction("符文分流", 8) then
			Oldhand_PutAction("狂乱", 8);
		end
		Oldhand_PutAction("吸血鬼之血", 63);

	elseif DeathKnight_DPS==1 then
		-- Oldhand_PutAction("铜墙铁壁", 8);
	elseif DeathKnight_DPS==0 then
		Oldhand_PutAction("血液沸腾", 63);
	else
		Oldhand_PutAction("符文分流", 8);
		Oldhand_PutAction("吸血鬼之血", 63);
	end
	--Oldhand_PutAction("符文分流", 8);

	if Oldhand_TestTrinket("枯骨之钥") then
		Oldhand_PutAction("枯骨之钥", 64);
	else
		Oldhand_PutAction("寒冰锁链", 65);
	end;
	Oldhand_PutAction("冰封之韧", 66);
	--Oldhand_PutAction("天灾契约", 68);
	Oldhand_PutAction("符文武器增效", 70);
	
	if Oldhand_TestTrinket("部落勋章") then
		Oldhand_PutAction("部落勋章", 71);
	elseif Oldhand_TestTrinket("卡德罗斯的印记") then
		Oldhand_PutAction("卡德罗斯的印记", 71);
		spell_table["卡德罗斯的印记"] = 71;
	elseif Oldhand_TestTrinket("磁力之镜") then
		Oldhand_PutAction("磁力之镜", 71);
	elseif Oldhand_TestTrinket("菲斯克的怀表") then
		Oldhand_PutAction("菲斯克的怀表", 71);
	elseif Oldhand_TestTrinket("恐惧小盒") then
		Oldhand_PutAction("恐惧小盒", 71);
	elseif Oldhand_TestTrinket("恐惧小盒") then
		Oldhand_PutAction("战歌的热情", 71);
	elseif Oldhand_TestTrinket("苔原护符") then
		Oldhand_PutAction("苔原护符", 71);
	end
	if Oldhand_TestTrinket("霸权印记") then
	  --if GetMacroIndexByName("血性狂怒") == 0 then
  	--	CreateMacro("霸权印记", 66, "/cast 血性狂怒", 1, 1);
  	--end;
		Oldhand_PutAction("霸权印记", 72);
	
	elseif Oldhand_TestTrinket("英雄勋章") then
		Oldhand_PutAction("英雄勋章", 72);
	elseif Oldhand_TestTrinket("伊萨诺斯甲虫") then
		Oldhand_PutAction("伊萨诺斯甲虫", 72);
	elseif Oldhand_TestTrinket("刃拳的宽容") then
		Oldhand_PutAction("刃拳的宽容", 72);
	end
	
	spell_table["霸权印记"] = 72;
	Oldhand_PutAction("血性狂怒", 51);

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
	
	SetBindingMacro(",","血性狂怒");	-- 29
	--SetBindingMacro("\'","活力分流");	-- 28
	--SetBindingMacro(";","打断施法");	-- 27
	--SetBindingMacro("\\","开始攻击");	-- 26
	
	--SaveBindings(1);
end;

function DeathKnight_NoTarget_RunCommand()
	if 1~=UnitAffectingCombat("player") then
		if DeathKnight_RunCommand() then return true; end;
	end
	return false;
end;

function DeathKnight_RunCommand()
  local buff = Oldhand_PlayerBU("疯狂耳语");
	if null==buff then
		if Oldhand_CastSpellByIdIgnoreRange("奥拉留斯的低语水晶", spell_table["奥拉留斯的低语水晶"]) then return true; end;
	end;

	if UnitAffectingCombat("player") then
		local id1 = Oldhand_GetActionID(deathknight_action_table["血性狂怒"]);
		if id1~=0 and null==Oldhand_PlayerBU("血性狂怒") then
		  local isNearAction = IsActionInRange(Oldhand_GetActionID(deathknight_action_table["灵界打击"])) == true;
			if isNearAction then -- 灵界打击有效
				if (GetActionCooldown(Oldhand_GetActionID(deathknight_action_table["血性狂怒"])) == 0) then 
					--Oldhand_SetText("血性狂怒", 29);
					--return true;
				end
			end;
		end

		if DeathKnight_DPS==2 then
			local name, remainTime = Oldhand_PlayerBU("冰霜之柱");
			if name==null then
				--if Oldhand_CastSpell("铜墙铁壁","INV_Armor_Helm_Plate_Naxxramas_RaidWarrior_C_01") then return true; end;
				if Oldhand_CastSpell("冰霜之柱","ability_deathknight_pillaroffrost") then return true; end;
			elseif remainTime > 29 then
				--Oldhand_SetText("活力分流",28); 
				Oldhand_CastSpell("活力分流","Spell_DeathKnight_BloodTap");
				return true;
			end
		end
	end

	return false;
end;

function DeathKnight_Auto_Trinket()
  -- 是否近战范围
  local isNearAction = IsActionInRange(Oldhand_GetActionID(237517)) == true;
  
	if null==Oldhand_PlayerBU("极化") then
		if Oldhand_TestTrinket("磁力之镜") and (isNearAction)  then
			if Oldhand_CastSpell("磁力之镜", "inv_stone_sharpeningstone_05") then return true; end		
		end
	end
	if null==Oldhand_PlayerBU("台风") then
		if Oldhand_TestTrinket("海洋之力") and (IsActionInRange(Oldhand_GetActionID("Spell_Deathknight_DeathStrike")) == 1)  then
			if Oldhand_CastSpellbyID("海洋之力", spell_table["海洋之力"]) then return true; end		
		end
	end
	
	if null==Oldhand_PlayerBU("非凡战力") then
		if Oldhand_TestTrinket("卡德罗斯的印记") and (IsActionInRange(Oldhand_GetActionID("Spell_Deathknight_DeathStrike")) == 1)  then
			if Oldhand_CastSpellbyID("卡德罗斯的印记", spell_table["卡德罗斯的印记"]) then return true; end		
		end
	end
	if null==Oldhand_PlayerBU("战斗！") then
		if Oldhand_TestTrinket("克瓦迪尔战旗") and (IsActionInRange(Oldhand_GetActionID("Spell_Deathknight_DeathStrike")) == 1)  then
			if Oldhand_CastSpellbyID("克瓦迪尔战旗", spell_table["克瓦迪尔战旗"]) then return true; end		
		end
	end
	if null==Oldhand_PlayerBU("怒火") and null==Oldhand_PlayerBU("狂怒") then
	  local range1 = IsActionInRange(Oldhand_GetActionID("Spell_DeathKnight_EmpowerRuneBlade2")); -- 冰霜打击
	  
	  --if range1 == 1 then
	  --  Oldhand_AddMessage("冰霜打击 距离 ....... 1");
	  --elseif range1 == 0 then
	  --  Oldhand_AddMessage("冰霜打击 距离 ....... 0");
	  --elseif range1 == nil then
	  --  Oldhand_AddMessage("冰霜打击 距离 ....... nil");
	  --elseif range1 == null then
	  --  Oldhand_AddMessage("冰霜打击 距离 ....... null");
	  --elseif range1 == true then
	  --  Oldhand_AddMessage("冰霜打击 距离 ....... true");
	  --elseif range1 == false then
	  --  Oldhand_AddMessage("冰霜打击 距离 ....... false");
	  --else 
	  --  Oldhand_AddMessage("冰霜打击 距离 ....... 其他");
	  --end;

		if Oldhand_TestTrinket("霸权印记") and (isNearAction) then
			local target_health_percent, target_health = Oldhand_GetPlayerHealthPercent("target");
			-- Oldhand_AddMessage("霸权印记 目标血量："..target_health.."/"..target_health_percent.."%");
			if target_health > 300000 then                                    
			  if Oldhand_CastSpellByIdIgnoreRange("霸权印记", spell_table["霸权印记"]) then return true; end;
			  --if Oldhand_CastSpellbyID("霸权印记", spell_table["霸权印记"]) then return true; end;
			  --Oldhand_AddMessage("霸权印记 未执行成功..........."..spell_table["霸权印记"]);
			  
			  local i = spell_table["霸权印记"];
			  if i > 0 then   
			    Oldhand_SetText("霸权印记", i - 48);
			  end;
			end;
		end
	end
	if null==Oldhand_PlayerBU("银色英勇") then
		if Oldhand_TestTrinket("菲斯克的怀表") and (IsActionInRange(Oldhand_GetActionID("Spell_Deathknight_DeathStrike")) == 1 or IsActionInRange(Oldhand_GetActionID("Spell_DeathKnight_Butcher2")) == 1)  then
			if Oldhand_CastSpell("菲斯克的怀表","INV_Misc_AhnQirajTrinket_03") then return true; end		
		end
	end
	if null==Oldhand_PlayerBU("野性狂怒") then
		if Oldhand_TestTrinket("战歌的热情") and (IsActionInRange(Oldhand_GetActionID("Spell_Deathknight_DeathStrike")) == 1)  then
			if Oldhand_CastSpellbyID("战歌的热情", spell_table["战歌的热情"]) then return true; end		
		end
	end
	if null==Oldhand_PlayerBU("奥术灌注") then
		if Oldhand_TestTrinket("伊萨诺斯甲虫") and (IsActionInRange(Oldhand_GetActionID("Spell_Deathknight_DeathStrike")) == 1)  then
			--Oldhand_AddMessage("准备施放。。。伊萨诺斯甲虫 "..spell_table["伊萨诺斯甲虫"]);
			if Oldhand_CastSpellbyID("伊萨诺斯甲虫", spell_table["伊萨诺斯甲虫"]) then return true; end		
		end
	end
	
	if null==Oldhand_PlayerBU("精准打击") then
		if Oldhand_TestTrinket("苔原护符") and (IsActionInRange(Oldhand_GetActionID("Spell_Deathknight_DeathStrike")) == 1)  then
			if Oldhand_CastSpellbyID("苔原护符", spell_table["苔原护符"]) then return true; end;
		end
	end
	if null==Oldhand_PlayerBU("凶暴") then
		if Oldhand_TestTrinket("刃拳的宽容") and (IsActionInRange(Oldhand_GetActionID("Spell_Deathknight_DeathStrike")) == 1)  then
			if Oldhand_CastSpellbyID("刃拳的宽容", spell_table["刃拳的宽容"]) then return true; end		
		end
	end
	if null==Oldhand_PlayerBU("卓越坚韧") then
		if Oldhand_TestTrinket("外交徽记") and (IsActionInRange(Oldhand_GetActionID("Spell_Deathknight_DeathStrike")) == 1)  then
			if Oldhand_CastSpellbyID("外交徽记", spell_table["外交徽记"]) then return true; end		
		end
	end
	
	--if Oldhand_GetActionID("INV_Misc_MonsterScales_15") ~= 0 then
	--	if Oldhand_TestTrinket("嗜血胸针") and (IsActionInRange(Oldhand_GetActionID("Spell_Deathknight_DeathStrike")) == 1)  then
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

function DeathKnight_DpsOut(dps_mode)
  DeathKnight_DPS = dps_mode;
  if dps_mode == 1 then
    DeathKnight_DpsOut1();
  elseif dps_mode == 2 then
    DeathKnight_DpsOut2();
  elseif dps_mode == 3 then
    DeathKnight_DpsOut3();
  else
    Oldhand_AddMessage("错误的天赋模式："..dps_mode);
  end;
end;

-- 冰霜攻击
function DeathKnight_DpsOut2()
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
		mianyi1 = 0; 
		--Oldhand_SetText("开始攻击",26);	
		Oldhand_SetText("自动攻击", 1);
		return true;
	end;
	-- 近战范围		
	local isNearAction = IsActionInRange(Oldhand_GetActionID(237517));

	if UnitIsPlayer("target") and UnitCanAttack("player","target") then
		if Oldhand_TargetDeBU("寒冰锁链") then
			if Oldhand_CastSpell("寒冰锁链", deathknight_action_table["寒冰锁链"]) then return true; end;
		end;


--		  if Oldhand_CastSpell("冷酷严冬","ability_deathknight_remoreslesswinters2") then return true; end;
--    end;
	end;
	
	if Oldhand_GetUnitPowerPercent("player") >= 75 then
		if Oldhand_CastSpell("冰霜打击", deathknight_action_table["冰霜打击"]) then return true; end;
	end
	
	--local id1, id2 = Oldhand_GetActionID("Spell_DeathKnight_MindFreeze"), Oldhand_GetActionID("Spell_Shadow_SoulLeech_3");
	if DeathKnight_playerSafe() then return true; end;
	
	if Oldhand_BreakCasting("心灵冰冻")==1 and Oldhand_CastSpell("心灵冰冻", deathknight_action_table["心灵冰冻"]) then return true; end;
	if Oldhand_CastSpellIgnoreRange("冰霜之柱",deathknight_action_table["冰霜之柱"]) then return true; end;
	
	-- 增强饰品
	if DeathKnight_Auto_Trinket() then return true; end;
  
	-- 增强	Buff
	if DeathKnight_RunCommand() then return true; end;
	local debuff1,remainTime1 = Oldhand_CheckDebuffByPlayer("冰霜疫病");
	local debuff2,remainTime2 = Oldhand_CheckDebuffByPlayer("血之疫病");
	if not debuff1 then
	  debuff1,remainTime1 = Oldhand_CheckDebuffByPlayer("锋锐之霜");
	end;
	if not debuff2 then
	  debuff2,remainTime2 = Oldhand_CheckDebuffByPlayer("死疽");
	end;

	local strenth = 0;
	local buff1 = Oldhand_PlayerBU("不洁之力");
	local buff2 = Oldhand_PlayerBU("暴怒");
	local buff3 = Oldhand_PlayerBU("伟大");
	local buff4 = Oldhand_PlayerBU("杰出");
	local buff5 = Oldhand_PlayerBU("憎恶之力");
	local buff6 = Oldhand_PlayerBU("不洁之能");
	local buff7 = Oldhand_PlayerBU("血性狂怒");
	local buff8 = Oldhand_PlayerBU("战斗!");
	local buff9 = Oldhand_PlayerBU("台风");
	local buff10 = Oldhand_PlayerBU("末日之眼");
	local buff11 = Oldhand_PlayerBU("杀戮机器");
	if buff1 then strenth = strenth + 200; end;		-- 不洁之力
	if buff2 then strenth = strenth + 500; end;
	if buff3 then strenth = strenth + 350; end;
	if buff4 then strenth = strenth + 450; end;
	if buff5 then strenth = strenth + 200; end;
	if buff6 then strenth = strenth + 180; end;
	if buff7 then strenth = strenth + 160; end;
	if buff8 then strenth = strenth + 830; end;
	if buff9 then strenth = strenth + 765; end;
	if buff10 then strenth = strenth + 1512; end;

	if (debuff2 and debuff1) then 
	  --Oldhand_AddMessage("两个疾病")
		step = 1;
		if plagueMode==1 and Oldhand_TargetCount() > 2 and ((GetTime() - plagueTime > 16) or (remainTime1>0 and remainTime1<2) or (remainTime2>0 and remainTime2<2)) then
			if plageRune==0 then
				if Api_CheckRune(1) then
					if Oldhand_CastSpell("传染","Spell_Shadow_PlagueCloud") then
						Oldhand_AddMessage("使用鲜血符文传染，序号：1");
						plageRune = 1;
						return true;
					end
				elseif Api_CheckRune(2) then
					if Oldhand_CastSpell("传染","Spell_Shadow_PlagueCloud") then
						Oldhand_AddMessage("使用鲜血符文传染，序号：2");
						plageRune = 2;
						return true;
					end
				else
					plageRune = Api_CheckDeathRune();
					if plageRune>0 then
						Oldhand_AddMessage("使用死亡符文传染，序号："..plageRune);
						Oldhand_CastSpell("传染","Spell_Shadow_PlagueCloud");
						return true;
					end
				end
			elseif not Api_CheckRune(plageRune) then
				local temp = GetTime() - plagueTime;
				Oldhand_AddMessage("已使用符文 " ..plageRune.. " 施放传染...距离上次传染时间："..temp.." 秒");
				plagueTime = GetTime();
				
				plageRune = 0;
			else
				return Oldhand_CastSpell("传染","Spell_Shadow_PlagueCloud");
			end
		end;
	end;

	if Oldhand_PlayerBU("白霜") or Oldhand_PlayerBU("冰冻之雾") then
	  Oldhand_AddMessage("白霜...................")
		if Oldhand_CastSpell("凛风冲击", deathknight_action_table["凛风冲击"]) then return true; end;
	end
	if Oldhand_PlayerBU("杀戮机器") then
		if Oldhand_CastSpell("湮灭", deathknight_action_table["湮灭"]) then return true; end;
		if Oldhand_CastSpell("冰霜之镰", deathknight_action_table["冰霜之镰"]) then return true; end;
		--if Oldhand_CastSpell("冰霜打击","Spell_DeathKnight_EmpowerRuneBlade2") then return true; end;
	end
	if (Oldhand_GetUnitPowerPercent("player") >= 50) then
		--if Oldhand_CastSpell("湮灭","Spell_Deathknight_ClassIcon") then return true; end;
		if Oldhand_CastSpell("冰霜打击", deathknight_action_table["冰霜打击"]) then return true; end;
	end

  if isNearAction then
    if Oldhand_CastSpell("冰川突进", deathknight_action_table["冰川突进"]) then return true; end;
    if Oldhand_CastSpell("冰霜之镰", deathknight_action_table["冰霜之镰"]) then return true; end;
  end;

  if Oldhand_CastSpell("凛风冲击", deathknight_action_table["凛风冲击"]) then return true; end; -- Spell_ DeathKnight_ IceTouch
	if not Api_CheckRunes() then
		if Oldhand_CastSpell("符文武器增效","INV_Sword_62") then return true; end;
	end
	
	--if Oldhand_CastSpell("冰霜打击","Spell_DeathKnight_EmpowerRuneBlade2") then return true; end;
	
	if Oldhand_CastSpell("湮灭", deathknight_action_table["湮灭"]) then return true; end;

	if Oldhand_CastSpell("冰霜之镰", deathknight_action_table["冰霜之镰"]) then return true; end;
	
	Oldhand_SetText("无动作",0);
	return;		

end;

-- 邪恶攻击
function DeathKnight_DpsOut3()
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
		mianyi1 = 0; 
		Oldhand_ClearTargetTable();
		--Oldhand_SetText("开始攻击",26);	
		Oldhand_SetText("攻击",1);
		return true;
	end;

  if DeathKnight_playerSafe() then return true; end;
  
	-- 是否在近战范围（使用灵界打击）
	local isNearAction = IsActionInRange(Oldhand_GetActionID(237517)) == true; 
	
	if (UnitIsPlayer("target") and UnitCanAttack("player", "target")) or UnitName("target")=="炸弹机器人" then
		if Oldhand_TargetDeBU("寒冰锁链") then
			if Oldhand_CastSpell("寒冰锁链", deathknight_action_table["寒冰锁链"]) then return true; end;
		end;
		-- 近战范围
		if (isNearAction) then
		  Oldhand_AddMessage("近战范围");
		  --if Oldhand_CastSpell("冷酷严冬", "ability_deathknight_remoreslesswinters2") then return true; end;
    end;
	end;

	if Oldhand_BreakCasting("心灵冰冻")==1 and Oldhand_CastSpell("心灵冰冻", deathknight_action_table["心灵冰冻"]) then return true; end;

  if (IsCurrentAction(Oldhand_GetActionID(deathknight_action_table["枯萎凋零"]))) then 
		Oldhand_SetText("枯萎凋零",0);
		return true; 
	end;

	if IsPetActive() then
	  if Oldhand_CastSpellIgnoreRange("黑暗突变", deathknight_action_table["黑暗突变"]) then return true; end;
	else
	  if Oldhand_CastSpellIgnoreRange("亡者复生", deathknight_action_table["亡者复生"]) then return true; end;
	end;
			
	local target_health_percent, target_health = Oldhand_GetPlayerHealthPercent("target");
	local player_health_percent, player_health = Oldhand_GetPlayerHealthPercent("target");
	local debuff7, remainTime7 = Oldhand_CheckDebuffByPlayer("灵魂收割");
	if not debuff7 then
  	if target_health_percent < 50 or target_health < 260000 then
  	  if Oldhand_CastSpell("灵魂收割", deathknight_action_table["灵魂收割"]) then return true; end;
  	end;
  end;
  
  if target_health > 500000 then
    if Oldhand_CastSpellIgnoreRange ("召唤石像鬼", deathknight_action_table["召唤石像鬼"]) then return true; end;
    if Oldhand_CastSpell("黑暗仲裁者", deathknight_action_table["黑暗仲裁者"]) then return true; end;
  end;

	-- 增强	Buff
	if DeathKnight_RunCommand() then return true; end;

	-- 增强饰品
	if DeathKnight_Auto_Trinket() then return true; end;

	local debuff1,remainTime1 = Oldhand_CheckDebuffByPlayer("冰霜疫病");
	local debuff2,remainTime2 = Oldhand_CheckDebuffByPlayer("血之疫病");
	
	local debuff3,remainTime3, count3 = Oldhand_CheckDebuffByPlayer("溃烂之伤");
	local debuff4,remainTime4, count4 = Oldhand_CheckDebuffByPlayer("恶性瘟疫");
	
	local strenth = 0;
	local buff1 = Oldhand_PlayerBU("不洁之力");
	local buff2 = Oldhand_PlayerBU("暴怒");
	local buff3 = Oldhand_PlayerBU("伟大");
	local buff4 = Oldhand_PlayerBU("杰出");
	local buff5 = Oldhand_PlayerBU("憎恶之力");
	local buff6 = Oldhand_PlayerBU("不洁之能");
	local buff7 = Oldhand_PlayerBU("血性狂怒");
	local buff8 = Oldhand_PlayerBU("狂怒");
	if buff1 then strenth = strenth + 200; end;		-- 不洁之力
	if buff2 then strenth = strenth + 500; end;
	if buff3 then strenth = strenth + 350; end;
	if buff4 then strenth = strenth + 450; end;
	if buff5 then strenth = strenth + 200; end;
	if buff6 then strenth = strenth + 180; end;
	if buff7 then strenth = strenth + 160; end;
	if buff8 then strenth = strenth + 1200; end;

	if (debuff2 and debuff1) then 
		step = 1;
		if plagueMode==1 and Oldhand_TargetCount() > 2 and ((GetTime() - plagueTime > 17) or (remainTime1>0 and remainTime1<2) or (remainTime2>0 and remainTime2<2)) then
			if plageRune==0 then
				if Api_CheckRune(1) then
					if Oldhand_CastSpell("传染","Spell_Shadow_PlagueCloud") then
						plageRune = 1;
						return true;
					end
				elseif Api_CheckRune(2) then
					if Oldhand_CastSpell("传染","Spell_Shadow_PlagueCloud") then
						plageRune = 2;
						return true;
					end
				end
			elseif not Api_CheckRune(plageRune) then
				local temp = GetTime() - plagueTime;
				Oldhand_AddMessage("已施放传染...距离上次传染时间："..temp.." 秒");
				plagueTime = GetTime();
				
				plageRune = 0;
			else
				return Oldhand_CastSpell("传染","Spell_Shadow_PlagueCloud");
			end
		end;
		if strenth >= 800 then
			if Oldhand_CastSpellIgnoreRange("召唤石像鬼", spell_table["召唤石像鬼"]) then return true; end;
			if Oldhand_CastSpell("黑暗仲裁者", deathknight_action_table["黑暗仲裁者"]) then return true; end;
		end
	end;

  local partyNum = GetNumGroupMembers();
	-- 没有恶性瘟疫则施放爆发
	if (not debuff4) then
	  if Oldhand_CastSpell("爆发", deathknight_action_table["爆发"]) then return true; end;
	elseif Oldhand_TargetCount() >= 3 then
	  if Oldhand_CastSpell("传染", deathknight_action_table["传染"]) then return true; end;
	end
	
	-- 溃烂之伤达到5层
  if (debuff3 and count3 >= 5) then
    if Oldhand_CastSpell("天启", deathknight_action_table["天启"]) then return true; end;
    if Oldhand_CastSpell("暗影之爪", deathknight_action_table["暗影之爪"]) then return true; end;
  end;
  
  local power = UnitPower("player");
	if (power >= 70 or (power >= 30 and player_health * 3 < target_health)) then
		if Oldhand_CastSpell("黑暗仲裁者", deathknight_action_table["黑暗仲裁者"]) then return true; end;
		if Oldhand_CastSpell("凋零缠绕", deathknight_action_table["凋零缠绕"]) then return true; end;
	end

	if Oldhand_CastSpell("脓疮打击", deathknight_action_table["脓疮打击"]) then return true; end;
	if Oldhand_CastSpell("凋零缠绕", deathknight_action_table["凋零缠绕"]) then return true; end;

	if Oldhand_CastSpell("暗影之爪", deathknight_action_table["暗影之爪"]) then return true; end;

	--local id1 = Oldhand_GetActionID("Spell_Shadow_AnimateDead");
	--if id1~=0 and Oldhand_PlayerBU("活力分流") then
	--	if (GetActionCooldown(Oldhand_GetActionID("Spell_Shadow_AnimateDead")) == 0) then 
	--		Oldhand_SetText("活力分流",28);
	--		return true;
	--	end
	--end

	Oldhand_SetText("无动作",0);
	return;		

end;

-- 坦克模式
function DeathKnight_DpsOut1()
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
		mianyi1 = 0; 
		--Oldhand_SetText("开始攻击",26);	
		Oldhand_SetText("自动攻击",1);
		return true;
	end;

	local tt_name = UnitName("targettarget");
	if UnitCanAttack("player", "target") and UnitName("player")~=tt_name and tt_name~=null and UnitHealthMax("targettarget")<120000 then
		if Oldhand_CastSpell("黑暗命令","Spell_Nature_DeathKnightRage") then return true; end;
	end
	
	
	if (IsActionInRange(Oldhand_GetActionID("Spell_DeathKnight_MindFreeze")) ~= 0 or IsActionInRange(Oldhand_GetActionID("Spell_Shadow_SoulLeech_3")) ~= 0) then
		if Oldhand_BreakCasting("心灵冰冻")==1 and Oldhand_CastSpell("心灵冰冻", deathknight_action_table["心灵冰冻"]) then return true; end;
		if Oldhand_BreakCasting("绞袭")==1 and Oldhand_CastSpell("绞袭","Spell_Shadow_SoulLeech_3") then return true; end;
	end;
	
	if DeathKnight_playerSafe() then return true; end;
	
	if UnitIsPlayer("target") and UnitCanAttack("player", "target") then
		if Oldhand_TargetDeBU("寒冰锁链") then
			if Oldhand_CastSpell("寒冰锁链","Spell_Frost_ChainsOfIce") then return true; end;
		end;
	end;

	-- 增强	Buff
	if DeathKnight_RunCommand() then return true; end;

	-- 增强饰品
	if DeathKnight_Auto_Trinket() then return true; end;

	local debuff1,remainTime1 = Oldhand_CheckDebuffByPlayer("冰霜疫病");
	local debuff2,remainTime2 = Oldhand_CheckDebuffByPlayer("血之疫病");
	if not debuff1 and not debuff2 then
		if Oldhand_CastSpell("爆发","spell_deathvortex") then return true; end;
	end;
  if (IsCurrentAction(Oldhand_GetActionID("spell_deathknight_defile"))) then 
		Oldhand_SetText("亵渎",0);
		return true; 
	end;
  if (IsCurrentAction(Oldhand_GetActionID("Spell_Shadow_DeathAndDecay"))) then 
		Oldhand_SetText("枯萎凋零",0);
		return true; 
	end;

	--if (debuff1) and (debuff2) then
	--	step = 1;
	--	if plagueMode==1 and Oldhand_TargetCount() > 2 and ((GetTime() - plagueTime > 16) or (remainTime1>0 and remainTime1<2) or (remainTime2>0 and remainTime2<2)) then
	--		if plageRune==0 then
	--			if Api_CheckRune(1) then
	--				if Oldhand_CastSpell("传染","Spell_Shadow_PlagueCloud") then
	--					Oldhand_AddMessage("使用鲜血符文传染，序号：1");
	--					plageRune = 1;
	--					return true;
	--				end
	--			elseif Api_CheckRune(2) then
	--				if Oldhand_CastSpell("传染","Spell_Shadow_PlagueCloud") then
	--					Oldhand_AddMessage("使用鲜血符文传染，序号：2");
	--					plageRune = 2;
	--					return true;
	--				end
	--			else
	--				plageRune = Api_CheckDeathRune();
	--				if plageRune>0 then
	--					Oldhand_AddMessage("使用死亡符文传染，序号："..plageRune);
	--					Oldhand_CastSpell("传染","Spell_Shadow_PlagueCloud");
	--					return true;
	--				end
	--			end
	--		elseif not Api_CheckRune(plageRune) then
	--			local temp = GetTime() - plagueTime;
	--			Oldhand_AddMessage("已使用符文 " ..plageRune.. " 施放传染...距离上次传染时间："..temp.." 秒");
	--			plagueTime = GetTime();
	--			
	--			plageRune = 0;
	--		else
	--			return Oldhand_CastSpell("传染","Spell_Shadow_PlagueCloud");
	--		end
	--	end;
	--end;
	if debuff1 and debuff2 then
	  if Oldhand_CastSpell("血液沸腾","Spell_DeathKnight_BloodBoil") then return true; end;
	elseif not debuff1 then
		plageRune = 0;
		if Oldhand_CastSpell("冰冷触摸","Spell_Frost_ArcticWinds") then return true; end;
	elseif not debuff2 then
		plageRune = 0;
		if Oldhand_CastSpell("暗影打击","Spell_DeathKnight_EmpowerRuneBlade") then return true; end;
	end;


	if Oldhand_CastSpell("灵界打击","Spell_DeathKnight_Butcher2") then return true; end;

	if (UnitPower("player") > 80) then
		if Oldhand_CastSpell("凋零缠绕","Spell_Shadow_DeathCoil") then return true; end;
	end 
	if not Api_CheckRunes() then
		if Oldhand_CastSpell("符文武器增效","INV_Sword_62") then return true; end;
	end
	
	
	Oldhand_SetText("无动作",0);
	return;		

end;

function Api_CheckRunes()
	for i=1, 6 do
		local _, _, runeReady = GetRuneCooldown(i);
		if runeReady then return true;end;
	end
	return false;
end

function DeathKnight_playerSafe()
	local HealthPercent = Oldhand_GetPlayerHealthPercent("player");
	if (HealthPercent < 50) then Oldhand_AddMessage('血量过低 '..HealthPercent); end;
	
	if (DeathKnight_DPS == 0 or DeathKnight_DPS == 1) then
		if HealthPercent < 50 then
			if Oldhand_CastSpell("吸血鬼之血", "Spell_Shadow_LifeDrain") then return true; end;
			if Oldhand_CastSpell("符文分流", "Spell_DeathKnight_RuneTap") then return true; end;
		end
	end
	if (UnitIsPlayer("target") and UnitCanAttack("player", "target")) or (HealthPercent < 55) then
		if null==Oldhand_PlayerBU("冰封之韧") then
			if Oldhand_CastSpellIgnoreRange("冰封之韧", deathknight_action_table["冰封之韧"]) then return true; end;
		end
		local debufftype = Oldhand_TestPlayerDebuff("player");
		if debufftype == 1 or debufftype == 3 then
			if Oldhand_PunishingBlow_Debuff() or (UnitClass("target")~="战士" and UnitClass("target")~="猎人" and UnitClass("target")~= "盗贼" and UnitClass("target")~="死亡骑士") then
				if Oldhand_CastSpell("反魔法护盾", deathknight_action_table["反魔法护盾"]) then return true; end;
			end
		end
	end;
	if HealthPercent < 60 then
		if (DeathKnight_DPS == 1) then
			if Oldhand_CastSpell("吸血鬼之血", deathknight_action_table["吸血鬼之血"]) then return true; end;
		end
		if Oldhand_CastSpell("灵界打击", deathknight_action_table["灵界打击"]) then return true; end;
		--if Oldhand_CastSpell("治疗石", deathknight_action_table["治疗石"]) then return true; end;
	end
	if HealthPercent < 70 then
		--if Oldhand_CastSpell("生命之血", "Spell_Nature_WispSplodeGreen") then return true; end;
		--if Oldhand_CastSpell("枯骨之钥", "inv_misc_key_15") then return true; end;
	end
	if HealthPercent < 80 then
		
		--if (Oldhand_TestTrinket("英雄勋章")) then
		--	if Oldhand_CastSpell("英雄勋章","INV_Jewelry_Talisman_07") then return true; end;
		--end
	end;
	
	if HealthPercent < 90 and Oldhand_PlayerBU("黑暗援助")~=null then
	  if Oldhand_CastSpell("灵界打击", deathknight_action_table["灵界打击"]) then return true; end;
	end;

	return false;
end;

--function Api_SetPlague(flag)
--	plagueTime = 0;
--	plageRune = 0;
--	if (plagueMode==0) then
--		plagueMode = 1;
--		Oldhand_AddMessage("已设置允许传染");
--	else
--		plagueMode = 0;
--		Oldhand_AddMessage("已设置禁止传染");
--	end
--end

--INV_ValentinePerfumeBottle
--Spell_Arcane_ManaTap
--Spell_Shadow_Teleport
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
local target_count = 0;		-- 目标个数
local target_table = {};	

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
-- 5 Spell_Nature_ShamanRage  黑暗命令                                         
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

local  DeathKnight_IGNORELIST = {
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
	
local DeathKnight_SKIP_LIST = {
		["无梦睡眠"] = true,
		["强效昏睡"] = true,
		["心灵视界"] = true,
	};
local 	DeathKnight_CLASS_DRUID   = '德鲁伊';
local 	DeathKnight_CLASS_HUNTER  = '猎人';
local 	DeathKnight_CLASS_MAGE    = '法师';
local 	DeathKnight_CLASS_PALADIN = '圣骑士';
local 	DeathKnight_CLASS_PRIEST  = '牧师';
local 	DeathKnight_CLASS_ROGUE   = '盗贼';
local 	DeathKnight_CLASS_SHAMAN  = '萨满祭司';
local 	DeathKnight_CLASS_WARLOCK = '术士';
local 	DeathKnight_CLASS_DeathKnight_ = '战士';

local DeathKnight_SKIP_BY_CLASS_LIST = {
		[DeathKnight_CLASS_DeathKnight_] = {		
			["上古狂乱"]   = true,
			["点燃法力"]   = true,
			["污浊之魂"]   = true,
		};
		[DeathKnight_CLASS_ROGUE] = {			
			["沉默"]       = true;
			["上古狂乱"]   = true,
			["点燃法力"]   = true,
			["污浊之魂"]   = true,
			["煽动烈焰"]   = true,	
			["熔岩镣铐"]   = true,
		};
		[DeathKnight_CLASS_HUNTER] = {			
			["煽动烈焰"]   = true,	
		};
		[DeathKnight_CLASS_MAGE] = {			
			["煽动烈焰"]   = true,	
		};
		[DeathKnight_CLASS_DRUID]= {
			["煽动烈焰"]   = true,	
		};
		[DeathKnight_CLASS_PALADIN]= {
			["煽动烈焰"]   = true,	
		};
		[DeathKnight_CLASS_PRIEST]= {
			["煽动烈焰"]   = true,	
		};
		[DeathKnight_CLASS_SHAMAN]= {
			["煽动烈焰"]   = true,	
		};
		[DeathKnight_CLASS_WARLOCK]= {
			["煽动烈焰"]   = true,	
		};
	};

local action_table = {};

action_table["自动攻击"] = 1087637;
action_table["血性狂怒"] = 135726;

-- 鲜血

-- 冰霜
action_table["湮灭"] = 135771;
action_table["凛风冲击"] = 135833;
action_table["冰霜之镰"] = 1060569;
action_table["冰霜打击"] = 237520;
action_table["冰霜之柱"] = 458718;
action_table["符文武器增效"] = 135372;
action_table["冰霜突进"] = 537514;

-- 邪恶
action_table["暗影之爪"] = 615099;
action_table["脓疮打击"] = 879926;
action_table["凋零缠绕"] = 136145;
action_table["灵魂收割"] = 636333;
action_table["灵界打击"] = 237517;
action_table["黑暗突变"] = 342913;
action_table["反魔法护罩"] = 136120;

action_table["死亡之握"] = 237532;
action_table["爆发"] = 348565;
action_table["心灵冰冻"] = 237527;
action_table["寒冰锁链"] = 135834;

action_table["冰封之韧"] = 237525;
action_table["黑暗仲裁者"] = 298674;
action_table["召唤石像鬼"] = 458967;
action_table["战斗的召唤"] = 132485;
action_table["幽魂步"] = 110041;
action_table["亡者复生"] = 136119;


-- 饰品
action_table["霸权印记"] = 134086;
action_table["奥拉留斯的疯狂耳语"] = 340336;

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


function DeathKnight_AutoSelectMode()
	if UnitAffectingCombat("player")~=1 then
	  local currentSpec = GetSpecialization();
	  local currentSpecName = currentSpec and select(2, GetSpecializationInfo(currentSpec)) or "None"
	  DeathKnight_DPS = currentSpec;
	  if DeathKnight_DPS == 1 then
	    DeathKnight_AddMessage("当前天赋：鲜血.."..currentSpecName);
	  elseif DeathKnight_DPS == 2 then
	    DeathKnight_AddMessage("当前天赋：冰霜.."..currentSpecName);
	  elseif DeathKnight_DPS == 3 then
	    DeathKnight_AddMessage("当前天赋：邪恶.."..currentSpecName);
	  end;
	end
end

-- 打断施法
local currTargetCasting = "";

function DeathKnight_BreakCasting(myspell)
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

function DeathKnight_TestPlayerDebuff(unit)	
	--if DeathKnight_GetPlayerHealthPercent(unit) < 40 then return 0; end;
	local i = 1;	
	while UnitDebuff(unit, i ) do
		DeathKnightTooltip:SetOwner(DeathKnight_MSG_Frame, "ANCHOR_BOTTOMRIGHT", 0, 0);
		DeathKnightTooltip:SetUnitDebuff(unit, i);		
		local	debuff_name = DeathKnightTooltipTextLeft1:GetText();
		local   debuff_type = DeathKnightTooltipTextRight1:GetText();				
		DeathKnightTooltip:Hide();
		if (debuff_name) and (debuff_type) then
			if (DeathKnight_IGNORELIST[debuff_name]) then
				break;
			end
			if (UnitAffectingCombat("player")) then
				if (DeathKnight_SKIP_LIST[debuff_name]) then
					break;
				end
				if (DeathKnight_SKIP_BY_CLASS_LIST[UClass]) then
					if (DeathKnight_SKIP_BY_CLASS_LIST[UClass][debuff_name]) then
						break;
					end
				end
			end						
			if (debuff_type) then
				if (debuff_type == DeathKnight_MAGIC) then							
					return 1;
				elseif (debuff_type == DeathKnight_DISEASE) then							
					return 2;
				elseif (debuff_type == DeathKnight_POISON) then							
					return 3;
				elseif (debuff_type == DeathKnight_CURSE) then							
					return 4;					
				end
			end	
		end;
		i = i + 1;
	end	
	return 0;
end

function DeathKnight_RegisterEvents(self)
	local englishClass;
	playerClass, englishClass = UnitClass("player");
	if not (playerClass=="死亡骑士") then
			HideUIPanel(DeathKnight_MSG_Frame);
			HideUIPanel(DeathKnightColorRectangle);
			return;
	end;
	self:RegisterEvent("PLAYER_ENTERING_WORLD");		
	self:RegisterEvent("UI_ERROR_MESSAGE");	
	self:RegisterEvent("PLAYER_TARGET_CHANGED");
	self:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED");
	--self:RegisterEvent("INSPECT_TALENT_READY");
	
	UnitPopupButtons["DeathKnightPOPUP"] = { text = "智能施法跟随对象", dist = 0 };	
		
	if (UnitPopupMenus["SELF"]) then
		--table.insert( UnitPopupMenus["SELF"], "DeathKnightPOPUP");
	end	
	if (UnitPopupMenus["PLAYER"]) then
		--table.insert( UnitPopupMenus["PLAYER"], "DeathKnightPOPUP");		
	end
	if (UnitPopupMenus["PARTY"]) then
		--table.insert( UnitPopupMenus["PARTY"], "DeathKnightPOPUP");		
	end
	
	--DeathKnight_Old_UnitPopup_OnClick = UnitPopup_OnClick;
	--UnitPopup_OnClick = DeathKnight_UnitPopup_OnClick;
end;
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
function DeathKnight_OnEvent(event)	
	if not (playerClass=="死亡骑士") then return; end;
	if (event=="PLAYER_ENTERING_WORLD") then
		DeathKnight_Data = {};
		DeathKnight_Data[UnitName("player")] = 
					{			
					DeathKnight={},
					};
		if( DeathKnight_SaveData == nil ) then
		    DeathKnight_SaveData = {};
		end
		
		if (DeathKnight_ActionTable == nil) then
		    DeathKnight_ActionTable = {};
		    DeathKnight_Test();
		end
		DEFAULT_CHAT_FRAME:AddMessage("智能施法插件 2.0 (死亡骑士版)   www.oldhand.net 版权所有");			
		getglobal("DeathKnightColorRectangle".."NormalTexture"):SetVertexColor(0, 0, 0);
		DeathKnight_AutoSelectMode();	
		DeathKnight_CreateMacro();
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
					 DeathKnight_AddMessage_A("**你的目标是"..GetTalentTabInfo(s,true).."天赋的"..UnitClass("target").."**");
				   end
				   if UnitIsUnit("player","target") and UnitAffectingCombat("player") ~= 1 then
						DeathKnight_CreateMacro();
				   end;
				   if not UnitCanAttack("player","target")  then
						if UnitClass("target") == "德鲁伊" and GetTalentTabInfo(s,true) == "野性战斗" then
							DeathKnight_AddPlayerTalent(UnitName("target"));
						end;
						if UnitClass("target") == "圣骑士" and GetTalentTabInfo(s,true) == "防护" then
							DeathKnight_AddPlayerTalent(UnitName("target"));
						end;
						if UnitClass("target") == "战士" and GetTalentTabInfo(s,true) == "防护" then
							DeathKnight_AddPlayerTalent(UnitName("target"));
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
			DeathKnight_AutoSelectMode();	
			DeathKnight_CreateMacro();
		end;
		if UnitIsPlayer("target") and not UnitIsUnit("player","target") then	
			NotifyInspect("playertarget");
		end;	
	end;	

end;

function DeathKnight_AddPlayerTalent(playername)
	for k, v in pairs(DeathKnight_PlayerTalentInfoDatas) do							
		if(playername == v["Name"]) then
			return;
		end		
	end

	table.insert(DeathKnight_PlayerTalentInfoDatas,
		{
		["Name"] = playername,
		});
end
function DeathKnight_GetPlayerTalent(playername)
	for k, v in pairs(DeathKnight_PlayerTalentInfoDatas) do							
		if(playername == v["Name"]) then
			return true;
		end		
	end
	return false;
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
	
	--if DeathKnight_PickupSpellByBook("攻击") then
	--	PlaceAction(1);
	--	ClearCursor();	
	--end;
	DeathKnight_PutAction("自动攻击", 1);

	DeathKnight_PutAction("灵界打击", 7);
	
	DeathKnight_PutAction("反魔法护罩", 11);

	DeathKnight_PutAction("死亡之握", 61);

	DeathKnight_PutAction("心灵冰冻", 64);

	DeathKnight_PutAction("幽魂步", 69);
		
	if DeathKnight_DPS==1 then
		DeathKnight_PutAction("冰冷触摸", 3);
		DeathKnight_PutAction("符文刃舞", 71);
	elseif DeathKnight_DPS==2 then
	  DeathKnight_PutAction("湮没", 2);
		DeathKnight_PutAction("凛风冲击", 3);
		DeathKnight_PutAction("冰霜打击", 5);
		DeathKnight_PutAction("冰霜之柱", 8);
		DeathKnight_PutAction("冷酷严冬", 9);
	elseif DeathKnight_DPS==3 then
		DeathKnight_PutAction("暗影之爪", 2);   -- 615099
		DeathKnight_PutAction("脓疮打击", 3);   -- 879926
		DeathKnight_PutAction("凋零缠绕", 4);   -- 136145
	  DeathKnight_PutAction("灵魂收割", 6);
		DeathKnight_PutAction("白骨之盾", 8);
		DeathKnight_PutAction("黑暗突变", 10);
		DeathKnight_PutAction("传染", 62);
		DeathKnight_PutAction("爆发", 63);  -- spell_deathvortex
		DeathKnight_PutAction("召唤石像鬼", 67);
		DeathKnight_PutAction("亡者复生", 70);
		
	else
		DeathKnight_PutAction("凋零缠绕", 4);
		DeathKnight_PutAction("黑暗命令", 5);
		DeathKnight_PutAction("邪恶虫群", 9);
		DeathKnight_PutAction("白骨之盾", 67);
	end

	if DeathKnight_DPS==0 or DeathKnight_DPS==1 then
		if not DeathKnight_PutAction("符文分流", 8) then
			DeathKnight_PutAction("狂乱", 8);
		end
		DeathKnight_PutAction("吸血鬼之血", 63);

	elseif DeathKnight_DPS==1 then
		-- DeathKnight_PutAction("铜墙铁壁", 8);
	elseif DeathKnight_DPS==0 then
		DeathKnight_PutAction("血液沸腾", 63);
	else
		DeathKnight_PutAction("符文分流", 8);
		DeathKnight_PutAction("吸血鬼之血", 63);
	end
	--DeathKnight_PutAction("符文分流", 8);

	if DeathKnight_TestTrinket("枯骨之钥") then
		DeathKnight_PutAction("枯骨之钥", 64);
	else
		DeathKnight_PutAction("寒冰锁链", 65);
	end;
	DeathKnight_PutAction("冰封之韧", 66);
	--DeathKnight_PutAction("天灾契约", 68);
	DeathKnight_PutAction("符文武器增效", 70);
	
	if DeathKnight_TestTrinket("部落勋章") then
		DeathKnight_PutAction("部落勋章", 71);
	elseif DeathKnight_TestTrinket("卡德罗斯的印记") then
		DeathKnight_PutAction("卡德罗斯的印记", 71);
		spell_table["卡德罗斯的印记"] = 71;
	elseif DeathKnight_TestTrinket("磁力之镜") then
		DeathKnight_PutAction("磁力之镜", 71);
	elseif DeathKnight_TestTrinket("菲斯克的怀表") then
		DeathKnight_PutAction("菲斯克的怀表", 71);
	elseif DeathKnight_TestTrinket("恐惧小盒") then
		DeathKnight_PutAction("恐惧小盒", 71);
	elseif DeathKnight_TestTrinket("恐惧小盒") then
		DeathKnight_PutAction("战歌的热情", 71);
	elseif DeathKnight_TestTrinket("苔原护符") then
		DeathKnight_PutAction("苔原护符", 71);
	end
	if DeathKnight_TestTrinket("霸权印记") then
	  --if GetMacroIndexByName("血性狂怒") == 0 then
  	--	CreateMacro("霸权印记", 66, "/cast 血性狂怒", 1, 1);
  	--end;
		DeathKnight_PutAction("霸权印记", 72);
	
	elseif DeathKnight_TestTrinket("英雄勋章") then
		DeathKnight_PutAction("英雄勋章", 72);
	elseif DeathKnight_TestTrinket("伊萨诺斯甲虫") then
		DeathKnight_PutAction("伊萨诺斯甲虫", 72);
	elseif DeathKnight_TestTrinket("刃拳的宽容") then
		DeathKnight_PutAction("刃拳的宽容", 72);
	end
	
	spell_table["霸权印记"] = 72;
	DeathKnight_PutAction("血性狂怒", 51);

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

function DeathKnight_PutAction(text, index)
  --if text == "自动攻击" then PickupAction(2);PlaceAction(8);ClearCursor(); end
	if not text then return false;end;
	if DeathKnight_PickupSpellByBook(text) then
		PlaceAction(index);
		ClearCursor();
		spell_table[text] = index;
		return true;
	end;
	spell_table[text] = 0;
	return false;
end;

function DeathKnight_NoTarget_RunCommand()
	if 1~=UnitAffectingCombat("player") then
		if DeathKnight_RunCommand() then return true; end;
	end
	return false;
end;

function DeathKnight_Test_IsFriend(unitname)
	if (UnitInRaid("player")) then
		for id=1, GetNumGroupMembers()  do
			if UnitName("raid"..id) == unitname then
				if UnitCanAttack("player","raid"..id) then return false; end;
				return true;
			end;			
		end
	else
		for id=1, GetNumSubgroupMembers()  do
			if UnitName("party"..id) == unitname then
				if UnitCanAttack("player","party"..id) then return false; end;
				return true;
			end;
		end
	end
	return false;
end;
function DeathKnight_Damage_Message(arg1, event)
	if (not arg1) then
		return;
	end;

	if event == "CHAT_MSG_SPELL_HOSTILEPLAYER_BUFF" then	
		for creatureName,creatureName1 in string.gmatch(arg1, "(.+)对(.+)使用消失。") do	
			if not DeathKnight_Test_IsFriend(creatureName)  then
				DeathKnight_AddMessage("|cff00adef"..creatureName.."|r|cff00ff00使用了消失!自动使用奉献!|r");
				table.insert(DeathKnight_Data[UnitName("player")]["Rogue"],{["Command"] = "奉献"});				
				StartTimer("Ability_DeathKnight_WarCry");
			end	
			return;
		end;
	end;
	
	local playerUnitName = UnitName("Player");	
	if (string.find(arg1, "打断") >= 0) and string.find(arg1, playerUnitName) >= 0 then 			
		DeathKnight_AddMessage(arg1);
	end;
	if ( event == "CHAT_MSG_SPELL_SELF_DAMAGE" ) then
		
		for spellname, creatureName, spell in string.gmatch(arg1, playerUnitName.."的(.+)打断了(.+)的(.+)。") do							       
			DeathKnight_AddMessage("**你的"..spellname.."打断了"..creatureName.."的"..spell.."...**");
			return;
		end;
		for spell, creatureName, damage in string.gmatch(arg1, "你的(.+)击中(.+)造成(%d+)点伤害。") do
			if spell and damage > 800 then
				DeathKnight_AddMessage("你的|cffffff00"..spell.."|r|cff00ff00造成|r|cffffff00"..damage.."|r|cff00ff00伤害...|r");				       
				return;
			end;
		end;			
		for spell, creatureName, damage in string.gmatch(arg1, "你的(.+)爆击对(.+)造成(%d+)点伤害。") do
			if spell and damage > 800 then
				DeathKnight_AddMessage("你的|cffffff00"..spell.."|r|cff00ff00造成|r|cffffff00"..damage.."|r|cff00ff00伤害(爆击)|r");
				return;
			end;
		end;
		for spell, creatureName, damage, damageType in string.gmatch(arg1, "你的(.+)击中(.+)造成(%d+)点(.+)伤害。") do
			if spell and damage > 800 then
				DeathKnight_AddMessage("你的|cffffff00"..spell.."|r|cff00ff00造成|r|cffffff00"..damage.."|r|cff00ff00伤害...");
				return;
			end;
		end;
		for spell, creatureName, damage, damageType in string.gmatch(arg1, "你的(.+)爆击对(.+)造成(%d+)点(.+)伤害。") do
			if spell and damage > 800 then
				DeathKnight_AddMessage("你的|cffffff00"..spell.."|r|cff00ff00造成|r|cffffff00"..damage.."|r|cff00ff00伤害(爆击)|r");
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
			DeathKnight_AddMessage(arg1);		
			for playerName, spell, creatureName, damage in string.gmatch(arg1, "(.+)的(.+)发挥极效，为(.+)恢复了(%d+)点生命值。") do
				if creatureName == "你" then 
					DeathKnight_AddMessage("|cff00adef"..playerName.."|r|cff00ff00的|r|cffffff00"..spell.."|r|cff00ff00x给我恢复了|r|cffffff00"..damage.."|r|cff00ff00生命值...|r");				       
				end;
				return;
			end;
			for playerName, spell, creatureName, damage in string.gmatch(arg1, "(.+)的(.+)为(.+)恢复了(%d+)点生命值。") do
				if creatureName == "你" then 
					DeathKnight_AddMessage("|cff00adef"..playerName.."|r|cff00ff00的|r|cffffff00"..spell.."|r|cff00ff00给我恢复了|r|cffffff00"..damage.."|r|cff00ff00生命值...|r");				       
				end;
				return;
			end;
		end;	
end;

function DeathKnight_Input(i)	
	DeathKnight_DPS = DeathKnight_DPS + 1;
	if (DeathKnight_DPS > 3) then DeathKnight_DPS = 0; end;
	
	if DeathKnight_DPS == 0 then
		DeathKnight_AddMessage("进入鲜血模式(PVP适用)...");
	elseif DeathKnight_DPS == 1 then
		DeathKnight_AddMessage("进入鲜血坦克模式(PVP适用)...");
	elseif DeathKnight_DPS == 2 then
		DeathKnight_AddMessage("进入冰霜模式(PVP适用)...");
	elseif DeathKnight_DPS == 3 then
		DeathKnight_AddMessage("进入邪恶模式(PVP适用)...");
	else
		DeathKnight_AddMessage("进入坦克模式...");
	end
	DeathKnight_CreateMacro();
end;

function DeathKnight_Msg_OnUpdate()
	if playerClass~="死亡骑士" then return; end;
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
					--EditMacro(MacroIndex,"TargetParty"..id, 63, "/target "..UnitName(unit), 1, 1);
					--SetBindingMacro("CTRL-SHIFT-F".. id,"TargetParty"..id)
					--SaveBindings(1);
				end;
			else
				--CreateMacro("TargetParty"..id, 63, "/target "..UnitName(unit), 1, 1);
				--SetBindingMacro("CTRL-SHIFT-F".. id,"TargetParty"..id)
				--SaveBindings(1);
			end;
		end;
	end;	
end;

function DeathKnight_Frame_OnUpdate()
	if playerClass~="死亡骑士" then return; end;
	--if(ChatFrameEditBox:IsVisible()) then
	local activeWindow = ChatEdit_GetActiveWindow();
	if ( activeWindow ) then
		DeathKnight_SetText("聊天状态",0);
		return;	
	end;
	if UnitIsDeadOrGhost("player") then 
	  DeathKnight_SetText("死亡状态",0);
		return; 
	end;
	if not UnitAffectingCombat("player") then
		plageRune = 0;
		step = 0;
		DeathKnight_ClearTargetTable();
	end;
	if UnitOnTaxi("player") == 1 then return; end;

	if DeathKnight_TestPlayerIsHorse() then			
		if IsActionInRange(DeathKnight_GetActionID("Spell_Holy_SealOfMight")) ~= 1  then
		    DeathKnight_SetText("骑乘状态",0);
			return;			
		end;	
	end;
	
	if (DeathKnight_PlayerBU("喝水") or DeathKnight_PlayerBU("进食")) and UnitAffectingCombat("player")~=1 then 
		DeathKnight_SetText("正在喝水",0); 
		return; 
	end;
	
	local spellname = UnitCastingInfo("player")
	if spellname then
		DeathKnight_SetText("施放"..spellname,0);
		return;
	end
	
	TestHelpTarget = "";

	if DeathKnight_Use_INV_Jewelry_TrinketPVP_02() then return; end;	

	if DeathKnight_NoControl_Debuff() then
		DeathKnight_SetText("被控制...",0);
		return;
	end;

	if DeathKnight_NoTarget_RunCommand() then return; end;

	if DeathKnight_dps_playerSafe() then return; end;
	--if DeathKnight_HelpTarget() then return; end;

	if not UnitExists("playertarget") then
		DeathKnight_SetText("没有目标", 0);		
		return; 
	end;
	if UnitIsDead("playertarget") then
		DeathKnight_SetText("目标死亡", 0);		
		return; 
	end;
	if not UnitCanAttack("player", "target")  then
		DeathKnight_SetText("友善目标", 0);		
		return;
	end;
	
	if UnitAffectingCombat("player") or IsCurrentAction(DeathKnight_Auto_Attack()) then
		if DeathKnight_DPS==0 then
			DeathKnight_DpsOut0();
		elseif DeathKnight_DPS==1 then
			DeathKnight_DpsOut1();
		elseif DeathKnight_DPS==2 then
			DeathKnight_DpsOut2();
		else
			DeathKnight_DpsOut3();
		end
		return;
	end
	DeathKnight_SetText("无动作", 0);	
end;
function  DeathKnight_PlayerVsPlayer()
	return;
end;
function DeathKnight_AutoDrink()	
	return false;
end

function DeathKnight_RunCommand()
  local buff = DeathKnight_PlayerBU("疯狂耳语");
	if null==buff then
		if DeathKnight_CastSpellByIdIgnoreRange("奥拉留斯的低语水晶", spell_table["奥拉留斯的低语水晶"]) then return true; end;
	end;

	if UnitAffectingCombat("player") then
		local id1 = DeathKnight_GetActionID(action_table["血性狂怒"]);
		if id1~=0 and null==DeathKnight_PlayerBU("血性狂怒") then
		  local isNearAction = IsActionInRange(DeathKnight_GetActionID(action_table["灵界打击"])) == true;
			if isNearAction then -- 灵界打击有效
				if (GetActionCooldown(DeathKnight_GetActionID(action_table["血性狂怒"])) == 0) then 
					DeathKnight_SetText("血性狂怒", 29);
					return true;
				end
			end;
		end

		if DeathKnight_DPS==2 then
			local name, remainTime = DeathKnight_PlayerBU("冰霜之柱");
			if name==null then
				--if DeathKnight_CastSpell("铜墙铁壁","INV_Armor_Helm_Plate_Naxxramas_RaidWarrior_C_01") then return true; end;
				if DeathKnight_CastSpell("冰霜之柱","ability_deathknight_pillaroffrost") then return true; end;
			elseif remainTime > 29 then
				--DeathKnight_SetText("活力分流",28); 
				DeathKnight_CastSpell("活力分流","Spell_DeathKnight_BloodTap");
				return true;
			end
		end
	end

	return false;
end;
function DeathKnight_Auto_Trinket()
  -- 是否近战范围
  local isNearAction = IsActionInRange(DeathKnight_GetActionID(237517)) == true;
  
	if null==DeathKnight_PlayerBU("极化") then
		if DeathKnight_TestTrinket("磁力之镜") and (isNearAction)  then
			if DeathKnight_CastSpell("磁力之镜", "inv_stone_sharpeningstone_05") then return true; end		
		end
	end
	if null==DeathKnight_PlayerBU("台风") then
		if DeathKnight_TestTrinket("海洋之力") and (IsActionInRange(DeathKnight_GetActionID("Spell_Deathknight_DeathStrike")) == 1)  then
			if DeathKnight_CastSpellbyID("海洋之力", spell_table["海洋之力"]) then return true; end		
		end
	end
	
	if null==DeathKnight_PlayerBU("非凡战力") then
		if DeathKnight_TestTrinket("卡德罗斯的印记") and (IsActionInRange(DeathKnight_GetActionID("Spell_Deathknight_DeathStrike")) == 1)  then
			if DeathKnight_CastSpellbyID("卡德罗斯的印记", spell_table["卡德罗斯的印记"]) then return true; end		
		end
	end
	if null==DeathKnight_PlayerBU("战斗！") then
		if DeathKnight_TestTrinket("克瓦迪尔战旗") and (IsActionInRange(DeathKnight_GetActionID("Spell_Deathknight_DeathStrike")) == 1)  then
			if DeathKnight_CastSpellbyID("克瓦迪尔战旗", spell_table["克瓦迪尔战旗"]) then return true; end		
		end
	end
	if null==DeathKnight_PlayerBU("怒火") and null==DeathKnight_PlayerBU("狂怒") then
	  local range1 = IsActionInRange(DeathKnight_GetActionID("Spell_DeathKnight_EmpowerRuneBlade2")); -- 冰霜打击
	  
	  --if range1 == 1 then
	  --  DeathKnight_AddMessage("冰霜打击 距离 ....... 1");
	  --elseif range1 == 0 then
	  --  DeathKnight_AddMessage("冰霜打击 距离 ....... 0");
	  --elseif range1 == nil then
	  --  DeathKnight_AddMessage("冰霜打击 距离 ....... nil");
	  --elseif range1 == null then
	  --  DeathKnight_AddMessage("冰霜打击 距离 ....... null");
	  --elseif range1 == true then
	  --  DeathKnight_AddMessage("冰霜打击 距离 ....... true");
	  --elseif range1 == false then
	  --  DeathKnight_AddMessage("冰霜打击 距离 ....... false");
	  --else 
	  --  DeathKnight_AddMessage("冰霜打击 距离 ....... 其他");
	  --end;

		if DeathKnight_TestTrinket("霸权印记") and (isNearAction) then
			local target_health_percent, target_health = DeathKnight_GetPlayerHealthPercent("target");
			-- DeathKnight_AddMessage("霸权印记 目标血量："..target_health.."/"..target_health_percent.."%");
			if target_health > 300000 then                                    
			  if DeathKnight_CastSpellByIdIgnoreRange("霸权印记", spell_table["霸权印记"]) then return true; end;
			  --if DeathKnight_CastSpellbyID("霸权印记", spell_table["霸权印记"]) then return true; end;
			  --DeathKnight_AddMessage("霸权印记 未执行成功..........."..spell_table["霸权印记"]);
			  
			  local i = spell_table["霸权印记"];
			  if i > 0 then   
			    DeathKnight_SetText("霸权印记", i - 48);
			  end;
			end;
		end
	end
	if null==DeathKnight_PlayerBU("银色英勇") then
		if DeathKnight_TestTrinket("菲斯克的怀表") and (IsActionInRange(DeathKnight_GetActionID("Spell_Deathknight_DeathStrike")) == 1 or IsActionInRange(DeathKnight_GetActionID("Spell_DeathKnight_Butcher2")) == 1)  then
			if DeathKnight_CastSpell("菲斯克的怀表","INV_Misc_AhnQirajTrinket_03") then return true; end		
		end
	end
	if null==DeathKnight_PlayerBU("野性狂怒") then
		if DeathKnight_TestTrinket("战歌的热情") and (IsActionInRange(DeathKnight_GetActionID("Spell_Deathknight_DeathStrike")) == 1)  then
			if DeathKnight_CastSpellbyID("战歌的热情", spell_table["战歌的热情"]) then return true; end		
		end
	end
	if null==DeathKnight_PlayerBU("奥术灌注") then
		if DeathKnight_TestTrinket("伊萨诺斯甲虫") and (IsActionInRange(DeathKnight_GetActionID("Spell_Deathknight_DeathStrike")) == 1)  then
			--DeathKnight_AddMessage("准备施放。。。伊萨诺斯甲虫 "..spell_table["伊萨诺斯甲虫"]);
			if DeathKnight_CastSpellbyID("伊萨诺斯甲虫", spell_table["伊萨诺斯甲虫"]) then return true; end		
		end
	end
	
	if null==DeathKnight_PlayerBU("精准打击") then
		if DeathKnight_TestTrinket("苔原护符") and (IsActionInRange(DeathKnight_GetActionID("Spell_Deathknight_DeathStrike")) == 1)  then
			if DeathKnight_CastSpellbyID("苔原护符", spell_table["苔原护符"]) then return true; end;
		end
	end
	if null==DeathKnight_PlayerBU("凶暴") then
		if DeathKnight_TestTrinket("刃拳的宽容") and (IsActionInRange(DeathKnight_GetActionID("Spell_Deathknight_DeathStrike")) == 1)  then
			if DeathKnight_CastSpellbyID("刃拳的宽容", spell_table["刃拳的宽容"]) then return true; end		
		end
	end
	if null==DeathKnight_PlayerBU("卓越坚韧") then
		if DeathKnight_TestTrinket("外交徽记") and (IsActionInRange(DeathKnight_GetActionID("Spell_Deathknight_DeathStrike")) == 1)  then
			if DeathKnight_CastSpellbyID("外交徽记", spell_table["外交徽记"]) then return true; end		
		end
	end
	
	--if DeathKnight_GetActionID("INV_Misc_MonsterScales_15") ~= 0 then
	--	if DeathKnight_TestTrinket("嗜血胸针") and (IsActionInRange(DeathKnight_GetActionID("Spell_Deathknight_DeathStrike")) == 1)  then
	--		if DeathKnight_CastSpell("嗜血胸针","INV_Misc_MonsterScales_15") then return true; end		
	--	end
	--end;
	--if  DeathKnight_GetActionID("INV_ValentinePerfumeBottle") ~= 0 then
	--	if DeathKnight_TestTrinket("殉难者精华") and (IsActionInRange(DeathKnight_GetActionID("Spell_Holy_HolyBolt")) == 1)  then
	--		if DeathKnight_CastSpell("殉难者精华","INV_ValentinePerfumeBottle") then return true; end		
	--	end
	--end  	
	return false;
end
function DeathKnight_dps_playerSafe()
	--if not DeathKnight_PlayerDeBU("断筋") or not DeathKnight_PlayerDeBU("减速药膏") or not DeathKnight_PlayerDeBU("寒冰箭") or not DeathKnight_PlayerDeBU("冰冻") or not DeathKnight_PlayerDeBU("冰霜陷阱光环")
	--	or not DeathKnight_PlayerDeBU("强化断筋") or not DeathKnight_PlayerDeBU("减速术") or not DeathKnight_PlayerDeBU("摔绊") or not DeathKnight_PlayerDeBU("震荡射击")
	--   	or not DeathKnight_PlayerDeBU("地缚术") or not DeathKnight_PlayerDeBU("冰霜震击") or not DeathKnight_PlayerDeBU("疲劳诅咒") 
	--   	or not DeathKnight_PlayerDeBU("冰霜新星") or not DeathKnight_PlayerDeBU("纠缠根须") or not DeathKnight_PlayerDeBU("霜寒刺骨")  then
	   	
	--end;
	--if not DeathKnight_PlayerDeBU("偷袭") or not DeathKnight_PlayerDeBU("肾击") or not DeathKnight_PlayerDeBU("制裁之锤") then
	--end;
	return false;
end;

function DeathKnight_PunishingBlow_Debuff()
	if not DeathKnight_TargetDeBU("月火术") 
	or not DeathKnight_TargetDeBU("腐蚀术")
	or not DeathKnight_TargetDeBU("献祭")  
	or not DeathKnight_TargetDeBU("暗言术：痛") 
	or not DeathKnight_TargetDeBU("噬灵瘟疫") 
	or not DeathKnight_TargetDeBU("毒蛇钉刺") 
	then
		return true;
	end
	return false;
end

-- 鲜血模式
function DeathKnight_DpsOut0()
    if DeathKnight_Test_Target_Debuff() then 
		DeathKnight_AddMessage(UnitName("target").."目标已经被控制...");			
		DeathKnight_SetText("目标已经被控制",0);
		return;
	end
	if not DeathKnight_TargetDeBU("飓风术") or not DeathKnight_TargetBU("圣盾术") or not  DeathKnight_TargetBU("保护之手") or  not DeathKnight_TargetBU("寒冰屏障") or not  DeathKnight_TargetBU("法术反射") or not  DeathKnight_TargetDeBU("放逐术") then
		DeathKnight_SetText("目标无法攻击",0);
		return ;
	end;
	if (not IsCurrentAction(DeathKnight_Auto_Attack())) and (not DeathKnight_Test_Target_Debuff()) then
		mianyi1 = 0; 
		--DeathKnight_SetText("开始攻击",26);	
		DeathKnight_SetText("攻击",1);
		return true;
	end;
	
	--if (IsActionInRange(DeathKnight_GetActionID("Spell_DeathKnight_MindFreeze")) == 1 or IsActionInRange(DeathKnight_GetActionID("Spell_Shadow_SoulLeech_3")) == 1) then
	--if (IsActionInRange(DeathKnight_GetActionIDbyName("心灵冰冻")) == 1 or IsActionInRange(DeathKnight_GetActionIDbyName("绞袭")) == 1) then
	  --DeathKnight_AddMessage("可打断");
		if DeathKnight_BreakCasting("心灵冰冻")==1 and DeathKnight_CastSpell("心灵冰冻", action_table["心灵冰冻"]) then return true; end;
		if DeathKnight_BreakCasting("绞袭")==1 and DeathKnight_CastSpell("绞袭","Spell_Shadow_SoulLeech_3") then return true; end;
  --else
  --  DeathKnight_AddMessage("不可打断");
	--end;
	
	if DeathKnight_playerSafe() then return true; end;
	
	if UnitIsPlayer("target") and UnitCanAttack("player", "target") then
		if DeathKnight_TargetDeBU("寒冰锁链") then
			if DeathKnight_CastSpell("寒冰锁链","Spell_Frost_ChainsOfIce") then return true; end;
		end;
	end;

	-- 增强	Buff
	if DeathKnight_RunCommand() then return true; end;

	-- 增强饰品
	if DeathKnight_Auto_Trinket() then return true; end;
	
	if (DeathKnight_DPS == 3 and not IsCurrentAction(DeathKnight_GetActionID("Spell_DeathKnight_DarkConviction"))) then 
		if DeathKnight_CastSpell("符文打击","Spell_DeathKnight_DarkConviction") then return true; end;
	end
	local debuff1,remainTime1 = DeathKnight_CheckDebuffByPlayer("冰霜疫病");
	local debuff2,remainTime2 = DeathKnight_CheckDebuffByPlayer("血之疫病");
	
	local strenth = 0;
	local buff1 = DeathKnight_PlayerBU("不洁之力");
	local buff2 = DeathKnight_PlayerBU("暴怒");
	local buff3 = DeathKnight_PlayerBU("伟大");
	local buff4 = DeathKnight_PlayerBU("杰出");
	local buff5 = DeathKnight_PlayerBU("憎恶之力");
	local buff6 = DeathKnight_PlayerBU("不洁之能");
	local buff7 = DeathKnight_PlayerBU("血性狂怒");
	if buff1 then strenth = strenth + 200; end;		-- 不洁之力
	if buff2 then strenth = strenth + 500; end;
	if buff3 then strenth = strenth + 350; end;
	if buff4 then strenth = strenth + 450; end;
	if buff5 then strenth = strenth + 200; end;
	if buff6 then strenth = strenth + 180; end;
	if buff7 then strenth = strenth + 160; end;

	if (debuff2 and debuff1) then 
		step = 1;
		if plagueMode==1 and target_count > 2 and target_count > 2 and ((GetTime() - plagueTime > 16) or (remainTime1>0 and remainTime1<2) or (remainTime2>0 and remainTime2<2)) then
			if plageRune==0 then
				if Api_CheckRune(1) then
					if DeathKnight_CastSpell("传染","Spell_Shadow_PlagueCloud") then
						DeathKnight_AddMessage("使用鲜血符文传染，序号：1");
						plageRune = 1;
						return true;
					end
				elseif Api_CheckRune(2) then
					if DeathKnight_CastSpell("传染","Spell_Shadow_PlagueCloud") then
						DeathKnight_AddMessage("使用鲜血符文传染，序号：2");
						plageRune = 2;
						return true;
					end
				else
					plageRune = Api_CheckDeathRune();
					if plageRune>0 then
						DeathKnight_AddMessage("使用死亡符文传染，序号："..plageRune);
						DeathKnight_CastSpell("传染","Spell_Shadow_PlagueCloud");
						return true;
					end
				end
			elseif not Api_CheckRune(plageRune) then
				local temp = GetTime() - plagueTime;
				DeathKnight_AddMessage("已使用符文 " ..plageRune.. " 施放传染...距离上次传染时间："..temp.." 秒");
				plagueTime = GetTime();
				
				plageRune = 0;
			else
				return DeathKnight_CastSpell("传染","Spell_Shadow_PlagueCloud");
			end
		end;
	else
		if strenth >= 900 or step>0 or (UnitCanAttack("player","target") and UnitIsPlayer("target")) then
			if not debuff2 then
				--plageRune = 0;
				if DeathKnight_CastSpell("暗影打击","Spell_DeathKnight_EmpowerRuneBlade") then return true; end;
			end;		
			if not debuff1 then
				--plageRune = 0;
				if DeathKnight_CastSpell("冰冷触摸","Spell_Frost_ArcticWinds") then return true; end;
			end;
		end
	end;
	
	
	if (IsCurrentAction(DeathKnight_GetActionID("Spell_Shadow_DeathAndDecay"))) then 
		DeathKnight_SetText("枯萎凋零",0);
		return true; 
	end;
	if step>0 then
		if DeathKnight_CastSpell("符文刃舞","INV_Sword_07") then return true; end;
	end
	if DeathKnight_CastSpell("心脏打击","INV_Weapon_Shortblade_40") then return true; end;
	if (UnitPower("player") >= 100) then
		if DeathKnight_CastSpell("凋零缠绕","Spell_Shadow_DeathCoil") then return true; end;
	end
	if DeathKnight_CastSpell("灵界打击","Spell_DeathKnight_Butcher2") then return true; end;
	
	--if DeathKnight_CastSpell("湮没","Spell_Deathknight_ClassIcon") then return true; end;
	--if DeathKnight_CastSpell("鲜血打击","Spell_Deathknight_DeathStrike") then return true; end;
	if DeathKnight_CastSpell("凋零缠绕","Spell_Shadow_DeathCoil") then return true; end;
	--if DeathKnight_CastSpell("冰冷触摸","Spell_Frost_ArcticWinds") then return true; end;
	if not Api_CheckRunes() then
		if DeathKnight_CastSpell("符文武器增效","INV_Sword_62") then return true; end;
	end

	DeathKnight_SetText("无动作",0);
	return;		
end;

-- 冰霜攻击
function DeathKnight_DpsOut2()
  if DeathKnight_Test_Target_Debuff() then 
		DeathKnight_AddMessage(UnitName("target").."目标已经被控制...");			
		DeathKnight_SetText("目标已经被控制",0);
		return;
	end
	if not DeathKnight_TargetDeBU("飓风术") or not DeathKnight_TargetBU("圣盾术") or not  DeathKnight_TargetBU("保护之手") or  not DeathKnight_TargetBU("寒冰屏障") or not  DeathKnight_TargetBU("法术反射") or not  DeathKnight_TargetDeBU("放逐术") then
		DeathKnight_SetText("目标无法攻击",0);
		return ;
	end;
	if (not IsCurrentAction(DeathKnight_Auto_Attack())) and (not DeathKnight_Test_Target_Debuff()) then
		mianyi1 = 0; 
		--DeathKnight_SetText("开始攻击",26);	
		DeathKnight_SetText("自动攻击", 1);
		return true;
	end;
	-- 近战范围		
	local isNearAction = IsActionInRange(DeathKnight_GetActionID(237517));

	if UnitIsPlayer("target") and UnitCanAttack("player","target") then
		if DeathKnight_TargetDeBU("寒冰锁链") then
			if DeathKnight_CastSpell("寒冰锁链", action_table["寒冰锁链"]) then return true; end;
		end;


--		  if DeathKnight_CastSpell("冷酷严冬","ability_deathknight_remoreslesswinters2") then return true; end;
--    end;
	end;
	
	if DeathKnight_GetUnitPowerPercent("player") >= 75 then
		if DeathKnight_CastSpell("冰霜打击", action_table["冰霜打击"]) then return true; end;
	end
	
	--local id1, id2 = DeathKnight_GetActionID("Spell_DeathKnight_MindFreeze"), DeathKnight_GetActionID("Spell_Shadow_SoulLeech_3");
	if DeathKnight_playerSafe() then return true; end;
	
	if DeathKnight_BreakCasting("心灵冰冻")==1 and DeathKnight_CastSpell("心灵冰冻", action_table["心灵冰冻"]) then return true; end;
	if DeathKnight_CastSpellIgnoreRange("冰霜之柱",action_table["冰霜之柱"]) then return true; end;
	
	-- 增强饰品
	if DeathKnight_Auto_Trinket() then return true; end;
  
	-- 增强	Buff
	if DeathKnight_RunCommand() then return true; end;
	local debuff1,remainTime1 = DeathKnight_CheckDebuffByPlayer("冰霜疫病");
	local debuff2,remainTime2 = DeathKnight_CheckDebuffByPlayer("血之疫病");
	if not debuff1 then
	  debuff1,remainTime1 = DeathKnight_CheckDebuffByPlayer("锋锐之霜");
	end;
	if not debuff2 then
	  debuff2,remainTime2 = DeathKnight_CheckDebuffByPlayer("死疽");
	end;

	local strenth = 0;
	local buff1 = DeathKnight_PlayerBU("不洁之力");
	local buff2 = DeathKnight_PlayerBU("暴怒");
	local buff3 = DeathKnight_PlayerBU("伟大");
	local buff4 = DeathKnight_PlayerBU("杰出");
	local buff5 = DeathKnight_PlayerBU("憎恶之力");
	local buff6 = DeathKnight_PlayerBU("不洁之能");
	local buff7 = DeathKnight_PlayerBU("血性狂怒");
	local buff8 = DeathKnight_PlayerBU("战斗!");
	local buff9 = DeathKnight_PlayerBU("台风");
	local buff10 = DeathKnight_PlayerBU("末日之眼");
	local buff11 = DeathKnight_PlayerBU("杀戮机器");
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
	  --DeathKnight_AddMessage("两个疾病")
		step = 1;
		if plagueMode==1 and target_count > 2 and ((GetTime() - plagueTime > 16) or (remainTime1>0 and remainTime1<2) or (remainTime2>0 and remainTime2<2)) then
			if plageRune==0 then
				if Api_CheckRune(1) then
					if DeathKnight_CastSpell("传染","Spell_Shadow_PlagueCloud") then
						DeathKnight_AddMessage("使用鲜血符文传染，序号：1");
						plageRune = 1;
						return true;
					end
				elseif Api_CheckRune(2) then
					if DeathKnight_CastSpell("传染","Spell_Shadow_PlagueCloud") then
						DeathKnight_AddMessage("使用鲜血符文传染，序号：2");
						plageRune = 2;
						return true;
					end
				else
					plageRune = Api_CheckDeathRune();
					if plageRune>0 then
						DeathKnight_AddMessage("使用死亡符文传染，序号："..plageRune);
						DeathKnight_CastSpell("传染","Spell_Shadow_PlagueCloud");
						return true;
					end
				end
			elseif not Api_CheckRune(plageRune) then
				local temp = GetTime() - plagueTime;
				DeathKnight_AddMessage("已使用符文 " ..plageRune.. " 施放传染...距离上次传染时间："..temp.." 秒");
				plagueTime = GetTime();
				
				plageRune = 0;
			else
				return DeathKnight_CastSpell("传染","Spell_Shadow_PlagueCloud");
			end
		end;
	end;

	if DeathKnight_PlayerBU("白霜") or DeathKnight_PlayerBU("冰冻之雾") then
	  DeathKnight_AddMessage("白霜...................")
		if DeathKnight_CastSpell("凛风冲击", action_table["凛风冲击"]) then return true; end;
	end
	if DeathKnight_PlayerBU("杀戮机器") then
		if DeathKnight_CastSpell("湮灭", action_table["湮灭"]) then return true; end;
		if DeathKnight_CastSpell("冰霜之镰", action_table["冰霜之镰"]) then return true; end;
		--if DeathKnight_CastSpell("冰霜打击","Spell_DeathKnight_EmpowerRuneBlade2") then return true; end;
	end
	if (DeathKnight_GetUnitPowerPercent("player") >= 50) then
		--if DeathKnight_CastSpell("湮灭","Spell_Deathknight_ClassIcon") then return true; end;
		if DeathKnight_CastSpell("冰霜打击", action_table["冰霜打击"]) then return true; end;
	end

  if isNearAction then
    if DeathKnight_CastSpell("冰川突进", action_table["冰川突进"]) then return true; end;
    if DeathKnight_CastSpell("冰霜之镰", action_table["冰霜之镰"]) then return true; end;
  end;

  if DeathKnight_CastSpell("凛风冲击", action_table["凛风冲击"]) then return true; end; -- Spell_ DeathKnight_ IceTouch
	if not Api_CheckRunes() then
		if DeathKnight_CastSpell("符文武器增效","INV_Sword_62") then return true; end;
	end
	
	--if DeathKnight_CastSpell("冰霜打击","Spell_DeathKnight_EmpowerRuneBlade2") then return true; end;
	
	if DeathKnight_CastSpell("湮灭", action_table["湮灭"]) then return true; end;

	if DeathKnight_CastSpell("冰霜之镰", action_table["冰霜之镰"]) then return true; end;
	
	DeathKnight_SetText("无动作",0);
	return;		

end;
-- 邪恶攻击
function DeathKnight_DpsOut3()
  if DeathKnight_Test_Target_Debuff() then 
		DeathKnight_AddMessage(UnitName("target").."目标已经被控制...");			
		DeathKnight_SetText("目标已经被控制",0);
		return;
	end
	if not DeathKnight_TargetDeBU("飓风术") or not DeathKnight_TargetBU("圣盾术") or not  DeathKnight_TargetBU("保护之手") or  not DeathKnight_TargetBU("寒冰屏障") or not  DeathKnight_TargetBU("法术反射") or not  DeathKnight_TargetDeBU("放逐术") then
		DeathKnight_SetText("目标无法攻击",0);
		return ;
	end;
	
	if (not IsCurrentAction(DeathKnight_Auto_Attack())) and (not DeathKnight_Test_Target_Debuff()) then
		mianyi1 = 0; 
		DeathKnight_ClearTargetTable();
		--DeathKnight_SetText("开始攻击",26);	
		DeathKnight_SetText("攻击",1);
		return true;
	end;

  if DeathKnight_playerSafe() then return true; end;
  
	if IsPetActive() then
	  if DeathKnight_CastSpellIgnoreRange("黑暗突变", action_table["黑暗突变"]) then return true; end;
	else
	  if DeathKnight_CastSpellIgnoreRange("亡者复生", action_table["亡者复生"]) then return true; end;
	end;
			
	-- 是否在近战范围（使用灵界打击）
	local isNearAction = IsActionInRange(DeathKnight_GetActionID(237517)) == true; 
	
	if (UnitIsPlayer("target") and UnitCanAttack("player", "target")) or UnitName("target")=="炸弹机器人" then
		if DeathKnight_TargetDeBU("寒冰锁链") then
			if DeathKnight_CastSpell("寒冰锁链", action_table["寒冰锁链"]) then return true; end;
		end;
		-- 近战范围
		if (isNearAction) then
		  DeathKnight_AddMessage("近战范围");
		  --if DeathKnight_CastSpell("冷酷严冬", "ability_deathknight_remoreslesswinters2") then return true; end;
    end;
	end;

	if DeathKnight_BreakCasting("心灵冰冻")==1 and DeathKnight_CastSpell("心灵冰冻", action_table["心灵冰冻"]) then return true; end;

  if (IsCurrentAction(DeathKnight_GetActionID(action_table["枯萎凋零"]))) then 
		DeathKnight_SetText("枯萎凋零",0);
		return true; 
	end;
	
  local power = UnitPower("player");
	if (power >= 35) then
		if DeathKnight_CastSpell("黑暗仲裁者", action_table["黑暗仲裁者"]) then return true; end;
	end

	if (power >= 70) then
		if DeathKnight_CastSpell("凋零缠绕", action_table["凋零缠绕"]) then return true; end;
	end

	local target_health_percent, target_health = DeathKnight_GetPlayerHealthPercent("target");
	local debuff7, remainTime7 = DeathKnight_CheckDebuffByPlayer("灵魂收割");
	if not debuff7 then
  	if target_health_percent < 50 or target_health < 260000 then
  	  if DeathKnight_CastSpell("灵魂收割", action_table["灵魂收割"]) then return true; end;
  	end;
  end;
  
  if target_health > 300000 then
    if DeathKnight_CastSpellIgnoreRange ("召唤石像鬼", action_table["召唤石像鬼"]) then return true; end;
  end;

	-- 增强	Buff
	if DeathKnight_RunCommand() then return true; end;

	-- 增强饰品
	if DeathKnight_Auto_Trinket() then return true; end;

	local debuff1,remainTime1 = DeathKnight_CheckDebuffByPlayer("冰霜疫病");
	local debuff2,remainTime2 = DeathKnight_CheckDebuffByPlayer("血之疫病");
	
	local debuff3,remainTime3, count3 = DeathKnight_CheckDebuffByPlayer("溃烂之伤");
	local debuff4,remainTime4, count4 = DeathKnight_CheckDebuffByPlayer("恶性瘟疫");
	
	local strenth = 0;
	local buff1 = DeathKnight_PlayerBU("不洁之力");
	local buff2 = DeathKnight_PlayerBU("暴怒");
	local buff3 = DeathKnight_PlayerBU("伟大");
	local buff4 = DeathKnight_PlayerBU("杰出");
	local buff5 = DeathKnight_PlayerBU("憎恶之力");
	local buff6 = DeathKnight_PlayerBU("不洁之能");
	local buff7 = DeathKnight_PlayerBU("血性狂怒");
	local buff8 = DeathKnight_PlayerBU("狂怒");
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
		if plagueMode==1 and target_count > 2 and ((GetTime() - plagueTime > 17) or (remainTime1>0 and remainTime1<2) or (remainTime2>0 and remainTime2<2)) then
			if plageRune==0 then
				if Api_CheckRune(1) then
					if DeathKnight_CastSpell("传染","Spell_Shadow_PlagueCloud") then
						plageRune = 1;
						return true;
					end
				elseif Api_CheckRune(2) then
					if DeathKnight_CastSpell("传染","Spell_Shadow_PlagueCloud") then
						plageRune = 2;
						return true;
					end
				end
			elseif not Api_CheckRune(plageRune) then
				local temp = GetTime() - plagueTime;
				DeathKnight_AddMessage("已施放传染...距离上次传染时间："..temp.." 秒");
				plagueTime = GetTime();
				
				plageRune = 0;
			else
				return DeathKnight_CastSpell("传染","Spell_Shadow_PlagueCloud");
			end
		end;
		if strenth >= 800 then
			if DeathKnight_CastSpellIgnoreRange("召唤石像鬼", spell_table["召唤石像鬼"]) then return true; end;
		end
	end;

  local partyNum = GetNumGroupMembers();
	-- 没有恶性瘟疫则释放爆发
	if (not debuff4) then
	  if DeathKnight_CastSpell("爆发", action_table["爆发"]) then return true; end;
	elseif (remainTime4 < 5 or target_health < 100000) and partyNum >= 1 then
	  if DeathKnight_CastSpell("传染", action_table["传染"]) then return true; end;
	end
	-- 溃烂之伤达到5层
  if (debuff3 and count3 >= 5) then
    if DeathKnight_CastSpell("暗影之爪", action_table["暗影之爪"]) then return true; end;
  end;
  
	if DeathKnight_CastSpell("脓疮打击", action_table["脓疮打击"]) then return true; end;
	if DeathKnight_CastSpell("凋零缠绕", action_table["凋零缠绕"]) then return true; end;

	if DeathKnight_CastSpell("暗影之爪", action_table["暗影之爪"]) then return true; end;

	--local id1 = DeathKnight_GetActionID("Spell_Shadow_AnimateDead");
	--if id1~=0 and DeathKnight_PlayerBU("活力分流") then
	--	if (GetActionCooldown(DeathKnight_GetActionID("Spell_Shadow_AnimateDead")) == 0) then 
	--		DeathKnight_SetText("活力分流",28);
	--		return true;
	--	end
	--end

	DeathKnight_SetText("无动作",0);
	return;		

end;

-- 坦克模式
function DeathKnight_DpsOut1()
    if DeathKnight_Test_Target_Debuff() then 
		DeathKnight_AddMessage(UnitName("target").."目标已经被控制...");			
		DeathKnight_SetText("目标已经被控制",0);
		return;
	end
	if not DeathKnight_TargetDeBU("飓风术") or not DeathKnight_TargetBU("圣盾术") or not  DeathKnight_TargetBU("保护之手") or  not DeathKnight_TargetBU("寒冰屏障") or not  DeathKnight_TargetBU("法术反射") or not  DeathKnight_TargetDeBU("放逐术") then
		DeathKnight_SetText("目标无法攻击",0);
		return ;
	end;
	if (not IsCurrentAction(DeathKnight_Auto_Attack())) and (not DeathKnight_Test_Target_Debuff()) then
		mianyi1 = 0; 
		--DeathKnight_SetText("开始攻击",26);	
		DeathKnight_SetText("自动攻击",1);
		return true;
	end;

	local tt_name = UnitName("targettarget");
	if UnitCanAttack("player", "target") and UnitName("player")~=tt_name and tt_name~=null and UnitHealthMax("targettarget")<120000 then
		if DeathKnight_CastSpell("黑暗命令","Spell_Nature_ShamanRage") then return true; end;
	end
	
	
	if (IsActionInRange(DeathKnight_GetActionID("Spell_DeathKnight_MindFreeze")) ~= 0 or IsActionInRange(DeathKnight_GetActionID("Spell_Shadow_SoulLeech_3")) ~= 0) then
		if DeathKnight_BreakCasting("心灵冰冻")==1 and DeathKnight_CastSpell("心灵冰冻", action_table["心灵冰冻"]) then return true; end;
		if DeathKnight_BreakCasting("绞袭")==1 and DeathKnight_CastSpell("绞袭","Spell_Shadow_SoulLeech_3") then return true; end;
	end;
	
	if DeathKnight_playerSafe() then return true; end;
	
	if UnitIsPlayer("target") and UnitCanAttack("player", "target") then
		if DeathKnight_TargetDeBU("寒冰锁链") then
			if DeathKnight_CastSpell("寒冰锁链","Spell_Frost_ChainsOfIce") then return true; end;
		end;
	end;

	-- 增强	Buff
	if DeathKnight_RunCommand() then return true; end;

	-- 增强饰品
	if DeathKnight_Auto_Trinket() then return true; end;

	local debuff1,remainTime1 = DeathKnight_CheckDebuffByPlayer("冰霜疫病");
	local debuff2,remainTime2 = DeathKnight_CheckDebuffByPlayer("血之疫病");
	if not debuff1 and not debuff2 then
		if DeathKnight_CastSpell("爆发","spell_deathvortex") then return true; end;
	end;
  if (IsCurrentAction(DeathKnight_GetActionID("spell_deathknight_defile"))) then 
		DeathKnight_SetText("亵渎",0);
		return true; 
	end;
  if (IsCurrentAction(DeathKnight_GetActionID("Spell_Shadow_DeathAndDecay"))) then 
		DeathKnight_SetText("枯萎凋零",0);
		return true; 
	end;

	--if (debuff1) and (debuff2) then
	--	step = 1;
	--	if plagueMode==1 and target_count > 2 and ((GetTime() - plagueTime > 16) or (remainTime1>0 and remainTime1<2) or (remainTime2>0 and remainTime2<2)) then
	--		if plageRune==0 then
	--			if Api_CheckRune(1) then
	--				if DeathKnight_CastSpell("传染","Spell_Shadow_PlagueCloud") then
	--					DeathKnight_AddMessage("使用鲜血符文传染，序号：1");
	--					plageRune = 1;
	--					return true;
	--				end
	--			elseif Api_CheckRune(2) then
	--				if DeathKnight_CastSpell("传染","Spell_Shadow_PlagueCloud") then
	--					DeathKnight_AddMessage("使用鲜血符文传染，序号：2");
	--					plageRune = 2;
	--					return true;
	--				end
	--			else
	--				plageRune = Api_CheckDeathRune();
	--				if plageRune>0 then
	--					DeathKnight_AddMessage("使用死亡符文传染，序号："..plageRune);
	--					DeathKnight_CastSpell("传染","Spell_Shadow_PlagueCloud");
	--					return true;
	--				end
	--			end
	--		elseif not Api_CheckRune(plageRune) then
	--			local temp = GetTime() - plagueTime;
	--			DeathKnight_AddMessage("已使用符文 " ..plageRune.. " 施放传染...距离上次传染时间："..temp.." 秒");
	--			plagueTime = GetTime();
	--			
	--			plageRune = 0;
	--		else
	--			return DeathKnight_CastSpell("传染","Spell_Shadow_PlagueCloud");
	--		end
	--	end;
	--end;
	if debuff1 and debuff2 then
	  if DeathKnight_CastSpell("血液沸腾","Spell_DeathKnight_BloodBoil") then return true; end;
	elseif not debuff1 then
		plageRune = 0;
		if DeathKnight_CastSpell("冰冷触摸","Spell_Frost_ArcticWinds") then return true; end;
	elseif not debuff2 then
		plageRune = 0;
		if DeathKnight_CastSpell("暗影打击","Spell_DeathKnight_EmpowerRuneBlade") then return true; end;
	end;


	if DeathKnight_CastSpell("灵界打击","Spell_DeathKnight_Butcher2") then return true; end;

	if (UnitPower("player") > 80) then
		if DeathKnight_CastSpell("凋零缠绕","Spell_Shadow_DeathCoil") then return true; end;
	end 
	if not Api_CheckRunes() then
		if DeathKnight_CastSpell("符文武器增效","INV_Sword_62") then return true; end;
	end
	
	
	DeathKnight_SetText("无动作",0);
	return;		

end;
function DeathKnight_BreakCast(LossHealth)
	if UnitExists("playertarget") then
		if not UnitCanAttack("player","target") then
			if UnitIsDeadOrGhost("target") then
				--if DeathKnight_CastSpell("打断施法","Ability_GolemThunderClap") then return true; end;
				DeathKnight_SetText("打断施法",27);	
				return true;
			end			
			if (IsActionInRange(DeathKnight_GetActionID("Spell_Holy_HolyBolt")) ~= 1) then
				--if DeathKnight_CastSpell("打断施法","Ability_GolemThunderClap") then return true; end;
				DeathKnight_SetText("打断施法",27);	
				return true;
			end	
			if DeathKnight_GetPlayerLossHealth("target") < LossHealth then
				--if DeathKnight_CastSpell("打断施法","Ability_GolemThunderClap") then return true; end;
				DeathKnight_SetText("打断施法",27);	
				return true;
			end
		else
			if DeathKnight_GetPlayerLossHealth("player") < LossHealth then
				--if DeathKnight_CastSpell("打断施法","Ability_GolemThunderClap") then return true; end;
				DeathKnight_SetText("打断施法",27);	
				return true;
			end
		end
	else
		if DeathKnight_GetPlayerLossHealth("player") < LossHealth then
				--if DeathKnight_CastSpell("打断施法","Ability_GolemThunderClap") then return true; end;
				DeathKnight_SetText("打断施法",27);	
				return true;
		end
	end
	return false;
end

function DeathKnight_playerSafe()
	local HealthPercent = DeathKnight_GetPlayerHealthPercent("player");
	if (HealthPercent < 50) then DeathKnight_AddMessage('血量过低 '..HealthPercent); end;
	
	if (DeathKnight_DPS == 0 or DeathKnight_DPS == 1) then
		if HealthPercent < 50 then
			if DeathKnight_CastSpell("吸血鬼之血", "Spell_Shadow_LifeDrain") then return true; end;
			if DeathKnight_CastSpell("符文分流", "Spell_DeathKnight_RuneTap") then return true; end;
		end
	end
	if (UnitIsPlayer("target") and UnitCanAttack("player", "target")) or (HealthPercent < 55) then
		if null==DeathKnight_PlayerBU("冰封之韧") then
			if DeathKnight_CastSpellIgnoreRange("冰封之韧", action_table["冰封之韧"]) then return true; end;
		end
		local debufftype = DeathKnight_TestPlayerDebuff("player");
		if debufftype == 1 or debufftype == 3 then
			if DeathKnight_PunishingBlow_Debuff() or (UnitClass("target")~="战士" and UnitClass("target")~="猎人" and UnitClass("target")~= "盗贼" and UnitClass("target")~="死亡骑士") then
				if DeathKnight_CastSpell("反魔法护盾", action_table["反魔法护盾"]) then return true; end;
			end
		end
	end;
	if HealthPercent < 60 then
		if (DeathKnight_DPS == 1) then
			if DeathKnight_CastSpell("吸血鬼之血", action_table["吸血鬼之血"]) then return true; end;
		end
		if DeathKnight_CastSpell("灵界打击", action_table["灵界打击"]) then return true; end;
		--if DeathKnight_CastSpell("治疗石", action_table["治疗石"]) then return true; end;
	end
	if HealthPercent < 70 then
		--if DeathKnight_CastSpell("生命之血", "Spell_Nature_WispSplodeGreen") then return true; end;
		--if DeathKnight_CastSpell("枯骨之钥", "inv_misc_key_15") then return true; end;
	end
	if HealthPercent < 80 then
		
		--if (DeathKnight_TestTrinket("英雄勋章")) then
		--	if DeathKnight_CastSpell("英雄勋章","INV_Jewelry_Talisman_07") then return true; end;
		--end
	end;
	
	if HealthPercent < 90 and DeathKnight_PlayerBU("黑暗援助")~=null then
	  if DeathKnight_CastSpell("灵界打击", action_table["灵界打击"]) then return true; end;
	end;

	return false;
end;

function DeathKnight_CheckDebuffByPlayer(debuffName)
	local i = 1;
	local name, _, _, count, _, _, expirationTime, unitCaster = UnitDebuff("target", i);
	while name do 
		--DeathKnight_AddMessage(string.format("name: %s, debuffName: %s, unitCaster: %s", name, debuffName, unitCaster));
		if (name==debuffName) and (unitCaster=="player" or unitCaster==UnitName("player")) then
			local temp = expirationTime - GetTime();
			--DeathKnight_AddMessage(debuffName.."剩余时间："..temp.." 秒");
			return true, temp, count;
		end;
		i = i+1;
		name, _, _, count, _, _, expirationTime, unitCaster = UnitDebuff("target", i);
	end 
	return false, 0, 0;
end

function DeathKnight_SelectPartyTarget(unitid)
	if UnitIsUnit("target", "party"..unitid) then return false; end;
	DeathKnight_SetText("选取"..unitid.."个队友",unitid+29);
	return true;	
end
function DeathKnight_GetPlayerManaPercent(unit)
	if UnitIsDeadOrGhost("player") then return 100; end
	local mana, manamax = UnitMana("player"), UnitManaMax("player");
	local ManaPercent = floor(mana/manamax*100+0.5);
	return ManaPercent;	
end
function DeathKnight_GetPlayerLossHealth(unit)	
	local health, healthmax  = UnitHealth(unit), UnitHealthMax(unit);
	return healthmax - health;	
end
function DeathKnight_GetPlayerHealthPercent(unit)	
	local health, healthmax  = UnitHealth(unit), UnitHealthMax(unit);
	local healthPercent = floor(health*100/healthmax+0.5);	
	return healthPercent, health;
end

function DeathKnight_Do_Reincarnation_CanUseAction(i) 
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

function DeathKnight_NoControl_Debuff()
	if not DeathKnight_PlayerDeBU("心灵尖啸") 
	   or not DeathKnight_PlayerDeBU("精神控制") 
	   or not DeathKnight_PlayerDeBU("恐惧")
	   or not DeathKnight_PlayerDeBU("恐惧嚎叫") 	 
	   or not DeathKnight_PlayerDeBU("女妖媚惑") 
	   or not DeathKnight_PlayerDeBU("破胆怒吼") 
	   or not DeathKnight_PlayerDeBU("休眠") 		 
	   or not DeathKnight_PlayerDeBU("逃跑")
	   or not DeathKnight_PlayerDeBU("凿击")
	   or not DeathKnight_PlayerDeBU("媚惑")  
	   or not DeathKnight_PlayerDeBU("变形术") 
	   or not DeathKnight_PlayerDeBU("休眠")  
	   or not DeathKnight_PlayerDeBU("致盲")  		
	   or not DeathKnight_PlayerDeBU("闷棍") 				
	   or not DeathKnight_PlayerDeBU("冰冻陷阱") 
	   or not DeathKnight_PlayerDeBU("肾击") 
	   or not DeathKnight_PlayerDeBU("忏悔") 
	   or not DeathKnight_PlayerDeBU("霜寒刺骨")
	   or not DeathKnight_PlayerDeBU("制裁之锤")	
	   or not DeathKnight_PlayerDeBU("强化断筋")
	   or not DeathKnight_PlayerDeBU("冲击")
	   or not DeathKnight_PlayerDeBU("冰霜新星") 
	   or not DeathKnight_PlayerDeBU("纠缠根须")
	   or not DeathKnight_PlayerDeBU("偷袭")
	then
		return true;
	end
	return false;	
end

function DeathKnight_IsSpellInRange(spellname,unit)
	if UnitExists(unit) then
		if UnitIsVisible(unit) then
			if IsSpellInRange(spellname,unit) == 1 then
				return true;
			end
		end
	end
	return false;
end
function DeathKnight_UnitAffectingCombat()
	if UnitAffectingCombat("player") == 1 then
		return true;
	end
	if (UnitInRaid("player")) then
		for id=1, GetNumGroupMembers()  do
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

function DeathKnight_CombatLogEvent(event,...)
	if not (playerClass=="死亡骑士") then return; end;

	local timestamp,eventType,hideCaster,sourceGUID,sourceName,sourceFlags,sourceFlags2,destGUID,destName,destFlags,destFlags2,auraId, auraName;
	local amount, school, resisted, blocked, absorbed, critical, glancing, crushing, missType, enviromentalType,interruptedSpellId, interruptedSpellName, interruptedSpellSchool;
	if info >=40200 then
		timestamp,eventType,hideCaster,sourceGUID,sourceName,sourceFlags,sourceFlags2,destGUID,destName,destFlags,destFlags2,auraId, auraName = ...;
	else
		timestamp,eventType,hideCaster,sourceGUID,sourceName,sourceFlags,destGUID,destName,destFlags,auraId, auraName = ...;
	end
	
	if eventType == "SPELL_CAST_SUCCESS" then
		if info >=40200 then
			spellId, spellName, spellSchool = select(12, ...);
		else
			spellId, spellName, spellSchool = select(10, ...);
		end;
		if CombatLog_Object_IsA(sourceFlags, COMBATLOG_FILTER_HOSTILE_PLAYERS) then
				if spellName == "消失" and sourceName then
					DeathKnight_Warning_AddMessage("**敌对玩家>>"..sourceName.."<<使用了消失,反隐反隐!**");					
					--table.insert(DeathKnight_Data[UnitName("player")]["Rogue"],{["Command"] = "奉献"});				
					StartTimer("Ability_DeathKnight_WarCry");					
					return;
				end;
				if spellName == "隐形术" and sourceName then
					DeathKnight_Warning_AddMessage("**敌对玩家>>"..sourceName.."<<使用了隐形术,反隐反隐!**");					
					--table.insert(DeathKnight_Data[UnitName("player")]["Rogue"],{["Command"] = "奉献"});				
					StartTimer("Ability_DeathKnight_WarCry");					
					return;
				end;
				if spellName == "闪避" and sourceName then
					DeathKnight_Warning_AddMessage("**警告:敌对玩家>>"..sourceName.."<<获得闪避效果,效果持续8秒!**");
					return;	
				end;
				if spellName == "圣盾术" and sourceName then					
					DeathKnight_Warning_AddMessage("**警告:敌对玩家>>"..sourceName.."<<获得".. spellName .."效果!!**");					
					return;	
				end;
				if spellName == "保护之手" and sourceName then
					if destName then
						DeathKnight_Warning_AddMessage("**警告:敌对玩家>>"..sourceName.."<<给>>"..destName.."<<施放了保护之手!!**");
					else
						DeathKnight_Warning_AddMessage("**警告:敌对玩家>>"..sourceName.."<<施放了保护之手!!**");
					end;
					return;	
				end;
		end
		if CombatLog_Object_IsA(sourceFlags, COMBATLOG_FILTER_FRIENDLY_UNITS) and spellName then			
			if (spellName == "嘲讽" or spellName == "正义防御" ) and sourceName and destName then
				--DeathKnight_Warning_AddMessage("**>>"..sourceName.."<<对"..destName.."成功施放了"..spellName.."!**");
			end;			
		end;	
		
		return;
	end;

	if eventType == "SPELL_MISSED" then
		if info >=40200 then
			spellId, spellName, spellSchool, missType = select(12, ...);
		else
			spellId, spellName, spellSchool, missType = select(10, ...);
		end;
		if CombatLog_Object_IsA(sourceFlags, COMBATLOG_FILTER_MINE) and spellName then			
			if missType == "RESIST" then
				DeathKnight_AddMessage("**>>"..destName.."<<抵抗了"..sourceName.."的"..spellName.."!**");
			elseif missType == "IMMUNE" then
				DeathKnight_AddMessage("**>>"..destName.."<<免疫了"..sourceName.."的"..spellName.."!**");
				if spellName == "冰冷触摸" then mianyi1 = 1;end;
				if sourceName == UnitName("player") and not UnitIsPlayer(destName) then
					local g_FindNpcName = false;
					for k, v in pairs(DeathKnight_SaveData) do
						if target_spellname then
							if v["npcname"] == destName and  v["spellname"] == spellName and v["targetspellname"] == target_spellname then  
						    	g_FindNpcName = true;
							end
						else
							if v["npcname"] == destName and  v["spellname"] == spellName then  
						    	g_FindNpcName = true;
							end
						end
					end
					if not g_FindNpcName then
					  	if target_spellname then
					      	table.insert(DeathKnight_SaveData,{["npcname"] = destName,["spellname"] = spellName,["targetspellname"] = target_spellname,});
					  		DeathKnight_AddMessage(string.format("%s 的 %s 免疫了你的 %s，打断失败，已记录。",destName,target_spellname,spellName));
					  	else
					  	  	table.insert(DeathKnight_SaveData,{["npcname"] = destName,["spellname"] = spellName,["targetspellname"] = "",});
					  	  	DeathKnight_AddMessage(string.format("%s 免疫了你的%s，已记录。",destName,spellName));
					  	end
					end
				end
				return;
			end			
			return;		
		end;
		if CombatLog_Object_IsA(sourceFlags, COMBATLOG_FILTER_FRIENDLY_UNITS) and spellName then			
			if (spellName == "嘲讽" or spellName == "正义防御" ) and sourceName and destName then
				if missType == "RESIST" then
					DeathKnight_Warning_AddMessage("**>>"..destName.."<<抵抗了"..sourceName.."的"..spellName.."!**");
				elseif missType == "IMMUNE" then
					DeathKnight_Warning_AddMessage("**>>"..destName.."<<免疫了"..sourceName.."的"..spellName.."!**");					
					return;
				end			
				return;
			end;
			if spellName == "震荡猛击"  and sourceName and destName then
				if missType == "RESIST" then
					DeathKnight_Warning_AddMessage("**>>"..destName.."<<抵抗了"..sourceName.."的"..spellName.."!**");
				elseif missType == "IMMUNE" then
					DeathKnight_Warning_AddMessage("**>>"..destName.."<<免疫了"..sourceName.."的"..spellName.."!**");					
					return;
				end			
				return;
			end;
		end;
		return;
	end;
	if CombatLog_Object_IsA(sourceFlags, COMBATLOG_FILTER_MINE) then		
		if (eventType == "SPELL_DAMAGE") then
			if info >=40200 then
				spellId, spellName, spellSchool, amount, overDamage,school, resisted, blocked, absorbed, critical, glancing, crushing = select(12, ...)
			else
				spellId, spellName, spellSchool, amount, overDamage,school, resisted, blocked, absorbed, critical, glancing, crushing = select(10, ...)
			end;
			
			if spellName and amount > 30000 then
				if critical then
					DeathKnight_AddMessage("你的|cffffff00"..spellName.."|r|cff00ff00对|r|cffffff00"..destName.."|r|cff00ff00造成|r|cffffff00"..amount.."|r|cff00ff00伤害(|r|cffffff00爆击|r|cff00ff00)...|r");				       
				else
					DeathKnight_AddMessage("你的|cffffff00"..spellName.."|r|cff00ff00对|r|cffffff00"..destName.."|r|cff00ff00造成|r|cffffff00"..amount.."|r|cff00ff00伤害...|r");				       
				end
			end
		end
	end
	if eventType == "SPELL_HEAL" then
		if info >=40200 then
			spellId, spellName, spellSchool, amount,overDamage, critical = select(12, ...);
		else
			spellId, spellName, spellSchool, amount,overDamage, critical = select(10, ...);
		end;
		if CombatLog_Object_IsA(sourceFlags, COMBATLOG_FILTER_MINE) and amount > 10000 and destName and sourceName then
			if critical then
				DeathKnight_AddMessage("|cff00ff00你的|cffffff00"..spellName.."|r|cff00ff00给|r|cffffff00"..destName.."|r|cff00ff00恢复|r|cffffff00"..amount.."|r|cff00ff00点生命(|r|cffffff00爆击|r|cff00ff00)...|r");				       
			else
				DeathKnight_AddMessage("|cff00ff00你的|cffffff00"..spellName.."|r|cff00ff00给|r|cffffff00"..destName.."|r|cff00ff00恢复|r|cffffff00"..amount.."|r|cff00ff00点生命...|r");				       
			end	
			return;
		end;
		if CombatLog_Object_IsA(destFlags, COMBATLOG_FILTER_MINE) and amount > 10000 and destName and sourceName then
			if critical then
				DeathKnight_AddMessage("|cffffff00"..sourceName.."|r|cff00ff00的|cffffff00"..spellName.."|r|cff00ff00给我|cff00ff00恢复|r|cffffff00"..amount.."|r|cff00ff00点生命(|r|cffffff00爆击|r|cff00ff00)...|r");				       
			else
				DeathKnight_AddMessage("|cffffff00"..sourceName.."|r|cff00ff00的|cffffff00"..spellName.."|r|cff00ff00给我|r|cff00ff00恢复|r|cffffff00"..amount.."|r|cff00ff00点生命...|r");				       
			end			
		end;
		return;
	end;
	if event == "COMBAT_LOG_EVENT_UNFILTERED" then
		if eventType == "SPELL_DAMAGE" then
			DeathKnight_CountTarget(sourceGUID, sourceName, destGUID, destName);
		elseif eventType == "UNIT_DIED" or eventType=="UNIT_DESTROYED" then
			DeathKnight_DecreaseTarget(sourceGUID, sourceName, destGUID, destName);
		end
	end
end

function DeathKnight_Test()	
	for i = 1, 120 do
		if ( HasAction(i) ) then
			local texture = GetActionTexture(i);
			local text = GetActionText(i);
			if text == nil then text = "nil"; end;
			
			table.insert(DeathKnight_ActionTable, {["actionId"] = i, ["actionTexture"] = texture, });
			DEFAULT_CHAT_FRAME:AddMessage(i.." |cffffff00" .. texture .. "|r".." "..text);
		end;		
	end;
	
end;

function Api_Test1()
	local numIcons = GetNumMacroIcons()
	for i=1000,numIcons do
	 DEFAULT_CHAT_FRAME:AddMessage(string.format("Icon %d: %s",i,GetMacroIconInfo(i)));
	end
end

function DeathKnight_Use_INV_Jewelry_TrinketPVP_02()
	if UnitIsPlayer("playertarget") then 
		if DeathKnight_NoControl_Debuff() then
			if DeathKnight_TestTrinket("部落徽记") or DeathKnight_TestTrinket("部落勋章")  then 
				if DeathKnight_CastSpell("部落徽记", "INV_Jewelry_TrinketPVP_02") then 
					--StartTimer("INV_Jewelry_TrinketPVP")
					return true; 
				end		
			end	
			if DeathKnight_TestTrinket("联盟徽记") or DeathKnight_TestTrinket("联盟勋章")  then
				if DeathKnight_CastSpell("联盟徽记","INV_Jewelry_TrinketPVP_01") then 
					--StartTimer("INV_Jewelry_TrinketPVP")
					return true; 
				end		
			end
		end
	end
end
function Api_SetPlague(flag)
	plagueTime = 0;
	plageRune = 0;
	if (plagueMode==0) then
		plagueMode = 1;
		DeathKnight_AddMessage("已设置允许传染");
	else
		plagueMode = 0;
		DeathKnight_AddMessage("已设置禁止传染");
	end
end

function DeathKnight_ClearTargetTable()
	if (target_count > 0) then
		target_count = 0;
		target_table = {};
		DeathKnight_AddMessage("目标数已清零。");
	end;
end
function DeathKnight_CountTarget(srcGuid,srcName,destGuid,destName)
	if UnitAffectingCombat("player") then
		if not DeathKnight_Test_IsFriend(destName) then
			if not target_table[destGuid] then 
				target_count = target_count+1;
				target_table[destGuid] = destName; 
				DeathKnight_AddMessage("战斗中目标数："..target_count.." 目标名字："..destName);
			end;
		elseif not DeathKnight_Test_IsFriend(srcName) then
			if not target_table[srcGuid] then 
				target_count = target_count+1;
				target_table[srcGuid] = srcName;
				DeathKnight_AddMessage("战斗中目标数："..target_count.." 目标名字："..destName);
			end;
		end
	end
end
function DeathKnight_DecreaseTarget(sourceGUID, sourceName, destGUID, destName)
	if target_count > 0 then
		if not DeathKnight_Test_IsFriend(srcName) then
			if target_table[srcGuid]~=null then 
				target_count = target_count-1;
				target_table[srcGuid] = null;
				DeathKnight_AddMessage("战斗中目标数："..target_count.." "..destName.." 已被杀死或摧毁");
			end;
		end
	end
end
--INV_ValentinePerfumeBottle
--Spell_Arcane_ManaTap
--Spell_Shadow_Teleport
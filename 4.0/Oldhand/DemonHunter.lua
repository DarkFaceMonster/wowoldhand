
DemonHunter_SaveData = nil;
DemonHunter_Data = nil;

DemonHunter_PlayerTalentInfoDatas = {};

local dynamicMicroID = 72;
local playerClass;
local DemonHunter_DPS = 1; -- Ĭ�Ϻƽ٣�1�ƽ٣�2����3
local DemonHunter_Reincarnation  = false;
local DemonHunter_Free  = false;
local DemonHunter_RaidFlag = 0;
local DemonHunter_Old_UnitPopup_OnClick;
local DemonHunter_AutoFollowName="";
local TestHelpTarget = "";
local target_count = 0;		-- Ŀ�����
local target_table = {};	

local DemonHunter_action_table = {};

DemonHunter_action_table["�Զ�����"] = 1302006;

-- �ƽ�
DemonHunter_action_table["��ħ֮ҧ"] = 135561;
DemonHunter_action_table["���Ҵ��"] = 1305152;
DemonHunter_action_table["�����Ӿ�"] = 1247266;
DemonHunter_action_table["����"] = 1305156;
DemonHunter_action_table["а�ܳ�ײ"] = 1247261;
DemonHunter_action_table["Ͷ������"] = 1305159;
DemonHunter_action_table["����"] = 1305149;
DemonHunter_action_table["����ħ��"] = 1305153;
DemonHunter_action_table["��ħ����"] = 1247262;

-- ����
DemonHunter_action_table["������"] = 135291;

-- ��Ʒ
DemonHunter_action_table["�ٽ��籩֮ŭ"] = 236164;
DemonHunter_action_table["����ŵ˹�׳�"] = 236164;

function DemonHunter_CreateMacro()	
--	if GetMacroIndexByName("���ʩ��") == 0 then
--		CreateMacro("���ʩ��", 67, "/stopcasting", 1, 1);
--	end;	
--	PickupMacro("���ʩ��");
--	--PlaceAction(61);
--	ClearCursor();

	if GetMacroIndexByName("��ʼ����") == 0 then
		CreateMacro("��ʼ����", 60, "/startattack", 1, 1);
	end;
	--PickupMacro("��ʼ����");
	--PlaceAction(1);
	--ClearCursor();

	if GetMacroIndexByName("ս����̤") == 0 then
		CreateMacro("ս����̤", 66, "/cast ս����̤", 1, 0);
	end;

	if GetMacroIndexByName("����ģʽ") == 0 then
		CreateMacro("����ģʽ", 61, "/script DemonHunter_Input(1);", 1, 1);
	end;	
	PickupMacro("����ģʽ");
	PlaceAction(49);
	ClearCursor();	
	if DemonHunter_DPS == 1 then
		if GetMacroIndexByName("�ƽ�ģʽ") == 0 then
			CreateMacro("�ƽ�ģʽ", 62, "/script DemonHunter_Input(1);", 0, 0);
		end;
		PickupMacro("�ƽ�ģʽ");
	elseif DemonHunter_DPS == 1 then
		if GetMacroIndexByName("����ģʽ") == 0 then
			CreateMacro("����ģʽ", 62, "/script DemonHunter_Input(1);", 0, 0);
		end;
		PickupMacro("����ģʽ");
	elseif DemonHunter_DPS == 3 then
		if GetMacroIndexByName("����ģʽ") == 0 then
			CreateMacro("����ģʽ", 62, "/script DemonHunter_Input(1);", 0, 0);
		end;
		PickupMacro("����ģʽ");
	end
	PlaceAction(50);
	ClearCursor();

  Oldhand_PutAction("�Զ�����", 1);
  Oldhand_PutAction("���", 61);
 
  if DemonHunter_DPS == 1 then
  elseif DemonHunter_DPS == 2 then
    Oldhand_PutAction("��Ѫ", 2);
    Oldhand_PutAction("�񱩻ӿ�", 3);
    Oldhand_PutAction("��ŭ", 4);
    Oldhand_PutAction("��ŭ�ظ�", 7);    
    Oldhand_PutAction("նɱ", 62);
    Oldhand_PutAction("ŭ��", 63);
    
  elseif DemonHunter_DPS == 3 then
    Oldhand_PutAction("������", 2);
    Oldhand_PutAction("�����ͻ�", 3);
    Oldhand_PutAction("����һ��", 4);
    Oldhand_PutAction("���Ƹ�", 7);    
    Oldhand_PutAction("����", 62);
    Oldhand_PutAction("��ʤ׷��", 63);  
  end;

	if Oldhand_TestTrinket("����ѫ��") then
		Oldhand_PutAction("����ѫ��", 71);
	elseif Oldhand_TestTrinket("�󸱵Ļ���") then
		Oldhand_PutAction("�󸱵Ļ���", 72);
	elseif Oldhand_TestTrinket("��˹�˵Ļ���") then
		Oldhand_PutAction("��˹�˵Ļ���", 72);
	elseif Oldhand_TestTrinket("�־�С��") then
		Oldhand_PutAction("�־�С��", 71);
	elseif Oldhand_TestTrinket("�־�С��") then
		Oldhand_PutAction("ս�������", 71);
	elseif Oldhand_TestTrinket("̦ԭ����") then
		Oldhand_PutAction("̦ԭ����", 71);
	elseif Oldhand_TestTrinket("ʳ��ħŹ���ߵĻ���") then
		Oldhand_PutAction("ʳ��ħŹ���ߵĻ���", 71);
	end
	if Oldhand_TestTrinket("ʤ�����") then
		Oldhand_PutAction("ʤ�����", 72);
	elseif Oldhand_TestTrinket("�ٽ��籩֮ŭ") then
		Oldhand_PutAction("�ٽ��籩֮ŭ", 71);
	elseif Oldhand_TestTrinket("Ӣ��ѫ��") then
		Oldhand_PutAction("Ӣ��ѫ��", 72);
	elseif Oldhand_TestTrinket("����ŵ˹�׳�") then
		Oldhand_PutAction("����ŵ˹�׳�", 72);
	elseif Oldhand_TestTrinket("��ȭ�Ŀ���") then
		Oldhand_PutAction("��ȭ�Ŀ���", 72);
	end
	
	Oldhand_PutAction("ս����̤", 51);

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
	
	SetBindingMacro(",","ս����̤");	-- 29
	--SetBindingMacro("\'","��������");	-- 28
	SetBindingMacro(";","���ʩ��");	-- 27
	--SetBindingMacro("\\","��ʼ����");	-- 26
	
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
		if id1~=0 and null==Oldhand_PlayerBU("ս����̤") then
			if 0~=IsActionInRange(Oldhand_GetActionID("Ability_DemonHunter_Lavalash")) then -- �������Ч
				if (GetActionCooldown(Oldhand_GetActionID("Racial_Troll_Berserk")) == 0) then 
					Oldhand_SetText("ս����̤",29);
					return true;
				end
			end;
		end
	end
	return false;
end;

function DemonHunter_Auto_Trinket()
  if not Oldhand_PlayerBU("ˮ�ֵ�Ѹ��") then
		if Oldhand_TestTrinket("�󸱵Ļ���") and (IsActionInRange(Oldhand_GetActionID("Ability_DemonHunter_Lavalash")) ~= 0)  then
			if Oldhand_CastSpell("�󸱵Ļ���", "INV_Misc_PocketWatch_02") then return true; end		
		end
	end
	if not Oldhand_PlayerBU("����ŭ��") then
		if Oldhand_TestTrinket("�ٽ��籩֮ŭ") and (IsActionInRange(Oldhand_GetActionID("Ability_DemonHunter_Lavalash")) ~= 0)  then
			if Oldhand_CastSpell_IgnoreRange("�ٽ��籩֮ŭ", DemonHunter_action_table["�ٽ��籩֮ŭ"]) then return true; end	
		end
	end
	if not Oldhand_PlayerBU("��ɫӢ��") then
		if Oldhand_TestTrinket("��˹�˵Ļ���") and (IsActionInRange(Oldhand_GetActionID("Ability_DemonHunter_Lavalash")) ~= 0)  then
			if Oldhand_CastSpell("��˹�˵Ļ���", "INV_Misc_AhnQirajTrinket_03") then return true; end		
		end
	end
	if not Oldhand_PlayerBU("Ұ�Կ�ŭ") then
		if Oldhand_TestTrinket("ս�������") and (IsActionInRange(Oldhand_GetActionID("Ability_DemonHunter_Lavalash")) ~= 0)  then
			if Oldhand_CastSpell("ս�������", "INV_Misc_Horn_02") then return true; end		
		end
	end
	if not Oldhand_PlayerBU("������ע") then
		if Oldhand_TestTrinket("����ŵ˹�׳�") and (IsActionInRange(Oldhand_GetActionID("Ability_DemonHunter_Lavalash")) ~= 0)  then
			if Oldhand_CastSpell_IgnoreRange("����ŵ˹�׳�", DemonHunter_action_table["����ŵ˹�׳�"]) then return true; end		
		end
	end
	
	if not Oldhand_PlayerBU("��׼���") then
		if Oldhand_TestTrinket("̦ԭ����") and (IsActionInRange(Oldhand_GetActionID("Ability_DemonHunter_Lavalash")) ~= 0)  then
			if Oldhand_CastSpell("̦ԭ����", "INV_Jewelcrafting_StarOfElune_03") then return true; end;
		end
	end
	if not Oldhand_PlayerBU("�ױ�") then
		if Oldhand_TestTrinket("��ȭ�Ŀ���") and (IsActionInRange(Oldhand_GetActionID("Ability_DemonHunter_Lavalash")) ~= 0)  then
			if Oldhand_CastSpell("��ȭ�Ŀ���", "INV_DataCrystal06") then return true; end		
		end
	end
	if not Oldhand_PlayerBU("ȼ��֮��") then
		if Oldhand_TestTrinket("ʳ��ħŹ���ߵĻ���") and (IsActionInRange(Oldhand_GetActionID("Ability_DemonHunter_Lavalash")) ~= 0)  then
			if Oldhand_CastSpell("ʳ��ħŹ���ߵĻ���", "INV_Jewelry_Talisman_04") then return true; end		
		end
	end
	
	--if Oldhand_GetActionID("INV_Misc_MonsterScales_15") ~= 0 then
	--	if Oldhand_TestTrinket("��Ѫ����") and (IsActionInRange(Oldhand_GetActionID("Ability_DemonHunter_Lavalash")) == 1)  then
	--		if Oldhand_CastSpell("��Ѫ����", "INV_Misc_MonsterScales_15") then return true; end		
	--	end
	--end;
	--if  Oldhand_GetActionID("INV_ValentinePerfumeBottle") ~= 0 then
	--	if Oldhand_TestTrinket("ѳ���߾���") and (IsActionInRange(Oldhand_GetActionID("Spell_Holy_HolyBolt")) == 1)  then
	--		if Oldhand_CastSpell("ѳ���߾���", "INV_ValentinePerfumeBottle") then return true; end		
	--	end
	--end  	
	return false;
end

function DemonHunter_dps_playerSafe()
	--if not DemonHunter_PlayerDeBU("�Ͻ�") or not DemonHunter_PlayerDeBU("����ҩ��") or not DemonHunter_PlayerDeBU("������") or not DemonHunter_PlayerDeBU("����") or not DemonHunter_PlayerDeBU("��˪����⻷")
	--	or not DemonHunter_PlayerDeBU("ǿ���Ͻ�") or not DemonHunter_PlayerDeBU("������") or not DemonHunter_PlayerDeBU("ˤ��") or not DemonHunter_PlayerDeBU("�����")
	--   	or not DemonHunter_PlayerDeBU("�ظ���") or not DemonHunter_PlayerDeBU("��˪���") or not DemonHunter_PlayerDeBU("ƣ������") 
	--   	or not DemonHunter_PlayerDeBU("��˪����") or not DemonHunter_PlayerDeBU("��������") or not DemonHunter_PlayerDeBU("˪���̹�")  then
	   	
	--end;
	--if not DemonHunter_PlayerDeBU("͵Ϯ") or not DemonHunter_PlayerDeBU("����") or not DemonHunter_PlayerDeBU("�Ʋ�֮��") then
	--end;
	return false;
end;

--function DemonHunter_PunishingBlow_Debuff()
--	if not Oldhand_TargetDeBU("�»���") 
--	or not Oldhand_TargetDeBU("��ʴ��")
--	or not Oldhand_TargetDeBU("�׼�")  
--	or not Oldhand_TargetDeBU("��������ʹ") 
--	or not Oldhand_TargetDeBU("��������") 
--	or not Oldhand_TargetDeBU("���߶���") 
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
  elseif dps_mode == 3 then
    DemonHunter_DpsOut3();
  else
    Oldhand_AddMessage("������츳ģʽ��"..dps_mode);
  end;
end;

-- �ƽ�ģʽ
function DemonHunter_DpsOut1()
  if Oldhand_Test_Target_Debuff() then 
		Oldhand_AddMessage(UnitName("target").."Ŀ���Ѿ�������...");			
		Oldhand_SetText("Ŀ���Ѿ�������", 0);
		return;
	end
	
	if (not IsCurrentAction(Oldhand_Auto_Attack())) and (not Oldhand_Test_Target_Debuff()) then
		--Oldhand_SetText("��ʼ����",26);	
		Oldhand_SetText("�Զ�����", 1);
		return true;
	end;
	if not Oldhand_TargetDeBU("쫷���") or not Oldhand_TargetBU("ʥ����") or not  Oldhand_TargetBU("����֮��") or  not Oldhand_TargetBU("��������") or not  Oldhand_TargetBU("��������") or not  Oldhand_TargetDeBU("������") then
		Oldhand_SetText("Ŀ���޷�����", 0);
		return ;
	end;
	if DemonHunter_playerSafe() then return true;end;
	
	local power = UnitPower("player");
  
	local spellname = UnitCastingInfo("target") 
	if null~=spellname then
		if Oldhand_CastSpell("����ħ��", DemonHunter_action_table["����ħ��"]) then return true; end;
	end;
	
	-- �ƽ�	Buff
	if DemonHunter_RunCommand() then return true; end;

	-- �ƽ���Ʒ
	if DemonHunter_Auto_Trinket() then return true; end;
	
	-- ��ս��Χ		
	local isNearAction = IsActionInRange(Oldhand_GetActionID(DemonHunter_action_table["��ħ֮ҧ"]));
	
	if not isNearAction then
	  if Oldhand_CastSpell("Ͷ������", DemonHunter_action_table["Ͷ������"]) then return true; end;
	else
  	-- local partyNum = GetNumGroupMembers();

  	if (isNearAction and Oldhand_TargetCount() >= 3 and power >= 50) then
  	  if Oldhand_CastSpell_IgnoreRange("����", DemonHunter_action_table["����"]) then return true; end;
  	end;	
  	
    if power >= 40 then
      if Oldhand_CastSpell("���Ҵ��", DemonHunter_action_table["���Ҵ��"]) then return true; end;
    end
    
----if not Oldhand_PlayerBU("ս��") then
----	if Oldhand_CastSpell_IgnoreRange("ս��", DemonHunter_action_table["ս��"]) then return true; end;
----end  
  
    if Oldhand_CastSpell("��ħ֮ҧ", DemonHunter_action_table["��ħ֮ҧ"]) then return true; end;
    
    if Oldhand_TargetCount() >= 4 then
      if Oldhand_CastSpell_IgnoreRange("����", DemonHunter_action_table["����"]) then return true; end;
    end;
    if Oldhand_CastSpell("��ħ֮ҧ", DemonHunter_action_table["��ħ֮ҧ"]) then return true; end;
	end;

  if Oldhand_TargetCount() >= 4 then
    if Oldhand_CastSpell_IgnoreRange("����", DemonHunter_action_table["����"]) then return true; end;
  end;
  
	Oldhand_SetText("�޶���",0);
	return;

end;

-- ����ģʽ
function DemonHunter_DpsOut2()
  if Oldhand_Test_Target_Debuff() then 
		Oldhand_AddMessage(UnitName("target").."Ŀ���Ѿ�������...");			
		Oldhand_SetText("Ŀ���Ѿ�������", 0);
		return;
	end
	
	if (not IsCurrentAction(Oldhand_Auto_Attack())) and (not Oldhand_Test_Target_Debuff()) then
		--Oldhand_SetText("��ʼ����",26);	
		Oldhand_SetText("�Զ�����", 1);
		return true;
	end;
	if not Oldhand_TargetDeBU("쫷���") or not Oldhand_TargetBU("ʥ����") or not  Oldhand_TargetBU("����֮��") or  not Oldhand_TargetBU("��������") or not  Oldhand_TargetBU("��������") or not  Oldhand_TargetDeBU("������") then
		Oldhand_SetText("Ŀ���޷�����", 0);
		return ;
	end;
	if DemonHunter_playerSafe() then return true;end;
	
	local power = UnitPower("player");
	
	local target_health_percent, target_health = Oldhand_GetPlayerHealthPercent("target");
	if target_health_percent <= 20 and power >= 25 then
  	if Oldhand_CastSpell("նɱ", DemonHunter_action_table["նɱ"]) then return true; end;
  end;
  
	local spellname = UnitCastingInfo("target") 
	if null~=spellname then
		if Oldhand_CastSpell("ȭ��", DemonHunter_action_table["ȭ��"]) then return true; end;
	end;
	
	-- ����	Buff
	if DemonHunter_RunCommand() then return true; end;

	-- ������Ʒ
	if DemonHunter_Auto_Trinket() then return true; end;
	
	-- ��ս��Χ		
	local isNearAction = IsActionInRange(Oldhand_GetActionID(DemonHunter_action_table["�񱩻ӿ�"]));
	
	if not isNearAction then
	  if Oldhand_CastSpell("���", DemonHunter_action_table["���"]) then return true; end;
	  if Oldhand_CastSpell("Ӣ��Ͷ��", DemonHunter_action_table["Ӣ��Ͷ��"]) then return true; end;
	else
  	-- local partyNum = GetNumGroupMembers();
  	
    if power >= 85 then
      if Oldhand_CastSpell("��ŭ", DemonHunter_action_table["��ŭ"]) then return true; end;
    end
    
  	if not Oldhand_PlayerBU("ս��") then
  		if Oldhand_CastSpell_IgnoreRange("ս��", DemonHunter_action_table["ս��"]) then return true; end;
  	end
  	
   	if not Oldhand_PlayerBU("ԡѪ��ս") then
  		if Oldhand_CastSpell_IgnoreRange("ԡѪ��ս", DemonHunter_action_table["ԡѪ��ս"]) then return true; end;
  	end
  	
  	if Oldhand_PlayerBU("�ݿ�����") then
  	  if Oldhand_CastSpell_IgnoreRange("����ն", DemonHunter_action_table["����ն"]) then return true; end;
  	end;  	
  	
    if Oldhand_PlayerBU("Ѫ��˳��") then
  		if Oldhand_CastSpell("��Ѫ", DemonHunter_action_table["��Ѫ"]) then return true; end;
  	end
      
  	if Oldhand_PlayerBU("��ŭ") then
  	  --Oldhand_AddMessage("��Ƣ��.................................")
  		if Oldhand_CastSpell("ŭ��", DemonHunter_action_table["ŭ��"]) then return true; end;
  	end
  	
  	if (isNearAction and Oldhand_TargetCount() >= 3 and not Oldhand_PlayerBU("Ѫ��˳��")) or Oldhand_PlayerBU("�ݿ�����") then
  	  if Oldhand_CastSpell_IgnoreRange("����ն", DemonHunter_action_table["����ն"]) then return true; end;
  	end;	  
  
    if Oldhand_CastSpell("��Ѫ", DemonHunter_action_table["��Ѫ"]) then return true; end;
    
    if Oldhand_TargetCount() >= 4 then
      if Oldhand_CastSpell_IgnoreRange("����ն", DemonHunter_action_table["����ն"]) then return true; end;
    end;
    if Oldhand_CastSpell("�񱩻ӿ�", DemonHunter_action_table["�񱩻ӿ�"]) then return true; end;
	end;

  if Oldhand_TargetCount() >= 4 then
    if Oldhand_CastSpell_IgnoreRange("����ն", DemonHunter_action_table["����ն"]) then return true; end;
  end;
  
	Oldhand_SetText("�޶���",0);
	return;

end;

function DemonHunter_DpsOut3()
end;
function DemonHunter_playerSafe()
  local HealthPercent = Oldhand_GetPlayerHealthPercent("player");
  if (DemonHunter_DPS == 2 and HealthPercent < 50) then
	  Oldhand_AddMessage('Ѫ������ '..HealthPercent);
	  if Oldhand_CastSpellIgnoreRange("��ŭ�ظ�", DemonHunter_action_table["��ŭ�ظ�"]) then return true; end;
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
			if Oldhand_TestTrinket("����ռ�") or Oldhand_TestTrinket("����ѫ��")  then 
				if Oldhand_CastSpell("����ռ�","INV_Jewelry_TrinketPVP_02") then 
					--StartTimer("INV_Jewelry_TrinketPVP")
					return true; 
				end		
			end	
			if Oldhand_TestTrinket("���˻ռ�") or Oldhand_TestTrinket("����ѫ��")  then
				if Oldhand_CastSpell("���˻ռ�","INV_Jewelry_TrinketPVP_01") then 
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
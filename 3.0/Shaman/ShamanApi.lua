Shaman_SaveData = nil;

function Resurrection()
   if (UnitExists("target") and UnitIsPlayer("target") and UnitCanAssist("player", "target")) then
      local btCustom = {
         [1] = {
            },
         [2] = {
            {"YELL", "我感觉得到你的恐惧,%t!赐于你新的生命,勇敢地站起来吧!"},
            {"YELL", "起来!不愿做尸体的%t,把你的血肉,筑成我们新的长城!"},
            {"YELL", "复活吧!%t,为了我而战!哎呀,你也太胖了吧!怎么也拉不起来呢?"},
            {"YELL", "%t,你知道你条命值多少钱么?我给你重生的机会,我们作个等价交换吧,你觉得自己值得多少钱复活后就给我多少钱!"},
            {"EMOTE", "手忙脚乱的把%t的尸体拼凑起来,念动咒语,一到光芒闪过,%t微微睁开双眼,看着老手,问了句:我的JJ哪去了?"},
            {"EMOTE", "用怀疑的目光打量了一下%t的尸体,冷冷的说:你在装死是不是?"},
            {"EMOTE", "使劲踩了%t两脚:丫的,装死还挺像模像样!%t大声说:好爽啊,再踩几下吧!"},
            {"EMOTE", "开始用脚踩%t的小JJ,嘴里喊着:叫你丫装死,赶紧起来!"}
            },
         [3] = {
            {"YELL", "亲爱的%t,你爱我吗?爱我的话你就点确定啊!"},
            {"YELL", "曼妙可爱的%t,复活你的灵魂需要用你的肉体做为交换,愿意的话请点确定!"},
            {"YELL", "%t是个乖宝宝,咿呀咿呀哟~起床时间要早早,咿呀咿呀哟~~"},
            {"YELL", "OH,亲爱的%t,在我们精神得到极度升华的瞬间你面带微笑精疲力竭地倒下了,我要让你重生,让我们重温那美好的瞬间!^o^嘴嘴"},
            {"EMOTE", "冲上去趴在%t胸口,用力的抚摸的%t胸口:你死得好惨阿~~(啊呀呀~~好有手感啊!)"},
            {"EMOTE", "对%t说:我亲爱的睡美人儿,你怎么又睡着了?快起来吧!"},
            {"EMOTE", "深深的吸了一口气,深情地弯下腰去,轻轻吻住%t的樱桃小嘴,呼入一口新鲜的空气……"},
            {"EMOTE", "%t别怕，英俊潇洒人见人爱花见花开的老手GG来拯救你了!"},
            {"EMOTE", "扑在%t的身上开始人工呼吸,%t睁开了美丽的双眼,饱含热泪的扑进老手的怀抱大声说:老手GG你救了我,无以为报,让我嫁给你吧!"},
            {"EMOTE", "扑在%t的身上开始人工呼吸,%t睁开了美丽的双眼,兴奋的说:再来一下吧,不来不起来!"}
            }
         };
      btCustom = btCustom[UnitSex("target")]
      btCustom = btCustom[math.random(1, table.getn(btCustom))];
      SendChatMessage(btCustom[2], btCustom[1]);
   end
end

local Shaman_No_Sneer_Bosses = {			
			"堕落的瓦拉斯塔兹",
			"奥妮克希亚",			
			"埃兰之影",
			"虚空幽龙",
			"玛克扎尔王子",
			"夜之魇",
			"屠龙者格鲁尔",
			"莫加尔大王",
			"血肉兽",
			"大型血肉兽",
			"猎手阿图门",	
			"幻影仆从",	
			"幽灵服务员",	
			"莫罗斯",	
			"骷髅招待员",	
			"幻影舞台工人",	
			"鬼灵演员",	
			"朱丽叶",	
			"罗密欧",
			"巫术之影",
			"虚灵窃法者",
			"贞节圣女",
			"被禁锢的幽魂",
			"奥术看守",
			"馆长",
			"奥术保卫者",
			"虚灵窃贼",
			    };

local Shaman_Bosses = {
			"范达尔·雷矛",
			"德雷克塔尔",
			"巴琳达·斯通赫尔斯",
			"加尔范上尉",	
			"大灰狼",	
			"朱丽叶",	
			"罗密欧",	
			"老巫婆",	
			"馆长",
			"特雷斯坦·邪蹄",
			"埃兰之影",
			"虚空幽龙",
			"玛克扎尔王子",
			"夜之魇",
			"潜伏者希亚奇斯",
			"蹂躏者洛卡德",
			"滑翔者沙德基斯",
			"屠龙者格鲁尔",
			"莫加尔大王",
			"背叛者门努",
			"巨钳鲁克玛尔",
			"夸格米拉",
			"霍加尔芬",
			"加兹安",
			"沼地领主穆塞雷克",
			"黑色阔步者",
			"水术师瑟丝比娅",
			"机械师斯蒂里格",
			"督军卡利瑟里斯",
			"不稳定的海度斯",
			"盲眼者莱欧瑟拉斯",
			"深水领主卡拉瑟雷斯",
			"莫洛格里·踏潮者",
			"鱼斯拉",
			"瓦丝琪",
			"德拉克中尉",
			"斯卡洛克上尉",
			"时空猎手",
			"时空领主德亚",
			"坦普卢斯",
			"埃欧努斯",
			"雷基·冬寒",
			"安纳塞隆",
			"卡兹洛加",
			"阿兹加洛",
			"阿克蒙德",
			"巡视者加戈玛",
			"无疤者奥摩尔",
			"制造者",
			"布洛戈克",
			"击碎者克里丹",
			"高阶术士奈瑟库斯",
			"战争使者沃姆罗格",
			"酋长卡加斯·刃拳",
			"玛瑟里顿",
			"看守者盖罗基尔",
			"看守者埃隆汉",
			"机械领主卡帕西图斯",
			"灵术师塞比瑟蕾",
			"计算者帕萨雷恩",
			"指挥官萨拉妮丝",
			"高级植物学家弗雷温",
			"看管者索恩格林",
			"拉伊",
			"迁跃扭木",
			"自由的瑟雷凯斯",
			"天怒预言者苏克拉底",
			"末日预言者达尔莉安",
			"预言者斯克瑞斯",
			"空灵机甲",
			"奥",
			"大星术师索兰莉安",
			"凯尔萨斯·逐日者",
		};

function Shaman_BU(s) local P,B,i="player",true,1  while UnitBuff(P,i)   do if string.find(UnitBuff(P,i),s)   then B=false end i=i+1 end return B end
function Shaman_TargetBU(s) local P,B,i="target",true,1  while UnitBuff(P,i)   do if string.find(UnitBuff(P,i),s)   then B=false end i=i+1 end return B end
function Shaman_TargetDeBU(s) local P,B,i="target",true,1  while UnitDebuff(P,i) do if string.find(UnitDebuff(P,i),s) then B=false end i=i+1 end return B end
function Shaman_PlayerDeBU(s)
	local name1, _,_,_,_,_,expirationTime = UnitDebuff("player", s);
	if (name1 ~= null) then 
		Shaman_AddMessage("你中了Debuff: "..name1..", 还有 "..expirationTime.." 毫秒");
		return false;
	else
		return true;
	end
	--local P,B,i="player",true,1;
	--while UnitDebuff(P,i) do 
	--	if string.find(UnitDebuff(P,i),s) then B=false end
	--	i=i+1;
	--end 
	--return B
	
end
function Shaman_UnitBU(unit,s) local P,B,i=unit,true,1  while UnitBuff(P,i)   do if string.find(UnitBuff(P,i),s)   then B=false end i=i+1 end return B end
function Shaman_UnitDeBU(unit,s) local P,B,i=unit,true,1  while UnitDebuff(P,i) do if string.find(UnitDebuff(P,i),s) then B=false end i=i+1 end return B end
function Shaman_PlayerBU(s)
	local i = 1;
	local name, _, _, count, _, _, expirationTime = UnitBuff("player", i);

	while name ~= null do
		if name==s then
			local temp = expirationTime - GetTime();
			return name, temp, count
		end;
		i = i+1;
		name, _, _, count, _, _, expirationTime = UnitBuff("player", i);
	end

	return null,null,0;

	--local P,B,i="player",true,1;
	--local temp = UnitBuff(P,i);
	--while temp do
	--	if string.find(temp,s) then
	--		return false;
	--	end;
	--	i=i+1;
	--	temp = UnitBuff(P,i);
	--end;
	--return B;
end

function Shaman_GetSpellCooldown(spellname) 
	i = Shaman_GetActionID(spellname);
	local start, duration, enable = GetActionCooldown(i);
	return duration;
end
function CanUseAction(i) 
	local _, duration, _ = GetActionCooldown(i);
	local isUsable, notEnoughMana = IsUsableAction(i);					
	if ( isUsable == 1 ) and ( not notEnoughMana ) and ( duration == 0) then
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
function Shaman_CanUseAction(i)
  local start, duration, enable = GetActionCooldown(i);
	if duration == 0 and start==0 and enable==1 then
		local isUsable, notEnoughMana = IsUsableAction(i);
		if (isUsable or isUsable==1) and (not notEnoughMana or nil == notEnoughMana) then
			return true;
		end
	end

	return false;
end

function Shaman_TestPlayerIsHorse()
	local i = 1;	
	while UnitBuff("player", i ) do
		ShamanTooltip:SetOwner(Shaman_MSG_Frame, "ANCHOR_BOTTOMRIGHT", 0, 0);
		ShamanTooltip:SetUnitBuff("player", i);		
		local	vText1 = ShamanTooltipTextLeft1:GetText();
		local	vText2 = ShamanTooltipTextLeft2:GetText();		
		ShamanTooltip:Hide();
		if vText2 ~= nil then
			if string.find(vText2, "能量值回复速度提高100") then
				return false;
			end
			if string.find(vText2, "飞行速度提高") or string.find(vText2, "速度提高60") or string.find(vText2, "速度提高100") then						
				return true;
			end								
		end		
		i = i + 1;
	end	
	return false;
end


function Shaman_TestHasBoss()	
	if (not UnitIsDeadOrGhost("player"))  and UnitExists("playertarget") then		    
		if(not UnitIsFriend("player","target")) and (not UnitIsDead("playertarget")) then			
			for k, v in pairs(Shaman_Bosses) do							
				if(UnitName("playertarget") == v) then
					return true,v;						
				end		
			end
		end
	end
	return false,"";
end

function Shaman_No_Sneer_Boss()	
	if (not UnitIsDeadOrGhost("player"))  and UnitExists("playertarget") then		    
		if(not UnitIsFriend("player","target")) and (not UnitIsDead("playertarget")) then			
			for k, v in pairs(Shaman_No_Sneer_Bosses) do							
				if(UnitName("playertarget") == v) then
					return true;						
				end		
			end
			for k, v in pairs(Shaman_SaveData) do		       
				if ( v["npcname"] == UnitName("playertarget") ) and v["spellname"] == "嘲讽" then  
					return true;	
				end
			end
		end
	end	
	return false;
end

function Shaman_ImmuneSpell(spellname)
	if (not UnitIsDeadOrGhost("player"))  and UnitExists("playertarget") then		    
		if(not UnitIsFriend("player","target")) and (not UnitIsDead("playertarget")) then
			for k, v in pairs(Shaman_SaveData) do		       
				if ( v["npcname"] == UnitName("playertarget") ) and string.find(v["spellname"],spellname)  then  
					return true;	
				end
			end
		end
	end	
	return false;
end;


function Shaman_TestSelfOT()	
	if (not UnitIsDeadOrGhost("player"))  and UnitExists("playertarget") then		    
		if(not UnitIsFriend("player","target")) and (not UnitIsDead("playertarget")) then			
			for k, v in pairs(Shaman_OT_Bosses) do							
				if(UnitName("playertarget") == v) then						
					if UnitExists("playertargettarget") then	
						if UnitIsUnit("playertargettarget", "player") then
							return true;	
						end
					end			
				end		
			end
		end
	end
	return false;
end


function Shaman_Test_Target_IsMe()	
	if UnitExists("playertargettarget") then	
		if UnitIsUnit("playertargettarget", "player") then
			return true;	
		end
	end			
	return false;
end
	
	
function Shaman_Test_Target_Debuff()
	if  UnitExists("playertarget") then		    
			if UnitCanAttack("player","target") and (not UnitIsDead("playertarget")) then
				if not Shaman_TargetDeBU("媚惑")  
					or not Shaman_TargetDeBU("变形术") 
					or not Shaman_TargetDeBU("休眠")  
					or not Shaman_TargetDeBU("致盲")  		
					or not Shaman_TargetDeBU("闷棍") 				
					or not Shaman_TargetDeBU("冰冻陷阱")
					or not Shaman_TargetDeBU("忏悔")
				then
					return true;
				end
			end
	end
	return false;	
end	

function Shaman_GetItemInfo(slotId)
	local mainHandLink = GetInventoryItemLink("player",slotId);
	local _, _, itemCode = strfind(mainHandLink, "(%d+):");
	local itemName, _, _, _, _, itemType = GetItemInfo(itemCode);
	return itemName;
end
function Shaman_TestTrinket(TrinketName)
	if Shaman_GetItemInfo(13) == TrinketName or Shaman_GetItemInfo(14) == TrinketName then
		return true;
	end
	return false;
end
function Shaman_GetMainHandType()
	local mainHandLink = GetInventoryItemLink("player",16);
	if mainHandLink then
		local _, _, itemCode = strfind(mainHandLink, "(%d+):");
		local itemName, _, _, _, _,_, itemType = GetItemInfo(itemCode);	
		return itemType;
	end
	return "";
end

function Shaman_GetAssistantHandType()
	local mainHandLink = GetInventoryItemLink("player",17);
	if mainHandLink then
		local _, _, itemCode = strfind(mainHandLink, "(%d+):");
		local itemName, _, _, _, _,_, itemType = GetItemInfo(itemCode);	
		return itemType;
	end
	return "";
end
function Shaman_GetUnitAssistantHandType(unit)
	local mainHandLink = GetInventoryItemLink(unit,17);
	if mainHandLink then
		local _, _, itemCode = strfind(mainHandLink, "(%d+):");
		local itemName, _, _, _, _,_, itemType = GetItemInfo(itemCode);	
		return itemType;
	end
	return "";
end
function Shaman_AddMessage(str)
	if Messagestr ~= str then
		Messagestr = str;
		DEFAULT_CHAT_FRAME:AddMessage("|cffffff00战斗信息:|r |cff00ff00" .. str .. "|r");	
	end
end
function Add(str)
	DEFAULT_CHAT_FRAME:AddMessage("|cffffff00战斗信息:|r |cff00ff00" .. str .. "|r");	
end
function Shaman_Warning_AddMessage(str)
	if Messagestr ~= str then
		Messagestr = str;
		if Shaman_Test_Battlefield() then
			DEFAULT_CHAT_FRAME:AddMessage("|cffffff00战斗信息:|r |cff00ff00" .. str .. "|r");	
		else
			if (UnitInRaid("player")) then
				SendChatMessage(str,"Raid");
			else
				if GetNumGroupMembers() > 0 then
					SendChatMessage(str,"Party");
				else
					DEFAULT_CHAT_FRAME:AddMessage("|cffffff00战斗信息:|r |cff00ff00" .. str .. "|r");	
				end;
			end
		end
	end
end
function Shaman_Warning_AddMessage1(str)
	if Shaman_Test_Battlefield() then
		DEFAULT_CHAT_FRAME:AddMessage("|cffffff00战斗信息:|r |cff00ff00" .. str .. "|r");	
	else
		if (UnitInRaid("player")) then
			SendChatMessage(str,"Raid");
		else
			if GetNumGroupMembers() > 0 then
				SendChatMessage(str,"Party");
			else
				DEFAULT_CHAT_FRAME:AddMessage("|cffffff00战斗信息:|r |cff00ff00" .. str .. "|r");	
			end;
		end
	end
end
function Shaman_Test_Battlefield()
	local _,zonetype = IsInInstance()
	if zonetype == "pvp" then return true; end;
	if zonetype == "arena" then return false; end;
	return false;

	--for i=1, MAX_BATTLEFIELD_QUEUES do
	--	local _, _, instanceID = GetBattlefieldStatus(i)		
	--	if( instanceID ~= 0 ) then
	--        	return true;
	--	end
	--end
	--return false;
end


function Shaman_AddMessage_A(str)
		DEFAULT_CHAT_FRAME:AddMessage("|cffffff00战斗信息:|r |cff00ff00" .. str .. "|r");	
end

function Shaman_SetText(str,rgb)
	Shaman_MSG_Text:SetText(str..", "..rgb);		
	getglobal("ShamanColorRectangle".."NormalTexture"):SetVertexColor((rgb - rgb % 10)/100 , 0, (rgb % 10)/10);	
end

function  Shaman_Auto_Attack()
	for i = 1, 120 do
		if ( HasAction(i) ) then
			local texture = GetActionTexture(i);
			local text = GetActionText(i);
			if IsAttackAction(i) then				
				return i;
			end
		end
	end
	return 0;
end

function Shaman_GetActionID(texture)
	for i = 1, 120 do
		if ( HasAction(i) ) then
			local temptexture = GetActionTexture(i);
			if temptexture == texture then
				return i;
			end
		end
	end
	return 0;
end

function Shaman_GetActionIDbyName(text)
	for i = 1, 120 do
		if ( HasAction(i) ) then
			local temptext = GetActionText(i);
			if string.find(temptext, text) then
				return i;
			end
		end
	end
	return 0;
end

function Shaman_CastSpell(text, texture)
	for i = 1, 12 do
	  -- Shaman_AddMessage("for do text: "..text..", i: "..i..", texture: "..texture); 
		if ( HasAction(i) ) then
		  -- Shaman_AddMessage("HasAction text: "..text..", i: "..i..", texture: "..texture); 
			local temptexture = GetActionTexture(i);
			-- Shaman_AddMessage("text: "..text..", i: "..i..", texture: "..texture);
			if temptexture == texture then
			  -- Shaman_AddMessage("text: "..text..", temptexture: "..temptexture..", texture: "..texture);
				if Shaman_CanUseAction(i) and (true==IsActionInRange(i)) then
					Shaman_SetText(text, i);															
					return true;
				end
			end
		end
	end
	for i = 61, 72 do
		if ( HasAction(i) ) then
			local temptexture = GetActionTexture(i);
			if temptexture == texture then
				if Shaman_CanUseAction(i) and (true==IsActionInRange(i)) then
					Shaman_SetText(text,i - 48);															
					return true;
				end
			end
		end
	end
	return false;
end

-- 不考虑距离
function Shaman_CastSpell_IgnoreRange(text, texture)
	for i = 61, 72 do
		if ( HasAction(i) ) then
			local temptexture = GetActionTexture(i);
			if temptexture == texture then
				if Shaman_CanUseAction(i) then
					Shaman_SetText(text, i - 48);
					return true;
				end
			end
		end
	end
	for i = 1, 12 do
		if ( HasAction(i) ) then
			local temptexture = GetActionTexture(i);
			if temptexture == texture then
				if Shaman_CanUseAction(i) then
					Shaman_SetText(text, i);
					return true;
				end
			end
		end
	end
	return false;
end

function Shaman_CastSpellById_IgnoreRange(text, i)
	if i > 0 then
		if HasAction(i) then
			if Shaman_CanUseAction(i) then
				local index = i;
				if (i >= 61 and i<=72) then
					index = i - 48;
				end
				Shaman_SetText(text, index);
				return true;
			end
		end
	end
	return false;
end

function Shaman_CastSpellbyID(text,texture,i)
	if i > 0 then
		if ( HasAction(i) ) then
			if Shaman_CanUseAction(i) and (0~=IsActionInRange(i)) then
				local index = i;
				if (i >= 61 and i<=72) then
					index = i - 48;
				end
				Shaman_SetText(text,index);															
				return true;
			end
		end
	end
	
	return false;
end

function  GetUnitHealthPercent(unit)
	local health, healthmax  = UnitHealth(unit), UnitHealthMax(unit);
	local healthPercent = floor(health/healthmax*100+0.5);	
	return healthPercent;
end
function  GetUnitPowerPercent(unit)
	local power, powermax  = UnitPower(unit), UnitPowerMax(unit);
	local powerPercent = floor(power/powermax*100+0.5);	
	return powerPercent;
end

function Shaman_PickupSpellByBook(spell)
	local i = 1
	while true do
	   local spellName, spellRank = GetSpellBookItemName(i, BOOKTYPE_SPELL)
	   local spellName1, spellRank1 = GetSpellBookItemName(i+1, BOOKTYPE_SPELL)
	   if not spellName then return false; end
	   if spellName == spell then
		   if not spellName1 or spellName ~= spellName1 then 		  
			   PickupSpellBookItem(i,BOOKTYPE_SPELL);
			   return true;
		   end	
	   end  	   
	   i = i + 1
	end
	return false;
end

local TimerDatas = {};

function StartTimer(id)
	for k, v in pairs(TimerDatas) do							
		if(id == v["Name"]) then
			v["Time"] = GetTime();
			return ;
		end		
	end
	table.insert(TimerDatas,
		{
		["Name"] = id,
		["Time"] = GetTime(),	
		});
end

function GetTimer(id)
	for k, v in pairs(TimerDatas) do							
		if(id == v["Name"]) then
			local now = GetTime();
			local startTime = v["Time"];
			return (now - startTime), startTime, now;			
		end		
	end
	return 999;
end
function EndTimer(id)
	for k, v in pairs(TimerDatas) do							
		if(id == v["Name"]) then
			table.remove(TimerDatas,k);
			return ;			
		end		
	end
end


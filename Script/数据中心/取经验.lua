--======================================================================--
-- @作者: GGE研究群: 342119466
-- @创建时间:   2018-03-03 02:34:19
-- @Last Modified time: 2020-10-09 20:01:00
-- 梦幻西游游戏资源破解 baidwwy@vip.qq.com(313738139) 老毕   和 C++PrimerPlus 717535046 这俩位大神破解所以资源
--======================================================================--
function 判断修炼召唤兽选项(id,事件)
	local 任务id=玩家数据[id].角色:取任务(13)
	if 任务数据[任务id]==nil or 任务数据[任务id].分类~=15 then
		return
	end
	local 选项={}
	local 模型=任务数据[任务id].bb
	for n=1,#玩家数据[id].召唤兽.数据 do
		if 玩家数据[id].召唤兽.数据[n].模型==模型 and 玩家数据[id].召唤兽.数据[n].种类=="变异" then
			选项[#选项+1]={对话=format("%s,等级:%s",玩家数据[id].召唤兽.数据[n].名称,玩家数据[id].召唤兽.数据[n].等级),编号=n}
		end
	end
	for n=1,#选项 do
		if 选项[n].对话==事件 then
			玩家数据[id].召唤兽:删除处理(id,选项[n].编号)
			任务处理类:完成宠修任务(id,任务id)
			return
		end
	end
	添加最后对话(id,"你所选的这只召唤兽并不是对方想要的")
end

function 取符合修炼召唤兽选项(id)
	local 任务id=玩家数据[id].角色:取任务(13)
	if 任务数据[任务id]==nil or 任务数据[任务id].分类~=15 then
		return
	end
	local 选项={}
	local 模型=任务数据[任务id].bb
	for n=1,#玩家数据[id].召唤兽.数据 do
       if 玩家数据[id].召唤兽.数据[n].模型==模型 and 玩家数据[id].召唤兽.数据[n].种类=="变异" then
            选项[#选项+1]=format("%s,等级:%s",玩家数据[id].召唤兽.数据[n].名称,玩家数据[id].召唤兽.数据[n].等级)
       	end
 	end
	return 选项
end

function 判断任务链召唤兽选项(id,事件)
	local 任务id=玩家数据[id].角色:取任务(15)
	if 任务数据[任务id]==nil or 任务数据[任务id].分类~=15 then
		return
	end
	local 选项={}
	local 模型=任务数据[任务id].bb
	for n=1,#玩家数据[id].召唤兽.数据 do
		if 玩家数据[id].召唤兽.数据[n].模型==模型 and 玩家数据[id].召唤兽.数据[n].种类=="变异" then
			选项[#选项+1]={对话=format("%s,等级:%s",玩家数据[id].召唤兽.数据[n].名称,玩家数据[id].召唤兽.数据[n].等级),编号=n}
		end
	end
	for n=1,#选项 do
		if 选项[n].对话==事件 then
			玩家数据[id].召唤兽:删除处理(id,选项[n].编号)
			任务处理类:完成任务链任务(id,任务id)
			return
		end
	end
	添加最后对话(id,"你所选的这只召唤兽并不是对方想要的")
end

function 取符合任务链召唤兽选项(id)
	local 任务id=玩家数据[id].角色:取任务(15)
	if 任务数据[任务id]==nil or 任务数据[任务id].分类~=15 then
		return
	end
	local 选项={}
	local 模型=任务数据[任务id].bb
	for n=1,#玩家数据[id].召唤兽.数据 do
       if 玩家数据[id].召唤兽.数据[n].模型==模型 and 玩家数据[id].召唤兽.数据[n].种类=="变异" then
            选项[#选项+1]=format("%s,等级:%s",玩家数据[id].召唤兽.数据[n].名称,玩家数据[id].召唤兽.数据[n].等级)
       	end
 	end
	return 选项
end

function 判断任务召唤兽选项(id,事件)
	local 任务id=玩家数据[id].角色:取任务("飞升剧情")
	if 任务数据[任务id]==nil or 任务数据[任务id].进程~=10 then
		return
	end
	local 选项={}
	for n=1,#玩家数据[id].召唤兽.数据 do
		if 玩家数据[id].召唤兽.数据[n].模型==任务数据[任务id].bb[1].名称 and 任务数据[任务id].bb[1].找到==false then
			任务数据[任务id].bb[1].找到=true
			选项[#选项+1]={对话=format("%s,等级:%s",玩家数据[id].召唤兽.数据[n].名称,玩家数据[id].召唤兽.数据[n].等级),编号=n}
		end
	end
	for n=1,#选项 do
		玩家数据[id].召唤兽:删除处理(id,选项[n].编号)
	end
end

function 取符合任务召唤兽选项(id)
	local 任务id=玩家数据[id].角色:取任务("飞升剧情")
	if 任务数据[任务id]==nil or 任务数据[任务id].进程~=10 then
		return
	end
	local 选项={}
	for n=1,#玩家数据[id].召唤兽.数据 do
        if 玩家数据[id].召唤兽.数据[n].模型==任务数据[任务id].bb[1].名称 then
            选项[#选项+1]=format("%s,等级:%s",玩家数据[id].召唤兽.数据[n].名称,玩家数据[id].召唤兽.数据[n].等级)
       	end
 	end
	return 选项
end

function 判断天门任务召唤兽选项(id,事件)
	local 选项={}
	for n=1,#玩家数据[id].召唤兽.数据 do
		if 玩家数据[id].召唤兽.数据[n].模型=="古代瑞兽" then
			选项[#选项+1]={对话=format("%s,等级:%s",玩家数据[id].召唤兽.数据[n].名称,玩家数据[id].召唤兽.数据[n].等级),编号=n}
		end
	end
	for n=1,#选项 do
		玩家数据[id].召唤兽:删除处理(id,选项[n].编号)
	end
end

function 取符合天门任务召唤兽选项(id)
	local 选项={}
	for n=1,#玩家数据[id].召唤兽.数据 do
        if 玩家数据[id].召唤兽.数据[n].模型=="古代瑞兽" then
            选项[#选项+1]=format("%s,等级:%s",玩家数据[id].召唤兽.数据[n].名称,玩家数据[id].召唤兽.数据[n].等级)
       	end
 	end
	return 选项
end

function 计算修炼等级经验(等级,上限)
	local 临时经验=110
	if 等级==0 then return 110 end
	for n=1,上限+1 do
		临时经验=临时经验+20+n*20
		if n==等级 then return  临时经验 end
	end
end

法宝经验={
	{469350,712000,2028000,4469000,8500000,14424000,22652000,33568000,47556000},
	{210268,472144,1082236,2237152,4133500,6967888,10936924,16237216,23065372,31618000,40000000,54683104},
	{199452,385616,790204,1544928,2781500,4631632,7227036,10699424,15180508,20802000,27695612,35993056,45826044,57326288,70625500},
	{1834389,2935112,4348503,6220896,8698625,11928024,16055427,21227168,27589581,35289000,44471759,55284192,67872633,82383416,98962875,117757344,138913157,1625976648},
}

技能消耗={}
技能消耗.经验={
	[1]=16,
	[2]=32,
	[3]=52,
	[4]=75,
	[5]=103,
	[6]=136,
	[7]=179,
	[8]=231,
	[9]=295,
	[10]=372,
	[11]=466,
	[12]=578,
	[13]=711,
	[14]=867,
	[15]=1049,
	[16]=1280,
	[17]=1503,
	[18]=1780,
	[19]=2096,
	[20]=2452,
	[21]=2854,
	[22]=3304,
	[23]=3807,
	[24]=4364,
	[25]=4983,
	[26]=5664,
	[27]=6415,
	[28]=7238,
	[29]=8138,
	[30]=9120,
	[31]=10188,
	[32]=11347,
	[33]=12602,
	[34]=13959,
	[35]=15423,
	[36]=16998,
	[37]=18692,
	[38]=20508,
	[39]=22452,
	[40]=24532,
	[41]=26753,
	[42]=29121,
	[43]=31642,
	[44]=34323,
	[45]=37169,
	[46]=40186,
	[47]=43388,
	[48]=46773,
	[49]=50352,
	[50]=54132,
	[51]=58120,
	[52]=62324,
	[53]=66750,
	[54]=71407,
	[55]=76303,
	[56]=81444,
	[57]=86840,
	[58]=92500,
	[59]=104640,
	[60]=111136,
	[61]=117931,
	[62]=125031,
	[63]=132444,
	[64]=140183,
	[65]=148253,
	[66]=156666,
	[67]=156666,
	[68]=165430,
	[69]=174556,
	[70]=184052,
	[71]=193930,
	[72]=204198,
	[73]=214868,
	[74]=225948,
	[75]=237449,
	[76]=249383,
	[77]=261760,
	[78]=274589,
	[79]=287884,
	[80]=301652,
	[81]=315908,
	[82]=330662,
	[83]=345924,
	[84]=361708,
	[85]=378023,
	[86]=394882,
	[87]=412297,
	[88]=430280,
	[89]=448844,
	[90]=468000,
	[91]=487760,
	[92]=508137,
	[93]=529145,
	[94]=550796,
	[95]=573103,
	[96]=596078,
	[97]=619735,
	[98]=644088,
	[99]=669149,
	[100]=721452,
	[101]=748722,
	[102]=776755,
	[103]=805566,
	[104]=835169,
	[105]=865579,
	[106]=896809,
	[107]=928876,
	[108]=961792,
	[109]=995572,
	[110]=1030234,
	[111]=1065190,
	[112]=1102256,
	[113]=1139649,
	[114]=1177983,
	[115]=1217273,
	[116]=1256104,
	[117]=1298787,
	[118]=1341043,
	[119]=1384320,
	[120]=1428632,
	[121]=1473999,
	[122]=1520435,
	[123]=1567957,
	[124]=1616583,
	[125]=1666328,
	[126]=1717211,
	[127]=1769248,
	[128]=1822456,
	[129]=1876852,
	[130]=1932456,
	[131]=1989284,
	[132]=2047353,
	[133]=2106682,
	[134]=2167289,
	[135]=2229192,
	[136]=2292410,
	[137]=2356960,
	[138]=2422861,
	[139]=2490132,
	[140]=2558792,
	[141]=2628860,
	[142]=2700356,
	[143]=2773296,
	[144]=2847703,
	[145]=2923593,
	[146]=3000989,
	[147]=3079908,
	[148]=3160372,
	[149]=3242400,
	[150]=6652022,
	[151]=6822452,
	[152]=6996132,
	[153]=7173104,
	[154]=7353406,
	[155]=11305620,
	[156]=15305620,
	[157]=22305620,
	[158]=27305620,
	[159]=37305620,
	[160]=45305620,
	[161]=54305620,
	[162]=57305620,
	[163]=60305620,
	[164]=65305620,
	[165]=70305620,
	[166]=84305620,
}

for n=167,250 do
  技能消耗.经验[n]=math.floor(技能消耗.经验[n-1]*1.2)
end

技能消耗.金钱={
	[1]=6,
	[2]=12,
	[3]=19,
	[4]=28,
	[5]=38,
	[6]=51,
	[7]=67,
	[8]=86,
	[9]=110,
	[10]=139,
	[11]=174,
	[12]=216,
	[13]=266,
	[14]=325,
	[15]=393,
	[16]=472,
	[17]=563,
	[18]=667,
	[19]=786,
	[20]=919,
	[21]=1070,
	[22]=1238,
	[23]=1426,
	[24]=1636,
	[25]=1868,
	[26]=2124,
	[27]=2404,
	[28]=2714,
	[29]=3050,
	[30]=3420,
	[31]=3820,
	[32]=4255,
	[33]=4725,
	[34]=5234,
	[35]=5783,
	[36]=6374,
	[37]=7009,
	[38]=7680,
	[39]=8419,
	[40]=9199,
	[41]=10032,
	[42]=10920,
	[43]=11865,
	[44]=12871,
	[45]=13938,
	[46]=15070,
	[47]=16270,
	[48]=17540,
	[49]=18882,
	[50]=20299,
	[51]=21795,
	[52]=23371,
	[53]=25031,
	[54]=26777,
	[55]=28613,
	[56]=30541,
	[57]=32565,
	[58]=34687,
	[59]=36911,
	[60]=39240,
	[61]=41676,
	[62]=44224,
	[63]=46886,
	[64]=49666,
	[65]=52568,
	[66]=55595,
	[67]=58749,
	[68]=62036,
	[69]=65458,
	[70]=69019,
	[71]=72723,
	[72]=76574,
	[73]=80575,
	[74]=84730,
	[75]=89043,
	[76]=93516,
	[77]=98160,
	[78]=102971,
	[79]=107956,
	[80]=113119,
	[81]=118465,
	[82]=123998,
	[83]=129721,
	[84]=135640,
	[85]=141758,
	[86]=148080,
	[87]=154611,
	[88]=161355,
	[89]=168316,
	[90]=175500,
	[91]=182910,
	[92]=190551,
	[93]=198429,
	[94]=206548,
	[95]=214913,
	[96]=223529,
	[97]=232400,
	[98]=241533,
	[99]=250931,
	[100]=260599,
	[101]=270544,
	[102]=280770,
	[103]=291283,
	[104]=302087,
	[105]=313188,
	[106]=324592,
	[107]=336303,
	[108]=348328,
	[109]=360672,
	[110]=373339,
	[111]=386337,
	[112]=399671 ,
	[113]=413346,
	[114]=427368,
	[115]=441743,
	[116]=456477,
	[117]=471576,
	[118]=487045,
	[119]=502891,
	[120]=519120,
	[121]=535737,
	[122]=552749,
	[123]=570163,
	[124]=587984,
	[125]=606218,
	[126]=624873,
	[127]=643954,
	[128]=663468 ,
	[129]=683421,
	[130]=703819,
	[131]=724671,
	[132]=745981,
	[133]=767757,
	[134]=790005,
	[135]=812733,
	[136]=835947 ,
	[137]=859653,
	[138]=883860,
	[139]=908573 ,
	[140]=933799 ,
	[141]=959547 ,
	[142]=985822,
	[143]=1012633,
	[144]=1039986,
	[145]=1067888 ,
	[146]=1096347,
	[147]=1125371,
	[148]=1154965,
	[149]=1185139,
	[150]=1215900,
	[151]=2494508,
	[152]=2558419,
	[153]=2623549,
	[154]=2689914,
	[155]=2757527,
	[156]=4239607,
	[157]=6239607,
	[158]=8239607,
	[159]=10239607,
	[160]=15239607,
	[161]=18239607,
	[162]=20239607,
	[163]=25239607,
	[164]=30239607,
	[165]=36239607,
	[166]=40239607,
}
for n=167,250 do
  技能消耗.金钱[n]=math.floor(技能消耗.金钱[n-1]*1.2)
end
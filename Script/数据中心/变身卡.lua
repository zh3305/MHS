--======================================================================--
-- @作者: GGE研究群: 342119466
-- @创建时间:   2018-03-03 02:34:19
-- @Last Modified time: 2020-04-16 17:57:29
-- 梦幻西游游戏资源破解 baidwwy@vip.qq.com(313738139) 老毕   和 C++PrimerPlus 717535046 这俩位大神破解所以资源
--======================================================================--
幻化属性基数={
	伤害=1.6
	,防御=1.5
	,气血=3
	,速度=1.5
	,法术伤害=1.6
	,法术伤害结果=2
	,法术防御=2
	,法术暴击等级=1.5
	,抗法术暴击等级=1.5
	,治疗能力=2
	,抗物理暴击等级=1.6
	,格挡值=2
	,气血回复效果=2
	,封印命中等级=1
	,抗封印等级=1
	,固定伤害=2
	,狂暴等级=1.5
	,穿刺等级=1.5
	,物理暴击等级=1.5
}
幻化属性强化={
	伤害=4
	,防御=8
	,气血=28
	,速度=3
	,法术伤害=4
	,法术伤害结果=5
	,法术暴击等级=3
	,抵抗封印等级=8
	,抗法术暴击等级=8
	,治疗能力=3
	,抗物理暴击等级=3
	,格挡值=8
	,法术防御=8
	,气血回复效果=5
	,封印命中等级=4
	,固定伤害=20
	,狂暴等级=3
	,穿刺等级=3
	,物理暴击等级=4
}
变身卡范围={
	[1]={"大海龟","巨蛙","海毛虫","护卫","树怪","大蝙蝠","山贼","强盗","野猪"}
	,[2]={"骷髅怪","羊头怪","蛤蟆精","狐狸精","老虎","黑熊","花妖"}
	,[3]={"牛妖","小龙女","野鬼","狼","虾兵","蟹将"}
	,[4]={"龟丞相","蜘蛛精","黑熊精","僵尸","牛头","马面"}
	,[5]={"雷鸟人","蝴蝶仙子","古代瑞兽","白熊","黑山老妖"}
	,[6]={"天兵","天将","地狱战神","风伯","凤凰","蛟龙"}
	,[7]={"如意仙子","巡游天神","星灵仙子","芙蓉仙子"}
	,[8]={"幽灵","吸血鬼","鬼将","雾中仙","灵鹤","夜罗刹","炎魔神","噬天虎"}
}
车迟变身卡范围={
	"大海龟","巨蛙","海毛虫","护卫","树怪","大蝙蝠","山贼","强盗","野猪"
	,"骷髅怪","羊头怪","蛤蟆精","狐狸精","老虎","黑熊","花妖"
	,"牛妖","小龙女","野鬼","狼","虾兵","蟹将"
	,"龟丞相","蜘蛛精","黑熊精","僵尸","牛头","马面"
	,"雷鸟人","蝴蝶仙子","古代瑞兽","白熊","黑山老妖"
	,"天兵","天将","地狱战神","风伯","凤凰","蛟龙"
	,"如意仙子","巡游天神","星灵仙子","芙蓉仙子"
	,"幽灵","吸血鬼","鬼将","雾中仙","灵鹤","夜罗刹","炎魔神","噬天虎"
}
变身卡数据={
	巨蛙={技能="",属性=0,类型="",正负=0,等级=1}
	,大海龟={技能="",属性=0,类型="",正负=0,等级=1}
	,护卫={技能="",属性=0,类型="",正负=0,等级=1}
	,树怪={技能="",属性=0,类型="",正负=0,等级=1}
	,强盗={技能="",属性=0,类型="",正负=0,等级=1}
	,海毛虫={技能="",属性=0,类型="",正负=0,等级=1}
	,大蝙蝠={技能="",属性=0,类型="",正负=0,等级=1}
	,山贼={技能="",属性=0,类型="",正负=0,等级=1}
	,野猪={技能="",属性=0,类型="",正负=0,等级=1}
	,骷髅怪={技能="夜战",属性=20,类型="气血",正负=2,等级=2}
	,羊头怪={技能="幸运",属性=10,类型="气血",正负=2,等级=2}
	,蛤蟆精={技能="毒",属性=15,类型="防御",正负=2,等级=2}
	,狐狸精={技能="感知",属性=5,类型="气血",正负=2,等级=2}
	,老虎={技能="强力",属性=10,类型="速度",正负=2,等级=2}
	,黑熊={技能="防御",属性=5,类型="灵力",正负=2,等级=2}
	,花妖={技能="慧根",属性=0,类型="",正负=0,等级=2}
	,牛妖={技能="反击",属性=5,类型="防御",正负=2,等级=3}
	,小龙女={技能="驱鬼",属性=5,类型="伤害",正负=2,等级=3}
	,野鬼={技能="夜战",属性=5,类型="灵力",正负=2,等级=3}
	,狼={技能="偷袭",属性=10,类型="气血",正负=2,等级=3}
	,虾兵={技能="必杀",属性=10,类型="伤害",正负=2,等级=3}
	,蟹将={技能="连击",属性=12,类型="速度",正负=2,等级=3}
	,龟丞相={技能="",属性=7,类型="气血",正负=1,等级=4}
	,蜘蛛精={技能="毒",属性=10,类型="防御",正负=2,等级=4}
	,黑熊精={技能="反震",属性=10,类型="防御",正负=2,等级=4}
	,僵尸={技能="弱点雷",属性=10,类型="气血",正负=1,等级=4}
	,牛头={技能="招架",属性=0,类型="",正负=0,等级=4}
	,马面={技能="必杀",属性=8,类型="伤害",正负=2,等级=4}
	,雷鸟人={技能="飞行",属性=10,类型="气血",正负=2,等级=5}
	,蝴蝶仙子={技能="魔之心",属性=10,类型="防御",正负=2,等级=5}
	,古代瑞兽={技能="反震",属性=10,类型="气血",正负=2,等级=5}
	,白熊={技能="迟钝",属性=0,类型="",正负=0,等级=5}
	,黑山老妖={技能="偷袭",属性=10,类型="速度",正负=2,等级=5}
	,天兵={技能="防御",属性=0,类型="",正负=0,等级=6}
	,天将={技能="强力",属性=8,类型="灵力",正负=2,等级=6}
	,地狱战神={技能="连击",属性=5,类型="气血",正负=2,等级=6}
	,风伯={技能="敏捷",属性=5,类型="防御",正负=2,等级=6}
	,凤凰={技能="飞行",属性=0,类型="",正负=0,等级=6}
	,蛟龙={技能="永恒",属性=0,类型="",正负=0,等级=6}
	,芙蓉仙子={技能="再生",属性=30,类型="防御",正负=1,单独=1,等级=7}
	,巡游天神={技能="必杀",属性=20,类型="速度",正负=2,等级=7}
	,星灵仙子={技能="慧根",属性=10,类型="灵力",正负=1,单独=1,等级=7}
	,如意仙子={技能="慧根",属性=10,类型="灵力",正负=1,单独=1,等级=7}
	,幽灵={技能="高级夜战",属性=0,类型="",正负=0,等级=8}
	,吸血鬼={技能="偷袭",属性=5,类型="速度",正负=2,等级=8}
	,鬼将={技能="高级必杀",属性=10,类型="伤害",正负=2,等级=8}
	,净瓶女娲={技能="高级永恒",属性=5,类型="防御",正负=2,等级=8}
	,律法女娲={技能="高级反击",属性=10,类型="速度",正负=2,等级=8}
	,灵符女娲={技能="魔之心",属性=0,类型="",正负=0,等级=8}
	,大力金刚={技能="高级防御",属性=5,类型="灵力",正负=2,等级=8}
	,雾中仙={技能="高级敏捷",属性=10,类型="防御",正负=2,等级=8}
	,灵鹤={技能="高级魔之心",属性=10,类型="防御",正负=2,等级=8}
	,炎魔神={技能="高级魔之心",属性=15,类型="气血",正负=2,等级=8}
	,夜罗刹={技能="高级夜战",属性=5,类型="速度",正负=1,等级=8}
	,噬天虎={技能="高级强力",属性=10,类型="速度",正负=2,等级=8}
}
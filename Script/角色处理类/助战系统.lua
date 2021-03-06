
local 助战系统 = class()
local floor = math.floor
local ceil = math.ceil
local jnzb = require("script/角色处理类/技能类")
function 助战系统:初始化()
	self.数据={}
end

function 助战系统:加载数据(账号,玩家id)
  self.id = 玩家id
  if f函数.文件是否存在([[data/]]..账号..[[/]]..self.id..[[/助战.txt]])==false then
    写出文件([[data/]]..账号..[[/]]..self.id.."/助战.txt",table.tostring({}))
  end
	self.数据=table.loadstring(读入文件([[data/]]..账号..[[/]]..self.id..[[/助战.txt]]))
  for i=1,#self.数据 do
    if self.数据[i].辅助技能==nil then
        self.数据[i].辅助技能={强身=0,冥想=0}
    end
  end
end

function 助战系统:数据处理(序号,内容)
  local 编号 = 内容.编号
  if self.数据[编号] == nil then
    return
  elseif 玩家数据[self.id].战斗 ~= 0 then
    return
  end
  local 是否刷新 = 0
  if 序号 == 87 then --改名OK
    是否刷新=1
    self.数据[编号].名称 = 内容.名称
    常规提示(self.id,"#Y/改名成功!")
  elseif 序号 == 86 then --参战OK
    if 玩家数据[self.id].角色.数据.助战 == nil then
      玩家数据[self.id].角色.数据.助战 = {}
    end
    if self.数据[编号].参战 then
      self.数据[编号].参战 = false
      for i=1,#玩家数据[self.id].角色.数据.助战 do
        if 玩家数据[self.id].角色.数据.助战[i] == 编号 then
          table.remove(玩家数据[self.id].角色.数据.助战,i)
        end
      end
      是否刷新=1
    else
      if #玩家数据[self.id].角色.数据.助战 >=4 then
        常规提示(self.id,"#Y/你当前已经有4位助战帮手参战了!")
        return
      elseif 玩家数据[self.id].队伍 ~= 0 and 玩家数据[self.id].队长 and #队伍数据[玩家数据[self.id].队伍].成员数据+1 >5 then
        常规提示(self.id,"#Y/你当前队伍内人数已经达到5人!")
        return
      else
        self.数据[编号].参战 = true
        玩家数据[self.id].角色.数据.助战[#玩家数据[self.id].角色.数据.助战+1]=编号
        常规提示(self.id,"#Y/助战帮手参战成功!")
      end
    end
    if 玩家数据[self.id].队伍 ~= 0 and 玩家数据[self.id].队长 then
      队伍处理类:重置助战(self.id,1)
    end
    是否刷新=1
  elseif 序号 == 85 then --属性培养
    local 培养经验=10000000
    local 培养银子=1000000
    if 让海啸席卷 then
      培养经验=1000000
      培养银子=500000
    end
    local 经验 = 培养经验*内容.次数
    local 银子 = 培养银子*内容.次数
    if 取银子(self.id)<银子 then
        常规提示(self.id,"#Y/你当前的银子好像不够哟!")
        return
    elseif 玩家数据[self.id].角色.数据.当前经验 < 经验 then
        常规提示(self.id,"#Y/你当前的经验好像不够哟!")
        return
    end
    玩家数据[self.id].角色.数据.当前经验=玩家数据[self.id].角色.数据.当前经验-经验
    玩家数据[self.id].角色:扣除银子(银子,0,0,"助战培养",1)
    self:添加经验(编号,经验)
    是否刷新 = 1
  elseif 序号 == 84 then
    self:遗弃助战(编号)
  elseif 序号 == 83 then --退出门派OK
    if 取银子(self.id)<30000000 then
      常规提示(self.id,"#Y/你当前的银子好像不够哟!")
      return
    end
    玩家数据[self.id].角色:扣除银子(30000000,0,0,"助战退出门派",1)
    self.数据[编号].门派 ="无门派"
    self.数据[编号].技能 = {}
    常规提示(self.id,"#Y/退出门派成功!")
    是否刷新 = 1
  elseif 序号 == 82 then --加入门派OK
    self.数据[编号].门派 = 分割文本(内容.门派,"(")[1]
    是否刷新 = 1
    常规提示(self.id,"#Y/加入门派成功!")
  elseif 序号 == 81 then
    self:加点处理(编号,内容.加点)
    是否刷新 = 1
  elseif 序号 == 80 then
    发送数据(玩家数据[self.id].连接id,103,{编号=编号,装备=self:取装备数据(编号),道具=玩家数据[self.id].道具:索要道具2(self.id),灵饰=self:取灵饰数据(编号),技能=self:取技能数据(编号)})
  elseif 序号 == 79 then
    self:使用道具(编号,内容)
  elseif 序号 == 78 then
    self:添加装备(编号,内容)
  elseif 序号 == 77 then
    self:去除装备(编号,内容)
  elseif 序号 == 76 then
    self:洗点处理(编号)
  elseif 序号 == 75 then
    self.数据[编号].技能 = 内容.技能
    常规提示(self.id,"#Y/修改助战技能成功!")
    是否刷新 = 1
  end
  if 是否刷新 == 1 then
    发送数据(玩家数据[self.id].连接id,100,{编号=编号,数据=self:取指定数据(编号)})--刷新指定数据
  end
end
function 助战系统:使用道具(编号,内容)
  local 道具格子=内容.物品编号
  local 道具id=玩家数据[self.id].角色.数据.道具[道具格子]
  if 道具id==nil or 玩家数据[self.id].道具.数据[道具id]==nil then
    玩家数据[self.id].角色.数据.道具[道具格子]=nil
    发送数据(玩家数据[self.id].连接id,3699)
    道具刷新(self.id)
    发送数据(玩家数据[self.id].连接id,105,玩家数据[self.id].道具:索要道具2(self.id))
    return
  end
  local 名称=玩家数据[self.id].道具.数据[道具id].名称
  local 使用成功 = false
  if 名称 == "中级神魂丹"  then
    if self.数据[编号].助战等级 == "初级" then
      self.数据[编号].助战等级 = "中级"
      self.数据[编号].修炼 = {攻击修炼=10,法术修炼=10,防御修炼=10,抗法修炼=10}
      self.数据[编号].辅助技能={强身=40,冥想=40}
      常规提示(self.id,"#Y/你的助战战力大幅度提升了!")
      使用成功 = true
    else
      常规提示(self.id,"#Y/该物品与要升级的助战等级不匹配!")
    end
  elseif 名称 == "高级神魂丹" then
    if self.数据[编号].助战等级 == "中级" then
      self.数据[编号].助战等级 = "高级"
      self.数据[编号].修炼 = {攻击修炼=20,法术修炼=20,防御修炼=20,抗法修炼=20}
      self.数据[编号].辅助技能={强身=100,冥想=100}
      常规提示(self.id,"#Y/你的助战战力大幅度提升了!")
      使用成功 = true
    else
      常规提示(self.id,"#Y/该物品与要升级的助战等级不匹配!")
    end
  elseif 名称 == "顶级神魂丹" then
    if self.数据[编号].助战等级 == "高级" then
      self.数据[编号].助战等级 = "顶级"
      self.数据[编号].修炼 = {攻击修炼=25,法术修炼=25,防御修炼=25,抗法修炼=25}
      常规提示(self.id,"#Y/你的助战战力大幅度提升了!")
      self.数据[编号].辅助技能={强身=150,冥想=150}
      使用成功 = true
    else
      常规提示(self.id,"#Y/该物品与要升级的助战等级不匹配!")
    end
  else
    常规提示(self.id,"#Y/该物品暂时无法使用!")
  end
  if 使用成功 then
    if 玩家数据[self.id].道具.数据[道具id].数量==nil  then
      玩家数据[self.id].道具.数据[道具id]=nil
      玩家数据[self.id].角色.数据.道具[道具格子]=nil
    else
      玩家数据[self.id].道具.数据[道具id].数量=玩家数据[self.id].道具.数据[道具id].数量-1
      if 玩家数据[self.id].道具.数据[道具id].数量<=0 then
        玩家数据[self.id].道具.数据[道具id]=nil
        玩家数据[self.id].角色.数据.道具[道具格子]=nil
      end
    end
    道具刷新(self.id)
    发送数据(玩家数据[self.id].连接id,105,玩家数据[self.id].道具:索要道具2(self.id))
    self:刷新信息(编号,1)
    发送数据(玩家数据[self.id].连接id,100,{编号=编号,数据=self:取指定数据(编号)})
  end
end

function 助战系统:取队伍数据(编号)
  local 发送数据={
    模型=self.数据[编号].模型,
    等级=self.数据[编号].等级,
    名称=self.数据[编号].名称,
    门派=self.数据[编号].门派,
    染色组=self.数据[编号].染色组,
    染色方案=self.数据[编号].染色方案,
    当前称谓 = self.数据[编号].当前称谓,
    id=self.id,
    装备={},
    锦衣={},
  }
  if self.数据[编号].装备[3]~=nil then
    发送数据.装备[3]=table.loadstring(table.tostring(玩家数据[self.id].道具.数据[self.数据[编号].装备[3]]))
  end
  return 发送数据
end

function 助战系统:附魔装备刷新(编号,装备id)
  local 临时道具id = 装备id
  for i,v in pairs(玩家数据[self.id].道具.数据[临时道具id].临时附魔) do
    if 玩家数据[self.id].道具.数据[临时道具id].临时附魔[i].数值 >0 and type(玩家数据[self.id].道具.数据[临时道具id].临时附魔[i].时间) == "string" and tonumber(玩家数据[self.id].道具.数据[临时道具id].临时附魔[i].时间) == nil then
        local 月份=分割文本(玩家数据[self.id].道具.数据[临时道具id].临时附魔[i].时间,"/")
        local 日份=分割文本(月份[2]," ")
        local 时分=分割文本(日份[2],":")
        local 时间戳 = os.time({day=日份[1], month=月份[1], year=2020, hour=时分[1], minute=0, second=0}) + 时分[2]*60
        if os.time() - 时间戳 >= 0 then
          if i ~= "愤怒" and i ~= "法术防御" and i ~= "法术伤害" then
            if i == "魔力" then
              self.数据[编号].装备属性["魔法"] = self.数据[编号].装备属性["魔法"] - 玩家数据[self.id].道具.数据[临时道具id].临时附魔[i].数值*5
              self.数据[编号].装备属性["灵力"] = self.数据[编号].装备属性["灵力"] - floor(玩家数据[self.id].道具.数据[临时道具id].临时附魔[i].数值*1.5)
            elseif i == "耐力" then
              self.数据[编号].装备属性["防御"] = self.数据[编号].装备属性["防御"] - floor(玩家数据[self.id].道具.数据[临时道具id].临时附魔[i].数值*2.3)
            elseif i == "体质" then
              self.数据[编号].装备属性["气血"] = self.数据[编号].装备属性["气血"] - 玩家数据[self.id].道具.数据[临时道具id].临时附魔[i].数值*5
            else
              self.数据[编号].装备属性[i] = self.数据[编号].装备属性[i] - 玩家数据[self.id].道具.数据[临时道具id].临时附魔[i].数值
            end
          end
          玩家数据[self.id].道具.数据[临时道具id].临时附魔[i].数值 = 0
          玩家数据[self.id].道具.数据[临时道具id].临时附魔[i].时间 = 0
          道具刷新(self.id)
          self:刷新信息(编号,1)
          常规提示(self.id,"#Y/你的"..玩家数据[self.id].道具.数据[临时道具id].名称.."附魔特效消失了！")
        end
    end
  end
end

function 助战系统:取技能数据(编号)
  local 发送信息={}
  发送信息.技能 = self.数据[编号].技能
  发送信息.特殊技能 = self.数据[编号].特殊技能
  return 发送信息
end


function 助战系统:洗点处理(编号)

  local 银子 = 0
  if 取银子(self.id)<银子 then
      常规提示(self.id,"#Y/你当前的银子好像不够哟!")
      return
  elseif self:检测装备(编号) then
    常规提示(self.id,"#Y/请先卸下该助战身上的装备以及灵饰!")
    return
  else
    玩家数据[self.id].角色:扣除银子(银子,0,0,"助战洗点",1)
    local cs = self:取初始属性(self.数据[编号].种族)
    self.数据[编号].潜力 = self.数据[编号].等级*5
    self.数据[编号].体质 =  cs[1]+self.数据[编号].等级
    self.数据[编号].魔力 =  cs[2]+self.数据[编号].等级
    self.数据[编号].力量 =  cs[3]+self.数据[编号].等级
    self.数据[编号].耐力 =  cs[4]+self.数据[编号].等级
    self.数据[编号].敏捷 =  cs[5]+self.数据[编号].等级
    self.数据[编号].装备属性 = {气血=0,魔法=0,命中=0,伤害=0,防御=0,速度=0,躲避=0,灵力=0,体质=0,魔力=0,力量=0,耐力=0,敏捷=0},
    常规提示(self.id,"#Y/助战帮手洗点成功!")
    发送数据(玩家数据[self.id].连接id,100,{编号=编号,数据=self:取指定数据(编号)})
  end
end




function 助战系统:去除装备(编号,内容)
  local 临时格子=玩家数据[self.id].角色:取道具格子1("道具")
  if 临时格子==0 then
    常规提示(self.id,"您的道具栏物品已经满啦")
    return 0
  end
  local 道具格子 = 内容.物品编号
  local 道具id = 0
  if 内容.灵饰 ~= nil then
    道具id = self.数据[编号].灵饰[道具格子]
  else
    道具id = self.数据[编号].装备[道具格子]
  end
  if 玩家数据[self.id].道具.数据[道具id] == nil or 玩家数据[self.id].道具.数据[道具id].分类 == nil then
    return
  elseif 玩家数据[self.id].道具.数据[道具id]~= nil and 玩家数据[self.id].道具.数据[道具id].灵饰 ~= nil and 玩家数据[self.id].道具.数据[道具id].灵饰 then
    self:卸下灵饰(编号,道具格子,道具id)
    return
  end
  self:卸下装备(编号,玩家数据[self.id].道具.数据[道具id],玩家数据[self.id].道具.数据[道具id].分类)
  玩家数据[self.id].角色.数据.道具[临时格子]=道具id
  self.数据[编号].装备[道具格子]=nil
  道具刷新(self.id)
  发送数据(玩家数据[self.id].连接id,105,玩家数据[self.id].道具:索要道具2(self.id))
  发送数据(玩家数据[self.id].连接id,104,{编号=编号,装备=self:取装备数据(编号)})
  发送数据(玩家数据[self.id].连接id,100,{编号=编号,数据=self:取指定数据(编号)})
  if 玩家数据[self.id].道具.数据[道具id].分类 == 3 then
    self.数据[编号].武器数据={名称="",子类="",等级=0,染色方案=0,染色组={}}
    发送数据(玩家数据[self.id].连接id,106,{编号=编号,数据=self.数据[编号].武器数据})--刷新武器数据
  end
end

function 助战系统:添加装备(编号,内容)
  local 道具格子 = 内容.物品编号
  local 道具id = 玩家数据[self.id].角色.数据.道具[道具格子]
  if 道具id == nil or 道具id == 0 then
    if 道具id == 0 then
      玩家数据[self.id].角色.数据.道具[道具格子] = nil
      玩家数据[self.id].道具.数据[道具id] = nil
    end
    发送数据(玩家数据[self.id].连接id,103,{编号=编号,装备=self:取装备数据(编号),道具=玩家数据[self.id].道具:索要道具2(self.id),技能=self:取技能数据(编号)})
    return
  end
  if 玩家数据[self.id].道具.数据[道具id]~= nil and 玩家数据[self.id].道具.数据[道具id].灵饰 ~= nil and 玩家数据[self.id].道具.数据[道具id].灵饰 then
    self:佩戴灵饰(编号,道具格子,道具id)
    return
  end
  local 装备条件
  if 玩家数据[self.id].道具.数据[道具id] == nil or 玩家数据[self.id].道具.数据[道具id].分类 == nil then
    装备条件 =false
  else
    装备条件=self:可装备(玩家数据[self.id].道具.数据[道具id],玩家数据[self.id].道具.数据[道具id].分类,"主角",编号)
  end
  if 装备条件~=true then
    发送数据(玩家数据[self.id].连接id,7,装备条件)
    return 0
  else
  --检查是否有装备已经佩戴
    if self.数据[编号].装备[玩家数据[self.id].道具.数据[道具id].分类]~=nil then --分类武器是3 腰带是5 鞋子是6 衣服是4 头盔是1 项链是2
      local 道具id1=self.数据[编号].装备[玩家数据[self.id].道具.数据[道具id].分类]
      self:卸下装备(编号,玩家数据[self.id].道具.数据[道具id1],玩家数据[self.id].道具.数据[道具id1].分类)
      self.数据[编号].装备[玩家数据[self.id].道具.数据[道具id].分类]= 道具id
      self:穿戴装备(编号,玩家数据[self.id].道具.数据[道具id],玩家数据[self.id].道具.数据[道具id].分类)
      玩家数据[self.id].角色.数据.道具[道具格子] = 道具id1
    else
      self.数据[编号].装备[玩家数据[self.id].道具.数据[道具id].分类]= 道具id
      self:穿戴装备(编号,玩家数据[self.id].道具.数据[道具id],玩家数据[self.id].道具.数据[道具id].分类)
      玩家数据[self.id].角色.数据.道具[道具格子] = nil
    end
  end
  道具刷新(self.id)
  发送数据(玩家数据[self.id].连接id,105,玩家数据[self.id].道具:索要道具2(self.id))
  发送数据(玩家数据[self.id].连接id,104,{编号=编号,装备=self:取装备数据(编号)})
  发送数据(玩家数据[self.id].连接id,100,{编号=编号,数据=self:取指定数据(编号)})
  if 玩家数据[self.id].道具.数据[道具id].分类 == 3 then
    self.数据[编号].武器数据.子类 = 玩家数据[self.id].道具.数据[道具id].子类
    self.数据[编号].武器数据.名称 = 玩家数据[self.id].道具.数据[道具id].名称
    self.数据[编号].武器数据.等级 = 玩家数据[self.id].道具.数据[道具id].级别限制
    if 玩家数据[self.id].道具.数据[道具id].染色组 ~= nil then
      self.数据[编号].武器数据.染色组 = 玩家数据[self.id].道具.数据[道具id].染色组
      self.数据[编号].武器数据.染色方案 = table.loadstring(table.tostring(玩家数据[self.id].道具.数据[道具id].染色方案))
    end
    发送数据(玩家数据[self.id].连接id,106,{编号=编号,数据=self.数据[编号].武器数据})--刷新武器数据
  end
end

function 助战系统:佩戴灵饰(编号,道具格子,道具id)
  local 物品=取物品数据(玩家数据[self.id].道具.数据[道具id].名称)
  local 级别=物品[5]
  if 级别>self.数据[编号].等级 and 玩家数据[self.id].道具.数据[道具id].特效~="无级别限制" then
    常规提示(self.id,"#Y该助战当前的等级不足以佩戴这样的灵饰")
    return
  end
  if self.数据[编号].灵饰[玩家数据[self.id].道具.数据[道具id].子类]==nil then
    self.数据[编号].灵饰[玩家数据[self.id].道具.数据[道具id].子类]=道具id
    self:灵饰佩戴(编号,玩家数据[self.id].道具.数据[道具id])
    玩家数据[self.id].角色.数据.道具[道具格子]=nil
  else
    local 道具id1=self.数据[编号].灵饰[玩家数据[self.id].道具.数据[道具id].子类]
    self:灵饰卸下(编号,玩家数据[self.id].道具.数据[道具id1])
    self.数据[编号].灵饰[玩家数据[self.id].道具.数据[道具id].子类]=道具id
    self:灵饰佩戴(编号,玩家数据[self.id].道具.数据[道具id])
    玩家数据[self.id].角色.数据.道具[道具格子]=道具id1
  end
  道具刷新(self.id)
  发送数据(玩家数据[self.id].连接id,105,玩家数据[self.id].道具:索要道具2(self.id))
  发送数据(玩家数据[self.id].连接id,107,{编号=编号,灵饰=self:取灵饰数据(编号)})
  发送数据(玩家数据[self.id].连接id,100,{编号=编号,数据=self:取指定数据(编号)})
end

function 助战系统:灵饰佩戴(编号,道具)
  for n=1,#灵饰正常属性 do
    if 道具.幻化属性.基础.类型==灵饰正常属性[n] then
      self.数据[编号].装备属性[灵饰正常属性[n]]=self.数据[编号].装备属性[灵饰正常属性[n]]+道具.幻化属性.基础.数值
    end
    for i=1,#道具.幻化属性.附加 do
      if 道具.幻化属性.附加[i].类型==灵饰正常属性[n] then
        self.数据[编号].装备属性[灵饰正常属性[n]]=self.数据[编号].装备属性[灵饰正常属性[n]]+道具.幻化属性.附加[i].数值+道具.幻化属性.附加[i].强化
      end
    end
  end
  for n=1,#灵饰战斗属性 do
    if 道具.幻化属性.基础.类型==灵饰战斗属性[n] then
      self.数据[编号][灵饰战斗属性[n]]=self.数据[编号][灵饰战斗属性[n]]+道具.幻化属性.基础.数值
    end
    for i=1,#道具.幻化属性.附加 do
      if 道具.幻化属性.附加[i].类型==灵饰战斗属性[n] then
        self.数据[编号][灵饰战斗属性[n]]=self.数据[编号][灵饰战斗属性[n]]+道具.幻化属性.附加[i].数值+道具.幻化属性.附加[i].强化
      end
    end
  end
  self:刷新信息(编号,1)
end

function 助战系统:灵饰卸下(编号,道具)
  if 道具==nil then
      return
  end
  for n=1,#灵饰正常属性 do
    if 道具.幻化属性.基础.类型==灵饰正常属性[n] then
      self.数据[编号].装备属性[灵饰正常属性[n]]=self.数据[编号].装备属性[灵饰正常属性[n]]-道具.幻化属性.基础.数值
    end
    for i=1,#道具.幻化属性.附加 do
      if 道具.幻化属性.附加[i].类型==灵饰正常属性[n] then
        self.数据[编号].装备属性[灵饰正常属性[n]]=self.数据[编号].装备属性[灵饰正常属性[n]]-道具.幻化属性.附加[i].数值-道具.幻化属性.附加[i].强化
      end
    end
  end
  for n=1,#灵饰战斗属性 do
    if 道具.幻化属性.基础.类型==灵饰战斗属性[n] then
      self.数据[编号][灵饰战斗属性[n]]=self.数据[编号][灵饰战斗属性[n]]-道具.幻化属性.基础.数值
    end
    for i=1,#道具.幻化属性.附加 do
      if 道具.幻化属性.附加[i].类型==灵饰战斗属性[n] then
        self.数据[编号][灵饰战斗属性[n]]=self.数据[编号][灵饰战斗属性[n]]-道具.幻化属性.附加[i].数值-道具.幻化属性.附加[i].强化
      end
    end
  end
  self:刷新信息(编号,1)
end

function 助战系统:卸下灵饰(编号,道具格子,道具id)
  local 临时格子=玩家数据[self.id].角色:取道具格子1("道具")
  if 临时格子==0 then
    常规提示(self.id,"您的道具栏物品已经满啦")
    return 0
  end
  self:灵饰卸下(编号,玩家数据[self.id].道具.数据[self.数据[编号].灵饰[道具格子]])
  玩家数据[self.id].角色.数据.道具[临时格子]=self.数据[编号].灵饰[道具格子]
  self.数据[编号].灵饰[道具格子]=nil
  道具刷新(self.id)
  发送数据(玩家数据[self.id].连接id,105,玩家数据[self.id].道具:索要道具2(self.id))
  发送数据(玩家数据[self.id].连接id,107,{编号=编号,灵饰=self:取灵饰数据(编号)})
  发送数据(玩家数据[self.id].连接id,100,{编号=编号,数据=self:取指定数据(编号)})
end

function 助战系统:卸下装备(编号,装备,分类)
  if 装备.符石 ~= nil then
    for i=1,#装备.符石 do
      if 装备.符石[i]~=nil then
        if 装备.符石[i].气血 ~= nil then
            self.数据[编号].装备属性.气血 = self.数据[编号].装备属性.气血 - (装备.符石[i].气血 or 0)
        end
        if 装备.符石[i].魔法 ~= nil then
            self.数据[编号].装备属性.魔法 = self.数据[编号].装备属性.魔法 - (装备.符石[i].魔法 or 0)
        end
        if 装备.符石[i].命中 ~= nil then
            self.数据[编号].装备属性.命中 = self.数据[编号].装备属性.命中 - (装备.符石[i].命中 or 0)
        end
        if 装备.符石[i].伤害 ~= nil then
            self.数据[编号].装备属性.伤害 = self.数据[编号].装备属性.伤害 - (装备.符石[i].伤害 or 0)
        end
        if 装备.符石[i].防御 ~= nil then
            self.数据[编号].装备属性.防御 = self.数据[编号].装备属性.防御 - (装备.符石[i].防御 or 0)
        end
        if 装备.符石[i].速度 ~= nil then
            self.数据[编号].装备属性.速度 = self.数据[编号].装备属性.速度 - (装备.符石[i].速度 or 0)
        end
        if 装备.符石[i].躲避 ~= nil then
            self.数据[编号].装备属性.躲避 = self.数据[编号].装备属性.躲避 - (装备.符石[i].躲避 or 0)
        end
        if 装备.符石[i].灵力 ~= nil then
            self.数据[编号].装备属性.灵力 = self.数据[编号].装备属性.灵力 - (装备.符石[i].灵力 or 0)
        end
        --属性加点
        if 装备.符石[i].体质 ~= nil then
            self.数据[编号].装备属性.气血 = self.数据[编号].装备属性.气血 - (装备.符石[i].体质 or 0)*5
        end
        if 装备.符石[i].魔法 ~= nil then
            self.数据[编号].装备属性.魔法 = self.数据[编号].装备属性.魔法 - (装备.符石[i].魔力 or 0)*5
        end
        if 装备.符石[i].伤害 ~= nil then
            self.数据[编号].装备属性.伤害 = self.数据[编号].装备属性.伤害 - floor(((装备.符石[i].力量 or 0)*3.5))
        end
        if 装备.符石[i].防御 ~= nil then
            self.数据[编号].装备属性.防御 = self.数据[编号].装备属性.防御 - floor(((装备.符石[i].耐力 or 0)*2.3))
        end
        if 装备.符石[i].速度 ~= nil then
            self.数据[编号].装备属性.速度 = self.数据[编号].装备属性.速度 - floor(((装备.符石[i].敏捷 or 0)*2.3))
        end
        if 装备.符石[i].灵力 ~= nil then
            self.数据[编号].装备属性.灵力 = self.数据[编号].装备属性.灵力 - floor(((装备.符石[i].魔力 or 0)*1.5))
        end
      end
        --属性显示
      if 装备.力量 ~= nil then
          self.数据[编号].装备属性.力量 = self.数据[编号].装备属性.力量 - (装备.符石[i].力量 or 0)
      end
      if 装备.体质 ~= nil then
          self.数据[编号].装备属性.体质 = self.数据[编号].装备属性.体质 - (装备.符石[i].体质 or 0)
      end
      if 装备.耐力 ~= nil then
          self.数据[编号].装备属性.耐力 = self.数据[编号].装备属性.耐力 - (装备.符石[i].耐力 or 0)
      end
      if 装备.敏捷 ~= nil then
          self.数据[编号].装备属性.敏捷 = self.数据[编号].装备属性.敏捷 - (装备.符石[i].敏捷 or 0)
      end
      if 装备.魔力 ~= nil then
          self.数据[编号].装备属性.魔力 = self.数据[编号].装备属性.魔力 - (装备.符石[i].魔力 or 0)
      end
    end
    if 装备.符石组合 ~= nil and 装备.符石组合.符石组合 ~= nil then
      if 装备.符石组合.符石组合 == "望穿秋水" then
        self.数据[编号].装备属性.灵力 = self.数据[编号].装备属性.灵力 - 30
      elseif 装备.符石组合.符石组合 == "无懈可击" then
        self.数据[编号].装备属性.防御 = self.数据[编号].装备属性.防御 - 60
      elseif 装备.符石组合.符石组合 == "万里横行" then
        self.数据[编号].装备属性.伤害 = self.数据[编号].装备属性.伤害 - 40
      elseif 装备.符石组合.符石组合 == "日落西山" then
        self.数据[编号].装备属性.速度 = self.数据[编号].装备属性.速度 - 40
      elseif 装备.符石组合.符石组合 == "万丈霞光" then
        if 装备.符石组合.等级 == 1 then
            self.数据[编号].治疗能力 = self.数据[编号].治疗能力 - 50
        elseif 装备.符石组合.等级 == 2 then
            self.数据[编号].治疗能力 = self.数据[编号].治疗能力 - 80
        elseif 装备.符石组合.等级 == 3 then
            self.数据[编号].治疗能力 = self.数据[编号].治疗能力 - 120
        elseif 装备.符石组合.等级 == 4 then
            self.数据[编号].治疗能力 = self.数据[编号].治疗能力 - 200
        end
      elseif 装备.符石组合.符石组合 == "高山流水" then
        if 装备.符石组合.等级 == 1 then
            self.数据[编号].法术伤害 = self.数据[编号].法术伤害 - math.floor(self.数据[编号].等级/3+30)
        elseif 装备.符石组合.等级 == 2 then
            self.数据[编号].法术伤害 = self.数据[编号].法术伤害 - math.floor(self.数据[编号].等级/2+30)
        elseif 装备.符石组合.等级 == 3 then
            self.数据[编号].法术伤害 = self.数据[编号].法术伤害 - math.floor(self.数据[编号].等级+30)
        end
      elseif 装备.符石组合.符石组合 == "百无禁忌" then
        if 装备.符石组合.等级 == 1 then
            self.数据[编号].抵抗封印等级 = self.数据[编号].抵抗封印等级 - math.floor(4*100*self.数据[编号].等级/1000)
        elseif 装备.符石组合.等级 == 2 then
            self.数据[编号].抵抗封印等级 = self.数据[编号].抵抗封印等级 - math.floor(8*100*self.数据[编号].等级/1000)
        elseif 装备.符石组合.等级 == 3 then
            self.数据[编号].抵抗封印等级 = self.数据[编号].抵抗封印等级 - math.floor(12*100*self.数据[编号].等级/1000)
        end
      end
    end
  end
  if 装备.临时附魔 ~= nil then
    for i,v in pairs(装备.临时附魔) do
      if type(装备.临时附魔[i].时间) == "string" and tonumber(装备.临时附魔[i].时间) == nil then
        local 月份=分割文本(装备.临时附魔[i].时间,"/")
        local 日份=分割文本(月份[2]," ")
        local 时分=分割文本(日份[2],":")
        local 时间戳 = os.time({day=日份[1], month=月份[1], year=2020, hour=时分[1], minute=0, second=0}) + 时分[2]*60
        if 装备.临时附魔[i].数值 >0 and os.time() - 时间戳 >= 0 then
            装备.临时附魔[i].数值 = 0
            装备.临时附魔[i].时间 = 0
            道具刷新(self.id)
            常规提示(self.id,"#Y/你的"..装备.名称.."附魔特效消失了！")
        end
      end
    end
    self.数据[编号].装备属性.气血 = self.数据[编号].装备属性.气血 - (装备.临时附魔.体质.数值 or 0)*5
    self.数据[编号].装备属性.魔法 = self.数据[编号].装备属性.魔法 - (装备.临时附魔.魔法.数值 or 0)
    self.数据[编号].装备属性.魔法 = self.数据[编号].装备属性.魔法 - (装备.临时附魔.魔力.数值 or 0)*5
    self.数据[编号].装备属性.伤害 = self.数据[编号].装备属性.伤害 - (装备.临时附魔.伤害.数值 or 0)
    self.数据[编号].装备属性.气血 = self.数据[编号].装备属性.气血 - (装备.临时附魔.气血.数值 or 0)
    self.数据[编号].装备属性.防御 = self.数据[编号].装备属性.防御 - (装备.临时附魔.防御.数值 or 0)
    self.数据[编号].装备属性.速度 = self.数据[编号].装备属性.速度 - (装备.临时附魔.速度.数值 or 0)
    self.数据[编号].装备属性.命中 = self.数据[编号].装备属性.命中 - (装备.临时附魔.命中.数值 or 0)
    self.数据[编号].装备属性.防御 = self.数据[编号].装备属性.防御 - floor(((装备.临时附魔.耐力.数值 or 0)*2.3))
    self.数据[编号].装备属性.灵力 = self.数据[编号].装备属性.灵力 - floor(((装备.临时附魔.魔力.数值 or 0)*1.5))
  end
  self.数据[编号].装备属性.气血 = self.数据[编号].装备属性.气血 - (装备.气血 or 0)
  self.数据[编号].装备属性.魔法 = self.数据[编号].装备属性.魔法 - (装备.魔法 or 0)
  self.数据[编号].装备属性.命中 = self.数据[编号].装备属性.命中 - (装备.命中 or 0)
  self.数据[编号].装备属性.伤害 = self.数据[编号].装备属性.伤害 - (装备.伤害 or 0)
  self.数据[编号].装备属性.防御 = self.数据[编号].装备属性.防御 - (装备.防御 or 0)
  self.数据[编号].装备属性.速度 = self.数据[编号].装备属性.速度 - (装备.速度 or 0)
  self.数据[编号].装备属性.躲避 = self.数据[编号].装备属性.躲避 - (装备.躲避 or 0)
  self.数据[编号].装备属性.灵力 = self.数据[编号].装备属性.灵力 - (装备.灵力 or 0)
  --属性加点
  self.数据[编号].装备属性.气血 = self.数据[编号].装备属性.气血 - (装备.体质 or 0)*5
  self.数据[编号].装备属性.魔法 = self.数据[编号].装备属性.魔法 - (装备.魔力 or 0)*5
  self.数据[编号].装备属性.伤害 = self.数据[编号].装备属性.伤害 - floor(((装备.力量 or 0)*3.5))
  self.数据[编号].装备属性.防御 = self.数据[编号].装备属性.防御 - floor(((装备.耐力 or 0)*2.3))
  self.数据[编号].装备属性.速度 = self.数据[编号].装备属性.速度 - floor(((装备.敏捷 or 0)*2.3))
  self.数据[编号].装备属性.灵力 = self.数据[编号].装备属性.灵力 - floor(((装备.魔力 or 0)*1.5))
  --属性显示
  self.数据[编号].装备属性.力量 = self.数据[编号].装备属性.力量 - (装备.力量 or 0)
  self.数据[编号].装备属性.体质 = self.数据[编号].装备属性.体质 - (装备.体质 or 0)
  self.数据[编号].装备属性.耐力 = self.数据[编号].装备属性.耐力 - (装备.耐力 or 0)
  self.数据[编号].装备属性.敏捷 = self.数据[编号].装备属性.敏捷 - (装备.敏捷 or 0)
  self.数据[编号].装备属性.魔力 = self.数据[编号].装备属性.魔力 - (装备.魔力 or 0)
  if 分类 < 7 then
    if 装备.特技 ~= nil then
      self.数据[编号].特殊技能[分类] = nil
    end
  end
  self:刷新信息(编号,1)
end

function 助战系统:穿戴装备(编号,装备,分类)
  if 装备.符石 ~= nil then
    for i=1,#装备.符石 do
      if 装备.符石[i]~=nil then
        if 装备.符石[i].气血 ~= nil then
            self.数据[编号].装备属性.气血 = self.数据[编号].装备属性.气血 + (装备.符石[i].气血 or 0)
        end
        if 装备.符石[i].魔法 ~= nil then
            self.数据[编号].装备属性.魔法 = self.数据[编号].装备属性.魔法 + (装备.符石[i].魔法 or 0)
        end
        if 装备.符石[i].命中 ~= nil then
            self.数据[编号].装备属性.命中 = self.数据[编号].装备属性.命中 + (装备.符石[i].命中 or 0)
        end
        if 装备.符石[i].伤害 ~= nil then
            self.数据[编号].装备属性.伤害 = self.数据[编号].装备属性.伤害 + (装备.符石[i].伤害 or 0)
        end
        if 装备.符石[i].防御 ~= nil then
            self.数据[编号].装备属性.防御 = self.数据[编号].装备属性.防御 + (装备.符石[i].防御 or 0)
        end
        if 装备.符石[i].速度 ~= nil then
            self.数据[编号].装备属性.速度 = self.数据[编号].装备属性.速度 + (装备.符石[i].速度 or 0)
        end
        if 装备.符石[i].躲避 ~= nil then
            self.数据[编号].装备属性.躲避 = self.数据[编号].装备属性.躲避 + (装备.符石[i].躲避 or 0)
        end
        if 装备.符石[i].灵力 ~= nil then
            self.数据[编号].装备属性.灵力 = self.数据[编号].装备属性.灵力 + (装备.符石[i].灵力 or 0)
        end
        --属性加点
        if 装备.符石[i].体质 ~= nil then
            self.数据[编号].装备属性.气血 = self.数据[编号].装备属性.气血 + (装备.符石[i].体质 or 0)*5
        end
        if 装备.符石[i].魔法 ~= nil then
            self.数据[编号].装备属性.魔法 = self.数据[编号].装备属性.魔法 + (装备.符石[i].魔力 or 0)*5
        end
        if 装备.符石[i].伤害 ~= nil then
            self.数据[编号].装备属性.伤害 = self.数据[编号].装备属性.伤害 + floor(((装备.符石[i].力量 or 0)*3.5))
        end
        if 装备.符石[i].防御 ~= nil then
            self.数据[编号].装备属性.防御 = self.数据[编号].装备属性.防御 + floor(((装备.符石[i].耐力 or 0)*2.3))
        end
        if 装备.符石[i].速度 ~= nil then
            self.数据[编号].装备属性.速度 = self.数据[编号].装备属性.速度 + floor(((装备.符石[i].敏捷 or 0)*2.3))
        end
        if 装备.符石[i].灵力 ~= nil then
            self.数据[编号].装备属性.灵力 = self.数据[编号].装备属性.灵力 + floor(((装备.符石[i].魔力 or 0)*1.5))
        end
      end
        --属性显示
      if 装备.力量 ~= nil then
          self.数据[编号].装备属性.力量 = self.数据[编号].装备属性.力量 + (装备.符石[i].力量 or 0)
      end
      if 装备.体质 ~= nil then
          self.数据[编号].装备属性.体质 = self.数据[编号].装备属性.体质 + (装备.符石[i].体质 or 0)
      end
      if 装备.耐力 ~= nil then
          self.数据[编号].装备属性.耐力 = self.数据[编号].装备属性.耐力 + (装备.符石[i].耐力 or 0)
      end
      if 装备.敏捷 ~= nil then
          self.数据[编号].装备属性.敏捷 = self.数据[编号].装备属性.敏捷 + (装备.符石[i].敏捷 or 0)
      end
      if 装备.魔力 ~= nil then
          self.数据[编号].装备属性.魔力 = self.数据[编号].装备属性.魔力 + (装备.符石[i].魔力 or 0)
      end

      if 装备.力量 ~= nil then
          self.数据[编号].装备属性.力量 = self.数据[编号].装备属性.力量 + (装备.符石[i].力量 or 0)
      end
      if 装备.体质 ~= nil then
          self.数据[编号].装备属性.体质 = self.数据[编号].装备属性.体质 + (装备.符石[i].体质 or 0)
      end
      if 装备.耐力 ~= nil then
          self.数据[编号].装备属性.耐力 = self.数据[编号].装备属性.耐力 + (装备.符石[i].耐力 or 0)
      end
      if 装备.敏捷 ~= nil then
          self.数据[编号].装备属性.敏捷 = self.数据[编号].装备属性.敏捷 + (装备.符石[i].敏捷 or 0)
      end
      if 装备.魔力 ~= nil then
          self.数据[编号].装备属性.魔力 = self.数据[编号].装备属性.魔力 + (装备.符石[i].魔力 or 0)
      end
    end
    if 装备.符石组合 ~= nil and 装备.符石组合.符石组合 ~= nil then
      if 装备.符石组合.符石组合 == "望穿秋水" then
          self.数据[编号].装备属性.灵力 = self.数据[编号].装备属性.灵力 + 30
      elseif 装备.符石组合.符石组合 == "无懈可击" then
          self.数据[编号].装备属性.防御 = self.数据[编号].装备属性.防御 + 60
      elseif 装备.符石组合.符石组合 == "万里横行" then
          self.数据[编号].装备属性.伤害 = self.数据[编号].装备属性.伤害 + 40
      elseif 装备.符石组合.符石组合 == "日落西山" then
          self.数据[编号].装备属性.速度 = self.数据[编号].装备属性.速度 + 40
      elseif 装备.符石组合.符石组合 == "万丈霞光" then
        if 装备.符石组合.等级 == 1 then
            self.数据[编号].治疗能力 = self.数据[编号].治疗能力 + 50
        elseif 装备.符石组合.等级 == 2 then
            self.数据[编号].治疗能力 = self.数据[编号].治疗能力 + 80
        elseif 装备.符石组合.等级 == 3 then
            self.数据[编号].治疗能力 = self.数据[编号].治疗能力 + 120
        elseif 装备.符石组合.等级 == 4 then
            self.数据[编号].治疗能力 = self.数据[编号].治疗能力 + 200
        end
      elseif 装备.符石组合.符石组合 == "高山流水" then
        if 装备.符石组合.等级 == 1 then
            self.数据[编号].法术伤害 = self.数据[编号].法术伤害 + math.floor(self.数据[编号].等级/3+30)
        elseif 装备.符石组合.等级 == 2 then
            self.数据[编号].法术伤害 = self.数据[编号].法术伤害 + math.floor(self.数据[编号].等级/2+30)
        elseif 装备.符石组合.等级 == 3 then
            self.数据[编号].法术伤害 = self.数据[编号].法术伤害 + math.floor(self.数据[编号].等级+30)
        end
      elseif 装备.符石组合.符石组合 == "百无禁忌" then
        if 装备.符石组合.等级 == 1 then
            self.数据[编号].抵抗封印等级 = self.数据[编号].抵抗封印等级 + math.floor(4*100*self.数据[编号].等级/1000)
        elseif 装备.符石组合.等级 == 2 then
            self.数据[编号].抵抗封印等级 = self.数据[编号].抵抗封印等级 + math.floor(8*100*self.数据[编号].等级/1000)
        elseif 装备.符石组合.等级 == 3 then
            self.数据[编号].抵抗封印等级 = self.数据[编号].抵抗封印等级 + math.floor(12*100*self.数据[编号].等级/1000)
        end
      end
    end
  end
  if 装备.临时附魔 ~= nil then
    for i,v in pairs(装备.临时附魔) do
      if type(装备.临时附魔[i].时间) == "string" and tonumber(装备.临时附魔[i].时间) == nil then
        local 月份=分割文本(装备.临时附魔[i].时间,"/")
        local 日份=分割文本(月份[2]," ")
        local 时分=分割文本(日份[2],":")
        local 时间戳 = os.time({day=日份[1], month=月份[1], year=2020, hour=时分[1], minute=0, second=0}) + 时分[2]*60
        if 装备.临时附魔[i].数值 >0 and os.time() - 时间戳 >= 0 then
            装备.临时附魔[i].数值 = 0
            装备.临时附魔[i].时间 = 0
            道具刷新(self.id)
            常规提示(self.id,"#Y/你的"..装备.名称.."附魔特效消失了！")
        end
      end
    end
    self.数据[编号].装备属性.气血 = self.数据[编号].装备属性.气血 + (装备.临时附魔.体质.数值 or 0)*5
    self.数据[编号].装备属性.魔法 = self.数据[编号].装备属性.魔法 + (装备.临时附魔.魔法.数值 or 0)
    self.数据[编号].装备属性.魔法 = self.数据[编号].装备属性.魔法 + (装备.临时附魔.魔力.数值 or 0)*5
    self.数据[编号].装备属性.伤害 = self.数据[编号].装备属性.伤害 + (装备.临时附魔.伤害.数值 or 0)
    self.数据[编号].装备属性.气血 = self.数据[编号].装备属性.气血 + (装备.临时附魔.气血.数值 or 0)
    self.数据[编号].装备属性.防御 = self.数据[编号].装备属性.防御 + (装备.临时附魔.防御.数值 or 0)
    self.数据[编号].装备属性.速度 = self.数据[编号].装备属性.速度 + (装备.临时附魔.速度.数值 or 0)
    self.数据[编号].装备属性.命中 = self.数据[编号].装备属性.命中 + (装备.临时附魔.命中.数值 or 0)
    self.数据[编号].装备属性.防御 = self.数据[编号].装备属性.防御 + floor(((装备.临时附魔.耐力.数值 or 0)*2.3))
    self.数据[编号].装备属性.灵力 = self.数据[编号].装备属性.灵力 + floor(((装备.临时附魔.魔力.数值 or 0)*1.5))
  end
  self.数据[编号].装备属性.气血 = self.数据[编号].装备属性.气血 + (装备.气血 or 0)
  self.数据[编号].装备属性.魔法 = self.数据[编号].装备属性.魔法 + (装备.魔法 or 0)
  self.数据[编号].装备属性.命中 = self.数据[编号].装备属性.命中 + (装备.命中 or 0)
  self.数据[编号].装备属性.伤害 = self.数据[编号].装备属性.伤害 + (装备.伤害 or 0)
  self.数据[编号].装备属性.防御 = self.数据[编号].装备属性.防御 + (装备.防御 or 0)
  self.数据[编号].装备属性.速度 = self.数据[编号].装备属性.速度 + (装备.速度 or 0)
  self.数据[编号].装备属性.躲避 = self.数据[编号].装备属性.躲避 + (装备.躲避 or 0)
  self.数据[编号].装备属性.灵力 = self.数据[编号].装备属性.灵力 + (装备.灵力 or 0)
  --属性加点
  self.数据[编号].装备属性.气血 = self.数据[编号].装备属性.气血 + (装备.体质 or 0)*5
  self.数据[编号].装备属性.魔法 = self.数据[编号].装备属性.魔法 + (装备.魔力 or 0)*5
  self.数据[编号].装备属性.伤害 = self.数据[编号].装备属性.伤害 + floor(((装备.力量 or 0)*3.5))
  self.数据[编号].装备属性.防御 = self.数据[编号].装备属性.防御 + floor(((装备.耐力 or 0)*2.3))
  self.数据[编号].装备属性.速度 = self.数据[编号].装备属性.速度 + floor(((装备.敏捷 or 0)*2.3))
  self.数据[编号].装备属性.灵力 = self.数据[编号].装备属性.灵力 + floor(((装备.魔力 or 0)*1.5))
  --属性显示
  self.数据[编号].装备属性.力量 = self.数据[编号].装备属性.力量 + (装备.力量 or 0)
  self.数据[编号].装备属性.体质 = self.数据[编号].装备属性.体质 + (装备.体质 or 0)
  self.数据[编号].装备属性.耐力 = self.数据[编号].装备属性.耐力 + (装备.耐力 or 0)
  self.数据[编号].装备属性.敏捷 = self.数据[编号].装备属性.敏捷 + (装备.敏捷 or 0)
  self.数据[编号].装备属性.魔力 = self.数据[编号].装备属性.魔力 + (装备.魔力 or 0)
  if 分类 < 7 then
    if 装备.特技 ~= nil then
      self.数据[编号].特殊技能[分类] = jnzb()
      self.数据[编号].特殊技能[分类]:置对象(装备.特技)
    end
  end
  self:刷新信息(编号,1)
end

function 助战系统:可装备(i1,i2,类型,编号)
  if i2 > 6 and 类型 == "主角" then
    return "#Y/该装备与你的种族不符"
  end
  if i1.总类 ~= 2 then
    return "#Y/这个物品不可以装备"
  end
  -- if i1.专用~=nil then
  --  return "#Y/助战无法佩戴专用装备"
  -- end
  if i1.鉴定==false then
      return "#Y/该装备未鉴定，无法佩戴"
  end
  if i1.耐久==nil then
      i1.耐久=500
  end
  if i1.耐久<=0 and i1.耐久~=nil then
      return "#Y/该装备耐久不足，无法穿戴"
  end
  if i1.修理失败~=nil and i1.修理失败==3 and i1.耐久<=0 then
      return "#Y/该装备因修理失败过度，而无法使用！"
  end
  if i1 ~= nil and i1.分类 == i2 then
    if i2 == 1 or i2 == 4 then
      if i1.性别限制 ~= 0 and i1.性别限制 == self.数据[编号].性别 then
          if (i1.级别限制 == 0 or i1.特效 == "无级别限制" or self.数据[编号].等级 >= i1.级别限制) then
            return true
          elseif i1.特效 == "简易" and self.数据[编号].等级+5 >= i1.级别限制 then
            return true
          else
          if self.数据[编号].等级 < i1.级别限制 then
            return "#Y/助战的等级不够呀"
          end
        end
      else
        return "#Y/该装备无法使用"
      end
    elseif i2 == 2 or i2 == 5 or i2 == 6 then
      if (i1.级别限制 == 0 or i1.特效 == "无级别限制" or self.数据[编号].等级 >= i1.级别限制) then
        return true
       elseif i1.特效 == "简易" and self.数据[编号].等级+5 >= i1.级别限制 then
            return true
      else
        if i1.级别限制 > tonumber(self.数据[编号].等级) then
          return "#Y/助战的等级不够呀"
        end
      end
    elseif i2 == 3 then
      if i1.角色限制 ~= 0 and (i1.角色限制[1] == self.数据[编号].模型 or i1.角色限制[2] == self.数据[编号].模型) then
          if (i1.级别限制 == 0 or i1.特效 == "无级别限制" or self.数据[编号].等级 >= i1.级别限制) then
            return true
          elseif i1.特效 == "简易" and self.数据[编号].等级+5 >= i1.级别限制 then
            return true
          else
          if self.数据[编号].等级 < i1.级别限制 then
            return "#Y/助战的等级不够呀"
          end
        end
      else
        return "#Y/该装备无法使用呀"
      end
    end
  end
  return false
end



function 助战系统:遗弃助战(编号)
  if self:检测装备(编号) then
    常规提示(self.id,"#Y/请先卸下该助战身上的装备以及灵饰!")
    return
  elseif self:检测参战() == false then
    常规提示(self.id,"#Y/请将所有的助战取消参战状态后进行遗弃操作!")
    return
  else
    if 玩家数据[self.id].角色.数据.助战 == nil or #玩家数据[self.id].角色.数据.助战 >0 then
      玩家数据[self.id].角色.数据.助战 = {}
    end
    table.remove(self.数据,编号)
    发送数据(玩家数据[self.id].连接id,102,self:取数据())--刷新指定数据
    常规提示(self.id,"#Y/万水千山总是情,离开了我你行不行!")
  end
end

function 助战系统:检测参战()
  for i=1,#self.数据 do
    if self.数据[i].参战 then
      return false
    end
  end
  return true
end

function 助战系统:取装备数据(编号)
  local 返回数据={}
  for n, v in pairs(self.数据[编号].装备) do
    返回数据[n]=table.loadstring(table.tostring(玩家数据[self.id].道具.数据[self.数据[编号].装备[n]]))
  end
  return 返回数据
end
function 助战系统:取灵饰数据(编号)
  local 返回数据={}
  for n, v in pairs(self.数据[编号].灵饰) do
    返回数据[n]=table.loadstring(table.tostring(玩家数据[self.id].道具.数据[self.数据[编号].灵饰[n]]))
  end
  return 返回数据
end

function 助战系统:检测装备(编号)
  for i=1,6 do
    if self.数据[编号].装备[i] ~= nil then
      return true
    end
  end
  for i=1,4 do
    if self.数据[编号].灵饰[i] ~= nil then
      return true
    end
  end
  return false
end

function 助战系统:加点处理(编号,加点内容)
  local 总点数 = 0
  for i,v in pairs(加点内容) do
    总点数 = 总点数 + v
  end
  if 总点数<=0 then
    return
  elseif 总点数 > self.数据[编号].潜力 then
    return
  else
    self.数据[编号].体质 = self.数据[编号].体质 + 加点内容.体质
    self.数据[编号].魔力 = self.数据[编号].魔力 + 加点内容.魔力
    self.数据[编号].力量 = self.数据[编号].力量 + 加点内容.力量
    self.数据[编号].耐力 = self.数据[编号].耐力 + 加点内容.耐力
    self.数据[编号].敏捷 = self.数据[编号].敏捷 + 加点内容.敏捷
    self.数据[编号].潜力 = self.数据[编号].潜力 - 总点数
    self:刷新信息(编号,"1")
  end
end


function 助战系统:添加经验(编号,数额)
  self.数据[编号].当前经验 = self.数据[编号].当前经验 + 数额
  while(self.数据[编号].当前经验>=self.数据[编号].最大经验) do
    if self.数据[编号].等级>=玩家数据[self.id].角色.数据.等级 then
      break
    end
    self:升级(编号)
    发送数据(连接id,27,{文本="#W/你的助战#R/"..self.数据[编号].名称.."#W/等级提升到了#R/"..self.数据[编号].等级.."#W/级",频道="xt"})
  end
end

function 助战系统:升级(编号)
  self.数据[编号].等级 = self.数据[编号].等级 + 1
  self.数据[编号].体质 = self.数据[编号].体质 + 1
  self.数据[编号].魔力 = self.数据[编号].魔力 + 1
  self.数据[编号].力量 = self.数据[编号].力量 + 1
  self.数据[编号].耐力 = self.数据[编号].耐力 + 1
  self.数据[编号].敏捷 = self.数据[编号].敏捷 + 1
  self.数据[编号].潜力 = self.数据[编号].潜力 + 5
  self.数据[编号].当前经验 = self.数据[编号].当前经验 - self.数据[编号].最大经验
  self:刷新信息(编号,"1")
end

function 助战系统:新增助战(id,模型)
  local ls = self:助战信息(模型)
 	local cs = self:取初始属性(ls.种族)
	self.数据[#self.数据+1]={
	    等级 = 0,
	    名称 = ls.模型,
	    性别 = ls.性别,
	    模型 = ls.模型,
	    种族 = ls.种族,
	    编号=#self.数据,
	    称谓 = {
	    "梦幻新秀"
	    },
	    当前称谓="梦幻新秀",
	    门派 = "无门派",
	    体质 = cs[1],
	    魔力 = cs[2],
	    力量 = cs[3],
	    耐力 = cs[4],
	    敏捷 = cs[5],
	    潜力 = 0,
	    愤怒 = 0,
	    当前经验 = 0,
	    最大经验 = 0,
	    装备 = {},
	    灵饰 = {},
	    修炼 = {攻击修炼=0,法术修炼=0,防御修炼=0,抗法修炼=0},
	    技能 = {},
	    特殊技能 = {},
	    染色方案 = ls.染色方案,
	    染色组 = {0,0,0},
      辅助技能={强身=0,冥想=0},
	    装备属性 = {气血=0,魔法=0,命中=0,伤害=0,防御=0,速度=0,躲避=0,灵力=0,体质=0,魔力=0,力量=0,耐力=0,敏捷=0},
	    武器数据={名称="",子类="",等级=0,染色方案=0,染色组={}},
	    参战=false,
      助战等级="初级"
  	}
	for n=1,#灵饰战斗属性 do
	    self.数据[#self.数据][灵饰战斗属性[n]]=0
	end
	self:刷新信息(#self.数据,1)
end

function 助战系统:取属性(种族,五维)
  local 属性={}
  local 力量 = 五维[3]
  local 体质 = 五维[1]
  local 魔力 = 五维[2]
  local 耐力 = 五维[4]
  local 敏捷 = 五维[5]
  if 种族 =="人" or 种族 == 1 then
    属性={
      命中=ceil(力量*2+30),
      伤害=ceil(力量*0.67+39),
      防御=ceil(耐力*1.5),
      速度=ceil(敏捷),
      灵力=ceil(体质*0.3+魔力*0.7+耐力*0.2+力量*0.4),
      躲避=ceil(敏捷+10),
      气血=ceil(体质*5+100),
      法力=ceil(魔力*3+80),
    }
  elseif 种族 =="魔" or 种族 == 2 then
    属性={
      命中=ceil(力量*2.3+29),
      伤害=ceil(力量*0.77+39),
      防御=ceil(耐力*214/153),
      速度=ceil(敏捷),
      灵力=ceil(体质*0.3+魔力*0.7+耐力*0.2+力量*0.4-0.3),
      躲避=ceil(敏捷+10),
      气血=ceil(体质*6+100),
      法力=ceil(魔力*2.5+80),
    }
  elseif 种族 =="仙" or 种族 == 3 then
    属性={
      命中=ceil(力量*1.7+30),
      伤害=ceil(力量*0.57+39),
      防御=ceil(耐力*1.6),
      速度=ceil(敏捷),
      灵力=ceil(体质*0.3+魔力*0.7+耐力*0.2+力量*0.4-0.3),
      躲避=ceil(敏捷+10),
      气血=ceil(体质*4.5+100),
      法力=ceil(魔力*3.5+80),
    }
  end
  return 属性
end

function 助战系统:刷新信息(编号,是否)
  local 五维属性 = self:取属性(self.数据[编号].种族,{self.数据[编号].体质,self.数据[编号].魔力,self.数据[编号].力量,self.数据[编号].耐力,self.数据[编号].敏捷})
  self.数据[编号].命中=math.floor(五维属性["命中"] + self.数据[编号].装备属性.命中)
  self.数据[编号].伤害=math.floor(五维属性["伤害"] + self.数据[编号].装备属性.伤害 + self.数据[编号].装备属性.命中/3)
  self.数据[编号].防御=math.floor(五维属性["防御"] + self.数据[编号].装备属性.防御)
  self.数据[编号].速度=math.floor(五维属性["速度"] + self.数据[编号].装备属性.速度)
  self.数据[编号].灵力=math.floor(五维属性["灵力"] + self.数据[编号].装备属性.灵力)
  self.数据[编号].躲避=math.floor(五维属性["躲避"] + self.数据[编号].装备属性.躲避)
  self.数据[编号].最大气血 = 五维属性["气血"]  + self.数据[编号].装备属性.气血
  self.数据[编号].最大魔法 = 五维属性["法力"]  + self.数据[编号].装备属性.魔法
  self.数据[编号].最大气血=math.floor(self.数据[编号].最大气血*(1+self.数据[编号].辅助技能.强身*0.01))
  self.数据[编号].最大魔法=math.floor(self.数据[编号].最大魔法*(1+self.数据[编号].辅助技能.冥想*0.01))
  if 是否 ~= nil then
    self.数据[编号].气血 = self.数据[编号].最大气血
    self.数据[编号].魔法 = self.数据[编号].最大魔法
  end
  if self.数据[编号].气血 > self.数据[编号].最大气血 then
    self.数据[编号].气血 = self.数据[编号].最大气血
  end
  if self.数据[编号].魔法 > self.数据[编号].最大魔法 then
    self.数据[编号].魔法 = self.数据[编号].最大魔法
  end
  if self.数据[编号].愤怒 > 150 then
    self.数据[编号].愤怒 = 150
  end
  if self.数据[编号].等级 <= 174 then
    self.数据[编号].最大经验 = self:取经验(1,self.数据[编号].等级)
  end
end

function 助战系统:取经验(id,lv)
  local exp={}
  if id==1 then
    exp={
      40,110,237,450,779,1252,1898,2745,3822,5159,6784,8726,11013,13674,16739,20236,24194,28641,33606,39119,45208,
      51902,55229,67218,75899,85300,95450,106377,118110,130679,144112,158438,173685,189882,207059,225244,244466,264753,
      286134,308639,332296,357134,383181,410466,439019,468868,500042,532569,566478,601799,638560,676790,716517,757770,
      800579,844972,890978,938625,987942,1038959,1091704,1146206,1202493,1260594,1320539,1382356,1446074,1511721,1579326,
      1648919,1720528,1794182,1869909,1947738,2027699,2109820,2194130,2280657,2369431,2460479,2553832,2649518,2747565,
      2848003,2950859,3056164,3163946,3274233,3387055,3502439,3620416,3741014,3864261,3990187,4118819,4250188,4384322,
      4521249,4660999,4803599,4998571,5199419,5406260,5619213,5838397,6063933,6295941,6534544,6779867,7032035,7291172,
      7557407,7830869,8111686,8399990,8695912,8999586,9311145,9630726,9958463,10294496,10638964,10992005,11353761,11724374,
      12103988,12492748,12890799,13298287,13715362,14142172,14578867,15025600,15482522,15949788,16427552,16915970,17415202,
      17925402,18446732,18979354,19523428,20079116,20646584,21225998,43635044,44842648,46075148,47332886,48616200,74888148,
      76891401,78934581,81018219,83142835,85308969,87977421,89767944,92061870,146148764,150094780,154147340,158309318,
      162583669,166973428,171481711,176111717,180866734,185780135,240602904,533679362,819407100,1118169947, 1430306664,
      1756161225,2096082853
    }
  else
    exp={
      50,200,450,800,1250,1800,2450,3250,4050,5000,6050,7200,8450,9800,11250,12800,14450,16200,18050,20000,22050,24200,
      26450,28800,31250,33800,36450,39200,42050,45000,48050,51200,54450,57800,61250,64800,68450,72200,76050,80000,84050,
      88200,92450,96800,101250,105800,110450,115200,120050,125000,130050,135200,140450,145800,151250,156800,162450,
      168200,174050,180000,186050,192200,198450,204800,211250,217800,224450,231200,238050,245000,252050,259200,266450,
      273800,281250,288800,296450,304200,312050,320000,328050,336200,344450,352800,361250,369800,378450,387200,396050,
      405000,414050,423200,432450,441800,451250,460800,470450,480200,490050,500000,510050,520200,530450,540800,551250,
      561800,572450,583200,594050,605000,616050,627200,638450,649800,661250,672800,684450,696200,708050,720000,732050,
      744200,756450,768800,781250,793800,806450,819200,832050,845000,858050,871200,884450,897800,911250,924800,938450,
      952200,966050,980000,994050,1008200,1022450,1036800,1051250,1065800,1080450,1095200,1110050,1125000,1140050,1155200,
      1170450,1185800,1201250,1216800,1232450,1248200,1264050,1280000,1300000,1340000,1380000,1420000,1460000,1500000,1540000,
      1580000,1700000,1780000,1820000,1940000,2400000,2880000,3220000,4020000,4220000,4420000,4620000,5220000,5820000,6220000,
      7020000,8020000,9020000
    }
  end
  return exp[lv+1]
end


function 助战系统:取初始属性(种族)
  local 属性 = {
    人 = {10,10,10,10,10},
    魔 = {12,11,11,8,8},
    仙 = {12,5,11,12,10},
  }
  return 属性[种族]
end

function 助战系统:助战信息(模型)
  local 角色信息 = {
    飞燕女 = {模型="飞燕女",ID=1,染色方案=3,性别="女",种族="人",武器={"双短剑","环圈"}},
    英女侠 = {模型="英女侠",ID=2,染色方案=4,性别="女",种族="人",武器={"双短剑","鞭"}},
    巫蛮儿 = {模型="巫蛮儿",ID=3,染色方案=1,性别="女",种族="人",武器={"宝珠","法杖"}},
    逍遥生 = {模型="逍遥生",ID=4,染色方案=1,性别="男",种族="人",武器={"扇","剑"}},
    剑侠客 = {模型="剑侠客",ID=5,染色方案=2,性别="男",种族="人",武器={"刀","剑"}},
    狐美人 = {模型="狐美人",ID=6,染色方案=7,性别="女",种族="魔",武器={"爪刺","鞭"}},
    骨精灵 = {模型="骨精灵",ID=7,染色方案=8,性别="女",种族="魔",武器={"魔棒","爪刺"}},
    杀破狼 = {模型="杀破狼",ID=8,染色方案=1,性别="男",种族="魔",武器={"宝珠","弓弩"}},
    巨魔王 = {模型="巨魔王",ID=9,染色方案=5,性别="男",种族="魔",武器={"刀","斧钺"}},
    虎头怪 = {模型="虎头怪",ID=10,染色方案=6,性别="男",种族="魔",武器={"斧钺","锤子"}},
    舞天姬 = {模型="舞天姬",ID=11,染色方案=11,性别="女",种族="仙",武器={"飘带","环圈"}},
    玄彩娥 = {模型="玄彩娥",ID=12,染色方案=12,性别="女",种族="仙",武器={"飘带","魔棒"}},
    羽灵神 = {模型="羽灵神",ID=13,染色方案=1,性别="男",种族="仙",武器={"法杖","弓弩"}},
    神天兵 = {模型="神天兵",ID=14,染色方案=9,性别="男",种族="仙",武器={"锤","枪矛"}},
    龙太子 = {模型="龙太子",ID=15,染色方案=10,性别="男",种族="仙",武器={"扇","枪矛"}},
    桃夭夭 = {模型="桃夭夭",ID=16,染色方案=1,性别="女",种族="仙",武器={"灯笼"}},
    偃无师 = {模型="偃无师",ID=17,染色方案=1,性别="男",种族="人",武器={"剑","巨剑"}},
    鬼潇潇 = {模型="鬼潇潇",ID=18,染色方案=2,性别="女",种族="魔",武器={"爪刺","伞"}},
  }
  return 角色信息[模型]
end

function 助战系统:取数据()
  return self.数据
end
function 助战系统:取指定数据(编号)
  return self.数据[编号]
end

function 助战系统:取总数据(编号)
  local 存档数据={}
  if self.数据[编号].气血 > self.数据[编号].最大气血 then
    self.数据[编号].气血 = self.数据[编号].最大气血
  end
  for i,v in pairs(self.数据[编号]) do
    存档数据[i] = self.数据[编号][i]
  end
  存档数据.装备=self:取装备数据(编号)
  存档数据.灵饰={}
  存档数据.锦衣={}
  return 存档数据
end

function 助战系统:更新(dt)
end
function 助战系统:显示()
end
return 助战系统
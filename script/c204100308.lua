Toolbox=require "lib.toolbox"
id,ref=Toolbox.gir()
ref.code=id
--created & coded by Lyris
--SBアンジェリカ
function ref.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,id)
	e1:SetCondition(ref.spcon)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_HAND+LOCATION_MZONE)
	e2:SetCategory(CATEGORY_DRAW)
	e2:SetCost(ref.cost)
	e2:SetTarget(ref.target)
	e2:SetOperation(ref.operation)
	c:RegisterEffect(e2)
	if not ref.global_check then
		ref.global_check=true
		local ge2=Effect.CreateEffect(c)
		ge2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge2:SetCode(EVENT_ADJUST)
		ge2:SetCountLimit(1)
		ge2:SetProperty(EFFECT_FLAG_NO_TURN_RESET)
		ge2:SetLabel(240)
		ge2:SetOperation(ref.chk)
		Duel.RegisterEffect(ge2,0)
	end
end
function ref.chk(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetFlagEffect(0,e:GetLabel())==0 then 
		Duel.CreateToken(tp,e:GetLabel())
		Duel.CreateToken(1-tp,e:GetLabel())
		Duel.RegisterFlagEffect(0,e:GetLabel(),0,0,0)
	end
end
function ref.bfilter(c)
	return c:IsFaceup() and c:IsCode(204100305)
end
function ref.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(ref.bfilter,tp,LOCATION_MZONE,0,1,nil)
end
function ref.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsAbleToRemoveAsCost() end
	Duel.Remove(c,POS_FACEUP,REASON_COST)
end
function ref.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local bee=Duel.IsExistingMatchingCard(ref.bfilter,tp,LOCATION_MZONE,0,1,nil)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) and (bee or Duel.IsPlayerCanDraw(1-tp,1)) end
	if bee then
		Duel.SetTargetPlayer(tp)
		Duel.SetTargetParam(1)
		Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
	else Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,PLAYER_ALL,1) end
end
function ref.operation(e,tp,eg,ep,ev,re,r,rp)
	if Duel.IsExistingMatchingCard(ref.bfilter,tp,LOCATION_MZONE,0,1,nil) then
		local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
		Duel.Draw(p,d,REASON_EFFECT)
		return
	end
	Duel.Draw(tp,1,REASON_EFFECT)
	Duel.Draw(1-tp,1,REASON_EFFECT)
end

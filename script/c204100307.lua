Toolbox=require "lib.toolbox"
id,ref=Toolbox.gir()
ref.code=id
--created & coded by Lyris
--SBエド
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
	e2:SetRange(LOCATION_MZONE)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetCountLimit(1,id+100000)
	e2:SetCondition(ref.condition)
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
function ref.cfilter(c)
	return c:IsFacedown() or not ref.bfilter(c)
end
function ref.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)==1 or not Duel.IsExistingMatchingCard(ref.cfilter,tp,LOCATION_MZONE,0,1,e:GetHandler())
end
function ref.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsAbleToRemoveAsCost() end
	Duel.Remove(c,POS_FACEUP,REASON_COST)
end
function ref.filter(c,e,tp,n)
	return c:IsLevelBelow(4) and (n~=nil or c:IsRace(RACE_PLANT) and c:IsSetCard(0x5e5)) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function ref.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local bee=Duel.IsExistingMatchingCard(ref.bfilter,tp,LOCATION_MZONE,0,1,nil)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(ref.filter,tp,LOCATION_DECK,0,1,nil,e,tp)
		and (bee or Duel.GetLocationCount(1-tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(ref.filter,tp,0,LOCATION_DECK,1,nil,e,tp,0))
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
	if not bee then
		Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,1-tp,LOCATION_DECK)
	end
end
function ref.operation(e,tp,eg,ep,ev,re,r,rp)
	local bee=Duel.IsExistingMatchingCard(ref.bfilter,tp,LOCATION_MZONE,0,1,nil)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 and not bee and Duel.GetLocationCount(1-tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g1=Duel.SelectMatchingCard(tp,ref.filter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
	if g1:GetCount()>0 then
		Duel.SpecialSummon(g1,0,tp,tp,false,false,POS_FACEUP)
	end
	if bee then return end
	Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_SPSUMMON)
	local g2=Duel.SelectMatchingCard(1-tp,ref.filter,tp,0,LOCATION_DECK,1,1,nil,e,1-tp,0)
	if g2:GetCount()>0 then
		Duel.SpecialSummon(g2,0,1-tp,1-tp,false,false,POS_FACEUP)
	end
end

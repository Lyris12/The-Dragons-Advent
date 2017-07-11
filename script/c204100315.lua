Toolbox=require "lib.toolbox"
id,ref=Toolbox.gir()
ref.code=id
--created & coded by Lyris
--SBピース・ドラゴン
function ref.initial_effect(c)
	c:EnableReviveLimit()
	local ge2=Effect.CreateEffect(c)
	ge2:SetDescription(aux.Stringid(531,0))
	ge2:SetType(EFFECT_TYPE_FIELD)
	ge2:SetCode(EFFECT_SPSUMMON_PROC)
	ge2:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_IGNORE_IMMUNE)
	ge2:SetRange(LOCATION_EXTRA)
	ge2:SetCondition(ref.altcon)
	ge2:SetOperation(ref.altop)
	ge2:SetReset(RESET_EVENT+EVENT_ADJUST,1)
	ge2:SetValue(0x15)
	c:RegisterEffect(ge2)
	local ae1=Effect.CreateEffect(c)
	ae1:SetType(EFFECT_TYPE_SINGLE)
	ae1:SetCode(EFFECT_ADD_CODE)
	ae1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	ae1:SetRange(LOCATION_MZONE)
	ae1:SetValue(204100305)
	c:RegisterEffect(ae1)
	local ae2=Effect.CreateEffect(c)
	ae2:SetType(EFFECT_TYPE_FIELD)
	ae2:SetRange(LOCATION_MZONE)
	ae2:SetTargetRange(0,LOCATION_MZONE)
	ae2:SetCode(EFFECT_CANNOT_SELECT_BATTLE_TARGET)
	ae2:SetValue(ref.atlimit)
	c:RegisterEffect(ae2)
	local ae3=Effect.CreateEffect(c)
	ae3:SetType(EFFECT_TYPE_FIELD)
	ae3:SetCode(EFFECT_IMMUNE_EFFECT)
	ae3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	ae3:SetRange(LOCATION_MZONE)
	ae3:SetTargetRange(LOCATION_REMOVED,0)
	ae3:SetTarget(function(e,c) return c:IsFaceup() and c:IsType(TYPE_MONSTER) and c:IsSetCard(0x5e5) end)
	ae3:SetValue(ref.efilter)
	c:RegisterEffect(ae3)
	local ae4=Effect.CreateEffect(c)
	ae4:SetType(EFFECT_TYPE_IGNITION)
	ae4:SetRange(LOCATION_MZONE)
	ae4:SetCountLimit(1)
	ae4:SetProperty(EFFECT_FLAG_CARD_TARGET)
	ae4:SetCategory(CATEGORY_SPECIAL_SUMMON)
	ae4:SetCost(ref.cost)
	ae4:SetTarget(ref.target)
	ae4:SetOperation(ref.operation)
	c:RegisterEffect(ae4)
	if not ref.global_check then
		ref.global_check=true
		local ge0=Effect.CreateEffect(c)
		ge0:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge0:SetCode(EVENT_ADJUST)
		ge0:SetCountLimit(1)
		ge0:SetLabel(531)
		ge0:SetProperty(EFFECT_FLAG_NO_TURN_RESET)
		ge0:SetOperation(ref.chk)
		Duel.RegisterEffect(ge0,0)
		local ge1=ge0:Clone()
		ge1:SetLabel(240)
		Duel.RegisterEffect(ge1,0)
	end
end
ref.harmony=true
ref.harmony_custom_proc=true
function ref.material(mc)
	return mc:IsFaceup() and (mc:IsCode(204100302) or (mc:IsSetCard(0x5e5) and mc:IsType(TYPE_MONSTER)))
end
function ref.alterf(mc)
	return ref.material(mc)
end
function ref.alfilter(c,x,g)
	return ref.alterf(c) and g:IsExists(ref.altfilter,1,nil,x,c)
end
function ref.altfilter(c,x,tc)
	return c:IsFaceup() and c:GetFlagEffect(10004000)>0 and c:GetFlagEffectLabel(10004000)>=x
		and ((tc:IsSetCard(0x5e5) and tc:IsType(TYPE_MONSTER) and c:IsCode(204100302))
		or (c:IsSetCard(0x5e5) and c:IsType(TYPE_MONSTER) and tc:IsCode(204100302))) and c:IsAbleToDeck()
end
function ref.chk(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetFlagEffect(0,e:GetLabel())==0 then 
		Duel.CreateToken(tp,e:GetLabel())
		Duel.CreateToken(1-tp,e:GetLabel())
		Duel.RegisterFlagEffect(0,e:GetLabel(),0,0,0)
	end
end
function ref.altcon(e,c)
	if c==nil then return true end
	if c:IsType(TYPE_PENDULUM) and c:IsFaceup() then return false end
	local tp=c:GetControler()
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return false end
	local mg=Duel.GetMatchingGroup(ref.matfilter,tp,LOCATION_REMOVED,0,nil,c:GetLevel(),c.material)
	e:SetLabelObject(mg)
	return mg:IsExists(ref.alfilter,1,nil,c:GetLevel(),mg)
end
function ref.alterfilter(c,x,alterf)
	return c:IsFaceup() and c:GetFlagEffect(10004000)>0 and c:GetFlagEffectLabel(10004000)>=x and alterf(c) and c:IsAbleToDeck()
end
function ref.altop(e,tp,eg,ep,ev,re,r,rp,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local mg=Duel.SelectMatchingCard(tp,ref.alterfilter,tp,LOCATION_REMOVED,0,1,1,nil,c:GetLevel(),c.alterf)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local sg=Duel.SelectMatchingCard(tp,ref.altfilter,tp,LOCATION_REMOVED,0,1,1,nil,c:GetLevel(),mg:GetFirst())
	mg:Merge(sg)
	c:SetMaterial(mg)
	Duel.SendtoDeck(mg,nil,2,REASON_MATERIAL+0x40000000)
end
function ref.atlimit(e,c)
	return c:IsFaceup() and c:IsCode(204100305)
end
function ref.efilter(e,te)
	return te:GetOwner()~=e:GetOwner()
end
function ref.cfilter(c)
	return c:IsFaceup() and c:IsCode(204100305) and c:IsAbleToRemoveAsCost()
end
function ref.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(ref.cfilter,tp,LOCATION_GRAVE,0,1,nil) end
	local g=Duel.SelectMatchingCard(tp,ref.cfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function ref.filter(c,e,tp)
	return c:IsRace(RACE_PLANT) and c:IsSetCard(0x5e5) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function ref.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and ref.filter(chkc,e,tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(ref.filter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,ref.filter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function ref.operation(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
	end
end

Toolbox=require "lib.toolbox"
id,ref=Toolbox.gir()
ref.code=id
--created & coded by Lyris
--SBオーキッド
function ref.initial_effect(c)
	c:EnableReviveLimit()
	local ae1=Effect.CreateEffect(c)
	ae1:SetCategory(CATEGORY_DESTROY)
	ae1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	ae1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	ae1:SetCode(EVENT_SPSUMMON_SUCCESS)
	ae1:SetCondition(ref.descon)
	ae1:SetTarget(ref.destg)
	ae1:SetOperation(ref.desop)
	c:RegisterEffect(ae1)
	if not ref.global_check then
		ref.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_ADJUST)
		ge1:SetCountLimit(1)
		ge1:SetLabel(531)
		ge1:SetProperty(EFFECT_FLAG_NO_TURN_RESET)
		ge1:SetOperation(ref.chk)
		Duel.RegisterEffect(ge1,0)
		local ge0=ge1:Clone()
		ge0:SetLabel(240)
		Duel.RegisterEffect(ge0,0)
	end
end
ref.harmony=true
function ref.material(mc)
	return mc:IsFaceup() and ref.alterf(mc)
end
function ref.alterf(mc)
	return mc:IsRace(RACE_PLANT) and mc:IsSetCard(0x5e5)
end
ref.altero=true
function ref.alterop(e,tp,chk)
	local rc=e:GetLabelObject()
	if chk==0 then return rc:IsExists(ref.alterf,2,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local mc=Duel.SelectMatchingCard(tp,ref.altfilter,tp,LOCATION_REMOVED,0,2,65,rc:GetFirst(),e:GetHandler():GetLevel())
	e:SetLabelObject(mc)
end
function ref.altfilter(c,x)
	return ref.alterf(c) and c:GetFlagEffect(10004000)>0 and c:GetFlagEffectLabel(10004000)>=x and c:IsAbleToDeck()
end
function ref.chk(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetFlagEffect(0,e:GetLabel())==0 then 
		Duel.CreateToken(tp,e:GetLabel())
		Duel.CreateToken(1-tp,e:GetLabel())
		Duel.RegisterFlagEffect(0,e:GetLabel(),0,0,0)
	end
end
function ref.descon(e,tp,eg,ep,ev,re,r,rp)
	return bit.band(e:GetHandler():GetSummonType(),0x15)==0x15
end
function ref.desfilter(c)
	return c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsDestructable()
end
function ref.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and ref.desfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(ref.desfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
	local ct=e:GetHandler():GetMaterialCount()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp, ref.desfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,ct,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
end
function ref.bfilter(c)
	return c:IsFaceup() and c:IsCode(204100305)
end
function ref.dfilter(c)
	return c:IsType(TYPE_SPELL+TYPE_TRAP)
end
function ref.desop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	local ct=Duel.Destroy(g,REASON_EFFECT)
	if not Duel.IsExistingMatchingCard(ref.bfilter,tp,LOCATION_MZONE,0,1,nil) then
		local dg=Duel.SelectMatchingCard(1-tp,ref.dfilter,tp,LOCATION_ONFIELD,0,1,ct,nil)
		Duel.HintSelection(dg)
		local dt=Duel.Destroy(dg,REASON_RULE)
	end
	local dc=Duel.GetOperatedGroup():GetCount()
	if dt then dc=dc+dt end
	local c=e:GetHandler()
	if c:IsFaceup() and c:IsRelateToEffect(e) then
		Duel.BreakEffect()
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(dc*200)
		e1:SetReset(RESET_EVENT+0x1ff0000)
		c:RegisterEffect(e1)
	end
end

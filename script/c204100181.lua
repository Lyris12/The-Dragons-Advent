Toolbox=require "lib.toolbox"
id,ref=Toolbox.gir()
ref.code=id
--created & coded by Lyris
--五溶輪の聖火守護竜ホーリー・トーチ・ドラゴン
function ref.initial_effect(c)
	c:EnableReviveLimit()
	c:SetUniqueOnField(1,0,id)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(ref.spcon)
	e1:SetOperation(ref.spop)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetTarget(ref.atktg)
	e2:SetValue(ref.atkval)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_PHASE+PHASE_BATTLE_START)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1)
	e3:SetCondition(function(e,tp) return Duel.GetTurnPlayer()==tp end)
	e3:SetCost(ref.cost)
	e3:SetOperation(ref.operation)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_BATTLE_START)
	e4:SetCategory(CATEGORY_DISABLE)
	e4:SetTarget(ref.distg)
	e4:SetOperation(ref.disop)
	c:RegisterEffect(e4)
	if not ref.global_check then
		ref.global_check=true
		local ge2=Effect.CreateEffect(c)
		ge2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge2:SetCode(EVENT_ADJUST)
		ge2:SetCountLimit(1)
		ge2:SetLabel(481)
		ge2:SetProperty(EFFECT_FLAG_NO_TURN_RESET)
		ge2:SetOperation(ref.chk)
		Duel.RegisterEffect(ge2,0)
		local gec=Effect.CreateEffect(c)
		gec:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		gec:SetCode(EVENT_ADJUST)
		gec:SetProperty(EFFECT_FLAG_NO_TURN_RESET)
		gec:SetLabel(240)
		gec:SetOperation(ref.chk)
		Duel.RegisterEffect(gec,0)
	end
end
ref.relay=true
ref.point=3
function ref.chk(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetFlagEffect(0,e:GetLabel())==0 then 
		Duel.CreateToken(tp,e:GetLabel())
		Duel.CreateToken(1-tp,e:GetLabel())
		Duel.RegisterFlagEffect(0,e:GetLabel(),0,0,0)
	end
end
function ref.cfilter1(c)
	return c:IsFaceup() and c:IsAbleToDeckAsCost()
end
function ref.cfilter2(c)
	return c:IsSetCard(0xb21) and c.relay
end
function ref.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local g=Duel.GetMatchingGroup(ref.cfilter1,tp,LOCATION_MZONE,0,1,nil)
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and g:IsExists(Card.IsCode,1,nil,id)
		and g:IsExists(ref.cfilter2,1,nil)
end
function ref.spop(e,tp,eg,ep,ev,re,r,rp,c)
	local g=Duel.GetMatchingGroup(ref.cfilter1,tp,LOCATION_MZONE,0,1,nil)
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(id,0))
	local g1=g:FilterSelect(tp,Card.IsCode,1,1,nil,id)
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(id,1))
	local g2=g:FilterSelect(tp,ref.cfilter2,1,1,nil)
	g1:Merge(g2)
	Duel.SendtoDeck(g1,nil,2,REASON_COST)
end
function ref.atktg(e,c)
	return c:IsSetCard(0xb21) and c~=e:GetHandler()
end
function ref.atkfilter(c)
	return c:IsFaceup() and c:IsSetCard(0xb21)
end
function ref.atkval(e,c)
	return Duel.GetMatchingGroupCount(ref.atkfilter,c:GetControler(),LOCATION_MZONE,0,nil)*200
end
function ref.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local x=1
	local point=c:GetFlagEffectLabel(10001100)
	if chk==0 then return point and point>=x end
	if point==x then
		c:ResetFlagEffect(10001100)
	else
		c:SetFlagEffectLabel(10001100,point-x)
	end
end
function ref.operation(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_CANNOT_ACTIVATE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(0,1)
	e1:SetValue(ref.aclimit)
	e1:SetCondition(ref.actcon)
	Duel.RegisterEffect(e1,tp)
end
function ref.aclimit(e,re,tp)
	return not re:GetHandler():IsImmuneToEffect(e)
end
function ref.actcon(e)
	local bc=Duel.GetAttacker()
	return bc:IsAttribute(ATTRIBUTE_FIRE) and bc.relay
end
function ref.distg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	local bc=c:GetBattleTarget()
	local x=1
	local point=c:GetLeftScale()
	if chkc then return false end
	if chk==0 then return bc~=nil and not bc:IsDisabled() and (bc:IsCanBeEffectTarget(e) or point>=x) end
	if bc:IsCanBeEffectTarget(e) and (point<x or not Duel.SelectYesNo(tp,aux.Stringid(id,2))) then
		e:SetProperty(EFFECT_FLAG_CARD_TARGET)
	else
		e:SetProperty(0)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_LSCALE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetValue(-x)
		c:RegisterEffect(e1,true)
	end
	Duel.SetTargetCard(bc)
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,bc,1,0,0)
end
function ref.disop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToBattle() and not tc:IsDisabled() then
		Duel.NegateRelatedChain(tc,RESET_TURN_SET)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_DISABLE_EFFECT)
		e2:SetValue(RESET_TURN_SET)
		e2:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e2)
	end
end

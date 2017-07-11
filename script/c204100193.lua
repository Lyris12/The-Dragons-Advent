Toolbox=require "lib.toolbox"
id,ref=Toolbox.gir()
ref.code=id
--created by LionHeartKIng, coded by Lyris
--五溶輪者フロア・ジムナティックス
function ref.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetRange(LOCATION_MZONE)
	e1:SetValue(ref.atkval)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e2:SetCondition(ref.indcon)
	e2:SetValue(1)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_ATTACK_ANNOUNCE)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetCountLimit(1,id)
	e3:SetCost(ref.cost)
	e3:SetTarget(ref.atktg)
	e3:SetOperation(ref.atkop)
	c:RegisterEffect(e3)
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
function ref.filter(c)
	return c:IsFaceup() and c:IsSetCard(0xb21)
end
function ref.atkval(e,c)
	return Duel.GetMatchingGroupCount(ref.filter,e:GetHandlerPlayer(),LOCATION_MZONE,0,nil)*200
end
function ref.indfilter(c)
	return c:IsFaceup() and c.relay and c:IsSetCard(0xb21)
end
function ref.indcon(e)
	return Duel.IsExistingMatchingCard(ref.indfilter,e:GetHandlerPlayer(),LOCATION_MZONE,0,1,e:GetHandler())
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
function ref.atkfilter(c)
	return c:IsFaceup() and c:IsSetCard(0xb21) and c:IsAttackable() and c:GetAttackAnnouncedCount()==0
end
function ref.atktg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and ref.atkfilter(chkc) and chkc~=c end
	if chk==0 then return Duel.IsExistingTarget(ref.atkfilter,tp,LOCATION_MZONE,0,1,c) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,ref.atkfilter,tp,LOCATION_MZONE,0,1,1,c)
end
function ref.atkop(e,tp,eg,ep,ev,re,r,rp)
	local c=Duel.GetFirstTarget()
	if c:IsRelateToEffect(e) and c:IsFaceup() then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_EXTRA_ATTACK)
		e1:SetValue(1)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		c:RegisterEffect(e1)
		local e2=Effect.CreateEffect(e:GetHandler())
		e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e2:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
		e2:SetCode(EVENT_PHASE+PHASE_BATTLE)
		e2:SetRange(LOCATION_MZONE)
		e2:SetOperation(ref.tdop)
		e2:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_BATTLE)
		e2:SetCountLimit(1)
		c:RegisterEffect(e2)
	end
end
function ref.tdop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_CARD,0,id)
	Duel.SendtoDeck(c,nil,2,REASON_EFFECT)
end

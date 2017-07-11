Toolbox=require "lib.toolbox"
id,ref=Toolbox.gir()
ref.code=id
--created & coded by Lyris
--五溶輪者ハードル・ホッパー
function ref.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetRange(LOCATION_MZONE)
	e1:SetValue(ref.atkval)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_BATTLE_START)
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
ref.point=1
function ref.chk(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetFlagEffect(0,e:GetLabel())==0 then 
		Duel.CreateToken(tp,e:GetLabel())
		Duel.CreateToken(1-tp,e:GetLabel())
		Duel.RegisterFlagEffect(0,e:GetLabel(),0,0,0)
	end
end
function ref.atkfilter(c)
	return c:IsFaceup() and c:IsSetCard(0xb21)
end
function ref.atkval(e,c)
	return Duel.GetMatchingGroupCount(ref.atkfilter,e:GetHandlerPlayer(),LOCATION_MZONE,0,nil)*100
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
function ref.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local bc=c:GetBattleTarget()
	if chk==0 then return bc~=nil and not c:IsHasEffect(EFFECT_CANNOT_DIRECT_ATTACK) end
end
function ref.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_PHASE+PHASE_DAMAGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e1:SetCountLimit(1)
	e1:SetReset(RESET_EVENT+0x1ff0000+RESET_PHASE+PHASE_DAMAGE)
	e1:SetOperation(function(e) Duel.SendtoDeck(e:GetHandler(),nil,2,REASON_EFFECT) end)
	c:RegisterEffect(e1)
	Duel.ChangeAttackTarget(nil)
end

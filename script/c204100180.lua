Toolbox=require "lib.toolbox"
id,ref=Toolbox.gir()
ref.code=id
--created & coded by Lyris
--五溶輪者スカイ・ドラゴン
function ref.initial_effect(c)
	local ae1=Effect.CreateEffect(c)
	ae1:SetType(EFFECT_TYPE_SINGLE)
	ae1:SetCode(EFFECT_ADD_RACE)
	ae1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	ae1:SetValue(RACE_PYRO)
	c:RegisterEffect(ae1)
	local ae2=Effect.CreateEffect(c)
	ae2:SetType(EFFECT_TYPE_SINGLE)
	ae2:SetCode(EFFECT_UPDATE_ATTACK)
	ae2:SetRange(LOCATION_MZONE)
	ae2:SetValue(ref.atkval)
	c:RegisterEffect(ae2)
	local ae3=Effect.CreateEffect(c)
	ae3:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_SINGLE)
	ae3:SetCode(EVENT_SUMMON_SUCCESS)
	ae3:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	ae3:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	ae3:SetTarget(ref.thtg1)
	ae3:SetOperation(ref.thop1)
	c:RegisterEffect(ae3)
	local ae4=Effect.CreateEffect(c)
	ae4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	ae4:SetCode(EVENT_BATTLE_START)
	ae4:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	ae4:SetTarget(ref.target)
	ae4:SetOperation(ref.operation)
	c:RegisterEffect(ae4)
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
ref.point=2
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
function ref.filter(c)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0xb21) and not c.relay and c:IsAbleToHand()
end
function ref.thtg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(ref.filter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function ref.thop1(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,ref.filter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function ref.thfilter(c)
	return c:IsAttribute(ATTRIBUTE_FIRE) and c.relay and c:IsAbleToHand()
end
function ref.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.GetAttackTarget()==c or (Duel.GetAttacker()==c and Duel.GetAttackTarget()~=nil)
		and Duel.IsExistingMatchingCard(ref.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function ref.operation(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,ref.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 and Duel.SendtoHand(g,nil,REASON_EFFECT)~=0 then
		Duel.ConfirmCards(1-tp,g)
		local c=e:GetHandler()
		local x=1
		local point=c:GetFlagEffectLabel(10001100)
		if point>=x and Duel.SelectYesNo(tp,aux.Stringid(id,0)) then
			if point==x then
				c:ResetFlagEffect(10001100)
			else
				c:SetFlagEffectLabel(10001100,point-x)
			end
		else
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_UPDATE_ATTACK)
			e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_DAMAGE)
			e1:SetValue(-700)
			c:RegisterEffect(e1)
		end
	end
end

Toolbox=require "lib.toolbox"
id,ref=Toolbox.gir()
ref.code=id
--created & coded by Lyris
--SBクイーン・ビー
function ref.initial_effect(c)
	c:EnableReviveLimit()
	local ae1=Effect.CreateEffect(c)
	ae1:SetType(EFFECT_TYPE_SINGLE)
	ae1:SetCode(EFFECT_CHANGE_CODE)
	ae1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	ae1:SetRange(LOCATION_MZONE)
	ae1:SetValue(204100305)
	c:RegisterEffect(ae1)
	local ae2=Effect.CreateEffect(c)
	ae2:SetType(EFFECT_TYPE_SINGLE)
	ae2:SetCode(EFFECT_UPDATE_ATTACK)
	ae2:SetRange(LOCATION_MZONE)
	ae2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	ae2:SetValue(ref.value)
	c:RegisterEffect(ae2)
	local ae3=Effect.CreateEffect(c)
	ae3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	ae3:SetCode(EVENT_REMOVE)
	ae3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	ae3:SetCategory(CATEGORY_REMOVE)
	ae3:SetCondition(function(e) return e:GetHandler():IsPreviousLocation(LOCATION_ONFIELD) end)
	ae3:SetTarget(ref.target)
	ae3:SetOperation(ref.operation)
	c:RegisterEffect(ae3)
	if not ref.global_check then
		ref.global_check=true
		local ge2=Effect.CreateEffect(c)
		ge2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge2:SetCode(EVENT_ADJUST)
		ge2:SetCountLimit(1)
		ge2:SetLabel(531)
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
ref.harmony=true
function ref.chk(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetFlagEffect(0,e:GetLabel())==0 then 
		Duel.CreateToken(tp,e:GetLabel())
		Duel.CreateToken(1-tp,e:GetLabel())
		Duel.RegisterFlagEffect(0,e:GetLabel(),0,0,0)
	end
end
function ref.material(mc)
	return mc:IsFaceup() and mc:IsCode(204100305)
end
function ref.atkfilter(c)
	return c:IsFaceup() and c:IsRace(RACE_PLANT) and c:IsSetCard(0x5e5)
end
function ref.value(e,c)
	return Duel.GetMatchingGroupCount(ref.atkfilter,tp,LOCATION_REMOVED,0,nil)*200
end
function ref.filter(c)
	return c:IsType(TYPE_SPELL) and c:IsAbleToRemove()
end
function ref.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and ref.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(ref.filter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectTarget(tp,ref.filter,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,g:GetCount(),0,0)
end
function ref.operation(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) then
		Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)
	end
end

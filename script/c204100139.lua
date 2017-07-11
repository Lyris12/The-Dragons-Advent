Toolbox=require "lib.toolbox"
id,ref=Toolbox.gir()
ref.code=id
--created & coded by Lyris
--ディメンション魔導剣士ブラック・パラディン
function ref.initial_effect(c)
	c:EnableReviveLimit()
	local ae1=Effect.CreateEffect(c)
	ae1:SetType(EFFECT_TYPE_SINGLE)
	ae1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	ae1:SetCode(EFFECT_UPDATE_ATTACK)
	ae1:SetRange(LOCATION_MZONE)
	ae1:SetValue(ref.val)
	c:RegisterEffect(ae1)
	local ae2=Effect.CreateEffect(c)
	ae2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	ae2:SetCode(EVENT_REMOVE)
	ae2:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DAMAGE_STEP)
	ae2:SetCountLimit(1,id)
	ae2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	ae2:SetCondition(function(e) return e:GetHandler():IsPreviousLocation(LOCATION_ONFIELD) end)
	ae2:SetTarget(ref.target)
	ae2:SetOperation(ref.operation)
	c:RegisterEffect(ae2)
	if not ref.global_check then
		ref.global_check=true
		local ge2=Effect.CreateEffect(c)
		ge2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge2:SetCode(EVENT_ADJUST)
		ge2:SetCountLimit(1)
		ge2:SetLabel(500)
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
ref.spatial=true
ref.dimensional_number_o=1
ref.dimensional_number=ref.dimensional_number_o
function ref.material(mc)
	return mc:IsRace(RACE_SPELLCASTER)
end
function ref.spatial_level(c,sc)
	if Duel.GetMatchingGroupCount(ref.atkfilter,c:GetControler(),LOCATION_REMOVED,LOCATION_REMOVED,nil)>=5 and sc:IsAttribute(ATTRIBUTE_DARK) then
		return 7
	else return false end
end
function ref.chk(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetFlagEffect(0,e:GetLabel())==0 then 
		Duel.CreateToken(tp,e:GetLabel())
		Duel.CreateToken(1-tp,e:GetLabel())
		Duel.RegisterFlagEffect(0,e:GetLabel(),0,0,0)
	end
end
function ref.atkfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_MONSTER) and c:IsSetCard(0xa03)
end
function ref.val(e,c)
	return Duel.GetMatchingGroupCount(ref.atkfilter,e:GetHandlerPlayer(),LOCATION_REMOVED,LOCATION_REMOVED,nil)*300
end
function ref.djncon(e,c)
	return Duel.GetMatchingGroupCount(ref.atkfilter,e:GetHandlerPlayer(),LOCATION_REMOVED,LOCATION_REMOVED,nil)>=5
end
function ref.filter(c,e,tp)
	return c:IsFaceup() and c:IsSetCard(0xa03) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and not c:IsCode(id)
end
function ref.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(ref.filter,tp,LOCATION_REMOVED,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,ref.filter,tp,LOCATION_REMOVED,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function ref.operation(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetFirstTarget()
	if g:IsRelateToEffect(e) then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end

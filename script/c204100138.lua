Toolbox=require "lib.toolbox"
id,ref=Toolbox.gir()
ref.code=id
--created & coded by Lyris
--ディメンション魔術師サイレント・マジシャン
function ref.initial_effect(c)
	c:EnableReviveLimit()
	local ae1=Effect.CreateEffect(c)
	ae1:SetCategory(CATEGORY_NEGATE+CATEGORY_REMOVE)
	ae1:SetType(EFFECT_TYPE_QUICK_F)
	ae1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	ae1:SetCode(EVENT_CHAINING)
	ae1:SetRange(LOCATION_MZONE)
	ae1:SetCountLimit(1,id)
	ae1:SetCondition(ref.condition)
	ae1:SetTarget(ref.distg)
	ae1:SetOperation(ref.disop)
	c:RegisterEffect(ae1)
	local ae2=Effect.CreateEffect(c)
	ae2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	ae2:SetCode(EVENT_REMOVE)
	ae2:SetCategory(CATEGORY_SPECIAL_SUMMON)
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
function ref.chk(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetFlagEffect(0,e:GetLabel())==0 then 
		Duel.CreateToken(tp,e:GetLabel())
		Duel.CreateToken(1-tp,e:GetLabel())
		Duel.RegisterFlagEffect(0,e:GetLabel(),0,0,0)
	end
end
function ref.condition(e,tp,eg,ep,ev,re,r,rp)
	return re:IsActiveType(TYPE_SPELL) and re:IsHasType(EFFECT_TYPE_ACTIVATE) and Duel.GetTurnPlayer()~=tp
end
function ref.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsAbleToRemove() and re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_REMOVE,eg,1,0,0)
	end
end
function ref.disop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetCurrentChain()~=ev+1 then return end
	if Duel.NegateActivation(ev) and re:GetHandler():IsRelateToEffect(re) then
		Duel.Remove(eg,POS_FACEUP,REASON_EFFECT)
	end
end
function ref.filter(c,e,tp)
	local lv=c:GetLevel()
	return (lv==6 or lv==7) and c:IsSetCard(0xa03) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function ref.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(ref.filter,tp,LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function ref.operation(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	local g=Duel.SelectMatchingCard(tp,ref.filter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end

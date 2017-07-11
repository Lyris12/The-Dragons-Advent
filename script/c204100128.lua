Toolbox=require "lib.toolbox"
id,ref=Toolbox.gir()
ref.code=id
--created & coded by Lyris
--ディメンション魔法+パワー
function ref.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetTarget(ref.target)
	e1:SetOperation(ref.activate)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCategory(CATEGORY_REMOVE)
	e2:SetCondition(aux.exccon)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(ref.rmtg)
	e2:SetOperation(ref.rmop)
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
function ref.filter1(c,e,tp)
	if not c.spatial then return false end
	local rk=c.dimensional_number
	return c:IsFaceup() and c:IsAbleToRemove()
		and Duel.IsExistingMatchingCard(ref.filter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,rk,c:GetRace(),c:GetAttribute())
end
function ref.filter2(c,e,tp,rk,rc,att)
	return c.dimensional_number_o==rk+1 and (c:IsRace(rc) or c:IsAttribute(att))
		and c:IsCanBeSpecialSummoned(e,0x4000,tp,true,false)
end
function ref.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_MZONE) and ref.filter1(chkc,e,tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>-1
		and Duel.IsExistingTarget(ref.filter1,tp,LOCATION_MZONE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,ref.filter1,tp,LOCATION_MZONE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function ref.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<0 then return end
	local tc=Duel.GetFirstTarget()
	if tc:IsFacedown() or not tc:IsRelateToEffect(e) or tc:IsControler(1-tp) or tc:IsImmuneToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local sg=Duel.SelectMatchingCard(tp,ref.filter2,tp,LOCATION_EXTRA,0,1,1,nil,e,tp,tc:GetRank(),tc:GetRace(),tc:GetAttribute())
	local sc=sg:GetFirst()
	if sc then
		local tg=Group.FromCards(tc)
		if tc:GetSummonType()-SUMMON_TYPE_SPECIAL==0x4000 then
			tg:Merge(tc:GetMaterial())
		end
		sc:SetMaterial(tg)
		Duel.Remove(Group.FromCards(tc),POS_FACEUP,REASON_EFFECT+REASON_MATERIAL+0x400000)
		Duel.SpecialSummon(sc,0x4000,tp,tp,true,false,POS_FACEUP)
	end
end
function ref.rmfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0xa03) and c:IsAbleToRemove()
end
function ref.rmtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(ref.rmfilter,tp,LOCATION_GRAVE,0,1,nil) end
	local g=Duel.GetMatchingGroup(ref.rmfilter,tp,LOCATION_GRAVE,0,nil)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,g:GetCount(),0,0)
end
function ref.rmop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(ref.rmfilter,tp,LOCATION_GRAVE,0,nil)
	Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
end

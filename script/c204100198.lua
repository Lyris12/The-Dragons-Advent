Toolbox=require "lib.toolbox"
id,ref=Toolbox.gir()
ref.code=id
--created & coded by Lyris
--五溶輪－ブレイク・タイム!
function ref.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TODECK+CATEGORY_DRAW+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(ref.target)
	e1:SetOperation(ref.activate)
	c:RegisterEffect(e1)
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
	return c:IsAttribute(ATTRIBUTE_FIRE) and c.relay and c:IsFaceup() and c:IsAbleToDeck()
end
function ref.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1)
		and Duel.IsExistingMatchingCard(ref.filter,tp,LOCATION_EXTRA,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,3,0,LOCATION_EXTRA)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,2)
end
function ref.spfilter(c,e,tp)
	return c:IsAttribute(ATTRIBUTE_FIRE) and c.relay and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function ref.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(ref.filter,tp,LOCATION_EXTRA,0,nil)
	if g:GetCount()<1 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local sg=g:Select(tp,1,1,nil)
	local pt=sg:GetFirst():GetFlagEffectLabel(10001100)
	Duel.SendtoDeck(sg,nil,0,REASON_EFFECT)
	local og=Duel.GetOperatedGroup()
	Duel.ShuffleDeck(tp)
	local ct=og:FilterCount(Card.IsLocation,nil,LOCATION_DECK)
	if ct>0 then
		Duel.Draw(tp,1,REASON_EFFECT)
		if pt and pt>=5 and Duel.IsExistingMatchingCard(ref.spfilter,tp,LOCATION_DECK+LOCATION_EXTRA,0,1,nil,e,tp)
			and Duel.SelectYesNo(tp,aux.Stringid(id,0)) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local cg=Duel.SelectMatchingCard(tp,ref.spfilter,tp,LOCATION_DECK+LOCATION_EXTRA,0,1,1,nil,e,tp)
			Duel.BreakEffect()
			Duel.SpecialSummon(cg,0,tp,tp,false,false,POS_FACEUP)
	end
end

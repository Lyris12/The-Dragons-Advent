Toolbox=require "lib.toolbox"
id,ref=Toolbox.gir()
ref.code=id
--created & coded by Lyris
--スターリ・アイズ・スぺーシュル・ドラゴン
function ref.initial_effect(c)
	c:EnableReviveLimit()
	local ae1=Effect.CreateEffect(c)
	ae1:SetCategory(CATEGORY_TOGRAVE)
	ae1:SetType(EFFECT_TYPE_IGNITION)
	ae1:SetRange(LOCATION_MZONE)
	ae1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	ae1:SetCountLimit(1)
	ae1:SetCost(ref.bancon)
	ae1:SetTarget(ref.bantg)
	ae1:SetOperation(ref.banop)
	c:RegisterEffect(ae1)
	local ae2=Effect.CreateEffect(c)
	ae2:SetType(EFFECT_TYPE_IGNITION)
	ae2:SetRange(LOCATION_PZONE)
	ae2:SetCategory(CATEGORY_TODECK+CATEGORY_DRAW)
	ae2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	ae2:SetCountLimit(1)
	ae2:SetTarget(ref.dmtg)
	ae2:SetOperation(ref.dmop)
	c:RegisterEffect(ae2)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_PZONE)
	e1:SetCondition(ref.sptcon)
	e1:SetOperation(ref.sptop)
	e1:SetValue(0x4000)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EFFECT_SEND_REPLACE)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e2:SetRange(LOCATION_ONFIELD)
	e2:SetTarget(ref.reen)
	c:RegisterEffect(e2)
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
		local ge3=ge2:Clone()
		ge3:SetLabel(300)
		Duel.RegisterEffect(ge3,0)
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
ref.dimensional_number_o=7
ref.dimensional_number=ref.dimensional_number_o
ref.dm=true
ref.dm_no_spsummon=true
function ref.chk(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetFlagEffect(0,e:GetLabel())==0 then 
		Duel.CreateToken(tp,e:GetLabel())
		Duel.CreateToken(1-tp,e:GetLabel())
		Duel.RegisterFlagEffect(0,e:GetLabel(),0,0,0)
	end
end
function ref.bancon(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetCurrentPhase()==PHASE_MAIN1 end
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_OATH)
	e1:SetCode(EFFECT_CANNOT_ATTACK)
	e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
	c:RegisterEffect(e1,true)
end
function ref.atkfilter(c)
	return c:IsType(TYPE_MONSTER) and aux.nzatk(c) and c:IsAbleToGrave()
end
function ref.bantg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chkc then return chkc:IsLocation(LOCATION_REMOVED) and chkc:IsControler(1-tp) and ref.atkfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(ref.atkfilter,tp,0,LOCATION_REMOVED,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g=Duel.SelectTarget(tp,ref.atkfilter,tp,0,LOCATION_REMOVED,1,1,nil)
	local atk=g:GetFirst():GetBaseAttack()
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,atk)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,g,1,0,0)
end
function ref.banop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and Duel.Damage(1-tp,tc:GetBaseAttack(),REASON_EFFECT)~=0 then
		Duel.BreakEffect()
		Duel.SendtoGrave(tc,REASON_EFFECT)
	end
end
function ref.filter(c)
	return c:IsFaceup() and c:IsType(TYPE_MONSTER) and c:IsAbleToDeck()
end
function ref.dmtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_REMOVED) and chkc:IsControler(tp) and ref.filter(chkc) end
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) and Duel.IsExistingTarget(ref.filter,tp,LOCATION_REMOVED,0,2,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectTarget(tp,ref.filter,tp,LOCATION_REMOVED,0,2,2,nil)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,2,0,0)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function ref.dmop(e,tp,eg,ep,ev,re,r,rp)
	local tg=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	if tg:GetCount()>0 then
		Duel.SendtoDeck(tg,nil,2,REASON_EFFECT)
		local g=Duel.GetOperatedGroup()
		if g:IsExists(Card.IsLocation,1,nil,LOCATION_DECK) then Duel.ShuffleDeck(tp) end
		local ct=g:FilterCount(Card.IsLocation,nil,LOCATION_DECK+LOCATION_EXTRA)
		if ct>0 then
			Duel.BreakEffect()
			Duel.Draw(tp,1,REASON_EFFECT)
		end
	end
end
function ref.reen(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local tc1=Duel.GetFieldCard(tp,LOCATION_SZONE,6)
	local tc2=Duel.GetFieldCard(tp,LOCATION_SZONE,7)
	if chk==0 then return c:IsOnField() and bit.band(c:GetDestination(),LOCATION_EXTRA+LOCATION_DECK+LOCATION_HAND)~=0 and (tc1==nil or tc2==nil) end
	Duel.MoveToField(c,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
end
function ref.sptfilter1(c,tp,djn,f,sc)
	local lv=c:GetLevel()
	if c.spatial_level then lv=c.spatial_level(c,sc) end
	return c:IsFaceup() and lv>0 and (not f or f(c)) and c:IsAbleToRemove()
		and Duel.IsExistingMatchingCard(ref.sptfilter2,tp,LOCATION_MZONE,0,1,c,djn,f,c:GetAttribute(),c:GetRace(),lv,sc)
end
function ref.sptfilter2(c,djn,f,at,rc,tlv,sc)
	local lv=c:GetLevel()
	if c.spatial_level then lv=c.spatial_level(c,sc) end
	return c:IsFaceup() and c:GetAttribute()==at and c:GetRace()==rc
		and c:GetLevel()>0 and (djn==tlv or djn==lv)
		and (not f or f(c)) and c:IsAbleToRemove()
end
function ref.sptcon(e,c)
	if c==nil then return true end
	if c:IsType(TYPE_PENDULUM) and c:IsFaceup() then return false end
	local tp=c:GetControler()
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	local ct=-ft
	local rt=1
	return ct<rt and Duel.IsExistingMatchingCard(ref.sptfilter1,tp,LOCATION_MZONE,0,1,nil,tp,7,c.material,c)
end
function ref.sptop(e,tp,eg,ep,ev,re,r,rp,c)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	local ct=-ft
	local rt=1
	local mg=Duel.GetFieldGroup(tp,LOCATION_MZONE,0)
	local x=7
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local m1=mg:FilterSelect(tp,ref.sptfilter1,1,1,nil,tp,x,c.material,c)
	local tc=m1:GetFirst()
	local lv=tc:GetLevel()
	if tc.spatial_level then lv=tc.spatial_level(tc) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local m2=mg:FilterSelect(tp,ref.sptfilter2,1,1,tc,x,c.material,tc:GetAttribute(),tc:GetRace(),lv,c)
	m1:Merge(m2)
	c:SetMaterial(m1)
	Duel.Remove(m1,POS_FACEUP,REASON_MATERIAL+0x400000)
end

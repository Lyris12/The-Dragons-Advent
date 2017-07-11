Toolbox=require "lib.toolbox"
id,ref=Toolbox.gir()
ref.code=id
--created & coded by Lyris
--スプリング・ブリーズ・ハーモニー・ドラゴン
function ref.initial_effect(c)
	c:EnableReviveLimit()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_IMMUNE_EFFECT)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(LOCATION_REMOVED,0)
	e1:SetValue(ref.efilter)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_REMOVE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetCountLimit(1)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTarget(ref.target)
	e2:SetOperation(ref.operation)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EFFECT_SEND_REPLACE)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e3:SetRange(LOCATION_ONFIELD)
	e3:SetTarget(ref.reen)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_SPSUMMON_PROC)
	e4:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e4:SetRange(LOCATION_PZONE)
	e4:SetCondition(ref.spcon)
	e4:SetOperation(ref.spop)
	e4:SetValue(0x1000)
	c:RegisterEffect(e4)
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_QUICK_O)
	e5:SetCode(EVENT_CHAINING)
	e5:SetRange(LOCATION_PZONE)
	e5:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e5:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)
	e5:SetCondition(ref.dmcon)
	e5:SetCost(ref.dmcost)
	e5:SetTarget(ref.dmtg)
	e5:SetOperation(ref.dmop)
	if not ref.global_check then
		ref.global_check=true
		local ge0=Effect.CreateEffect(c)
		ge0:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge0:SetCode(EVENT_ADJUST)
		ge0:SetCountLimit(1)
		ge0:SetLabel(531)
		ge0:SetProperty(EFFECT_FLAG_NO_TURN_RESET)
		ge0:SetOperation(ref.chk)
		Duel.RegisterEffect(ge0,0)
		local ge1=ge0:Clone()
		ge1:SetLabel(300)
		Duel.RegisterEffect(ge1,0)
		local ge2=ge0:Clone()
		ge2:SetLabel(240)
		Duel.RegisterEffect(ge2,0)
	end
end
ref.harmony=true
function ref.material(mc)
	return mc:IsFaceup() and mc:IsType(TYPE_SPELL)
end
ref.dm=true
ref.dm_no_spsummon=true
function ref.dm_custom_lose(e,tp,eg,ep,ev,re,r,rp)
	return rp~=tp and e:GetHandler():GetFlagEffect(300)>0 and r~=1048650
end
function ref.chk(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetFlagEffect(0,e:GetLabel())==0 then 
		Duel.CreateToken(tp,e:GetLabel())
		Duel.CreateToken(1-tp,e:GetLabel())
		Duel.RegisterFlagEffect(0,e:GetLabel(),0,0,0)
	end
end
function ref.efilter(e,te)
	local tc=te:GetHandler()
	return te:GetOwnerPlayer()~=e:GetHandlerPlayer() and te:IsActiveType(TYPE_MONSTER) and tc:IsLevelAbove(5)
end
function ref.filter(c)
	return c:IsLevelAbove(5) and c:IsAbleToRemove()
end
function ref.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and ref.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(ref.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectTarget(tp,ref.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,g:GetCount(),0,0)
end
function ref.operation(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	local rsn=REASON_EFFECT
	if tc:GetPreviousControler()~=tp then rsn=rsn+REASON_TEMPORARY end
	if tc:IsRelateToEffect(e) and Duel.Remove(tc,tc:GetPosition(),rsn)~=0
		and rsn~=REASON_EFFECT then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_PHASE+PHASE_END)
		e1:SetReset(RESET_PHASE+PHASE_END)
		e1:SetCountLimit(1)
		e1:SetLabelObject(tc)
		e1:SetOperation(ref.retop)
		Duel.RegisterEffect(e1,tp)
	end
end
function ref.retop(e,tp,eg,ep,ev,re,r,rp)
	Duel.ReturnToField(e:GetLabelObject())
end
function ref.reen(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local tc1=Duel.GetFieldCard(tp,LOCATION_SZONE,6)
	local tc2=Duel.GetFieldCard(tp,LOCATION_SZONE,7)
	if chk==0 then return c:IsOnField() and bit.band(c:GetDestination(),LOCATION_EXTRA+LOCATION_DECK+LOCATION_HAND)~=0 and (tc1==nil or tc2==nil) end
	Duel.MoveToField(c,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
end
function ref.matfilter(c,x,f)
	return c:GetFlagEffect(10004000)>0 and c:GetFlagEffectLabel(10004000)>=x and (not f or f(c))
		and c:IsAbleToDeck()
end
function ref.spcon(e,c)
	if c==nil then return true end
	if c:IsType(TYPE_PENDULUM) and c:IsFaceup() then return false end
	local tp=c:GetControler()
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return false end
	local ct=1
	if c.material_mincount then ct=c.material_mincount end
	return Duel.IsExistingMatchingCard(ref.matfilter,tp,LOCATION_REMOVED,0,1,nil,7,c.material)
end
function ref.spop(e,tp,eg,ep,ev,re,r,rp,c)
	local min=1
	if c.material_mincount then min=c.material_mincount end
	local max=min
	if c.material_maxcount then max=c.material_maxcount end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectMatchingCard(tp,ref.matfilter,tp,LOCATION_REMOVED,0,min,max,nil,7,c.material)
	c:SetMaterial(g)
	Duel.SendtoDeck(g,nil,2,REASON_MATERIAL+0x40000000)
end
function ref.dmfilter(c)
	if not c:IsAttribute(ATTRIBUTE_WIND) then return false end
	if c:IsLocation(LOCATION_GRAVE) then return true end
	return c:IsLocation(LOCATION_MZONE) and c:IsFaceup() 
end
function ref.dmcon(e,tp,eg,ep,ev,re,r,rp)
	if not re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) then return false end
	local g=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
	return g and g:IsExists(ref.dmfilter,1,nil)
		and Duel.IsChainNegatable(ev)
end
function ref.dmcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,LOCATION_DECK,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,Card.IsAbleToRemove,tp,LOCATION_DECK,0,1,1,nil)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function ref.dmtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
	end
end
function ref.dmop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.NegateActivation(ev) and re:GetHandler():IsRelateToEffect(re) then
		Duel.Destroy(eg,REASON_EFFECT)
	end
end

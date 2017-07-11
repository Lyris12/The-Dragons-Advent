Toolbox=require "lib.toolbox"
id,ref=Toolbox.gir()
ref.code=id
--created & coded by Lyris
--Hispanicアルチピエラゴ
function ref.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetRange(LOCATION_FZONE)
	e2:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e2:SetTarget(ref.atktg)
	e2:SetValue(400)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_TO_DECK)
	e3:SetRange(LOCATION_FZONE)
	e3:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetCondition(ref.con)
	e3:SetTarget(ref.tg)
	e3:SetOperation(ref.op)
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
function ref.atktg(e,c)
	return c:IsAttribute(ATTRIBUTE_LIGHT) and c.accent
end
function ref.cfilter(c,tp)
	return c:IsPreviousLocation(LOCATION_MZONE) and c:GetPreviousControler()==tp and c:IsLocation(LOCATION_DECK)
end
function ref.con(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(ref.cfilter,1,nil,tp)
end
function ref.thfilter(c,codes,e,tp,n)
	if not (c:IsType(TYPE_MONSTER) and c:IsSetCard(0x92b)) then return false end
	if n==nil and not c:IsCanBeSpecialSummoned(e,0,tp,false,false) then return false end
	for i,code in ipairs(codes) do
		if c:GetCode()==i then return false end
	end
	return true
end
function ref.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local t={}
		local tc=eg:GetFirst()
		while tc do
			for i,code in ipairs({tc:GetCode()}) do
				if not t[code] then
					t[code]=true
				end
			end
			tc=eg:GetNext()
		end
		return Duel.IsExistingMatchingCard(ref.thfilter,tp,LOCATION_DECK,0,3,nil,t,e,tp)
	end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,0,LOCATION_DECK)
end
function ref.op(e,tp,eg,ep,ev,re,r,rp)
	local t={}
	local tc=eg:GetFirst()
	while tc do
		for i,code in ipairs({tc:GetCode()}) do
			if not t[code] then
				t[code]=true
			end
		end
		tc=eg:GetNext()
	end
	local g=Duel.GetMatchingGroup(ref.thfilter,tp,LOCATION_DECK,0,nil,t,e,tp,0)
	if g:GetCount()>=3 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local sg=g:Select(tp,3,3,nil)
		Duel.ConfirmCards(1-tp,sg)
		Duel.ShuffleDeck(tp)
		local tg=sg:RandomSelect(1-tp,1)
		local tc=tg:GetFirst()
		if tc:IsCanBeSpecialSummoned(e,0,tp,false,false) then
			Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
		end
		Duel.ShuffleDeck(tp)
	end
end

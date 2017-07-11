Toolbox=require "lib.toolbox"
id,ref=Toolbox.gir()
ref.code=id
--created & coded by Lyris
--ディメンション魔法裂け目
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
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetProperty(EFFECT_FLAG_SET_AVAILABLE+EFFECT_FLAG_IGNORE_RANGE)
	e3:SetCode(EFFECT_TO_GRAVE_REDIRECT)
	e3:SetRange(LOCATION_FZONE)
	e3:SetCondition(ref.condition)
	e3:SetTarget(ref.rmtarget)
	e3:SetTargetRange(0xff,0xff)
	e3:SetValue(LOCATION_REMOVED)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetCode(81674782)
	e4:SetRange(LOCATION_FZONE)
	e4:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
	e4:SetTargetRange(0xff,0xff)
	e4:SetTarget(ref.checktg)
	c:RegisterEffect(e4)
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
	return c:IsAttribute(ATTRIBUTE_DARK) and c.spatial
end
function ref.filter(c)
	return c:IsFaceup() and c:IsType(TYPE_MONSTER) and c:IsSetCard(0xa03)
end
function ref.condition(e)
	return Duel.IsExistingMatchingCard(ref.filter,e:GetHandlerPlayer(),LOCATION_REMOVED,0,3,nil)
end
function ref.rmtarget(e,c)
	return not c:IsLocation(0x80) and not c:IsType(TYPE_SPELL)
end
function ref.checktg(e,c)
	return not c:IsPublic()
end

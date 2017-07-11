Toolbox=require "lib.toolbox"
id,ref=Toolbox.gir()
ref.code=id
--created & coded by Lyris
--五溶輪の神殿スタジアム
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
	e3:SetTarget(ref.rdtarget)
	e3:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e3:SetValue(LOCATION_DECKSHF)
	c:RegisterEffect(e3)
	
end
function ref.atktg(e,c)
	return c:IsAttribute(ATTRIBUTE_FIRE) and c.relay
end
function ref.rdtarget(e,c)
	if bit.band(c:GetReason(),REASON_RELEASE+REASON_MATERIAL+REASON_SUMMON)~=REASON_RELEASE+REASON_MATERIAL+REASON_SUMMON then return false end
	return ref.atktg(e,c) and (c:GetReasonCard():IsSetCard(0xb21) or ref.atktg(e,c:GetReasonCard()))
end
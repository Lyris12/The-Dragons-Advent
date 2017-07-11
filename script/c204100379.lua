Toolbox=require "lib.toolbox"
id,ref=Toolbox.gir()
ref.code=id
--created & coded by Lyris
--ヨーロッパ・ボイス・アクセント・ドラゴン
function ref.initial_effect(c)
	c:EnableReviveLimit()
	local ae1=Effect.CreateEffect(c)
	ae1:SetType(EFFECT_TYPE_SINGLE)
	ae1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	ae1:SetCode(EFFECT_FUSION_MATERIAL)
	ae1:SetCondition(ref.fscon(aux.FilterBoolFunction(Card.IsAttribute,ATTRIBUTE_LIGHT),2,false))
	ae1:SetOperation(ref.fsop(aux.FilterBoolFunction(Card.IsAttribute,ATTRIBUTE_LIGHT),2,false))
	c:RegisterEffect(ae1)
	local ae2=Effect.CreateEffect(c)
	ae2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	ae2:SetCode(EVENT_CHAIN_SOLVING)
	ae2:SetRange(LOCATION_MZONE)
	ae2:SetOperation(ref.disop)
	c:RegisterEffect(ae2)
	local ae3=Effect.CreateEffect(c)
	ae3:SetType(EFFECT_TYPE_QUICK_O)
	ae3:SetCode(EVENT_CHAINING)
	ae3:SetRange(LOCATION_MZONE)
	ae3:SetCountLimit(1,id)
	ae3:SetCondition(ref.condition)
	ae3:SetOperation(ref.operation)
	c:RegisterEffect(ae3)
	local ae4=Effect.CreateEffect(c)
	ae4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	ae4:SetCode(EVENT_CHAINING)
	ae4:SetRange(LOCATION_EXTRA)
	ae4:SetOperation(ref.chop1)
	c:RegisterEffect(ae4)
	if not ref.global_check then
		ref.global_check=true
		local ge2=Effect.CreateEffect(c)
		ge2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge2:SetCode(EVENT_ADJUST)
		ge2:SetCountLimit(1)
		ge2:SetLabel(357)
		ge2:SetProperty(EFFECT_FLAG_NO_TURN_RESET)
		ge2:SetOperation(ref.chk)
		Duel.RegisterEffect(ge2,0)
		local gec=Effect.CreateEffect(c)
		gec:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		gec:SetCode(EVENT_ADJUST)
		gec:SetCountLimit(1)
		gec:SetProperty(EFFECT_FLAG_NO_TURN_RESET)
		gec:SetLabel(240)
		gec:SetOperation(ref.chk)
		Duel.RegisterEffect(gec,0)
	end
end
ref.accent=true
function ref.chk(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetFlagEffect(0,e:GetLabel())==0 then 
		Duel.CreateToken(tp,e:GetLabel())
		Duel.CreateToken(1-tp,e:GetLabel())
		Duel.RegisterFlagEffect(0,e:GetLabel(),0,0,0)
	end
end
function ref.fscon(f,cc,insf)
	return  function(e,g,gc,chkf)
				if g==nil then return insf end
				if gc then return f(gc) and g:IsExists(f,cc-1,gc) end
				local g1=g:Filter(f,nil)
				if chkf~=PLAYER_NONE then
					return g1:FilterCount(Card.IsOnField,nil)~=0 and g1:GetCount()>=cc
				else return g1:GetCount()>=cc end
			end
end
function ref.fsop(f,cc,insf)
	return  function(e,tp,eg,ep,ev,re,r,rp,gc,chkf)
				if gc then
					Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FMATERIAL)
					local g1=eg:FilterSelect(tp,f,cc-1,cc-1,gc)
					Duel.SetFusionMaterial(g1)
					return
				end
				local sg=eg:Filter(f,nil)
				if chkf==PLAYER_NONE or sg:GetCount()==cc then
					Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FMATERIAL)
					local g1=sg:Select(tp,cc,cc,nil)
					Duel.SetFusionMaterial(g1)
					return
				end
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FMATERIAL)
				local g1=sg:FilterSelect(tp,aux.FConditionCheckF,1,1,nil,chkf)
				if cc>1 then
					Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FMATERIAL)
					local g2=sg:Select(tp,cc-1,cc-1,g1:GetFirst())
					g1:Merge(g2)
				end
				Duel.SetFusionMaterial(g1)
			end
end
function ref.chop1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local rc=re:GetHandler()
	if not re:IsActiveType(TYPE_MONSTER) or not rc:IsRelateToEffect(re) then return end
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_DESTROYED)
	e3:SetLabelObject(re)
	e3:SetCondition(ref.chcon)
	e3:SetOperation(ref.chop3)
	Duel.RegisterEffect(e3,tp)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e4:SetCode(EVENT_CHAIN_NEGATED)
	e4:SetLabelObject(e3)
	e4:SetOperation(ref.regop)
	e4:SetReset(RESET_CHAIN)
	Duel.RegisterEffect(e4,tp)
	local ae5=Effect.CreateEffect(c)
	ae5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	ae5:SetCode(EVENT_DESTROY)
	ae5:SetLabelObject(e3)
	ae5:SetOperation(ref.chop2)
	ae5:SetReset(RESET_CHAIN+RESET_EVENT+0x1fe0000)
	rc:RegisterEffect(ae5)
	local ae6=Effect.CreateEffect(c)
	ae6:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	ae6:SetCode(EVENT_CHAIN_SOLVING)
	ae6:SetLabelObject(ae5)
	ae6:SetOperation(function(e,tp,eg,ep,ev,re,r,rp)
		if re~=e:GetLabelObject():GetLabelObject():GetLabelObject() then return end
		e:GetLabelObject():Reset()
	end)
	ae6:SetReset(RESET_CHAIN)
	Duel.RegisterEffect(ae6,tp)
end
function ref.regop(e,tp,eg,ep,ev,re,r,rp)
	if re==e:GetLabelObject():GetLabelObject() then
		local ct=e:GetLabelObject():GetLabel()
		e:GetLabelObject():SetLabel(-1)
	end
end
function ref.chop2(e,tp,eg,ep,ev,re,r,rp)
	local ct=e:GetLabelObject():GetLabel()
	if ct>0 then ct=0 end
	e:GetLabelObject():SetLabel(ct+1)
end
function ref.chcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetLabel()==1
end
function ref.chop3(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetOwner())
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_CHAIN_SOLVED)
	e1:SetLabelObject(e:GetLabelObject())
	e1:SetOperation(ref.sprop)
	Duel.RegisterEffect(e1,tp)
	e:SetLabel(0)
	e:Reset()
end
function ref.sprop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetOwner()
	if re==e:GetLabelObject() then
		local rc=re:GetHandler()
		local chkf=Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and PLAYER_NONE or tp
		local m=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,LOCATION_GRAVE,0,nil)
		if c:IsLocation(LOCATION_EXTRA) and c:IsCanBeSpecialSummoned(e,0x400,tp,false,false) and c:CheckFusionMaterial(m,rc,chkf) and Duel.GetFlagEffect(tp,id)==0 and Duel.SelectYesNo(tp,aux.Stringid(id,0)) then
			local mat=Duel.SelectFusionMaterial(tp,c,m,rc,chkf)
			c:SetMaterial(mat)
			Duel.Remove(mat,POS_FACEUP,REASON_EFFECT+REASON_MATERIAL+0x140000)
			Duel.BreakEffect()
			Duel.SpecialSummon(c,0x400,tp,tp,false,false,POS_FACEUP)
			c:CompleteProcedure()
			Duel.RegisterFlagEffect(tp,id,RESET_PHASE+PHASE_END,0,1)
		end
		e:Reset()
	end
end
function ref.disop(e,tp,eg,ep,ev,re,r,rp)
	local rc=re:GetHandler()
	if not rc:IsLocation(LOCATION_REMOVED) or e:GetHandler():GetMaterial():IsContains(rc) then return end
	Duel.NegateEffect(ev)
	if rc:IsRelateToEffect(re) then
		Duel.SendtoDeck(rc,nil,2,REASON_EFFECT)
	end
end
function ref.condition(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local rc=re:GetHandler()
	local loc=Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_LOCATION)
	return re:IsActiveType(TYPE_MONSTER) and rc:IsLevelAbove(5) and rc:IsControler(1-c:GetControler()) and loc==LOCATION_MZONE
		and not c:IsStatus(STATUS_BATTLE_DESTROYED)
end
function ref.operation(e,tp,eg,ep,ev,re,r,rp)
	local g=Group.CreateGroup()
	Duel.ChangeTargetCard(ev,g)
	Duel.ChangeChainOperation(ev,ref.repop)
end
function ref.repop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CHANGE_DAMAGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_AVAILABLE_BD)
	e1:SetLabel(c:GetAttack())
	e1:SetTargetRange(1,1)
	e1:SetValue(ref.damval)
	Duel.RegisterEffect(e1,tp)
end
function ref.damval(e,re,val,r,rp,rc)
	local atk=e:GetLabel()
	if val<=atk then return 0 else return val end
end

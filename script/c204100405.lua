Toolbox=require "lib.toolbox"
id,ref=Toolbox.gir()
ref.code=id
--created & coded by Lyris
--Hispanicソル・ドラゴン
function ref.initial_effect(c)
	c:EnableReviveLimit()
	local ae1=Effect.CreateEffect(c)
	ae1:SetType(EFFECT_TYPE_SINGLE)
	ae1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	ae1:SetCode(EFFECT_FUSION_MATERIAL)
	ae1:SetCondition(ref.fscon(id,aux.FilterBoolFunction(Card.IsSetCard,0x92b),1,false,false))
	ae1:SetOperation(ref.fsop(id,aux.FilterBoolFunction(Card.IsSetCard,0x92b),1,false,false))
	c:RegisterEffect(ae1)
	local ae2=Effect.CreateEffect(c)
	ae2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	ae2:SetCode(EVENT_CHAIN_SOLVING)
	ae2:SetRange(LOCATION_MZONE)
	ae2:SetOperation(ref.disop)
	c:RegisterEffect(ae2)
	local ae3=Effect.CreateEffect(c)
	ae3:SetCategory(CATEGORY_NEGATE+CATEGORY_TODECK)
	ae3:SetType(EFFECT_TYPE_QUICK_O)
	ae3:SetCode(EVENT_CHAINING)
	ae3:SetRange(LOCATION_MZONE)
	ae3:SetCountLimit(1)
	ae3:SetCondition(ref.condition)
	ae3:SetTarget(ref.target)
	ae3:SetOperation(ref.operation)
	c:RegisterEffect(ae3)
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
		gec:SetProperty(EFFECT_FLAG_NO_TURN_RESET)
		gec:SetLabel(240)
		gec:SetOperation(ref.chk)
		Duel.RegisterEffect(gec,0)
	end
end
ref.accent=true
ref.accent_only=true
function ref.chk(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetFlagEffect(0,e:GetLabel())==0 then 
		Duel.CreateToken(tp,e:GetLabel())
		Duel.CreateToken(1-tp,e:GetLabel())
		Duel.RegisterFlagEffect(0,e:GetLabel(),0,0,0)
	end
end
function ref.fscon(code,f,cc,sub,insf)
	return  function(e,g,gc,chkfnf)
				if g==nil then return insf end
				local chkf=bit.band(chkfnf,0xff)
				local notfusion=bit.rshift(chkfnf,8)~=0
				local sub=sub or notfusion
				local mg=g:Filter(aux.TRUE,nil,e:GetHandler())
				if gc then
					if (gc:IsCode(code) or (sub and gc:CheckFusionSubstitute(e:GetHandler()))) and mg:IsExists(f,cc,gc) then
						return true
					elseif f(gc) then
						local g1=Group.CreateGroup() local g2=Group.CreateGroup()
						local tc=mg:GetFirst()
						while tc do
							if tc:IsCode(code) or (sub and tc:CheckFusionSubstitute(e:GetHandler()))
								then g1:AddCard(tc) end
							if f(tc) then g2:AddCard(tc) end
							tc=mg:GetNext()
						end
						if cc>1 then
							g2:RemoveCard(gc)
							return g1:IsExists(aux.FConditionFilterCF,1,gc,g2,cc-1)
						else
							g1:RemoveCard(gc)
							return g1:GetCount()>0
						end
					else return false end
				end
				local b1=0 local b2=0 local bw=0
				local fs=false
				local tc=mg:GetFirst()
				while tc do
					local c1=tc:IsCode(code) or (sub and tc:CheckFusionSubstitute(e:GetHandler()))
					local c2=f(tc)
					if c1 or c2 then
						if aux.FConditionCheckF(tc,chkf) then fs=true end
						if c1 and c2 then bw=bw+1
						elseif c1 then b1=1
						else b2=b2+1
						end
					end
					tc=mg:GetNext()
				end
				if b2>cc then b2=cc end
				return b1+b2+bw>=1+cc and (fs or chkf==PLAYER_NONE)
			end
end
function ref.fsop(code,f,cc,sub,insf)
	return  function(e,tp,eg,ep,ev,re,r,rp,gc,chkfnf)
				local chkf=bit.band(chkfnf,0xff)
				local notfusion=bit.rshift(chkfnf,8)~=0
				local sub=sub or notfusion
				local g=eg:Filter(aux.TRUE,nil,e:GetHandler())
				if gc then
					if (gc:IsCode(code) or (sub and gc:CheckFusionSubstitute(e:GetHandler()))) and g:IsExists(f,cc,gc) then
						Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FMATERIAL)
						local g1=g:FilterSelect(tp,f,cc,cc,gc)
						Duel.SetFusionMaterial(g1)
					else
						local sg1=Group.CreateGroup() local sg2=Group.CreateGroup()
						local tc=g:GetFirst()
						while tc do
							if tc:IsCode(code) or (sub and tc:CheckFusionSubstitute(e:GetHandler())) then sg1:AddCard(tc) end
							if f(tc) then sg2:AddCard(tc) end
							tc=g:GetNext()
						end
						if cc>1 then
							sg2:RemoveCard(gc)
							if sg2:GetCount()==cc-1 then
								sg1:Sub(sg2)
							end
							Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FMATERIAL)
							local g1=sg1:Select(tp,1,1,gc)
							Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FMATERIAL)
							local g2=sg2:Select(tp,cc-1,cc-1,g1:GetFirst())
							g1:Merge(g2)
							Duel.SetFusionMaterial(g1)
						else
							Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FMATERIAL)
							local g1=sg1:Select(tp,1,1,gc)
							Duel.SetFusionMaterial(g1)
						end
					end
					return
				end
				local sg1=Group.CreateGroup() local sg2=Group.CreateGroup() local fs=false
				local tc=g:GetFirst()
				while tc do
					if tc:IsCode(code) or (sub and tc:CheckFusionSubstitute(e:GetHandler())) then sg1:AddCard(tc) end
					if f(tc) then sg2:AddCard(tc) if aux.FConditionCheckF(tc,chkf) then fs=true end end
					tc=g:GetNext()
				end
				if chkf~=PLAYER_NONE then
					if sg2:GetCount()==cc then
						sg1:Sub(sg2)
					end
					local g1=nil
					Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FMATERIAL)
					if fs then g1=sg1:Select(tp,1,1,nil)
					else g1=sg1:FilterSelect(tp,aux.FConditionCheckF,1,1,nil,chkf) end
					local tc1=g1:GetFirst()
					sg2:RemoveCard(tc1)
					if aux.FConditionCheckF(tc1,chkf) or sg2:GetCount()==cc then
						Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FMATERIAL)
						local g2=sg2:Select(tp,cc,cc,tc1)
						g1:Merge(g2)
					else
						Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FMATERIAL)
						local g2=sg2:FilterSelect(tp,aux.FConditionCheckF,1,1,tc1,chkf)
						g1:Merge(g2)
						if cc>1 then
							sg2:RemoveCard(g2:GetFirst())
							Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FMATERIAL)
							g2=sg2:Select(tp,cc-1,cc-1,tc1)
							g1:Merge(g2)
						end
					end
					Duel.SetFusionMaterial(g1)
				else
					if sg2:GetCount()==cc then
						sg1:Sub(sg2)
					end
					Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FMATERIAL)
					local g1=sg1:Select(tp,1,1,nil)
					Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FMATERIAL)
					g1:Merge(sg2:Select(tp,cc,cc,g1:GetFirst()))
					Duel.SetFusionMaterial(g1)
				end
			end
end
function ref.disop(e,tp,eg,ep,ev,re,r,rp)
	local rc=re:GetHandler()
	if not rc:IsLocation(LOCATION_GRAVE) or rc:IsControler(tp) then return end
	Duel.NegateEffect(ev)
	if rc:IsRelateToEffect(re) then
		Duel.SendtoDeck(rc,nil,2,REASON_EFFECT)
	end
end
function ref.condition(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local rc=re:GetHandler()
	return re:IsActiveType(TYPE_MONSTER) and rc~=c and not c:IsStatus(STATUS_BATTLE_DESTROYED) and Duel.IsChainNegatable(ev)
end
function ref.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsAbleToDeck() and re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_TODECK,eg,1,0,0)
	end
end
function ref.filter(c,ec)
	return c~=ec and c:IsAbleToDeck()
end
function ref.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local rc=re:GetHandler()
	if Duel.NegateEffect(ev) and rc:IsRelateToEffect(re) and rc:IsAbleToDeck() then
		local g=Duel.SelectMatchingCard(1-tp,ref.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,rc,c)
		if g:GetCount()>0 then
			g:AddCard(rc)
			Duel.SendtoDeck(g,nil,2,REASON_EFFECT)
		end
	end
end

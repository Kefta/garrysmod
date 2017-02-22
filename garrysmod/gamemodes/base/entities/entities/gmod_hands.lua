
AddCSLuaFile()

ENT.Type = "anim"
ENT.RenderGroup = RENDERGROUP_OTHER


function ENT:Initialize()

	hook.Add( "OnViewModelChanged", self, self.ViewModelChanged )

	self:SetNotSolid( true )
	self:DrawShadow( false )
	self:SetTransmitWithParent( true ) -- Transmit only when the viewmodel does!

end

function ENT:SetupDataTables()

	self:NetworkVar( "Int", 0, "ViewModelIndex" )

end

function ENT:DoSetup( ply, spec, index --[[= 0]] )

	local displayply = spec or ply
	index = index or 0
	local vm = displayply:GetViewModel( index )
	if ( not IsValid( vm ) ) then

		if ( SERVER ) then

			self:Remove()

		end

		return
	end

	-- Set these hands to the player
	ply:SetHands( self, index )
	self:SetOwner( ply )
	self:SetViewModelIndex( index )

	-- Which hands should we use? Let the gamemode decide
	hook.Call( "PlayerSetHandsModel", GAMEMODE, displayply, self, index )

	-- Attach them to the viewmodel
	self:AttachToViewmodel( vm )

	vm:DeleteOnRemove( self )
	ply:DeleteOnRemove( self )
	self:Spawn()

end

function ENT:GetPlayerColor()

	--
	-- Make sure there's an owner and they have this function
	-- before trying to call it!
	--
	local owner = self:GetOwner()
	if ( !IsValid( owner ) ) then return end
	if ( !owner.GetPlayerColor ) then return end

	return owner:GetPlayerColor()

end

function ENT:ViewModelChanged( vm )

	-- Ignore other peoples viewmodel changes!
	if ( vm:GetOwner() == self:GetOwner() && self:GetViewModelIndex() == vm:ViewModelIndex() ) then

		self:AttachToViewmodel( vm )

	end

end

function ENT:AttachToViewmodel( vm )

	self:AddEffects( EF_BONEMERGE )
	self:SetParent( vm )
	self:SetMoveType( MOVETYPE_NONE )

	self:SetLocalPos( vector_origin )
	self:SetLocalAngles( angle_zero )

end

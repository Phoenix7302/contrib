﻿-- This file is subject to copyright - contact swampservers@gmail.com for more information.
-- INSTALL: CINEMA
SWEP.PrintName = "Dodgeball"
SWEP.Slot = 0
SWEP.ViewModel = Model("models/pyroteknik/dodgeball.mdl")
SWEP.WorldModel = Model("models/pyroteknik/dodgeball.mdl")
local outie = 64
local innie = 28

function SWEP:Initialize()
    self:SetHoldType("physgun")
end

makeDodgeball = makeDodgeball or function(pos,vel,ply)
local ball = ents.Create("dodgeball")
ball:SetPos(pos)
ball:Spawn()
ball:GetPhysicsObject():SetVelocity(vel)
ball.Owner = ply

end

function SWEP:ThrowBall(force)
    self:SetHoldType("physgun")
    self:SetNextPrimaryFire(CurTime() + 1)
    
    self:SetHoldType("melee")
   
    if SERVER then
        timer.Simple(.1, function()
            self.Owner:SetAnimation(PLAYER_ATTACK1)
            timer.Simple(.2, function()
            if IsValid(self) and IsValid(self.Owner) then
                local p1 = self.Owner:GetPos() + self.Owner:GetCurrentViewOffset()
                local p2 = p1 + (self.Owner:GetAimVector() * outie)

                local tr = util.TraceLine({
                    start = p1,
                    endpos = p2,
                    mask = MASK_SOLID_BRUSHONLY
                })

                if tr.Hit then
                    p2 = tr.HitPos
                end
                
                p2 = p2 - (self.Owner:GetAimVector() * innie)
                self:SetNoDraw(true)
                timer.Simple(.2, function()
                    if(IsValid(self))then
                        self.Owner:StripWeapon("weapon_dodgeball")
                    end
                end)
                makeDodgeball(p2, (self.Owner:GetAimVector() * force) + self.Owner:GetVelocity(), self.Owner)
               
                
            end
            end)
        end)
    end
end

function SWEP:PrimaryAttack()
    self:ThrowBall(1400)
end


function SWEP:SecondaryAttack()
    self:ThrowBall(200)
end

function SWEP:Reload()
    self:ThrowBall(200)
end

local v1 = game:GetService("ReplicatedStorage")
require(v1.Modules.AnimationLibrary)
local v_u_2 = require(v1.Modules.ItemLibrary)
require(v1.Modules.Utility)
return {
    {
        "Equip Cooldown",
        { "EquipCooldown" },
        "Time"
    },
    {
        "Move Speed",
        { "WalkSpeedMultiplier" },
        "Custom",
        function(_, p3)
            if p3 == 1 then
                return "Normal"
            end
            local v4 = p3 > 1 and "+" or ""
            local v5 = (p3 - 1) * 100 + 0.5
            return v4 .. math.floor(v5) .. "%"
        end
    },
    {
        "Double Jumps",
        { "MaxDoubleJumps" }
    },
    {
        "Damage",
        {
            "ShootDamage",
            "BurnDamage",
            "AttackDamage",
            "Damage"
        },
        "Custom",
        function(p6, p7)
            local v8 = v_u_2.Items[p6]
            local v9
            if v8.ShootPellets and v8.ShootPellets > 1 then
                v9 = string.format("%.1fx%s", p7 / v8.ShootPellets, v8.ShootPellets) or p7
            else
                v9 = p7
            end
            local v10 = not v8.RaycastDamageDropoffMultiplier or v8.ShootPellets and v8.ShootPellets > 1 and string.format("%.1fx%s", p7 / v8.ShootPellets * v8.RaycastDamageDropoffMultiplier, v8.ShootPellets) or (string.format("%.0f", p7 * v8.RaycastDamageDropoffMultiplier) or "")
            return v9 .. (v10 == "" and v10 and v10 or " \226\134\146 " .. v10)
        end
    },
    {
        "Damage Dropoff Range",
        { "RaycastDamageDropoffStartDistance" },
        "Custom",
        function(p11, p12)
            return p12 .. "<font weight=\"600\" size=\"6\">studs</font> \226\134\146 " .. v_u_2.Items[p11].RaycastDamageDropoffEndDistance .. "<font weight=\"600\" size=\"6\">studs</font>"
        end
    },
    {
        "Splash Radius",
        { "ShootExplosionRadius" },
        "Custom",
        function(_, p13)
            if p13 > 0 then
                return p13
            end
        end
    },
    {
        "Damage Per Second",
        { "DamagePerSecond" }
    },
    {
        "Afterburn Damage",
        { "AfterburnDamage" }
    },
    {
        "Splash Damage",
        { "SplashDamage" }
    },
    {
        "Explosion Damage",
        { "ExplosionDamage" }
    },
    {
        "Explosion Radius",
        { "ExplosionRadius" }
    },
    {
        "Cooldown",
        { "ShootCooldown", "AttackCooldown", "Cooldown" },
        "Time"
    },
    {
        "Spread",
        { "ShootSpread" },
        "Custom",
        function(_, p14)
            if p14 > 0 then
                return string.format("%.1f\194\176", p14)
            end
        end
    },
    {
        "Aim Spread",
        { "AimSpreadMultiplier" },
        "Custom",
        function(p15, p16)
            if p16 > 0 then
                return string.format("%.1f\194\176", v_u_2.Items[p15].ShootSpread * p16)
            end
        end
    },
    {
        "Bounces",
        { "RaycastBounceCount" },
        "Custom",
        function(_, p17)
            if p17 > 0 then
                return p17
            end
        end
    },
    {
        "Burst",
        { "ShootBurst" },
        "Custom",
        function(_, p18)
            if p18 > 1 then
                return p18
            end
        end
    },
    {
        "Burst Delay",
        { "ShootBurstCooldown" },
        "Custom",
        function(_, p19)
            if p19 > 0 then
                return string.format("%.2f", p19) .. "s"
            end
        end
    },
    {
        "Fan Cooldown",
        { "QuickShotCooldown" },
        "Time"
    },
    {
        "Attack Delay",
        { "AttackDelay" },
        "Custom",
        function(_, p20)
            if p20 > 0 then
                return string.format("%.2f", p20) .. "s"
            end
        end
    },
    {
        "Reach",
        { "Reach" }
    },
    {
        "Attack Reach",
        { "AttackReach" }
    },
    {
        "Heavy Damage",
        { "HeavyAttackDamage" }
    },
    {
        "Heavy Cooldown",
        { "HeavyAttackCooldown" },
        "Time"
    },
    {
        "Heavy Reach",
        { "HeavyAttackReach" }
    },
    {
        "Critical Hit Multiplier",
        { "CriticalMultiplier" },
        "Custom",
        function(_, p21)
            if p21 ~= 1 then
                return string.format("\195\151%.2f", p21)
            end
        end
    },
    {
        "Ammo",
        { "MaxAmmo" },
        "Custom",
        function(p22, p23)
            local v24 = (p22 == "Chainsaw" or p22 == "Flamethrower") and "\226\136\158" or ((v_u_2.Items[p22].MaxAmmoReserve or 0) > 0 and v_u_2.Items[p22].MaxAmmoReserve or nil)
            return (p23 >= (1 / 0) and "\226\136\158" or p23) .. (not v24 and "" or " <font weight=\"600\" size=\"9\">" .. v24 .. "</font>")
        end
    },
    {
        "Reload",
        { "ReloadActionTimestamp" },
        "Time"
    },
    {
        "Empty Reload",
        { "EmptyReloadActionTimestamp" },
        "Custom",
        function(p25, p26)
            local v27 = p26 - (v_u_2.Items[p25].ReloadActionTimestamp or 0)
            if math.abs(v27) > 0.001 then
                return string.format("%.2fs", p26)
            end
        end
    },
    {
        "Reload",
        { "ReloadType" },
        "Custom",
        function(_, p28)
            if p28 == "Segmented" then
                return p28
            end
        end
    },
    {
        "Ability Speed Boost",
        { "HoldSpeedBoostMax" },
        "Custom",
        function(_, p29)
            local v30 = p29 * 100 + 0.5
            return "+" .. math.floor(v30) .. "%"
        end
    },
    {
        "Ability Damage Per Second",
        { "HoldDamageMultiplier" },
        "Custom",
        function(p31, _)
            return v_u_2.Items[p31].AttackDamage * v_u_2.Items[p31].HoldDamageMultiplier
        end
    },
    {
        "Airblast Cooldown",
        { "AirblastCooldown" },
        "Time"
    },
    {
        "Long Heal",
        { "LongHeal", "Heal" }
    },
    {
        "Long Heal Time",
        { "LongActionTimestamp" },
        "Time"
    },
    {
        "Quick Heal",
        { "QuickHeal" }
    },
    {
        "Quick Heal Time",
        { "QuickActionTimestamp" },
        "Time"
    },
    {
        "Fire Radius",
        { "FireRadius" }
    },
    {
        "Fire Lifetime",
        { "FireDuration" },
        "Time"
    },
    {
        "Blind Duration",
        { "BlindDuration" },
        "Time"
    },
    {
        "Smoke Radius",
        { "SmokeRadius" }
    },
    {
        "Smoke Lifetime",
        { "SmokeDuration" },
        "Time"
    },
    {
        "Deflect Cooldown",
        { "DeflectCooldown" },
        "Time"
    },
    {
        "Deflect Duration",
        { "DeflectDuration" },
        "Time"
    },
    {
        "Blade Cooldown",
        { "BladeCooldown" },
        "Time"
    },
    {
        "Blade Reach",
        { "BladeReach" }
    },
    {
        "Blade Damage",
        { "BladeDamage" }
    },
    {
        "Blade Critical Damage",
        { "BladeCriticalDamage" }
    },
    {
        "Dash Cooldown",
        { "DashCooldown" },
        "Time"
    },
    {
        "Build Cooldown",
        { "BuildCooldown" },
        "Time"
    },
    {
        "Build Reach",
        { "BuildReach" }
    },
    {
        "Max Bricks",
        { "MaxBricks" }
    },
    {
        "Brick Lifetime",
        { "BrickLifetime" },
        "Time"
    },
    {
        "Full Charge Time",
        { "ChargeLevelTimestamps" },
        "Custom",
        function(_, p32)
            return string.format("%.2fs", p32[#p32])
        end
    },
    {
        "Full Charge Damage",
        { "ChargeLevelDamageMultipliers" },
        "Custom",
        function(p33, p34)
            return string.format("%.0fs", v_u_2.Items[p33].ShootDamage * p34[#p34])
        end
    },
    {
        "Charge Damage",
        { "ChargeDamage" }
    },
    {
        "Charge Knockback",
        { "ChargeKnockbackForce" }
    },
    {
        "Charge Time",
        { "ChargeIntro" },
        "Time"
    },
    {
        "Detonate Delay",
        { "DetonateDelay" },
        "Time"
    },
    {
        "Splash Radius",
        { "SplashRadius" }
    },
    {
        "Speed Boost",
        { "SpeedBoost" },
        "Custom",
        function(_, p35)
            local v36 = p35 * 100 + 0.5
            return "+" .. math.floor(v36) .. "%"
        end
    },
    {
        "Speed Duration",
        { "SpeedBoostDuration" },
        "Time"
    },
    {
        "Spin Damage",
        { "SpinDamage" }
    },
    {
        "Spin Radius",
        { "SpinRadius" }
    },
    {
        "Spin Cooldown",
        { "SpinCooldown" },
        "Time"
    },
    {
        "Charging Windup Time",
        { "ChargingWindUpLength" },
        "Time"
    },
    {
        "Charging Move Speed",
        { "ChargingSpeedBoost" },
        "Custom",
        function(_, p37)
            if p37 == 0 then
                return "Normal"
            end
            local v38 = p37 > 0 and "+" or ""
            local v39 = p37 * 100 + 0.5
            return v38 .. math.floor(v39) .. "%"
        end
    },
    {
        "Vortex Cooldown",
        { "VortexCooldown" },
        "Time"
    },
    {
        "Vortex Radius",
        { "VortexRadius" }
    },
    {
        "Vortex Lifetime",
        { "VortexLifetime" },
        "Time"
    },
    {
        "Knockback",
        { "KnockbackForce" }
    },
    {
        "Slow",
        { "SlowBoost" },
        "Custom",
        function(_, p40)
            local v41 = p40 * 100 + 0.5
            return math.floor(v41) .. "%"
        end
    },
    {
        "Slow Duration",
        { "SlowDuration" },
        "Time"
    },
    {
        "Max Freeze Duration",
        { "MaxFreezeDuration" },
        "Time"
    },
    {
        "Freeze Duration",
        { "FreezeDuration" },
        "Time"
    }
}
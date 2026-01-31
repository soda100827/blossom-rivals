--!strict

--// Services

--// Dependencies (require)

--// Constants

--// Types
export type CombatState = {
  client: any,
  logger: any,
  isAimbotEnabled: boolean,
  isSilentAimEnabled: boolean,
  isFovEnabled: boolean,
  isSilentAimFovEnabled: boolean,
  fovRadius: number,
  silentAimFovRadius: number,
  fovColor: Color3,
  silentAimFovColor: Color3,
  fovTransparency: number,
  silentAimFovTransparency: number,
  silentHitChance: number,
  targetPart: string,
  isManipulationEnabled: boolean,
  isAntiKatanaEnabled: boolean,
  isClosestPositionEnabled: boolean,
  closestPositionWhitelist: { string },
  isWallCheckEnabled: boolean,
  smoothness: number,
  isNoRecoilEnabled: boolean,
  isNoSpreadEnabled: boolean,
  isNoMuzzleFlashEnabled: boolean,
  attackCooldownMultiplier: number,
  isMeleeAttackCooldownEnabled: boolean,
  meleeAttackCooldownMultiplier: number,
  isMeleeSkillCooldownEnabled: boolean,
  meleeSkillCooldownMultiplier: number,
  isMeleeAuraEnabled: boolean,
  isTeleportAuraEnabled: boolean,
  isRagebotEnabled: boolean,
  ragebotTarget: Player?,
  ragebotHomeCFrame: CFrame?,
  -- Internal
  forcingAim: boolean?,
  target: Player?,
  silentTarget: Player?,
  targetLostAt: number?,
  silentTargetLostAt: number?,
  fovCircle: any?,
  silentAimFovCircle: any?,
  cameraController: any?,
  fighterController: any?,
  isRemoteHooked: boolean,
  isUtilityHooked: boolean,
  isCameraShakerHooked: boolean,
  isGunModsHooked: boolean,
  isInputLocked: boolean,
  mouseBehavior: Enum.MouseBehavior?,
  mouseDeltaSensitivity: number?,
}

export type CombatVisuals = {
  updateFovCircle: () -> (),
}

export type CombatFeature = {
  init: (self: CombatFeature, client: any) -> (),
  Destroy: (self: CombatFeature) -> (),
  setAimbotEnabled: (self: CombatFeature, isEnabled: boolean) -> (),
  setFovEnabled: (self: CombatFeature, isEnabled: boolean) -> (),
  setFovRadius: (self: CombatFeature, radius: number) -> (),
  setFovColor: (self: CombatFeature, color: Color3) -> (),
  setFovTransparency: (self: CombatFeature, transparency: number) -> (),
  setSmoothness: (self: CombatFeature, smoothness: number) -> (),
  setWallCheckEnabled: (self: CombatFeature, isEnabled: boolean) -> (),
  setSilentAimEnabled: (self: CombatFeature, isEnabled: boolean) -> (),
  setSilentAimFovEnabled: (self: CombatFeature, isEnabled: boolean) -> (),
  setSilentAimFovRadius: (self: CombatFeature, radius: number) -> (),
  setSilentAimFovColor: (self: CombatFeature, color: Color3) -> (),
  setSilentAimFovTransparency: (self: CombatFeature, transparency: number) -> (),
  setSilentHitChance: (self: CombatFeature, chance: number) -> (),
  setTargetPart: (self: CombatFeature, part: string) -> (),
  setManipulationEnabled: (self: CombatFeature, enabled: boolean) -> (),
  setAntiKatanaEnabled: (self: CombatFeature, enabled: boolean) -> (),
  setClosestPositionEnabled: (self: CombatFeature, enabled: boolean) -> (),
  setClosestPositionWhitelist: (self: CombatFeature, whitelist: { string }) -> (),
  setNoRecoilEnabled: (self: CombatFeature, isEnabled: boolean) -> (),
  setNoSpreadEnabled: (self: CombatFeature, isEnabled: boolean) -> (),
  setNoMuzzleFlashEnabled: (self: CombatFeature, isEnabled: boolean) -> (),
  setAttackCooldownMultiplier: (self: CombatFeature, multiplier: number) -> (),
  setMeleeAttackCooldownEnabled: (self: CombatFeature, isEnabled: boolean) -> (),
  setMeleeAttackCooldownMultiplier: (self: CombatFeature, multiplier: number) -> (),
  setMeleeSkillCooldownEnabled: (self: CombatFeature, isEnabled: boolean) -> (),
  setMeleeSkillCooldownMultiplier: (self: CombatFeature, multiplier: number) -> (),
  setMeleeAuraEnabled: (self: CombatFeature, isEnabled: boolean) -> (),
  setTeleportAuraEnabled: (self: CombatFeature, isEnabled: boolean) -> (),
  setRagebotEnabled: (self: CombatFeature, isEnabled: boolean) -> (),
}

--// Private state

--// Private helpers

--// Public API
return {}

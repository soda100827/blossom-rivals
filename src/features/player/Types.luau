--!strict

--// Services

--// Dependencies (require)

--// Constants

--// Types
export type InputState = {
  forward: number,
  back: number,
  left: number,
  right: number,
  up: number,
  down: number,
}

export type PlayerState = {
  client: any,
  logger: any,
  character: Model?,
  humanoid: Humanoid?,
  rootPart: BasePart?,
  isFlyEnabled: boolean,
  isNoclipEnabled: boolean,
  isWalkSpeedEnabled: boolean,
  isJumpPowerEnabled: boolean,
  walkSpeedValue: number,
  jumpPowerValue: number,
  flySpeed: number,
  defaultWalkSpeed: number?,
  defaultJumpPower: number?,
  defaultJumpHeight: number?,
  defaultUseJumpPower: boolean?,
  defaultAutoRotate: boolean?,
  defaultPlatformStand: boolean?,
  noclipParts: { [BasePart]: boolean },
  characterMaid: any,
  input: InputState,
}

export type PlayerFeature = {
  init: (self: PlayerFeature, client: any) -> (),
  cleanup: (self: PlayerFeature) -> (),
  setFlyEnabled: (self: PlayerFeature, isEnabled: boolean) -> (),
  setNoclipEnabled: (self: PlayerFeature, isEnabled: boolean) -> (),
  setWalkSpeedEnabled: (self: PlayerFeature, isEnabled: boolean) -> (),
  setJumpPowerEnabled: (self: PlayerFeature, isEnabled: boolean) -> (),
  setWalkSpeed: (self: PlayerFeature, value: number) -> (),
  setJumpPower: (self: PlayerFeature, value: number) -> (),
  setFlySpeed: (self: PlayerFeature, value: number) -> (),
}

--// Private state

--// Private helpers

--// Public API
return {}

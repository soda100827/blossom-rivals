--!strict

--// Services

--// Dependencies (require)

--// Constants

--// Types
export type VisualsSettings = {
  isEspEnabled: boolean,
  shouldShowNames: boolean,
  shouldShowWeapon: boolean,
  shouldShowDistance: boolean,
  shouldShowBoxes: boolean,
  shouldShowSkeleton: boolean,
  shouldShowHealthbar: boolean,
  shouldShowHighlight: boolean,
  shouldShowTeammates: boolean,
  boxColor: Color3,
  textColor: Color3,
  weaponColor: Color3,
  distanceColor: Color3,
  skeletonColor: Color3,
  healthbarColor: Color3,
  healthbarOutlineColor: Color3,
  nameOutlineColor: Color3,
  weaponOutlineColor: Color3,
  distanceOutlineColor: Color3,
  boxOutlineColor: Color3,
  skeletonOutlineColor: Color3,
  highlightFill: Color3,
  highlightOutline: Color3,
  boxThickness: number,
  skeletonThickness: number,
  textSize: number,
  shouldOutline: boolean,
  isCustomHitSoundEnabled: boolean,
  hitSoundId: string,
  isNoHurtEffectEnabled: boolean,
}

export type VisualsState = {
  client: any,
  logger: any,
  isEnabled: boolean,
  drawings: { [Player]: any },
  highlights: { [Player]: Highlight? },
  settings: VisualsSettings,
  overrideCheck: (() -> boolean)?,
  isEspPreviouslyEnabled: boolean,
  lastSkeletonUpdate: number,
  lastTextUpdate: number,
}

export type VisualsFeature = {
  init: (self: VisualsFeature, client: any) -> (),
  Destroy: (self: VisualsFeature) -> (),
  toggle: (self: VisualsFeature, isEnabled: boolean) -> (),
  setEspEnabled: (self: VisualsFeature, isEnabled: boolean) -> (),
  setShowNames: (self: VisualsFeature, shouldShow: boolean) -> (),
  setShowWeapon: (self: VisualsFeature, shouldShow: boolean) -> (),
  setShowDistance: (self: VisualsFeature, shouldShow: boolean) -> (),
  setShowBoxes: (self: VisualsFeature, shouldShow: boolean) -> (),
  setShowSkeleton: (self: VisualsFeature, shouldShow: boolean) -> (),
  setShowHealthbar: (self: VisualsFeature, shouldShow: boolean) -> (),
  setShowHighlight: (self: VisualsFeature, shouldShow: boolean) -> (),
  setShowTeammates: (self: VisualsFeature, shouldShow: boolean) -> (),
  setBoxColor: (self: VisualsFeature, color: Color3) -> (),
  setTextColor: (self: VisualsFeature, color: Color3) -> (),
  setWeaponColor: (self: VisualsFeature, color: Color3) -> (),
  setDistanceColor: (self: VisualsFeature, color: Color3) -> (),
  setSkeletonColor: (self: VisualsFeature, color: Color3) -> (),
  setHealthbarColor: (self: VisualsFeature, color: Color3) -> (),
  setHealthbarOutlineColor: (self: VisualsFeature, color: Color3) -> (),
  setNameOutlineColor: (self: VisualsFeature, color: Color3) -> (),
  setWeaponOutlineColor: (self: VisualsFeature, color: Color3) -> (),
  setDistanceOutlineColor: (self: VisualsFeature, color: Color3) -> (),
  setBoxOutlineColor: (self: VisualsFeature, color: Color3) -> (),
  setSkeletonOutlineColor: (self: VisualsFeature, color: Color3) -> (),
  setHighlightFill: (self: VisualsFeature, color: Color3) -> (),
  setHighlightOutline: (self: VisualsFeature, color: Color3) -> (),
  setBoxThickness: (self: VisualsFeature, value: number) -> (),
  setSkeletonThickness: (self: VisualsFeature, value: number) -> (),
  setTextSize: (self: VisualsFeature, value: number) -> (),
  setOutline: (self: VisualsFeature, isEnabled: boolean) -> (),
  setOverrideCheck: (self: VisualsFeature, check: () -> boolean) -> (),
  setCustomHitSoundEnabled: (self: VisualsFeature, isEnabled: boolean) -> (),
  setHitSoundId: (self: VisualsFeature, id: string) -> (),
  setNoHurtEffectEnabled: (self: VisualsFeature, isEnabled: boolean) -> (),
}

--// Private state

--// Private helpers

--// Public API
return {}

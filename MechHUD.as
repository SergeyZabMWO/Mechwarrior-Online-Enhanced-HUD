class MechHUD extends LayoutBase
{
   static var m_msClassName = "MechHUD";
   var m_HUDStyle = 0;
   function MechHUD()
   {
      super();
      this.m_bDisableLoadout = false;
      this.m_bInThirdPerson = false;  // default start FP or TP
      this.m_bLanceVisible = true;
      this.m_ScaleFactorX = 1;
      this.m_ScaleFactorY = 1;
      this.m_iLoadoutBottomPos = 488; // Loadout bottom position (As far as I remember, this parameter is responsible for the initial lowest point of weapon positioning, of which the maximum number is 16)
      this.m_iOldWidth = 1280;
      this.m_iOldHeight = 720;
      this.m_sTargetTagNarcCache = "";
      this.m_sTargetStatusesCache = "";
      this.m_sTargetDistanceCache = "";
      this.m_sTargetInfoCache = new Object();
      this.m_bPIPZoomVisible = false;
   }
   function InitLayout()
   {
      super.InitLayout();
      gfx.motion.Tween.init();
      this.m_mcThis = this.mcHud;
      this.m_mcTargetInfoUpdate = this.m_mcThis.createEmptyMovieClip("targetInfo",900);
      this.m_mcTargetTagNarcUpdate = this.m_mcThis.createEmptyMovieClip("targetInfo",901);
      this.m_mcTargetStatusesUpdate = this.m_mcThis.createEmptyMovieClip("targetInfo",902);
      this.m_mcTargetDistanceUpdate = this.m_mcThis.createEmptyMovieClip("targetInfo",903);
      this.m_mcTargetInfoUpdate._alpha = 0;
      this.m_mcTargetTagNarcUpdate._alpha = 0;
      this.m_mcTargetStatusesUpdate._alpha = 0;
      this.m_mcTargetDistanceUpdate._alpha = 0;
      this.m_mcShutdownTxtContainer = this.mcShutdownTxtContainer;
      this.m_mcShutdownTxt = this.m_mcShutdownTxtContainer.mcShutdownTxtBox;
      this.m_mcShutdownTxt.SetColor(11078154);
      this.m_mcShutdownTxt.SetText("@HUD_Shutdown");
      this.m_mcOverHeatingTxt = this.m_mcShutdownTxtContainer.mcOverHeatingTxtBox;
      this.m_mcOverHeatingTxt.SetColor(11078154);
      this.m_mcOverHeatingTxt.SetText("@HUD_Overheated");
      var _loc3_ = new TextFormat();
      _loc3_.align = "center";
      this.m_mcOverHeatingTxt.SetTextFormat(_loc3_);
      this.m_mcShutdownTxt.SetTextFormat(_loc3_);
      false;
      this.m_mcShutdownTxtContainer._visible = false;
      this.m_mcWeaponGroupStatus = this.m_mcThis.mcGroupStatus;
      this.m_mcWeaponGroupStatus.Init(this.m_HUDStyle);
      this.m_origX = this.m_mcWeaponGroupStatus._x;
      this.m_mcCrosshairs = this.m_mcThis.mcCrosshair;
      this.m_mcCrosshairs.Init(this.m_HUDStyle,this.m_mcWeaponGroupStatus);
      this.m_mcRangeFinder = this.m_mcThis.mcRange;
      this.m_mcRangeFinder.Init(HUDStyleEnum.DEFAULT_STYLE);
      this.m_mcCompass = this.m_mcThis.mcCompass;
      this.m_mcCompass.Init(HUDStyleEnum.DEFAULT_STYLE);
      this.m_mcPitchIndicator = this.m_mcThis.mcPitch;
      this.m_mcPitchIndicator.Init(HUDStyleEnum.DEFAULT_STYLE);
      this.m_mcDirectionalDam = this.m_mcPitchIndicator.mcDirectionalDam;
      this.m_mcDirectionalDam.Init(HUDStyleEnum.DEFAULT_STYLE);
      this.m_mcTopHUD = this.m_mcThis.mcTopHUD;
      this.m_DetailedDam = this.m_mcTopHUD.mcDetailedDam;
      this.m_DetailedDam.Init(this.m_HUDStyle);
      this.m_DetailedDam._visible = false;
      this.m_mcTextWarnings = this.m_mcTopHUD.mcTextWarnings;
      this.m_mcTextWarnings.Init(HUDStyleEnum.DEFAULT_STYLE);
      this.m_mcCountdownTimer = this.m_mcTopHUD.mcCountdown;
      this.m_mcCountdownTimer.Init();
      this.InitGameTimer(this.m_mcTopHUD.mcGameTimer,HUDStyleEnum.DEFAULT_STYLE);
      this.m_StatusBar = this.m_mcThis.mcStatusBar;
      this.m_StatusBar.Init(HUDStyleEnum.DEFAULT_STYLE);
      this.m_mcBotHUD = this.m_mcThis.mcBotHUD;
      this.m_mcWeaponLoadContainer = this.m_mcBotHUD.mcLoadoutContainer;
      this.m_mcWeaponLoadout = this.m_mcWeaponLoadContainer.mcWeaponLoadout;
      this.m_mcWeaponLoadout.Init(this.m_HUDStyle,gfx.utils.Delegate.create(this,this.LoadoutResizedCB),this.m_mcWeaponGroupStatus);
      this.m_bDisableLoadout = false;
      this.m_ThrottleInd = this.m_mcBotHUD.mcThrottle;
      this.m_ThrottleInd.Init(HUDStyleEnum.DEFAULT_STYLE);
      this.m_HeatMeter = this.m_mcBotHUD.mcHeat;
      this.m_HeatMeter.Init(this.m_HUDStyle);
      this.m_mcDamageIndicator = this.m_mcBotHUD.mcDamageIndicator;
      this.m_mcDamageIndicator.Init(this.m_HUDStyle,true,DamageIndicator.k_SELF);
      this.m_TargetManager = this.m_mcThis.mcTargetMan;
      this.m_TargetManager.InitManager(this.m_mcThis.mcTargets);
      this.m_BattleGrid = this.m_mcThis.mcBattleGrid;
      this.m_BattleGrid.Init(this.m_HUDStyle,gfx.utils.Delegate.create(this,this.OnBGCloseAnimCompleteCB));
      this.m_iBattleGridY = this.m_BattleGrid._y;
      this.m_mcBGTweener = this.createEmptyMovieClip("BGTweener",1000);
      this.m_mcBGTweener._alpha = 0;
      this.m_mcBGTimer = this.createEmptyMovieClip("BGTimer",1001);
      this.m_mcBGTimer._alpha = 0;
      var _loc4_ = this.m_mcTopHUD.mcLanceCont;
      this.m_LancemateInfo = _loc4_.mcLancemateInfo;
      this.m_LancemateInfo.Init();
      this.m_EjectWarning = this.m_mcThis.mcEjectWarning;
      this.m_EjectWarning.Init();
      this.m_VoipStatus = this.m_mcThis.mcVoipStatus;
      this.m_VoipStatus.Init();
      this.m_MASCMeter = this.m_mcThis.mcMASCMeter;
      this.m_MASCMeter.Init(this.m_HUDStyle);
      this.m_mcTurnSignals = this.m_mcBotHUD.mcTurnSignals;
      this.m_mcTurnSignals.Init();
      this.InitInGameChat(this.mcInGameChat,HUDStyleEnum.DEFAULT_STYLE);
      this.InitPlayerFeedback(this.mcPlayerFeedback,HUDStyleEnum.DEFAULT_STYLE);
      this.m_mcDamEffect = this.mcDamEffect;
      this.m_mcDamEffect.stop();
      this.m_mcDamEffect.mcDam1.mcTarDam.stop();
      this.m_mcRewardDisplay = this.m_mcThis.mcRewardDisplay;
      this.m_mcRewardDisplay.Init(this.m_HUDStyle);
      this.m_mcShade = this.mcShade;
      this.m_mcShade._visible = false;
      this.m_mcProgressMeter = this.m_mcThis.mcProgressMeter;
      this.m_mcProgressMeter.Init();
      this.Setup3D();
      this.m_mcCommandWheel = this.m_mcThis.mcCommandWheel;
      this.m_mcCommandWheel.Init(gfx.utils.Delegate.create(this,this.OnCommandWheelHide));
      fscommand("OnLoaded");
      HUDComponentHighlight.DisableAll();
   }
   function Spectator()
   {
      this.m_mcWeaponLoadout.SpectatorMode();
      fscommand("SpecMode");
   }
   function Setup3D()   // These are the window positioning settings and their visual tilt.
   {
      this._perspfov = 70;
      this._xscale = 100;
      this._yscale = 100;
      this._zScale = 0.0001;  // It is better not to set 0, as far as I remember there will be an incorrect display or a mismatch of aiming.
      this.m_mcCrosshairs._zScale = 0;   // Scale Crosshair
      this.m_mcCrosshairs._xScale = 25; 
      this.m_mcCrosshairs._yScale = 25;
      this.m_mcCrosshairs._xrotation = null;
      this.m_mcCrosshairs._yrotation = null;
      this.m_mcCrosshairs._y = null;
      this.m_mcCrosshairs._y = null;
      this.m_ThrottleInd._xrotation = 0;  // Throttle
      this.m_ThrottleInd._xscale = 90;
      this.m_ThrottleInd._yscale = 80;
      this.m_ThrottleInd._y = 305;
      this.m_ThrottleInd._x = 539;
      this.m_HeatMeter._xrotation = 0;  // HeatMeter
      this.m_HeatMeter._xscale = 90;
      this.m_HeatMeter._yscale = 80;
      this.m_HeatMeter._y = 305;
      this.m_HeatMeter._x = 802;
      this.m_mcDamageIndicator._xscale = 80;  // Our Mech paperdoll
      this.m_mcDamageIndicator._yscale = 80;
      this.m_mcDamageIndicator._xrotation = 0;
      this.m_mcDamageIndicator._yrotation = 0;
      this.m_mcDamageIndicator._rotation = 0;
      this.m_mcDamageIndicator._y = 297;
      this.m_mcDamageIndicator._x = 113;
      this.m_LancemateInfo._xscale = 80; // Lance
      this.m_LancemateInfo._yscale = 80;
      this.m_LancemateInfo._xrotation = 0;
      this.m_LancemateInfo._yrotation = 0;
      this.m_LancemateInfo._rotation = 0;
      this.m_LancemateInfo._y = -17;
      this.m_LancemateInfo._x = -72;
      this.m_mcCountdownTimer._xrotation = 0;  // Game timer on Top
      this.m_mcCountdownTimer._yrotation = 0;
      this.m_mcCountdownTimer._rotation = 0;
      this.m_mcWeaponLoadContainer._xscale = 80;  // Our Loadout (Weapons)
      this.m_mcWeaponLoadContainer._yscale = 80;
      this.m_mcWeaponLoadContainer._xrotation = 0;
      this.m_mcWeaponLoadContainer._yrotation = 0;
      this.m_mcWeaponLoadContainer._rotation = 0;
      this.m_mcWeaponLoadContainer._x = 1180;
      this.m_DetailedDam._xscale = 80;   // Enemy Paperdoll
      this.m_DetailedDam._yscale = 80;
      this.m_DetailedDam._xrotation = 0;
      this.m_DetailedDam._yrotation = 0;
      this.m_DetailedDam._rotation = 0;
      this.m_DetailedDam._y = 65;
      this.m_DetailedDam._x = 1190;
      this.m_mcThis.mcMates._xscale = null; // ...Forgot
      this.m_mcThis.mcMates._yscale = null;
      this.m_mcThis.mcMates._x = null;
      this.m_mcThis.mcMates._y = null;
      this.m_mcThis.mcMates._xrotation = 0;
      this.m_mcThis.mcMates._yrotation = 0;
      this.m_mcThis.mcMates._rotation = 0;
      this.m_BattleGrid._xrotation = 0;   // Battlegrid
      this.m_BattleGrid._yrotation = 0;
      this.m_BattleGrid._rotation = 0;
      this.m_BattleGrid._xscale = 110;
      this.m_BattleGrid._yscale = 110;
      this.m_BattleGrid._zScale = 0.0001;
      this.m_BattleGrid.m_fFeedbackMessagingFn = gfx.utils.Delegate.create(this,this.OnCommandMessageEvent);
   }
   function ResizeHUD(a_iScreenWidth, a_iScreenHeight)  // sets the zoom multiplier depending on your screen resolution
   {
      var _loc2_ = 1.7777777777777777;
      var _loc5_ = a_iScreenWidth / a_iScreenHeight;  // 1920/1080=1,777777777777778 
      var _loc4_ = a_iScreenWidth;   // 1920
      var _loc3_ = a_iScreenHeight; // Example: 1080, below is the scaling formula, we can remove it completely
      this.m_ScaleFactorX = 1;
      this.m_ScaleFactorY = 1;
      if(_loc2_ < _loc5_)
      {
         _loc4_ = _loc3_ * _loc2_;
         this.m_ScaleFactorX = a_iScreenWidth / _loc4_;
      }
      else if(_loc2_ > _loc5_)
      {
         _loc3_ = _loc4_ / _loc2_;
         this.m_ScaleFactorY = a_iScreenHeight / _loc3_;
      }
      if(_loc5_ == 1.7777777777777777)
      {
         this.m_ScaleFactorX = 1;
         this.m_ScaleFactorY = 1;
      }
      this.mcBGTop._y = -360 * this.m_ScaleFactorY;  // Adjusting the location. Depends on scaling
      this.mcBGBot._y = 360 * this.m_ScaleFactorY;
      this.m_mcTopHUD._y = -360 * this.m_ScaleFactorY;
      this.m_mcBotHUD._y = 360 * this.m_ScaleFactorY;
      this.m_InGameChat._y = -175 * this.m_ScaleFactorY;
      this.m_PlayerFeedback._y = 130 * this.m_ScaleFactorY;
      this.m_BattleGrid._x = 0;
      this.m_iBattleGridY = 262 * this.m_ScaleFactorY;
      this.m_BattleGrid._y = !this.m_BattleGrid.IsInMinimapMode() ? 0 : this.m_iBattleGridY;
      this.m_BattleGrid.OnResize(a_iScreenWidth,a_iScreenHeight);
      this.m_mcShade._x = -640 * this.m_ScaleFactorX;
      this.m_mcShade._y = -360 * this.m_ScaleFactorY;
      this.m_mcShade._width = 1280 * this.m_ScaleFactorX;
      this.m_mcShade._height = 720 * this.m_ScaleFactorY;
   }
   function OnAction(a_sAction, a_iActivationEvent)
   {
      if(!this.m_bDisableLoadout)
      {
         this.m_mcWeaponLoadout.OnAction(a_sAction,a_iActivationEvent);
      }
      if(this.m_mcCommandWheel._visible)
      {
         this.m_mcCommandWheel.OnAction(a_sAction,a_iActivationEvent);
      }
      this.m_BattleGrid.OnAction(a_sAction,a_iActivationEvent);
   }
   function Set3rdPersonMode(a_bIn3rdPerson)  // can turn on Lance and Minimap in TP
   {
      if(this.NullCheck(this.m_LancemateInfo) && this.NullCheck(this.m_BattleGrid) && this.NullCheck(a_bIn3rdPerson))
      {
         return undefined;
      }
      this.m_bInThirdPerson = a_bIn3rdPerson;
      this.m_LancemateInfo._visible = !this.m_bInThirdPerson && this.m_bLanceVisible;
      this.m_BattleGrid._visible = !this.m_bInThirdPerson;
   }
   function SetGameMode(a_Mode)
   {
      this.m_mcRewardDisplay.SetGameMode(a_Mode);
      this.m_BattleGrid.SetGameMode(a_Mode);
      super.SetGameMode(a_Mode);
   }
   function OnGameModeChanged(a_Mode)
   {
      this.m_mcRewardDisplay.SetGameMode(a_Mode);
      super.OnGameModeChanged(a_Mode);
   }
   function StartUpHUD()
   {
      this.m_mcShutdownTxtContainer._visible = false;
      this.gotoAndPlay("startup");
      this.m_ThrottleInd.gotoAndPlay("intro");
      this.m_HeatMeter.gotoAndPlay("intro");
      this.m_mcDamageIndicator.gotoAndPlay("intro");
      this.m_mcWeaponLoadout.gotoAndPlay("intro");
      this.m_mcTopHUD.gotoAndPlay("intro");
      this.m_mcBotHUD.gotoAndPlay("intro");
   }
   function ShutdownHUD()
   {
      this.m_mcShutdownTxtContainer._visible = false;
      this.gotoAndPlay("shutdown");
      this.m_ThrottleInd.gotoAndPlay("outro");
      this.m_HeatMeter.gotoAndPlay("outro");
      this.m_mcDamageIndicator.gotoAndPlay("outro");
      this.m_mcWeaponLoadout.gotoAndPlay("outro");
      this.m_mcTopHUD.gotoAndPlay("outro");
      this.m_mcBotHUD.gotoAndPlay("outro");
      this.m_EjectWarning.HideWarning();
      this.m_VoipStatus.ClearStatus();
   }
   function StartOverheatingHUD()
   {
      this.m_mcShutdownTxtContainer._visible = true;
      this.gotoAndPlay("shutdownToOverheat");
      this.m_ThrottleInd.gotoAndPlay("outro");
      this.m_HeatMeter.gotoAndPlay("outro");
      this.m_mcDamageIndicator.gotoAndPlay("outro");
      this.m_mcWeaponLoadout.gotoAndPlay("outro");
      this.m_mcTopHUD.gotoAndPlay("outro");
      this.m_mcBotHUD.gotoAndPlay("outro");
      this.m_EjectWarning.HideWarning();
      this.m_VoipStatus.ClearStatus();
   }
   function StopOverheatingHUD()
   {
      this.StartUpHUD();
   }
   function UpdateHeading(a_iLookHeading, a_iFeetHeading, a_WorldPosX, a_WorldPosY)
   {
      this.m_mcCompass.SetHeading(a_iLookHeading,a_WorldPosX,a_WorldPosY);
      this.m_mcCompass.SetFeetHeading(a_iFeetHeading,a_iLookHeading);
      this.m_BattleGrid.UpdateTorsoRotation(a_iLookHeading,a_iLookHeading - a_iFeetHeading);
      this.m_mcTurnSignals.UpdateArrows(a_iLookHeading,a_iFeetHeading);
   }
   function SetVisionState(a_iZoomState, a_sZoomFactorText, a_iVisionMode, a_iTexID)
   {
      this.m_bPIPZoomVisible = a_iZoomState == VisionStates.ZOOM4 || a_iZoomState == VisionStates.ZOOM8 || a_iZoomState == VisionStates.ZOOM12;
      this.m_mcPitchIndicator.SetVisionState(a_iZoomState,a_sZoomFactorText,a_iVisionMode,a_iTexID);
   }
   function UpdateFallDamageIndicator(a_fFts, fallDamageText)
   {
      this.m_mcPitchIndicator.SetFallDamageIndicator(a_fFts,fallDamageText);
   }
   function AddCompassMarker(a_iID, a_iRot, a_bTargeted, a_iAllegiance)
   {
   }
   function AddBaseCompassMarker(a_iID, a_iRot, a_iAllegiance, a_Text)
   {
   }
   function AddObjectiveMarker(a_Id, a_Rot, a_Type, a_WaypointName)
   {
   }
   function AddOrderCompassMarker(a_Id, a_MarkerType, a_Rot, a_Color, a_CommandStr, a_Icon, a_bTerrainMarker)
   {
   }
   function UpdateOrderCompassMarker(a_Id, a_Rot)
   {
   }
   function RemoveOrderCompassMarker(a_Id)
   {
   }
   function RemoveCompassMarker(a_iID)
   {
   }
   function OnCommandMessageEvent(evt)
   {
      if(this.m_BattleGrid.m_iState == BattleGridState.MINI_MAP)
      {
         if(this.NullCheck(this.m_PlayerFeedback) && this.NullCheck(evt.messageTxt) && this.NullCheck(evt.icon) && this.NullCheck(evt.txtcolor))
         {
            return undefined;
         }
         this.m_PlayerFeedback.AddCommandText(evt.messageTxt,"",evt.icon,evt.txtcolor);
      }
   }
   function UpdateMissileLock(a_PerLocked, a_bLockConfirmed)
   {
      if(this.NullCheck(this.m_mcCrosshairs) && this.NullCheck(a_PerLocked) && this.NullCheck(a_bLockConfirmed))
      {
         return undefined;
      }
      this.m_mcCrosshairs.SetMissileLock(a_PerLocked,a_bLockConfirmed);
   }
   function UpdateCrosshairPosition(a_fLookX, a_fLookY, a_fTorsoX, a_fTorsoY, a_fRange, a_fDepth)
   {
      if(this.NullCheck(this.m_mcCrosshairs) && this.NullCheck(a_fLookX) && this.NullCheck(a_fLookY) && this.NullCheck(a_fTorsoX) && this.NullCheck(a_fTorsoY) && this.NullCheck(a_fRange))
      {
         return undefined;
      }
      var _loc4_ = this._x + this.m_mcThis._x;
      var _loc3_ = this._y + this.m_mcThis._y;
      a_fLookX -= _loc4_;
      a_fLookY -= _loc3_;
      a_fTorsoX -= _loc4_;
      a_fTorsoY -= _loc3_;
      this.m_mcCrosshairs.SetCrosshairXYZ(a_fLookX,a_fLookY,a_fTorsoX,a_fTorsoY,a_fDepth);
      this.m_mcRangeFinder.SetRange(a_fRange,a_fDepth);
      this.m_mcWeaponGroupStatus.UpdateDepth(a_fDepth);
      this.m_mcWeaponLoadout.SetRange(a_fRange);
      this.m_MASCMeter.UpdateDepth(a_fDepth);
   }
   function PlayHitFeedbackAnim()
   {
      if(this.NullCheck(this.m_mcCrosshairs))
      {
         return undefined;
      }
      this.m_mcCrosshairs.PlayHitFeedbackAnim();
   }
   function UpdateRangeFinder(a_fRange)
   {
   }
   function UpdateEngineThrottle(a_iSpdPer, a_bIsReverse)
   {
      if(this.NullCheck(this.m_ThrottleInd) && this.NullCheck(a_iSpdPer) && this.NullCheck(a_bIsReverse))
      {
         return undefined;
      }
      this.m_ThrottleInd.SetCurrentThrottle(a_iSpdPer,a_bIsReverse);
   }
   function UpdateEnginePower(a_iSpdPer, a_fMASCPer, a_bIsReverse)
   {
      if(this.NullCheck(this.m_ThrottleInd) && this.NullCheck(a_iSpdPer) && this.NullCheck(a_fMASCPer) && this.NullCheck(a_bIsReverse))
      {
         return undefined;
      }
      this.m_ThrottleInd.SetCurrentPower(a_iSpdPer,a_fMASCPer,a_bIsReverse);
   }
   function UpdateVelocityReadout(a_fVelo)
   {
      if(this.NullCheck(this.m_ThrottleInd) && this.NullCheck(a_fVelo))
      {
         return undefined;
      }
      this.m_ThrottleInd.SetVelocityReadout(a_fVelo);
   }
   function UpdateJumpJetFuel(a_fFuelPer)
   {
      if(this.NullCheck(this.m_ThrottleInd) && this.NullCheck(a_fFuelPer))
      {
         return undefined;
      }
      this.m_ThrottleInd.UpdateJumpJet(a_fFuelPer);
   }
   function UpdatePitchAngle(a_iPitchAngle, a_iMaxAngle)
   {
      if(this.NullCheck(this.m_mcPitchIndicator) && this.NullCheck(a_iPitchAngle) && this.NullCheck(a_iMaxAngle))
      {
         return undefined;
      }
      this.m_mcPitchIndicator.SetPitchAngle(a_iPitchAngle,a_iMaxAngle);
   }
   function SetMechName(a_sName)
   {
      if(this.NullCheck(this.m_mcDamageIndicator) && this.NullCheck(a_sName))
      {
         return undefined;
      }
      this.m_mcDamageIndicator.SetMechName(a_sName);
   }
   function UpdateDamageIndicator(a_DataArr)
   {
      if(this.NullCheck(this.m_mcDamageIndicator) && this.NullCheck(a_DataArr))
      {
         return undefined;
      }
      var _loc5_ = undefined;
      var _loc6_ = undefined;
      var _loc4_ = undefined;
      var _loc3_ = a_DataArr.split("|");
      var _loc2_ = 0;
      while(_loc2_ < _loc3_.length)
      {
         _loc5_ = _loc3_[_loc2_];
         _loc6_ = _loc3_[_loc2_ + 1];
         if(_loc3_[_loc2_ + 2] == "0")
         {
            _loc4_ = false;
         }
         else
         {
            _loc4_ = true;
         }
         this.m_mcDamageIndicator.SetDamage(_loc5_,_loc6_,_loc4_);
         _loc2_ += 3;
      }
   }
   function PlayWarning(a_sVideo)
   {
      if(this.NullCheck(this.m_mcDamageIndicator) && this.NullCheck(a_sVideo))
      {
         return undefined;
      }
      this.m_mcDamageIndicator.PlayWarning(a_sVideo);
   }
   function ShowOOBWarning(a_iTimeRemaining, a_iID)
   {
      if(this.NullCheck(this.m_mcTextWarnings) && this.NullCheck(a_iTimeRemaining) && this.NullCheck(a_iID))
      {
         return undefined;
      }
      this.m_mcTextWarnings.ShowOOBWarning(a_iTimeRemaining,a_iID);
   }
   function ShowTextWarning(a_sText, a_iLine, a_iID)
   {
      if(this.NullCheck(this.m_mcTextWarnings) && this.NullCheck(a_sText) && this.NullCheck(a_iLine) && this.NullCheck(a_iID))
      {
         return undefined;
      }
      this.m_mcTextWarnings.ShowWarning(a_sText,a_iLine,a_iID);
   }
   function StopTextWarning(a_iID)
   {
      if(this.NullCheck(this.m_mcTextWarnings) && this.NullCheck(a_iID))
      {
         return undefined;
      }
      this.m_mcTextWarnings.StopWarning(a_iID);
   }
   function UpdateHeatMeter(a_iCurHeat, a_iMaxHeat)
   {
      if(this.NullCheck(this.m_HeatMeter) && this.NullCheck(a_iCurHeat) && this.NullCheck(a_iMaxHeat))
      {
         return undefined;
      }
      this.m_HeatMeter.UpdateHeatMeter(a_iCurHeat,a_iMaxHeat);
   }
   function InitCoolantMeter(a_iNumCoolants, a_iNumAdvanced)
   {
      if(this.NullCheck(this.m_HeatMeter) && this.NullCheck(a_iNumCoolants) && this.NullCheck(a_iNumAdvanced))
      {
         return undefined;
      }
      this.m_HeatMeter.InitCoolantMeter(a_iNumCoolants,a_iNumAdvanced);
   }
   function UpdateCoolantMeter(a_fPercent)
   {
      if(this.NullCheck(this.m_HeatMeter) && this.NullCheck(a_fPercent))
      {
         return undefined;
      }
      this.m_HeatMeter.UpdateCoolantMeter(a_fPercent);
   }
   function ShowGraphicWarning(a_sWarningPath)
   {
      var _loc1_ = 0;
   }
   function SetWeaponLoadoutInfo(a_sAgs)
   {
      if(this.NullCheck(this.m_mcWeaponLoadout) && this.NullCheck(a_sAgs))
      {
         return undefined;
      }
      var _loc5_ = a_sAgs.split("|");
      var _loc6_ = _loc5_.length;
      var _loc2_ = 0;
      while(_loc2_ < _loc6_)
      {
         var _loc4_ = String(_loc5_[_loc2_]);
         var _loc3_ = _loc4_.split(":");
         this.m_mcWeaponLoadout.UpdateWeapon(_loc3_[0],_loc3_);
         _loc2_ = _loc2_ + 1;
      }
   }
   function SetStealthArmourLoadoutInfo(a_iID, a_sName, a_bDestroyed, a_bActive, a_Cooldown)
   {
      if(this.NullCheck(this.m_mcWeaponLoadout) && this.NullCheck(a_iID) && this.NullCheck(a_sName))
      {
         return undefined;
      }
      var _loc2_ = [a_sName,a_bDestroyed,a_bActive,a_Cooldown];
      this.m_mcWeaponLoadout.UpdateStealthArmour(a_iID,_loc2_);
   }
   function SetECMLoadoutInfo(a_iID, a_sName, a_bDestroyed, a_bDisruptionMode, a_fEffectiveRange)
   {
      if(this.NullCheck(this.m_mcWeaponLoadout) && this.NullCheck(a_iID) && this.NullCheck(a_sName))
      {
         return undefined;
      }
      var _loc2_ = [a_sName,a_bDestroyed,a_bDisruptionMode,a_fEffectiveRange];
      this.m_mcWeaponLoadout.UpdateECM(a_iID,_loc2_);
   }
   function SetAMSLoadoutInfo(a_iID, a_sName, a_iAmmo, a_fMaxRange, a_iNumActive, a_bEnabled)
   {
      if(this.NullCheck(this.m_mcWeaponLoadout) && this.NullCheck(a_iID) && this.NullCheck(a_sName))
      {
         return undefined;
      }
      var _loc2_ = [a_sName,a_iAmmo,a_fMaxRange,a_iNumActive,a_bEnabled];
      this.m_mcWeaponLoadout.UpdateAMS(a_iID,_loc2_);
   }
   function SetLaserAMSLoadoutInfo(a_iID, a_sName, a_fMaxRange, a_iNumActive, a_bEnabled)
   {
      if(this.NullCheck(this.m_mcWeaponLoadout) && this.NullCheck(a_iID) && this.NullCheck(a_sName))
      {
         return undefined;
      }
      var _loc2_ = [a_sName,a_fMaxRange,a_iNumActive,a_bEnabled];
      this.m_mcWeaponLoadout.UpdateLaserAMS(a_iID,_loc2_);
   }
   function SetUnderEnemyECM(a_bUnderECM)
   {
      if(this.NullCheck(this.m_BattleGrid) && this.NullCheck(this.m_TargetManager) && this.NullCheck(this.m_DetailedDam) && this.NullCheck(a_bUnderECM))
      {
         return undefined;
      }
      var _loc2_ = false;
      if(a_bUnderECM == "1")
      {
         _loc2_ = true;
      }
      this.m_BattleGrid.SetUnderEnemyECM(_loc2_);
      this.m_TargetManager.SetUnderEnemyECM(_loc2_);
      if(this.m_bPIPZoomVisible)
      {
         this.m_mcPitchIndicator.SetUnderEnemyECM(_loc2_);
      }
      this.m_DetailedDam.SetUnderEnemyECM(_loc2_);
   }
   function LoadoutResizedCB()
   {
      this.m_mcWeaponLoadContainer._y = this.m_iLoadoutBottomPos - this.m_mcWeaponLoadContainer._height / 2;
      var _loc2_ = this.m_mcBotHUD._y + this.m_mcWeaponLoadContainer._y;
      getURL("FSCommand:OnLoadoutResized",[_loc2_]);
   }
   function SetWeaponGroupStatus(a_DataArr)
   {
      if(this.NullCheck(this.m_mcWeaponGroupStatus) && this.NullCheck(a_DataArr))
      {
         return undefined;
      }
      var _loc3_ = a_DataArr.split("|");
      var _loc4_ = _loc3_.length;
      var _loc2_ = 0;
      while(_loc2_ < _loc4_)
      {
         this.m_mcWeaponGroupStatus.SetGroupStatus(_loc3_[_loc2_],_loc3_[_loc2_ + 1]);
         _loc2_ += 2;
      }
   }
   function SetChainfireStatus(a_iGroupIdx, a_bOn)
   {
      if(this.NullCheck(this.m_mcWeaponLoadout) && this.NullCheck(a_iGroupIdx) && this.NullCheck(a_bOn))
      {
         return undefined;
      }
      this.m_mcWeaponLoadout.SetChainfireStatus(a_iGroupIdx,Boolean(a_bOn));
   }
   function SetNextChainFireWeapon(a_iGroupIdx, a_iWeaponId)
   {
      if(this.NullCheck(this.m_mcWeaponLoadout) && this.NullCheck(a_iGroupIdx) && this.NullCheck(a_iWeaponId))
      {
         return undefined;
      }
      this.m_mcWeaponLoadout.SetNextChainFireWeapon(a_iGroupIdx,a_iWeaponId);
   }
   function AddDamageDirection(a_iRot)
   {
      if(this.NullCheck(this.m_mcDirectionalDam) && this.NullCheck(a_iRot))
      {
         return undefined;
      }
      this.m_mcDirectionalDam.AddDirection(a_iRot,1);
   }
   function PlayEffect(a_iEffect)
   {
      if(this.NullCheck(this.m_mcDamEffect) && this.NullCheck(a_iEffect))
      {
         return undefined;
      }
      switch(a_iEffect)
      {
         case HUDEffects.DAMAGE:
            if(this.m_mcDamEffect["mcDam" + a_iEffect]._currentFrame == 1)
            {
               this.m_mcDamEffect["mcDam" + a_iEffect].gotoAndPlay(1);
            }
            if(this.m_DetailedDam._visible)
            {
               if(this.m_mcDamEffect["mcDam" + a_iEffect].mcTarDam._currentFrame == 1)
               {
                  this.m_mcDamEffect["mcDam" + a_iEffect].mcTarDam.gotoAndPlay(1);
               }
            }
            break;
         case HUDEffects.STARTUP:
            this.StartUpHUD();
            break;
         case HUDEffects.SHUTDOWN:
            this.ShutdownHUD();
            break;
         case HUDEffects.START_OVERHEAT:
            this.StartOverheatingHUD();
            break;
         case HUDEffects.STOP_OVERHEAT:
            this.StopOverheatingHUD();
      }
   }
   function AddStatusEffect(a_StatusID)
   {
      if(this.NullCheck(this.m_StatusBar) && this.NullCheck(a_StatusID))
      {
         return undefined;
      }
      this.m_StatusBar.AddStatusEffect(a_StatusID);
   }
   function RemoveStatusEffect(a_StatusID)
   {
      if(this.NullCheck(this.m_StatusBar) && this.NullCheck(a_StatusID))
      {
         return undefined;
      }
      this.m_StatusBar.RemoveStatusEffect(a_StatusID);
   }
   function UpdateScoutingStatus(a_StatusId, a_eAffinity, a_TimePct)
   {
      this.m_StatusBar.UpdateScoutingStatus(a_StatusId,a_eAffinity,a_TimePct);
   }
   function InitConsumableStatus(a_iStatusID, a_iSlot, a_iInitialState, a_Key, a_bIsMC)
   {
      if(this.NullCheck(this.m_StatusBar) && this.NullCheck(a_iStatusID) && this.NullCheck(a_iSlot) && this.NullCheck(a_iInitialState) && this.NullCheck(a_Key) && this.NullCheck(a_bIsMC))
      {
         return undefined;
      }
      this.m_StatusBar.InitConsumableStatus(a_iStatusID,a_iSlot,a_iInitialState,a_Key,a_bIsMC);
   }
   function UpdateConsumableStatus(a_iStatusID, a_iState, a_fTimer)
   {
      if(this.NullCheck(this.m_StatusBar) && this.NullCheck(a_iStatusID) && this.NullCheck(a_iState) && this.NullCheck(a_fTimer))
      {
         return undefined;
      }
      this.m_StatusBar.UpdateConsumableStatus(a_iStatusID,a_iState,a_fTimer);
   }
   function SetTargetInfo(a_sData)
   {
      if(this.NullCheck(this.m_TargetManager) && this.NullCheck(this.m_mcPitchIndicator) && this.NullCheck(a_sData))
      {
         return undefined;
      }
      if(this.m_mcTargetInfoUpdate.onEnterFrame == undefined || this.m_mcTargetInfoUpdate.onEnterFrame == null)
      {
         this.m_mcTargetInfoUpdate.onEnterFrame = gfx.utils.Delegate.create(this,this.UpdateTargetInfo);
      }
      var _loc12_ = this._x + this.m_mcThis._x;
      var _loc11_ = this._y + this.m_mcThis._y;
      var _loc9_ = a_sData.split("|");
      var _loc10_ = _loc9_.length;
      var _loc3_ = 0;
      while(_loc3_ < _loc10_)
      {
         var _loc8_ = String(_loc9_[_loc3_]);
         var _loc2_ = _loc8_.split(":");
         var _loc4_ = Number(_loc2_[0]);
         var _loc7_ = _loc2_[5] - _loc12_;
         var _loc6_ = _loc2_[6] - _loc11_;
         var _loc5_ = Number(_loc2_[7]);
         this.m_TargetManager.SetPos(_loc4_,_loc7_,_loc6_,_loc5_);
         if(this.m_bPIPZoomVisible)
         {
            this.m_mcPitchIndicator.SetPos(_loc4_,_loc7_,_loc6_,_loc5_);
         }
         this.m_sTargetInfoCache[_loc2_[0]] = _loc2_;
         _loc3_ = _loc3_ + 1;
      }
   }
   function UpdateTargetInfo()
   {
      var _loc29_ = this._x + this.m_mcThis._x;
      var _loc28_ = this._y + this.m_mcThis._y;
      for(var _loc30_ in this.m_sTargetInfoCache)
      {
         var _loc2_ = this.m_sTargetInfoCache[_loc30_];
         var _loc11_ = Number(_loc2_[0]);
         var _loc3_ = Number(_loc2_[1]);
         var _loc6_ = String(_loc2_[2]);
         var _loc19_ = String(_loc2_[3]);
         var _loc16_ = Number(_loc2_[4]);
         var _loc24_ = _loc2_[5] - _loc29_;
         var _loc23_ = _loc2_[6] - _loc28_;
         var _loc17_ = Number(_loc2_[7]);
         var _loc5_ = _loc2_[8] - _loc29_;
         var _loc13_ = _loc2_[9] - _loc28_;
         var _loc7_ = Number(_loc2_[10]);
         var _loc18_ = Boolean(_loc2_[11] == 1);
         var _loc25_ = Boolean(_loc2_[12] == 1);
         var _loc14_ = Boolean(_loc2_[13] == 1);
         var _loc20_ = String(_loc2_[14]);
         var _loc26_ = Number(_loc2_[15]);
         var _loc21_ = Number(_loc2_[16]);
         var _loc27_ = Boolean(_loc2_[17] == 1);
         var _loc8_ = Boolean(_loc2_[18] == 1);
         var _loc9_ = Number(_loc2_[19]);
         var _loc12_ = Number(_loc2_[20]);
         var _loc15_ = Number(_loc2_[21]);
         var _loc4_ = String(_loc2_[22]);
         var _loc22_ = String(_loc2_[23]);
         var _loc10_ = Number(_loc2_[24]);
         this.m_TargetManager.SetTargetInfo(_loc11_,_loc3_,_loc6_,_loc19_,_loc16_,_loc24_,_loc23_,_loc17_,_loc5_,_loc13_,_loc7_,_loc18_,_loc25_,_loc14_,_loc20_,_loc26_,_loc21_,_loc27_,_loc8_,_loc9_,_loc12_,_loc15_,_loc4_,_loc22_,_loc10_);
         if(this.m_bPIPZoomVisible || _loc3_ == 0)
         {
            this.m_mcPitchIndicator.SetTargetInfo(_loc11_,_loc3_,_loc6_,_loc19_,_loc16_,_loc24_,_loc23_,_loc17_,_loc5_,_loc13_,_loc7_,_loc18_,_loc25_,_loc14_,_loc20_,_loc26_,_loc21_,_loc27_,_loc8_,_loc9_,_loc12_,_loc15_,_loc4_,_loc22_,_loc10_);
         }
      }
      delete this.m_mcTargetInfoUpdate.onEnterFrame;
      this.m_sTargetInfoCache = {};
   }
   function ShowDetialedInfo(a_bShow)
   {
      if(this.NullCheck(this.m_DetailedDam) && this.NullCheck(a_bShow))
      {
         return undefined;
      }
      this.m_DetailedDam.Show(a_bShow);
   }
   function SetDetailedInfoType(a_iType)
   {
      if(this.NullCheck(this.m_DetailedDam) && this.NullCheck(a_iType))
      {
         return undefined;
      }
   }
   function SetDetailedInfoDamage(a_sData)
   {
      if(this.NullCheck(this.m_DetailedDam) && this.NullCheck(a_sData))
      {
         return undefined;
      }
      var _loc8_ = a_sData.split("|");
      var _loc9_ = _loc8_.length;
      var _loc3_ = 0;
      while(_loc3_ < _loc9_)
      {
         var _loc7_ = String(_loc8_[_loc3_]);
         var _loc2_ = _loc7_.split(":");
         var _loc5_ = Number(_loc2_[0]);
         var _loc4_ = Number(_loc2_[1]);
         var _loc6_ = Number(_loc2_[2]);
         if(!(this.NullCheck(_loc5_) && this.NullCheck(_loc4_) && this.NullCheck(_loc6_)))
         {
            this.m_DetailedDam.UpdateDamageIndicator(_loc5_,_loc4_,_loc6_);
         }
         _loc3_ = _loc3_ + 1;
      }
   }
   function SetDetailedInfoComponentStrings(a_sData)
   {
      if(this.NullCheck(this.m_DetailedDam) && this.NullCheck(a_sData))
      {
         return undefined;
      }
      var _loc8_ = a_sData.split("|");
      var _loc9_ = _loc8_.length;
      var _loc3_ = 0;
      while(_loc3_ < _loc9_)
      {
         var _loc7_ = String(_loc8_[_loc3_]);
         var _loc2_ = _loc7_.split(":");
         var _loc4_ = Number(_loc2_[0]);
         var _loc6_ = String(_loc2_[1]);
         var _loc5_ = false;
         if(Number(_loc2_[2]) == 1)
         {
            _loc5_ = true;
         }
         if(!(this.NullCheck(_loc4_) && this.NullCheck(_loc6_)))
         {
            this.m_DetailedDam.SetComponentStrings(_loc4_,_loc6_,_loc5_);
         }
         _loc3_ = _loc3_ + 1;
      }
   }
   function SetDetailedInfoName(a_sName)
   {
      if(this.NullCheck(this.m_DetailedDam) && this.NullCheck(a_sName))
      {
         return undefined;
      }
      this.m_DetailedDam.SetDetailedInfoName(a_sName);
   }
   function ResetDetailedInfo()
   {
      if(this.NullCheck(this.m_DetailedDam))
      {
         return undefined;
      }
      this.m_DetailedDam.Reset();
   }
   function GivePlayerFeedback(a_sPrefix, a_iCBills, a_iEXP, a_iACC, a_sExtraData, a_iDisplayMode)
   {
      if(this.NullCheck(a_iDisplayMode))
      {
         return undefined;
      }
      var _loc0_ = null;
      if((_loc0_ = a_iDisplayMode) !== 1)
      {
         super.GivePlayerFeedback(a_sPrefix,a_iCBills,a_iEXP,a_iACC,a_sExtraData,a_iDisplayMode);
      }
      else
      {
         this.m_mcRewardDisplay.AddReward(a_sPrefix,a_iCBills,a_iEXP,a_iACC,a_sExtraData);
      }
   }
   function SetLancemateData(a_sStrData)
   {
      if(this.NullCheck(this.m_LancemateInfo) && this.NullCheck(a_sStrData))
      {
         return undefined;
      }
      this.m_LancemateInfo.SetPlayerData(a_sStrData);
   }
   function StopAllBGTweens()
   {
      delete this.m_mcBGTimer.onEnterFrame;
      this.m_mcBGTweener.tweenEnd(true);
      HUDComponentHighlight.HideAll();
      this.m_BattleGrid.stop();
   }
   function StartOpenBGTween()
   {
      this.StopAllBGTweens();
      this.m_mcBGTimer.onEnterFrame = gfx.utils.Delegate.create(this,this.BGOpenTween);
      this.m_mcBGTweener._xrotation = this.m_BattleGrid._xrotation;
      this.m_mcBGTweener._y = this.m_BattleGrid._y;
      this.m_mcBGTweener.tweenTo(0.05,{_y:0,_xrotation:0},gfx.motion.Tween.linearEase);
   }
   function StartCloseBGTween()
   {
      this.StopAllBGTweens();
      this.m_mcBGTimer.onEnterFrame = gfx.utils.Delegate.create(this,this.BGCloseTween);
      this.m_mcBGTweener._xrotation = this.m_BattleGrid._xrotation;
      this.m_mcBGTweener._y = this.m_BattleGrid._y;
      this.m_mcBGTweener.tweenTo(0.15,{_y:this.m_iBattleGridY,_xrotation:-50},gfx.motion.Tween.linearEase);
   }
   function BGOpenTween()
   {
      this.m_BattleGrid._xrotation = this.m_mcBGTweener._xrotation;
      this.m_BattleGrid._y = this.m_mcBGTweener._y;
      if(this.CheckStop(0,0))
      {
         this.m_BattleGrid.PlayOpenAnim();
      }
   }
   function BGCloseTween()
   {
      this.m_BattleGrid._xrotation = this.m_mcBGTweener._xrotation;
      this.m_BattleGrid._y = this.m_mcBGTweener._y;
      this.CheckStop(-50,this.m_iBattleGridY);
   }
   function CheckStop(a_XRotGoal, a_YGoal)
   {
      var _loc2_ = false;
      if(Math.abs(this.m_BattleGrid._xrotation - a_XRotGoal) < 1)
      {
         this.m_mcBGTweener._xrotation = a_XRotGoal;
         _loc2_ = true;
      }
      if(Math.abs(this.m_BattleGrid._y - a_YGoal) < 1)
      {
         this.m_mcBGTweener._y = a_YGoal;
         _loc2_;
      }
      if(_loc2_)
      {
         this.StopAllBGTweens();
      }
      return _loc2_;
   }
   function OnBGCloseAnimCompleteCB()
   {
      this.StartCloseBGTween();
   }
   function ShowBattleGrid(a_bVisible, a_sShowBattleGridKeybind, a_sToggleInfoPanelKeybind)
   {
      if(this.NullCheck(this.m_BattleGrid) && this.NullCheck(a_bVisible) && this.NullCheck(a_sShowBattleGridKeybind) && this.NullCheck(a_sToggleInfoPanelKeybind))
      {
         return undefined;
      }
      this.StopAllBGTweens();
      if(a_bVisible)
      {
         this.m_mcBGTweener._y = this.m_iBattleGridY;
         this.m_mcBGTweener._xrotation = -50;
         this.StartOpenBGTween();
         this.m_ThrottleInd.gotoAndPlay("outro");
         this.m_HeatMeter.gotoAndPlay("outro");
         this.m_mcDamageIndicator.gotoAndPlay("outro");
         this.m_mcWeaponLoadout.gotoAndPlay("outro");
         this.m_mcTopHUD.gotoAndPlay("outro");
         this.m_mcBotHUD.gotoAndPlay("outro");
         this.m_DetailedDam.ToggleForBattleGrid(true);
      }
      else
      {
         this.m_mcBGTweener._y = 0;
         this.m_mcBGTweener._xrotation = 0;
         this.m_ThrottleInd.gotoAndPlay("intro");
         this.m_HeatMeter.gotoAndPlay("intro");
         this.m_mcDamageIndicator.gotoAndPlay("intro");
         this.m_mcWeaponLoadout.gotoAndPlay("intro");
         this.m_mcTopHUD.gotoAndPlay("intro");
         this.m_mcBotHUD.gotoAndPlay("intro");
         this.m_DetailedDam.ToggleForBattleGrid(false);
      }
      this.m_BattleGrid.ShowBattleGrid(a_bVisible,a_sShowBattleGridKeybind,a_sToggleInfoPanelKeybind);
   }
   function LoadMiniMap(a_sPath, a_fStartX, a_fStartY, a_fDistX, a_fDistY, a_fCellSize, a_MinimapStyle, a_MiniMapIconScale, a_UseDarkGrid)
   {
      this.m_BattleGrid.LoadMiniMap(a_sPath,a_fStartX,a_fStartY,a_fDistX,a_fDistY,a_fCellSize,a_MinimapStyle,a_MiniMapIconScale,a_UseDarkGrid);
   }
   function UpdateBattleGridMarker(a_Id, a_Type, a_bVisible, a_bShowOnCompass, a_bTargeted, a_X, a_Y, a_eAllegiance, a_Color, a_Data)
   {
      var _loc2_ = this.m_BattleGrid.UpdateMarker(a_Id,a_Type,a_bVisible,a_X,a_Y,a_eAllegiance,a_Color,a_Data);
      var _loc3_ = a_bShowOnCompass && a_bVisible;
      if(_loc2_.GetShowOnCompass() != _loc3_)
      {
         _loc2_.SetShowOnCompass(_loc3_);
         if(_loc3_)
         {
            var _loc5_ = this.m_mcCompass.AddMarker(a_Id,a_Type);
            if(_loc5_ != null)
            {
               _loc2_.ConfigureCompassMarker(_loc5_);
            }
            if(_loc2_.IsOrder())
            {
               var _loc4_ = MarkerOrder(_loc2_);
               if(_loc4_.HasCmdString() && this.m_BattleGrid.IsInMinimapMode())
               {
                  this.m_PlayerFeedback.AddCommandText(_loc4_.GetCmdString(),"@ui_orderreceived",_loc4_.GetFeedbackIcon(),a_Color);
               }
            }
         }
         else
         {
            this.m_mcCompass.RemoveMarker(a_Id);
         }
      }
      if(_loc3_)
      {
         this.m_mcCompass.UpdateMarker(a_Id,a_X,a_Y,a_Color,_loc2_._currentframe,a_bTargeted);
      }
   }
   function SetLanceState(a_sDataStr)
   {
      this.m_BattleGrid.SetLanceState(a_sDataStr);
   }
   function SetMiniMapZoom(a_Zoom)
   {
      this.m_BattleGrid.SetMiniMapZoom(a_Zoom);
   }
   function InitContextMenu(a_Data)
   {
      this.m_BattleGrid.InitContextMenu(a_Data);
   }
   function SetMapRot(a_iRotation)
   {
      var _loc1_ = 0;
   }
   function ShowEjectWarning(a_iSecondsRemaining)
   {
      this.m_EjectWarning.ShowWarning(a_iSecondsRemaining);
   }
   function UpdateVoipState(a_UserId, a_UserName, a_bIsTalking, a_bIsInLance, a_bIsTeamLeader)
   {
      if(this.NullCheck(this.m_VoipStatus) && this.NullCheck(a_UserId) && this.NullCheck(a_UserName) && this.NullCheck(a_bIsTalking) && this.NullCheck(a_bIsInLance) && this.NullCheck(a_bIsTeamLeader))
      {
         return undefined;
      }
      this.m_VoipStatus.UpdateStatus(a_UserId,a_UserName,a_bIsTalking,a_bIsInLance,a_bIsTeamLeader);
   }
   function FlashElement(a_Element, a_Time)
   {
      HUDComponentHighlight.Flash(a_Element,a_Time);
   }
   function DisableLoadoutInput(a_bDisabled)
   {
      this.m_bDisableLoadout = a_bDisabled;
   }
   function ShowShade()
   {
      this.m_mcShade._visible = true;
      HUDComponentHighlight.EnableAll();
      this.m_BattleGrid.OnPauseScreen(true);
   }
   function HideShade()
   {
      this.m_mcShade._visible = false;
      HUDComponentHighlight.HideAll();
      HUDComponentHighlight.DisableAll();
      this.m_BattleGrid.OnPauseScreen(false);
   }
   function OnRoadMapShow(a_bShow)
   {
      this.m_StatusBar.ShowTextLabels(!a_bShow);
   }
   function OnCommWindowShow(a_bShow)
   {
      this.m_bLanceVisible = !a_bShow;
      this.m_LancemateInfo._visible = !this.m_bInThirdPerson && this.m_bLanceVisible;
   }
   function OnStopWatchShow(a_bShow)
   {
      this.m_GamerTimer._visible = !a_bShow;
   }
   function SetNARCState(a_bIsNARCed)
   {
      this.m_mcPitchIndicator.SetNARCState(a_bIsNARCed);
   }
   function SetStealthArmourNoCapState(a_bTryingToCapWithStealthArmourActive)
   {
      this.m_mcPitchIndicator.SetStealthArmourNoCapState(a_bTryingToCapWithStealthArmourActive);
   }
   function SetMASCValues(a_iMASCLimit, a_iCurrentMASCValue, a_bActivated)
   {
      this.m_MASCMeter.SetMASCValues(a_iMASCLimit,a_iCurrentMASCValue,a_bActivated);
   }
   function EnableTurnSignal(a_bEnable)
   {
      this.m_mcTurnSignals.SetVisible(a_bEnable);
   }
   function UpdateHitMarkerType(a_eType)
   {
      this.m_mcCrosshairs.UpdateHitMarkerType(a_eType);
   }
   function HideElements()
   {
      this.StartUpHUD();
      this.m_DetailedDam._visible = false;
      this.m_mcTextWarnings._visible = false;
      this.m_LancemateInfo._visible = false;
      this.m_BattleGrid._visible = false;
      this.m_EjectWarning._visible = false;
      this.m_MASCMeter._visible = false;
      this.m_mcTurnSignals._visible = false;
      this.m_mcDamEffect._visible = false;
      this.m_mcRewardDisplay._visible = false;
      this.m_StatusBar._visible = false;
      this.m_mcDirectionalDam._visible = false;
      this.m_mcPitchIndicator._visible = false;
      this.m_mcCompass._visible = false;
      this.m_mcRangeFinder._visible = false;
      this.m_mcCrosshairs._visible = false;
      this.m_mcWeaponGroupStatus._visible = false;
      this.m_mcBotHUD._visible = false;
      this.m_PlayerFeedback._visible = false;
   }
   function SetExtractionScore(a_iTeamScore, a_iEnemyScore)
   {
      this.m_GamerTimer.SetExtractionScore(a_iTeamScore,a_iEnemyScore);
   }
   function SetCountdownTimer(a_eType, a_Name, a_Type)
   {
      this.m_mcCountdownTimer.Set(a_eType,a_Name,a_Type);
   }
   function UpdateCountdownTime(a_fCurrent, a_fTotal)
   {
      this.m_mcCountdownTimer.Update(a_fCurrent,a_fTotal);
   }
   function SetProgressState(a_sName, a_State, a_Type, a_Color)
   {
      this.m_mcProgressMeter.SetState(a_sName,a_State,a_Type,a_Color);
   }
   function UpdateProgressMeter(a_fCurrent, a_fTotal)
   {
      this.m_mcProgressMeter.SetProgress(a_fCurrent,a_fTotal);
   }
   function CommandWheelShow(a_eContextParams)
   {
      HUDComponentHighlight.DisableAll();
      this.m_mcCommandWheel.InitCmdWheelFromStrData(a_eContextParams);
      this.m_mcCommandWheel.Show();
   }
   function CommandWheelHide(a_bExecuteCommand)
   {
      this.OnCommandWheelHide();
      this.m_mcCommandWheel.Hide(a_bExecuteCommand);
   }
   function OnCommandWheelHide()
   {
   }
   function UpdateWheelCommands(a_sId)
   {
      this.m_mcCommandWheel.UpdateWheelCommands(a_sId);
   }
   function UpdateAssaultGenerators(a_Name, a_Status, a_bIsTeam, a_HealthPct, a_Id)
   {
      this.m_GamerTimer.UpdateAssaultGenerators(a_Name,a_Status,a_bIsTeam,a_HealthPct,a_Id);
   }
   function UpdateVipHealth(a_T, a_CT, a_RT, a_LT, a_LA, a_RA, a_LL, a_RL, a_H, a_CTR, a_LTR, a_RTR, a_bFriendly)
   {
      this.m_GamerTimer.UpdateVipHealth(a_T,a_CT,a_RT,a_LT,a_LA,a_RA,a_LL,a_RL,a_H,a_CTR,a_LTR,a_RTR,a_bFriendly);
   }
   function UpdateIncursionBaseStatus(a_Id, a_DamageCounter, a_Destroyed)
   {
      var _loc2_ = a_Destroyed > 0;
      this.m_GamerTimer.UpdateIncursionBaseStatus(a_Id,a_DamageCounter,_loc2_);
   }
   function UpdateIncursionTowerStatus(a_Id, a_DamageCounter, a_Destroyed)
   {
      var _loc2_ = a_Destroyed > 0;
      this.m_GamerTimer.UpdateIncursionTowerStatus(a_Id,a_DamageCounter,_loc2_);
   }
   function UpdateIncursionTowerPower(a_Id, a_PowerTime)
   {
      this.m_GamerTimer.UpdateIncursionTowerPower(a_Id,a_PowerTime);
   }
   function UpdatePickupStatus(a_bHasPickup)
   {
      if(a_bHasPickup)
      {
         this.m_StatusBar.AddStatusEffect(4);
      }
      else
      {
         this.m_StatusBar.RemoveStatusEffect(4);
      }
   }
   function SetHudCounterToCapture(a_bIsCaptureMode)
   {
      this.m_GamerTimer.SetHudCounterToCapture(a_bIsCaptureMode);
   }
   function SetCrosshairVisible(a_bVisible)
   {
      this.m_mcCrosshairs.SetCrosshairVisible(a_bVisible);
   }
}

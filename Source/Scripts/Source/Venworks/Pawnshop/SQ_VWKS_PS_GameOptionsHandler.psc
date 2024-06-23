ScriptName Venworks:PawnShop:SQ_VWKS_PS_GameOptionsHandler extends Quest
{ script for configuring the pawn shop game options }

Import Venworks:Shared:Logging


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;e
;;; Global Variables
;;;
GlobalVariable Property DebugEnabled Auto Const Mandatory
String Property ModName="VenworksPawnShop" Auto Const


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;
;;; Guards
;;;
Guard XPMultGuard


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;
;;; Structs
;;;
Struct OptionDatum
  GamePlayOption Option
  {GamePlay option form: game play option forms are a new form type that appear as GamePlay option sliders in the menu}
  GlobalVariable ValueGlobal
  {Global associated with the option - this global is used as a proxy for the value of the game play option in various data and will appear in the updated ESM so other creations can refer to the settings}
EndStruct


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;
;;; Properties
;;;
Group Properties
  ReferenceAlias Property Player_Alias Auto Const Mandatory
  {Should autofill}

  OptionDatum[] Property OptionData Auto Const Mandatory
  {Used to set related Game Options and Global}

  ActorValue Property PEO_XP_Mult Auto Const Mandatory RequiresGuard(XPMultGuard)
EndGroup


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;
;;; Events
;;;
Event OnQuestInit()
  Log(modName=ModName, moduleName="Venworks:Pawnshop:SQ_VWKS_PS_GameOptionsHandler", functionName="OnQuestInit", logMessage="OnQuestInit Triggered.", level=0, debugModeEnabled=DebugEnabled.GetValueInt())
  RegisterForGamePlayOptionChangedEvent()
EndEvent

Event OnGamePlayOptionChanged(GamePlayOption[] aChangedOptions)
  Log(modName=ModName, moduleName="Venworks:Pawnshop:SQ_VWKS_PS_GameOptionsHandler", functionName="OnGamePlayOptionChanged", logMessage="OnGamePlayOptionChanged Triggered. aChangedOptions: " + aChangedOptions, level=0, debugModeEnabled=DebugEnabled.GetValueInt())
  UpdateOptionsAndGetGlobals(aChangedOptions)
  UpdateXPMult()

  ;THIS MUST GO LAST IN THIS EVENT. It pokes the game to update inventory data, etc.
  GamePlayOption.NotifyGamePlayOptionUpdateFinished()
EndEvent


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;
;;; Functions
;;;
Function UpdateOptionsAndGetGlobals(GamePlayOption[] OptionsToUpdateAndGetGlobalsFor)
  int i = 0
  While (i < OptionsToUpdateAndGetGlobalsFor.length)
    GamePlayOption currentGamePlayOption = OptionsToUpdateAndGetGlobalsFor[i]
    Log(modName=ModName, moduleName="Venworks:Pawnshop:SQ_VWKS_PS_GameOptionsHandler", functionName="UpdateOptionsAndGetGlobals", logMessage=i + ": Processing GamePlay Option " + currentGamePlayOption + ".", level=0, debugModeEnabled=DebugEnabled.GetValueInt())

    GlobalVariable matchingGlobal = GetMatchingGlobalForOption(currentGamePlayOption)
    if (matchingGlobal)
        matchingGlobal.SetValue(currentGamePlayOption.GetValue())
    endif
    
    i += 1
  EndWhile
EndFunction

GlobalVariable Function GetMatchingGlobalForOption(GamePlayOption OptionToCheck)
  int foundPos = OptionData.FindStruct("Option", OptionToCheck)
  OptionDatum foundOptionDatum
  if (foundPos > -1)
      foundOptionDatum = OptionData[foundPos]
      Return foundOptionDatum.ValueGlobal
  else 
      Log(modName=ModName, moduleName="Venworks:Pawnshop:SQ_VWKS_PS_GameOptionsHandler", functionName="GetMatchingGlobalForOption", logMessage="Could not find a matching GlobalVariable for OptionToCheck: " + OptionToCheck + ". Note: this might be for an option from another creation and doesn't necessarily mean it's a bug.", level=0, debugModeEnabled=DebugEnabled.GetValueInt())
      Return none
  endIf
EndFunction

Function UpdateXPMult() private
  LockGuard XPMultGuard
    float OptionRewardXPTotal ;stores the numeric total of all the player experience GamePlay options. These can be negative values. 10 = 10%, -5 = -5%

    OptionRewardXPTotal = GamePlayOption.GetXPTotal()
    Log(modName=ModName, moduleName="Venworks:Pawnshop:SQ_VWKS_PS_GameOptionsHandler", functionName="UpdateXPMult", logMessage="OptionRewardXPTotal: " + OptionRewardXPTotal + ".", level=0, debugModeEnabled=DebugEnabled.GetValueInt())

    float XPMult = 1 + (OptionRewardXPTotal * 0.01) ;this will modify a default 1.0 value ActorValue that will multiply EXP via perk entry. A total of 10 OptionRewardXPTotal becomes 1.10 to scale the incoming EXP.
    Log(modName=ModName, moduleName="Venworks:Pawnshop:SQ_VWKS_PS_GameOptionsHandler", functionName="UpdateXPMult", logMessage="XPMult: " + XPMult + ".", level=0, debugModeEnabled=DebugEnabled.GetValueInt())

    Game.GetPlayer().SetValue(PEO_XP_Mult, XPMult)
  EndLockGuard
EndFunction

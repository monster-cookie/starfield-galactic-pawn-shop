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
Guard AVArrayGuard
Guard GlobalArrayGuard
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

Struct OptionAVDatum
  GlobalVariable GlobalToCheck
  {Global value associated with the option}

  float ValueToCheck
  {Associated value in OptionGlobal}

  ActorValue AVToSet
  {Associated ActorValue to set}

  float ValueToSet
  {Value AVToSet should be set to when OptionGlobal == OptionValue}
EndStruct

Struct OptionGlobalDatum
  GlobalVariable GlobalToCheck
  {Global value associated with the option}
  float ValueToCheck
  {Associated value in OptionGlobal}
  GlobalVariable GlobalToSet
  {Associated global value to set}
  float ValueToSet
  {Value GlobalToSet should be set to when OptionGlobal == OptionValue}
  GlobalVariable ValueToSetFromGlobal
  {Global value GlobalToSet should be set to when not using a discrete value}
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

  OptionAVDatum[] Property OptionAVData Mandatory Const Auto RequiresGuard(AVArrayGuard) 
  {Used to set ActorValues based on PEO Actor Values}

  OptionGlobalDatum[] Property OptionGlobalData Auto Const Mandatory RequiresGuard(GlobalArrayGuard)
  {Used to set GlobalVariables based on PEO Global Variables}

  ActorValue Property PEO_XP_Mult Auto Const Mandatory RequiresGuard(XPMultGuard)
EndGroup


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;
;;; Events
;;;
Event OnQuestInit()
  Log(modName=ModName, moduleName="Venworks:Pawnshop:SQ_VWKS_PS_GameOptionsHandler", functionName="OnQuestInit", logMessage="OnQuestInit Triggered.", level=0, debugModeEnabled=DebugEnabled.GetValueInt())
  RegisterForGamePlayOptionChangedEvent()
  GlobalVariable[] AllPlayerExperienceOptionGlobals = UpdateOptionsAndGetGlobals(GetAllPlayerExperienceOptions())
  UpdateSpecificOptions(AllPlayerExperienceOptionGlobals) ;by default set up all
EndEvent

Event OnGamePlayOptionChanged(GamePlayOption[] aChangedOptions)
  Log(modName=ModName, moduleName="Venworks:Pawnshop:SQ_VWKS_PS_GameOptionsHandler", functionName="OnGamePlayOptionChanged", logMessage="OnGamePlayOptionChanged Triggered. aChangedOptions: " + aChangedOptions, level=0, debugModeEnabled=DebugEnabled.GetValueInt())
  GlobalVariable[] globalsToUpdate = UpdateOptionsAndGetGlobals(aChangedOptions)
  Log(modName=ModName, moduleName="Venworks:Pawnshop:SQ_VWKS_PS_GameOptionsHandler", functionName="OnGamePlayOptionChanged", logMessage="OnGamePlayOptionChanged Triggered. globalsToUpdate: " + globalsToUpdate, level=0, debugModeEnabled=DebugEnabled.GetValueInt())
  UpdateSpecificOptions(globalsToUpdate)
  UpdateXPMult()

  ;THIS MUST GO LAST IN THIS EVENT. It pokes the game to update inventory data, etc.
  GamePlayOption.NotifyGamePlayOptionUpdateFinished()
EndEvent


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;
;;; Functions
;;;
GlobalVariable[] Function UpdateOptionsAndGetGlobals(GamePlayOption[] OptionsToUpdateAndGetGlobalsFor)
  GlobalVariable[] globalsToGet = new GlobalVariable[0]

  int i = 0
  While (i < OptionsToUpdateAndGetGlobalsFor.length)
      GamePlayOption currentGamePlayOption = OptionsToUpdateAndGetGlobalsFor[i]
      Log(modName=ModName, moduleName="Venworks:Pawnshop:SQ_VWKS_PS_GameOptionsHandler", functionName="UpdateOptionsAndGetGlobals", logMessage=i + ": Processing GamePlay Option " + currentGamePlayOption + ".", level=0, debugModeEnabled=DebugEnabled.GetValueInt())

      GlobalVariable matchingGlobal = GetMatchingGlobalForOption(currentGamePlayOption)
      if (matchingGlobal)
          matchingGlobal.SetValue(currentGamePlayOption.GetValue())
          globalsToGet.Add(matchingGlobal)
      endif
      
      i += 1
  EndWhile

  Log(modName=ModName, moduleName="Venworks:Pawnshop:SQ_VWKS_PS_GameOptionsHandler", functionName="UpdateOptionsAndGetGlobals", logMessage=i + ": Relevant Globals to fetch " + globalsToGet + ".", level=0, debugModeEnabled=DebugEnabled.GetValueInt())
  Return globalsToGet
EndFunction

GamePlayOption[] Function GetAllPlayerExperienceOptions()
  GamePlayOption[] options = new GamePlayOption[OptionData.Length]

  int i = 0
  While (i < OptionData.length)
      options[i] = OptionData[i].Option
      i += 1
  EndWhile

  Return options
EndFunction

GlobalVariable[] Function GetAllPlayerExperienceOptionGlobals()
  GlobalVariable[] allOptionGlobals = new GlobalVariable[0]
  int i = 0
  While (i < OptionData.length)
      allOptionGlobals.add(OptionData[i].ValueGlobal)
      i += 1
  EndWhile

  Return allOptionGlobals
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

Function UpdateSpecificOptions(GlobalVariable[] GlobalsToUpdate = None) Private
  UpdateActorValues(GlobalsToUpdate)
  UpdateGlobalVariables(GlobalsToUpdate)
EndFunction

Function UpdateActorValues(GlobalVariable[] GlobalsToUpdate = None) Private
  LockGuard AVArrayGuard
    Log(modName=ModName, moduleName="Venworks:Pawnshop:SQ_VWKS_PS_GameOptionsHandler", functionName="UpdateActorValues", logMessage="Updating actor values for the globals: " + GlobalsToUpdate + ".", level=0, debugModeEnabled=DebugEnabled.GetValueInt())

    If (GlobalsToUpdate == None)
      GlobalsToUpdate = GetAllPlayerExperienceOptionGlobals()
      Log(modName=ModName, moduleName="Venworks:Pawnshop:SQ_VWKS_PS_GameOptionsHandler", functionName="UpdateActorValues", logMessage="Using ALL GlobalsToUpdate: " + GlobalsToUpdate + ".", level=0, debugModeEnabled=DebugEnabled.GetValueInt())
    EndIf

    int index_GlobalsToUpdate = 0
    While (index_GlobalsToUpdate < GlobalsToUpdate.length)
      GlobalVariable currentGlobal = GlobalsToUpdate[index_GlobalsToUpdate]
      OptionAVDatum[] matchingData =  OptionAVData.GetAllMatchingStructs("GlobalToCheck", currentGlobal)

      int index_AVData = 0
      While (index_AVData < matchingData.length)
        OptionAVDatum currentDatum = matchingData[index_AVData]
        GlobalVariable currentOptionGlobal = currentDatum.GlobalToCheck
        float currentValueToCheck = currentDatum.ValueToCheck
        ActorValue currentAVToSet = currentDatum.AVToSet
        float currentValueToSet = currentDatum.ValueToSet
        float currentActualValue = currentOptionGlobal.GetValue()

        If currentActualValue == currentValueToCheck
          Log(modName=ModName, moduleName="Venworks:Pawnshop:SQ_VWKS_PS_GameOptionsHandler", functionName="UpdateActorValues", logMessage="currentOptionGlobal: " + currentOptionGlobal + " --> setting currentAVToSet: " + currentAVToSet + " to currentValueToSet: " + currentValueToSet + ".", level=0, debugModeEnabled=DebugEnabled.GetValueInt())
          Game.GetPlayer().SetValue(currentAVToSet, currentValueToSet)
        EndIf
    
        index_AVData += 1
      EndWhile

      index_GlobalsToUpdate += 1
    EndWhile
  EndLockGuard
EndFunction

Function UpdateGlobalVariables(GlobalVariable[] GlobalsToUpdate = None) Private
  LockGuard GlobalArrayGuard
    Log(modName=ModName, moduleName="Venworks:Pawnshop:SQ_VWKS_PS_GameOptionsHandler", functionName="UpdateGlobalVariables", logMessage="Updating globals: " + GlobalsToUpdate + ".", level=0, debugModeEnabled=DebugEnabled.GetValueInt())

    if GlobalsToUpdate == None
      GlobalsToUpdate = GetAllPlayerExperienceOptionGlobals() ;default behavior of function is to update for all
      Log(modName=ModName, moduleName="Venworks:Pawnshop:SQ_VWKS_PS_GameOptionsHandler", functionName="UpdateGlobalVariables", logMessage="Using ALL GlobalsToUpdate: " + GlobalsToUpdate + ".", level=0, debugModeEnabled=DebugEnabled.GetValueInt())
    endif

    ;outer while loop is looping through an array of GlobalsToUpdate.
    ;inner while loop is looping through an array of things to update based on each global in the outer loop

    int index_GlobalsToUpdate = 0
    While (index_GlobalsToUpdate < GlobalsToUpdate.length)
      GlobalVariable currentGlobal = GlobalsToUpdate[index_GlobalsToUpdate]

      ;get data matching the current global and loop through it updating things
      OptionGlobalDatum[] matchingData =  OptionGlobalData.GetAllMatchingStructs("GlobalToCheck", currentGlobal)

      int index_GlobalData = 0
      While (index_GlobalData < matchingData.length)
        OptionGlobalDatum currentDatum = matchingData[index_GlobalData]

        GlobalVariable currentOptionGlobal = currentDatum.GlobalToCheck
        float currentValueToCheck = currentDatum.ValueToCheck
        GlobalVariable currentGlobalToSet = currentDatum.GlobalToSet
        float currentValueToSet = currentDatum.ValueToSet
        GlobalVariable currentValueToSetFromGlobal = currentDatum.ValueToSetFromGlobal

        float currentActualValue = currentOptionGlobal.GetValue()

        if currentActualValue == currentValueToCheck
          ;set ValueToSet from global instead of ValueToCheck if ValueToSetFromGlobal global variable property is populated
          if currentValueToSetFromGlobal
            currentValueToSet = currentValueToSetFromGlobal.GetValue()
          endif
          
          Log(modName=ModName, moduleName="Venworks:Pawnshop:SQ_VWKS_PS_GameOptionsHandler", functionName="UpdateGlobalVariables", logMessage="currentOptionGlobal: " + currentOptionGlobal + " --> setting currentGlobalToSet: " + currentGlobalToSet + " to currentValueToSet: " + currentValueToSet + ".", level=0, debugModeEnabled=DebugEnabled.GetValueInt())
          currentGlobalToSet.SetValue(currentValueToSet)
        endif
        index_GlobalData += 1
      EndWhile
      index_GlobalsToUpdate += 1
    EndWhile
  EndLockGuard
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

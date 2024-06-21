ScriptName Venworks:Pawnshop:VendorActivatorScript Extends ObjectReference
{ script for accessing the vendor menu via an activator }

Import Venworks:Shared:Logging

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;
;;; Global Variables
;;;
GlobalVariable Property DebugEnabled Auto Const Mandatory
String Property ModName="VenworksPawnshop" Auto Const

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;
;;; Properties
;;;
ActorBase Property Vendor Auto Const mandatory
Container Property VendorContainer Auto Const mandatory
Keyword Property VendorContainerKeyword01 Auto Const mandatory
Bool Property ClearVendorActorInventoryOnLoad = False Auto Const

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;
;;; Variables
;;;
Actor myVendor
ObjectReference myVendorContainer
Int iDaysToRespawnVendor

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;
;;; Events
;;;

Event OnInit()
  ; Log(ModName, "Venworks:Pawnshop:VendorActivatorScript", "OnInit", "OnInit Triggered.", 0, DebugEnabled.GetValueInt())
  self.OnLoad()
  iDaysToRespawnVendor = Game.GetGameSettingInt(asGameSetting="iDaysToRespawnVendor") 
EndEvent

Event OnLoad()
  Log(ModName, "Venworks:Pawnshop:VendorActivatorScript", "OnLoad", "OnLoad Triggered.", 0, DebugEnabled.GetValueInt())
  If (myVendor == None)
    myVendor = Self.PlaceActorAtMe(Vendor, 4, None, False, True, True, None, True)
    myVendorContainer = Self.PlaceAtMe(VendorContainer as Form, 1, False, True, True, None, None, True)
    myVendor.SetLinkedRef(myVendorContainer, VendorContainerKeyword01, True)
  EndIf

  If (ClearVendorActorInventoryOnLoad)
    Log(ModName, "Venworks:Pawnshop:VendorActivatorScript", "OnLoad", "Clearing stock container due to ClearVendorActorInventoryOnLoad being true.", 0, DebugEnabled.GetValueInt())
    myVendor.RemoveAllItems(None, False, False)
  EndIf

  If (GetCurrentShipRef() != None)
    Log(ModName, "Venworks:Pawnshop:VendorActivatorScript", "OnLoad", "Pawn shop is deployed on a ship so using emulated vendor reset via timer.", 0, DebugEnabled.GetValueInt())
    StartTimerGameTime(Math.DaysAsHours(iDaysToRespawnVendor), 1)
  EndIf
EndEvent

Event OnActivate(ObjectReference akActionRef)
  self.OnLoad()
  If (akActionRef == Game.GetPlayer() as ObjectReference)
    myVendor.ShowBarterMenu()
  EndIf
EndEvent

Event OnCellDetach()
  ; Log(ModName, "Venworks:Pawnshop:VendorActivatorScript", "OnCellDetach", "OnCellDetach Triggered.", 0, DebugEnabled.GetValueInt())
  If (ClearVendorActorInventoryOnLoad)
    Log(ModName, "Venworks:Pawnshop:VendorActivatorScript", "OnCellDetach", "Clearing stock container due to ClearVendorActorInventoryOnLoad being true.", 0, DebugEnabled.GetValueInt())
    myVendor.RemoveAllItems(None, False, False)
  EndIf
EndEvent

Event OnTimerGameTime(int aiTimerID)
  Log(ModName, "Venworks:Pawnshop:VendorActivatorScript", "OnTimerGameTime", "OnTimerGameTime Triggered for timer #" + aiTimerID, 0, DebugEnabled.GetValueInt())
  myVendor.RemoveAllItems(None, False, False)
EndEvent

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;
;;; Functions
;;;

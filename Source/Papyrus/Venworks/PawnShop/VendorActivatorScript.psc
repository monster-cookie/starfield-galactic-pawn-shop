ScriptName Venworks:Pawnshop:VendorActivatorScript Extends ObjectReference
{ script for accessing the vendor menu via an activator }

Import Venworks:Shared:Logging

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;
;;; Global Variables
;;;
GlobalVariable Property Venpi_DebugEnabled Auto Const Mandatory
String Property Venpi_ModName Auto Const Mandatory

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;
;;; Properties
;;;
ActorBase Property Vendor Auto Const mandatory
Container Property VendorContainer Auto Const mandatory
Keyword Property VendorContainerKeyword01 Auto Const mandatory
Bool Property ClearVendorActorInventoryOnLoad = False Auto Const
;;Keyword Property SQ_TreasureMap_CreateMapStoryEvent Auto Const mandatory
;;GlobalVariable Property SQ_TreasureMap_CreateAny Auto Const mandatory

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;
;;; Variables
;;;
Actor myVendor
ObjectReference myVendorContainer

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;
;;; Events
;;;

Event OnInit()
  ; Log(Venpi_ModName, "Venworks:Pawnshop:VendorActivatorScript", "OnInit", "OnInit Triggered.", 0, Venpi_DebugEnabled.GetValueInt())
  self.OnLoad()
EndEvent

Event OnLoad()
  Log(Venpi_ModName, "Venworks:Pawnshop:VendorActivatorScript", "OnLoad", "OnLoad Triggered.", 0, Venpi_DebugEnabled.GetValueInt())
  If (myVendor == None)
    myVendor = Self.PlaceActorAtMe(Vendor, 4, None, False, True, True, None, True)
    myVendorContainer = Self.PlaceAtMe(VendorContainer as Form, 1, False, True, True, None, None, True)
    myVendor.SetLinkedRef(myVendorContainer, VendorContainerKeyword01, True)
  EndIf

  If (ClearVendorActorInventoryOnLoad)
    Log(Venpi_ModName, "Venworks:Pawnshop:VendorActivatorScript", "OnLoad", "Clearing stock container due to ClearVendorActorInventoryOnLoad being true.", 0, Venpi_DebugEnabled.GetValueInt())
    myVendor.RemoveAllItems(None, False, False)
  EndIf
EndEvent

Event OnActivate(ObjectReference akActionRef)
  self.OnLoad()
  If (akActionRef == Game.GetPlayer() as ObjectReference)
    myVendor.ShowBarterMenu()
  EndIf
EndEvent

Event OnCellDetach()
  ; Log(Venpi_ModName, "Venworks:Pawnshop:VendorActivatorScript", "OnCellDetach", "OnCellDetach Triggered.", 0, Venpi_DebugEnabled.GetValueInt())
  If (ClearVendorActorInventoryOnLoad)
    Log(Venpi_ModName, "Venworks:Pawnshop:VendorActivatorScript", "OnCellDetach", "Clearing stock container due to ClearVendorActorInventoryOnLoad being true.", 0, Venpi_DebugEnabled.GetValueInt())
    myVendor.RemoveAllItems(None, False, False)
  EndIf
EndEvent

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;
;;; Functions
;;;

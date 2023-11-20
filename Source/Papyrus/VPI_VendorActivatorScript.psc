ScriptName VPI_VendorActivatorScript Extends ObjectReference
{ script for accessing the vendor menu via an activator }

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;
;;; Global Variables
;;;
GlobalVariable Property GPSDebugMode Auto Const Mandatory

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
  ; VPI_Helper.DebugMessage("VendorActivatorScript", "OnInit", "OnInit Triggered.", 0, GPSDebugMode.GetValueInt())
EndEvent

Event OnLoad()
  VPI_Helper.DebugMessage("VendorActivatorScript", "OnLoad", "OnLoad Triggered.", 0, GPSDebugMode.GetValueInt())
  If (myVendor == None)
    myVendor = Self.PlaceActorAtMe(Vendor, 4, None, False, True, True, None, True)
    myVendorContainer = Self.PlaceAtMe(VendorContainer as Form, 1, False, True, True, None, None, True)
    myVendor.SetLinkedRef(myVendorContainer, VendorContainerKeyword01, True)
  EndIf

  If (ClearVendorActorInventoryOnLoad)
    VPI_Helper.DebugMessage("VendorActivatorScript", "OnLoad", "Clearing stock container due to ClearVendorActorInventoryOnLoad being true.", 0, GPSDebugMode.GetValueInt())
    myVendor.RemoveAllItems(None, False, False)
  EndIf
EndEvent

Event OnActivate(ObjectReference akActionRef)
  If (akActionRef == Game.GetPlayer() as ObjectReference)
    myVendor.ShowBarterMenu()
  EndIf
EndEvent

; Event OnCellLoad()
;   VPI_Helper.DebugMessage("VendorActivatorScript", "OnCellLoad", "OnCellLoad Triggered.", 0, GPSDebugMode.GetValueInt())
; EndEvent

; Event OnCellAttach()
;   VPI_Helper.DebugMessage("VendorActivatorScript", "OnCellAttach", "OnCellAttach Triggered.", 0, GPSDebugMode.GetValueInt())
; EndEvent

Event OnCellDetach()
  ; VPI_Helper.DebugMessage("VendorActivatorScript", "OnCellDetach", "OnCellDetach Triggered.", 0, GPSDebugMode.GetValueInt())
  If (ClearVendorActorInventoryOnLoad)
    VPI_Helper.DebugMessage("VendorActivatorScript", "OnCellDetach", "Clearing stock container due to ClearVendorActorInventoryOnLoad being true.", 0, GPSDebugMode.GetValueInt())
    myVendor.RemoveAllItems(None, False, False)
  EndIf
EndEvent

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;
;;; Functions
;;;

# Galactic Pawn Shop

## V1.0.12
* Fix problems when made part of an interior cell

## V1.0.11
* Now with our own custom terminal instead of messing with the crimson fleet mission board. You may have to remove and readd the terminal to get it working again but shouldn't for a pure model change. 

## V1.0.10
* Using Venpi Core 1.0.10 and the new user debug log files.

## V1.0.9
* Consuming rare book leveled item list from VenpiCore, needed update to avoid crash/conflict

## V1.0.8
* Now requires Venpi Core utility library (https://www.nexusmods.com/starfield/mods/7097)
* The legit terminal was missing most of its script args /facepalm. It should work much better now lol. 
* Removed the duplicated global vars and pex scripts that are now the core mod. 

## V1.0.7
* Fixed some spelling errors found working on Galactic Pet Shop

## V1.0.6
* Fixed the cache treasure maps not spawning..... Stupid cut and paste errors. 

## V1.0.5
* The vanilla vendor script clears inventory in OnLoad this is not reliably called in a ship hab. I've cloned the script and can clearing OnCellAttach/Detach which seem to more reliably get called. Now that being said none of the events ever get called if you just exit/save/load without leaving the ship. Will need the custom script so I can call story manager to get the treasure maps anyway so long term this would have been needed. 
* Ok now for the bad part you need to remove and readd your terminal so my script takes over just use the build interface to do it. 

## V1.0.4
* Use global value LegalPawnShop (XX000808) to control selling/stocking of contraband items. Use "FindForm LegalPawnShop" to get the correct form ID for your load order, then use "set XX000808 to 1" fixing XX to your index value, finally use "help LegalPawnShop" to verify it's setting. Use the outpost modify mode to remove the old terminal first or you will not be able to deploy a new one. They are mutually exclusive. 

## V1.0.3
* Pawn shop has a small random stock of items and resources most are with 90%, 75%, 40%, or 25% chance
* Will now sell informational items (Survey Maps, Cache Locations, Trigger Books). I hope to sell mission board quest triggers too eventually.
* Cut credits in half 400k seems too much probably should around 100k I probably could make it random. Thoughts? 

## V1.0.2
* Updated splash screen image from domi29

## V1.0.1
* No more loose files everything is one BA2 now which should make manual installs way easier. Overriding the screen for the Crimson Fleet Faction terminal until CK2 or find a way to make a custom model.  

## V1.0.0
* Initial Release
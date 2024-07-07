# Mechwarrior-Online-New-HUD
Extended HUD - Whis project to upgrade default MWO uncomfortable and not rational Battle HUD.

HUD consists of two parts:

Crosshair HUD named HUDComponents.gfx (CLAN_HUDComponents.gfx not a copy of HUDComponents.gfx, it's is partially addressed from HUDComponents.gfx).

And Main screen battle HUD named MechHUD.gfx (ClanHUD.gfx).
![image](https://github.com/SergeyZabMWO/Mechwarrior-Online-New-HUD/assets/173540532/cbac3d03-1333-449b-8c71-e90355472b72)


In HUD.xml from Mechwarrior Online\Game\GameData.pak\Libs\UI\UIElements\ we can set the scaling and positioning settings of the Battle Screen 
(the starting points of the menu's positioning in ActionScript are conditional, which means that each menu has its own conditional zero started axis, which is not related to the resolution of your screen).
We remove the scaling and set the positioning in the center of our screen - this is where we will start moving the "windows" from the conditional center.
![image](https://github.com/SergeyZabMWO/Mechwarrior-Online-New-HUD/assets/173540532/a0cf6e37-048b-43e2-ab3b-8bcc5082a16b)



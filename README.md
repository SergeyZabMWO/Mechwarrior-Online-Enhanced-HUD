# Mechwarrior-Online-Enhanced-HUD

Enhanced HUD - Whis project to upgrade default MWO uncomfortable and not rational Battle HUD.

HUD consists of two parts:

Crosshair HUD named HUDComponents.gfx (CLAN_HUDComponents.gfx not a copy of HUDComponents.gfx, it's is partially addressed from HUDComponents.gfx).

And Main screen battle HUD named MechHUD.gfx (ClanHUD.gfx).
![image](https://github.com/SergeyZabMWO/Mechwarrior-Online-New-HUD/assets/173540532/cbac3d03-1333-449b-8c71-e90355472b72)


In HUD.xml from Mechwarrior Online\Game\GameData.pak\Libs\UI\UIElements\ we can set the scaling and positioning settings of the Battle Screen 
(the starting points of the menu's positioning in ActionScript are conditional, which means that each menu has its own conditional zero started axis, which is not related to the resolution of your screen).
We remove the scaling and set the positioning in the center of our screen - this is where we will start moving the "windows" from the conditional center.
![image](https://github.com/SergeyZabMWO/Mechwarrior-Online-New-HUD/assets/173540532/a0cf6e37-048b-43e2-ab3b-8bcc5082a16b)


As a result(after edit ), we get a flat interface(Scripts->_Packages->defaul_package->MechHUD) without scaling. all we have to do is put the windows and information menus in convenient places on the screen.
![image](https://github.com/SergeyZabMWO/Mechwarrior-Online-Enhanced-HUD/assets/173540532/4603268a-1705-4b4b-a66e-7ca9e1e775b4)

![image](https://github.com/SergeyZabMWO/Mechwarrior-Online-Enhanced-HUD/assets/173540532/bb6b2d72-27ba-4b52-879c-6558e3d122d6)

![image](https://github.com/SergeyZabMWO/Mechwarrior-Online-Enhanced-HUD/assets/173540532/b7b48cb3-1e1c-400d-a36c-1a5270574c13)


Moving the necessary objects for our screen resolution
![image](https://github.com/SergeyZabMWO/Mechwarrior-Online-Enhanced-HUD/assets/173540532/5b25600e-d1e6-4621-bcff-ed147dbf2b48)
Depending of AS code in MechHUD
![image](https://github.com/SergeyZabMWO/Mechwarrior-Online-Enhanced-HUD/assets/173540532/bf484286-0889-4faf-b529-96ef5f4751c7)







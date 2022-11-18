class Map_End_HUDController expands Info;

event Tick(float DeltaTime)
{
	local HUD HUD;

	foreach AllActors(class'HUD', HUD)
	{
		if (string(HUD.Class) ~= "UDSDemo.CS_Hud" && HUD.TimerRate == 0)
			HUD.SetTimer(107.0, false);
		Disable('Tick');
	}
}

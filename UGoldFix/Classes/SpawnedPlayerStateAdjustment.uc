class SpawnedPlayerStateAdjustment expands Info;

var Pawn ControlledPlayer;

function Tick(float DeltaTime)
{
	AdjustControlledPlayer();
	Destroy();
}

function AdjustControlledPlayer()
{
	if (ControlledPlayer == none || ControlledPlayer.PlayerReplicationInfo == none)
		return;

	if (Spectator(ControlledPlayer) == none && !ControlledPlayer.PlayerReplicationInfo.bIsSpectator)
	{
		if (ControlledPlayer.IsInState('PlayerWalking') || ControlledPlayer.IsInState('PlayerSwimming'))
		{
			if (ControlledPlayer.Region.Zone.bWaterZone)
			{
				if (ControlledPlayer.Physics != PHYS_Swimming)
					ControlledPlayer.SetPhysics(PHYS_Swimming);
				if (!ControlledPlayer.IsInState('PlayerSwimming'))
					ControlledPlayer.GotoState('PlayerSwimming');
			}

			if (ControlledPlayer.FootRegion.Zone.bPainZone)
				ControlledPlayer.PainTime = 1;
			else if (ControlledPlayer.HeadRegion.Zone.bWaterZone)
			{
				ControlledPlayer.PainTime = ControlledPlayer.UnderwaterTime;
				if (ControlledPlayer.Inventory != none)
					ControlledPlayer.Inventory.ReduceDamage(0, 'Drowned', ControlledPlayer.Location);
			}

			if (!ControlledPlayer.HeadRegion.Zone.bWaterZone && ControlledPlayer.Inventory != none)
				ControlledPlayer.Inventory.ReduceDamage(0, 'Breathe', ControlledPlayer.Location);
		}
		AdjustPlayerInventory(ControlledPlayer);
	}
}

static function AdjustPlayerInventory(Pawn P)
{
	if (P.SelectedItem == none)
		P.NextItem();
}


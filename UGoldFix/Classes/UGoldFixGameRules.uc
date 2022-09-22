class UGoldFixGameRules expands GameRules;

var UGoldFix UGoldFix;
var bool bHandleSafeFall;

function PostBeginPlay()
{
	UGoldFix = UGoldFix(Owner);
	if (UGoldFix == none)
		Destroy();
	else
		AddSelf();
}

function AddSelf()
{
	if (Level.Game.GameRules == none)
		Level.Game.GameRules = self;
	else
		Level.Game.GameRules.AddRules(self);
}

function ModifyDamage(
	Pawn Injured,
	Pawn DamageInstigator,
	out int Damage,
	vector HitLocation,
	name DamageType,
	out vector Momentum)
{
	if (Injured == DamageInstigator && UGoldFix.bEnableGameFix && UGoldFix.bAdjustSelfDamageMomentum)
		Momentum /= 0.6; // compensates "momentum *= 0.6" in Engine.Pawn.TakeDamage
	if (bHandleSafeFall)
		HandleSafeFall(Injured, Damage, DamageType);
}

function ModifyPlayer(Pawn P)
{
	if (!UGoldFix.bEnableGameFix)
		return;

	if (P != none)
		UGoldFix.InitPlayer(P);
	if (UGoldFix.bAdjustSpawnedPlayerState)
		Spawn(class'SpawnedPlayerStateAdjustment').ControlledPlayer = P;
}

function ModifyPlayerStart(Pawn P, out NavigationPoint StartPoint, byte Team)
{
	if (StartPoint == none && UGoldFix.bEnableGameFix && UGoldFix.bExtraPlayerStartLookup)
		StartPoint = FindPlayerStart(Team, GetIncomingTag());
}


function HandleSafeFall(Pawn LandedPawn, out int Damage, name DamageType)
{
	local SafeFall SafeFall;

	if (DamageType != 'fell')
		return;
	foreach LandedPawn.TouchingActors(class'SafeFall', SafeFall)
	{
		Damage = 0;
		return;
	}
}

function NavigationPoint FindPlayerStart(byte Team, optional string IncomingName)
{
	local PlayerStart Dest, Candidate[32], Best;
	local Teleporter Tel, SrcTel;
	local string TelTag;
	local float Score[32], BestScore, NextDist;
	local Pawn OtherPlayer;
	local int i, num;

	num = 0;

	foreach AllActors(class'PlayerStart', Dest)
	{
		if (Dest.bEnabled && (Dest.bSinglePlayerStart || Dest.bCoopStart) && !Dest.Region.Zone.bWaterZone)
		{
			if (num < ArrayCount(Candidate))
				Candidate[num] = Dest;
			else if (Rand(num) < ArrayCount(Candidate))
				Candidate[Rand(ArrayCount(Candidate))] = Dest;
			++num;
		}
	}
	if (num == 0) // No enabled start found outside of water zones
		foreach AllActors(class'PlayerStart', Dest)
		{
			if (Dest.bEnabled && (Dest.bSinglePlayerStart || Dest.bCoopStart))
			{
				if (num < ArrayCount(Candidate))
					Candidate[num] = Dest;
				else if (Rand(num) < ArrayCount(Candidate))
					Candidate[Rand(ArrayCount(Candidate))] = Dest;
				++num;
			}
		}

	if (num == 0) // No enabled start found
	{
		foreach AllActors(class'PlayerStart', Dest)
		{
			if ((Dest.bSinglePlayerStart || Dest.bCoopStart) && !Dest.Region.Zone.bWaterZone)
			{
				if (num < ArrayCount(Candidate))
					Candidate[num] = Dest;
				else if (Rand(num) < ArrayCount(Candidate))
					Candidate[Rand(ArrayCount(Candidate))] = Dest;
				++num;
			}
		}
	}

	if (num == 0) // No disabled start found outside of water zones
	{
		foreach AllActors(class'PlayerStart', Dest)
		{
			if (Dest.bSinglePlayerStart || Dest.bCoopStart)
			{
				if (num < ArrayCount(Candidate))
					Candidate[num] = Dest;
				else if (Rand(num) < ArrayCount(Candidate))
					Candidate[Rand(ArrayCount(Candidate))] = Dest;
				++num;
			}
		}
	}

	if (num == 0)
	{
		if (IncomingName != "")
		{
			foreach AllActors(class'Teleporter', Tel)
				if (string(Tel.Tag) ~= IncomingName)
					return Tel;
		}
		foreach AllActors(class'Teleporter', Tel)
		{
			if (Tel.Tag == '' || Tel.Tag == Tel.class.name || Tel.URL != "")
				continue;
			TelTag = string(Tel.Tag);
			num = 1;
			foreach AllActors(class'Teleporter', SrcTel)
				if (Tel != SrcTel && TelTag ~= SrcTel.URL)
				{
					num = 0;
					break;
				}
			if (num == 1)
				return Tel;
		}
		return none;
	}

	if (num > ArrayCount(Candidate))
		num = ArrayCount(Candidate);

	for (i = 0; i < num; ++i)
		Score[i] = 4000 * FRand(); // randomize

	foreach AllActors(class'Pawn', OtherPlayer)
	{
		if (IsPlayer(OtherPlayer))
		{
			for (i = 0; i < num; i++)
			{
				NextDist = VSize(OtherPlayer.Location - Candidate[i].Location);
				Score[i] += NextDist;
				if (NextDist < OtherPlayer.CollisionRadius + OtherPlayer.CollisionHeight)
					Score[i] -= 1000000.0;
			}
		}
	}

	BestScore = Score[0];
	Best = Candidate[0];
	for (i = 1; i < num; ++i)
	{
		if (Score[i] > BestScore)
		{
			BestScore = Score[i];
			Best = Candidate[i];
		}
	}

	return Best;
}

function string GetIncomingTag()
{
	local string S;
	local int Offset;

	S = Level.GetLocalURL();

	while (true)
	{
		Offset = InStr(S, "#");
		if (Offset < 0)
			return "";
		S = Mid(S, Offset + 1);

		Offset = InStr(S, "?");
		if (Offset < 0)
			return S;
		S = Mid(S, Offset + 1);
	}
	return "";
}

static function bool IsPlayer(Pawn Player)
{
	return Player != none && Player.bIsPlayer && Player.PlayerReplicationInfo != none;
}

defaultproperties
{
	bModifyDamage=True
	bNotifySpawnPoint=True
}

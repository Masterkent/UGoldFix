//=============================================================================
// UGoldFix v10.4                                            Author: Masterkent
//                                                             Date: 2023-03-13
//=============================================================================
class UGoldFix expands UGoldFixBase
	config(UGoldFix);

var const string VersionInfo;
var const string Version;

// Configurable properties:
// - General:
var(General) config bool bEnableGameFix;
var(General) config bool bEnableMapFix;

// - Advanced [bEnableGameFix]:
var(Advanced_GameFix) config bool bAdjustActorsOutOfWorld;
var(Advanced_GameFix) config bool bAdjustCrushingMovers;
var(Advanced_GameFix) config bool bAdjustDispersionAmmoAmount;
var(Advanced_GameFix) config bool bAdjustDispersionFireRate;
var(Advanced_GameFix) config bool bAdjustDistanceLightnings;
var(Advanced_GameFix) config bool bAdjustEnhancedSightCheck;
var(Advanced_GameFix) config bool bAdjustExplodingWalls;
var(Advanced_GameFix) config bool bAdjustGLGrenades;
var(Advanced_GameFix) config bool bAdjustMoverMovements;
var(Advanced_GameFix) config bool bAdjustNetUpdateFrequency;
var(Advanced_GameFix) config bool bAdjustSelfDamageMomentum;
var(Advanced_GameFix) config bool bAdjustSpaceMarineCarcasses;
var(Advanced_GameFix) config bool bAdjustSpaceMarineCARDamage;
var(Advanced_GameFix) config bool bAdjustSpawnedPlayerState;
var(Advanced_GameFix) config bool bAdjustTransientSoundVolume;
var(Advanced_GameFix) config bool bAdjustUPakBursts;
var(Advanced_GameFix) config bool bAllowAbnormalActors;
var(Advanced_GameFix) config bool bCheckActorPackages;
var(Advanced_GameFix) config bool bDisableMoversGoodCollision;
var(Advanced_GameFix) config bool bDisableNetInterpolatePos;
var(Advanced_GameFix) config bool bDisableOrientToGround;
var(Advanced_GameFix) config bool bDisableZoneEnvironmentMapping; // only for 227i network clients
var(Advanced_GameFix) config bool bExtraPlayerStartLookup;
var(Advanced_GameFix) config bool bGiveUPakScubaGear;
var(Advanced_GameFix) config bool bRemoveDestructibleBrushes;
var(Advanced_GameFix) config bool bReplaceBigRocks;
var(Advanced_GameFix) config bool bReplaceBlastDecals;
var(Advanced_GameFix) config bool bReplaceExplosiveBullets;
var(Advanced_GameFix) config bool bReplaceFlashLightBeams;
var(Advanced_GameFix) config bool bReplaceGrenades;
var(Advanced_GameFix) config bool bReplaceOctagons;
var(Advanced_GameFix) config bool bReplaceRazorBlades;
var(Advanced_GameFix) config bool bReplaceRockets;
var(Advanced_GameFix) config bool bReplaceUPakRockets;
var(Advanced_GameFix) config bool bReplaceWarlordRockets;
var(Advanced_GameFix) config bool bRestrictMoversRetriggering;

// - Advanced [bEnableMapFix]:
var(Advanced_MapFix) config bool bAdjustDynamicLightMover;
var(Advanced_MapFix) config bool bAdjustFallingMovers;
var(Advanced_MapFix) config bool bCoverHolesInLevelsGeometry;
var(Advanced_MapFix) config bool bEnableDecorativeMapChanges;
var(Advanced_MapFix) config bool bEnableLogicMapChanges;
var(Advanced_MapFix) config bool bImproveNPCBehavior;
var(Advanced_MapFix) config bool bModifyNalic2Exit;
var(Advanced_MapFix) config bool bModifyNetRelevance;
var(Advanced_MapFix) config bool bPreventFastRetriggering;
var(Advanced_MapFix) config bool bUnlockNaliSecrets;

// - Multiplayer:
var(Multiplayer) config bool bEnableMoverProtection;
var(Multiplayer) config bool bEnableExtraProtection;

var(Multiplayer) config bool bEnableStationaryEquipment;
var(Multiplayer) config string StationaryEquipment;

var(Multiplayer) config bool bAdjustCovertThingFactories;
var(Multiplayer) config float CovertThingFactoryTimeout;

// Auxiliary properties:
var transient bool bInitializedClassReplacements;
var bool bActiveMutator;
var bool bLevelPostStartupHandled;
var bool bUnrealMap;
var bool bRtnpMap;
var bool bRtnpIntermissionLevel;
var bool bStandardSPMap;
var bool bDisablePlayerMoves;

// UPak resources
var class<Actor> class_BubbleTrail;
var class<Weapon> class_CARifle;
var class<Effects> class_CARWallHitEffect3;
var class<Projectile> class_ExplosiveBullet;
var class<Projectile> class_GLDetGrenade;
var class<Projectile> class_GLGrenade;
var class<Weapon> class_GrenadeLauncher;
var class<Actor> class_Octagon;
var class<Weapon> class_RocketLauncher;
var class<Actor> class_SpaceMarineCarcass;
var class<Projectile> class_TowRocket;
var class<Effects> class_UPakBurst;
var class<Effects> class_UPakExplosion1;
var class<Effects> class_UPakExplosion2;
var class<Projectile> class_UPakRocket;
var class<Pickup> class_UPakScubaGear;

var mesh mesh_Octagon;

var sound sound_BeamIn;
var sound sound_RocketShot1;
var sound sound_RocketLoop1;
var sound sound_RocketLoop2;

struct StationaryEquipmentTypeInfo
{
	var name PackageName;
	var name ClassName;
};

var array<StationaryEquipmentTypeInfo> StationaryEquipmentClasses;

var UGoldFixGameRules GameRules;
var transient MapFixClient MapFixClient;


event BeginPlay()
{
	local UGoldFix m;

	foreach AllActors(class'UGoldFix', m)
		if (m.bActiveMutator)
			return;

	bActiveMutator = true;
	AddToPackagesMap(string(class'UGoldFixCommon'.Outer.Name));
	ApplyUGoldFix();
}

function ApplyUGoldFix()
{
	ClassifyCurrentMap();

	if (bEnableGameFix)
	{
		LoadUPakResources();
		InitClassReplacements();
		Spawn(class'UGoldFixSpawnNotify').Init(self);

		ApplyServerGameFix();
		ApplyCommonGameFix();
	}
	if (Level.NetMode != NM_Standalone)
	{
		if (bEnableMoverProtection)
			InitMoverProtection();
		if (bEnableStationaryEquipment && !Level.Game.bDeathMatch)
			InitStationaryEquipmentList();
		if (bAdjustCovertThingFactories && CovertThingFactoryTimeout > 0)
			InitCovertThingFactoryControllers();
	}
	if (bEnableMapFix)
		FixCurrentMap();

	if (bEnableGameFix)
		ApplyNextServerGameFix();

	SaveConfig();

	if (!bEnableGameFix)
		Disable('Tick');
}

event Tick(float DeltaTime)
{
	if (!bLevelPostStartupHandled)
	{
		LevelPostStartupAdjustments();
		bLevelPostStartupHandled = true;
	}
	if (!bInitializedClassReplacements && bActiveMutator && bEnableGameFix)
		InitClassReplacements();
}

function bool CheckReplacement(Actor A, out byte bSuperRelevant)
{
	if (!bActiveMutator || A.bDeleteMe)
		return true;

	return AdjustSpawnedActor(A);
}

function bool AdjustSpawnedActor(Actor A)
{
	local string msg;

	if (bDisablePlayerMoves && PlayerPawn(A) != none)
		DisablePlayerMoves(Pawn(A));

	if (!bEnableGameFix)
		return true;

	if (Level.NetMode != NM_Standalone &&
		bCheckActorPackages &&
		(A.bIsPawn || Inventory(A) != none) &&
		bLevelPostStartupHandled &&
		!CheckActorPackage(A))
	{
		if (PlayerPawn(A.Instigator) != none && PlayerPawn(A.Instigator).bAdmin && A.Location != A.Instigator.Location)
		{
			msg = "UGoldFix Warning: New actor of type" @ A.class @ "is irrelevant because package" @
				GetObjectPackageName(A.class) @ "is not included in the ServerPackages map";
			A.Instigator.ClientMessage(msg);
			msg = "    * Note: UGoldFix.bCheckActorPackages == True" $ ", UGoldFix.bAllowAbnormalActors == " $ bAllowAbnormalActors;
			A.Instigator.ClientMessage(msg);
		}
		if (!bAllowAbnormalActors || A.Instigator != none && A.Location == A.Instigator.Location)
			return false;
	}
	else if (A.class == class'FlashlightBeam')
		return CreateFlashLightBeamReplacement(FlashLightBeam(A));
	else if (Projectile(A) != none)
	{
		if (A.class == class_ExplosiveBullet)
			return ReplaceExplosiveBullet(A);
		if (A.class == class'Grenade')
			return DisarmProjectile(Projectile(A), bReplaceGrenades);
		if (A.class == class'RazorBlade' || A.class == class'RazorBladeAlt')
			return DisarmProjectile(Projectile(A), bReplaceRazorBlades);
		if (ActorIsA(A, 'UPak', 'UPakRocket'))
			return ReplaceUPakRocket(A);
		if (A.class == class'Rocket' || A.class == class'SeekingRocket')
			return DisarmProjectile(Projectile(A), bReplaceRockets);
		if (A.class == class'WarlordRocket')
			return DisarmProjectile(Projectile(A), bReplaceWarlordRockets);
	}
	else if (A.class == class_SpaceMarineCarcass)
		return CheckSpaceMarineCarcass(A);
	return true;
}

function DisablePlayerMoves(Pawn P)
{
	P.AirControl = 0;
	P.GroundSpeed = 0;
}

function bool CheckActorPackage(Actor A)
{
	local name PackageName;

	PackageName = class'UGoldFix'.static.GetObjectPackageName(A.class);
	return
		PackageName == 'Engine' ||
		PackageName == 'UnrealI' ||
		PackageName == 'UnrealShare' ||
		IsInPackageMap(string(PackageName));
}


function name CurrentMap()
{
	return Level.Outer.Name;
}

static function name GetObjectPackageName(Object X)
{
	while (X.Outer != none)
		X = X.Outer;
	return X.Name;
}

static function bool ActorIsA(Actor A, name ClassOuterName, name ClassName)
{
	return A != none && A.Class.Outer.Name == ClassOuterName && A.IsA(ClassName);
}

function Actor LoadLevelActor(string ActorName)
{
	return Actor(DynamicLoadObject(Level.Outer.Name $ "." $ ActorName, class'Actor'));
}

function class<Actor> LoadClass(string ClassName, optional bool bNoFailureWarning)
{
	return class<Actor>(DynamicLoadObject(ClassName, class'class', bNoFailureWarning));
}

function bool CheckClass(string ClassName)
{
	return class<Actor>(DynamicLoadObject(ClassName, class'class', true)) != none;
}


function ClassifyCurrentMap()
{
	local name CurrentMapName;

	bRtnpIntermissionLevel =
		Level.DefaultGameType != none && Level.DefaultGameType.name == 'UPakTransitionInfo';

	if (bRtnpIntermissionLevel)
	{
		bUnrealMap = false;
		bRtnpMap = true;
		return;
	}

	CurrentMapName = CurrentMap();

	if (CurrentMapName == 'Vortex2' ||
		CurrentMapName == 'NyLeve' ||
		CurrentMapName == 'Dig' ||
		CurrentMapName == 'Dug' ||
		CurrentMapName == 'Passage' ||
		CurrentMapName == 'Chizra' ||
		CurrentMapName == 'Ceremony' ||
		CurrentMapName == 'Dark' ||
		CurrentMapName == 'Harobed' ||
		CurrentMapName == 'TerraLift' ||
		CurrentMapName == 'Terraniux' ||
		CurrentMapName == 'Noork' ||
		CurrentMapName == 'Ruins' ||
		CurrentMapName == 'Trench' ||
		CurrentMapName == 'IsvKran4' ||
		CurrentMapName == 'IsvKran32' ||
		CurrentMapName == 'IsvDeck1' ||
		CurrentMapName == 'SpireVillage' ||
		CurrentMapName == 'TheSunspire' ||
		CurrentMapName == 'SkyCaves' ||
		CurrentMapName == 'SkyTown' ||
		CurrentMapName == 'SkyBase' ||
		CurrentMapName == 'VeloraEnd' ||
		CurrentMapName == 'Bluff' ||
		CurrentMapName == 'DasaPass' ||
		CurrentMapName == 'DasaCellars' ||
		CurrentMapName == 'NaliBoat' ||
		CurrentMapName == 'NaliC' ||
		CurrentMapName == 'DCrater' ||
		CurrentMapName == 'ExtremeBeg' ||
		CurrentMapName == 'ExtremeLab' ||
		CurrentMapName == 'ExtremeCore' ||
		CurrentMapName == 'ExtremeGen' ||
		CurrentMapName == 'ExtremeDGen' ||
		CurrentMapName == 'ExtremeDark' ||
		CurrentMapName == 'ExtremeEnd' ||
		CurrentMapName == 'QueenEnd')
	{
		bUnrealMap = true;
		bRtnpMap = false;
		bStandardSPMap = true;
		return;
	}

	if (CurrentMapName == 'DmAriza' ||
		CurrentMapName == 'DmCurse' ||
		CurrentMapName == 'DmDeathFan' ||
		CurrentMapName == 'DmDeck16' ||
		CurrentMapName == 'DmElsinore' ||
		CurrentMapName == 'DmFith' ||
		CurrentMapName == 'DmHealPod' ||
		CurrentMapName == 'DmMorbias' ||
		CurrentMapName == 'DmRadikus' ||
		CurrentMapName == 'DmTundra')
	{
		bUnrealMap = true;
		bRtnpMap = false;
		bStandardSPMap = false;
		return;
	}

	if (CurrentMapName == 'DuskFalls' ||
		CurrentMapName == 'Nevec' ||
		CurrentMapName == 'Eldora' ||
		CurrentMapName == 'Glathriel1' ||
		CurrentMapName == 'Glathriel2' ||
		CurrentMapName == 'Crashsite' ||
		CurrentMapName == 'Crashsite1' ||
		CurrentMapName == 'Crashsite2' ||
		CurrentMapName == 'SpireLand' ||
		CurrentMapName == 'Nagomi' ||
		CurrentMapName == 'Velora' ||
		CurrentMapName == 'NagomiSun' ||
		CurrentMapName == 'Foundry' ||
		CurrentMapName == 'Toxic' ||
		CurrentMapName == 'Glacena' ||
		CurrentMapName == 'Abyss' ||
		CurrentMapName == 'Nalic2')
	{
		bUnrealMap = false;
		bRtnpMap = true;
		bStandardSPMap = true;
		return;
	}

	if (CurrentMapName == 'DmAthena' ||
		CurrentMapName == 'DmDaybreak' ||
		CurrentMapName == 'DmHazard' ||
		CurrentMapName == 'DmStomp' ||
		CurrentMapName == 'DmSunSpeak' ||
		CurrentMapName == 'DmTerra')
	{
		bUnrealMap = false;
		bRtnpMap = true;
		bStandardSPMap = false;
		return;
	}
}

function LoadUPakResources()
{
	local bool has_upak;

	has_upak = CheckClass("UPak.CARifle");

	if (has_upak)
	{
		// load UPak resources
		class_BubbleTrail = LoadClass("UPak.BubbleTrail");
		class_CARifle = class<Weapon>(LoadClass("UPak.CARifle"));
		class_CARWallHitEffect3 = class<Effects>(LoadClass("UPak.CARWallHitEffect3"));
		class_ExplosiveBullet = class<Projectile>(LoadClass("UPak.ExplosiveBullet"));
		class_GLDetGrenade = class<Projectile>(LoadClass("UPak.GLDetGrenade"));
		class_GLGrenade = class<Projectile>(LoadClass("UPak.GLGrenade"));
		class_GrenadeLauncher = class<Weapon>(LoadClass("UPak.GrenadeLauncher"));
		class_Octagon = LoadClass("UPak.Octagon");
		class_RocketLauncher = class<Weapon>(LoadClass("UPak.RocketLauncher"));
		class_SpaceMarineCarcass = LoadClass("UPak.SpaceMarineCarcass");
		class_TowRocket = class<Projectile>(LoadClass("UPak.TowRocket"));
		class_UPakBurst = class<Effects>(LoadClass("UPak.UPakBurst"));
		class_UPakExplosion1 = class<Effects>(LoadClass("UPak.UPakExplosion1"));
		class_UPakExplosion2 = class<Effects>(LoadClass("UPak.UPakExplosion2"));
		class_UPakRocket = class<Projectile>(LoadClass("UPak.UPakRocket"));
		class_UPakScubaGear = class<Pickup>(LoadClass("UPak.UPakScubaGear"));

		mesh_Octagon = mesh(DynamicLoadObject("UPak.Octagon", class'mesh'));

		sound_BeamIn = sound(DynamicLoadObject("UPak.BeamIn", class'sound'));
		sound_RocketShot1 = sound(DynamicLoadObject("UPak.RocketShot1", class'sound'));
		sound_RocketLoop1 = sound(DynamicLoadObject("UPak.RocketLoop1", class'sound'));
		sound_RocketLoop2 = sound(DynamicLoadObject("UPak.RocketLoop2", class'sound'));
	}
}

function InitClassReplacements()
{
	if (bReplaceExplosiveBullets && class_ExplosiveBullet != none)
		MakeNonGameRelevant(class_ExplosiveBullet);

	if (bReplaceGrenades)
		MakeNonGameRelevant(class'UnrealShare.Grenade');

	if (bReplaceRazorBlades)
	{
		MakeNonGameRelevant(class'UnrealI.RazorBlade');
		MakeNonGameRelevant(class'UnrealI.RazorBladeAlt');
	}

	if (bReplaceRockets)
	{
		MakeNonGameRelevant(class'UnrealShare.Rocket');
		MakeNonGameRelevant(class'UnrealShare.SeekingRocket');
	}

	if (bReplaceUPakRockets &&
		class_UPakRocket != none &&
		class_TowRocket != none)
	{
		MakeNonGameRelevant(class_UPakRocket);
		MakeNonGameRelevant(class_TowRocket);
	}

	if (bReplaceWarlordRockets)
		MakeNonGameRelevant(class'UnrealI.WarlordRocket');

	bInitializedClassReplacements = true;
}

// Called before map-specific fixes
function ApplyServerGameFix()
{
	if (bAdjustActorsOutOfWorld)
		AdjustActorsOutOfWorld();
	if (bRemoveDestructibleBrushes)
		RemoveDestructibleBrushes();
	if (bAdjustCrushingMovers)
		AdjustCrushingMovers();
	if (bAdjustDistanceLightnings)
		AdjustDistanceLightnings();
	if (bAdjustEnhancedSightCheck)
		AdjustEnhancedSightCheck();
	if (bAdjustExplodingWalls)
		AdjustExplodingWalls();
	if (bAdjustTransientSoundVolume)
		AdjustTransientSoundVolume();
	if (bAdjustNetUpdateFrequency)
		AdjustNetUpdateFrequency();
	if (bDisableMoversGoodCollision)
		class'UGoldFixCommon'.static.DisableMoversGoodCollision(Level);
	if (bDisableOrientToGround)
		DisableOrientToGround();
	if (bRestrictMoversRetriggering)
		RestrictMoversRetriggering();
	AddGameRules();
}

function ApplyCommonGameFix()
{
	local UGoldFixCommon UGoldFixCommon;

	if (Level.NetMode == NM_Standalone)
		return;

	UGoldFixCommon = Spawn(class'UGoldFixCommon', self);

	UGoldFixCommon.bAdjustDistanceLightnings = bAdjustDistanceLightnings;
	UGoldFixCommon.bAdjustUPakBursts = bAdjustUPakBursts;
	UGoldFixCommon.bDisableMoversGoodCollision = bDisableMoversGoodCollision;
	UGoldFixCommon.bDisableNetInterpolatePos = bDisableNetInterpolatePos;
	UGoldFixCommon.bDisableZoneEnvironmentMapping = bDisableZoneEnvironmentMapping;
}

// Called after map-specific fixes
function ApplyNextServerGameFix()
{
	if (bAdjustMoverMovements)
		AdjustMoverMovements();
}

function AdjustActorsOutOfWorld()
{
	local Actor A;

	foreach AllActors(class'Actor', A)
		if (A.Region.ZoneNumber <= 0 && A.Physics == PHYS_Falling && A.bNoDelete)
			A.SetPhysics(PHYS_None);
}

function RemoveDestructibleBrushes()
{
	local Brush br;

	if (Level.NetMode == NM_Standalone)
		return;

	foreach AllActors(class'Brush', br)
		if (!br.bNoDelete && !br.bStatic)
			br.Destroy();
}

function AdjustCrushingMovers()
{
	local Mover m;

	foreach AllActors(class'Mover', m)
		if (m.MoverEncroachType == ME_CrushWhenEncroach)
			m.EncroachDamage = Max(m.EncroachDamage, 1000000);
}

function AdjustDistanceLightnings()
{
	local DistanceLightning A;

	if (Level.NetMode == NM_Standalone)
		return;
	foreach AllActors(class'Engine.DistanceLightning', A)
		if (A.class == class'Engine.DistanceLightning')
			A.RemoteRole = ROLE_None;
}

function AdjustEnhancedSightCheck()
{
	// AI fix (Issue: creatures can see through non-transparent movers or
	// behave in a strange manner in presence of an unreachable player or several players
	// behind a transparent wall)
	Level.Game.bAlwaysEnhancedSightCheck = false;
}

function AdjustExplodingWalls()
{
	local ExplodingWallsController ExplodingWallsController;
	local ExplodingWall ExplodingWall;

	foreach AllActors(class'ExplodingWall', ExplodingWall)
		if (ExplodingWall.Class.Outer.Name == 'UnrealShare')
		{
			if (ExplodingWallsController == none)
			{
				ExplodingWallsController = Spawn(class'ExplodingWallsController');
				if (ExplodingWallsController == none)
					return;
			}
			ExplodingWallsController.AddExplodingWall(ExplodingWall);
		}
}

function AdjustTransientSoundVolume()
{
	const MaxTransientSoundVolume = 327.675; // max value of sound volume that can be replicated to clients
	local Actor A;

	if (Level.NetMode != NM_Standalone)
		foreach AllActors(class'Actor', A)
		{
			// Note: TransientSoundVolume > 1 makes sounds louder when using Galaxy audio subsystem
			if (A.TransientSoundVolume > MaxTransientSoundVolume)
				A.TransientSoundVolume = MaxTransientSoundVolume;
		}
}

function AdjustMoverMovements()
{
	local Mover M;

	if (Level.NetMode == NM_Standalone)
		return;

	foreach AllActors(class'Mover', M)
		if (Level.Game.IsRelevant(M) &&
			M.RemoteRole == ROLE_SimulatedProxy &&
			M.ClientUpdate >= 0)
		{
			M.bAlwaysRelevant = true;
			Spawn(class'MoverMovementSynchronizer').ControlledMover = M;
		}
}

// Reverts crazy 227j's change of ReplicationInfo's NetUpdateFrequency
function AdjustNetUpdateFrequency()
{
	local ReplicationInfo RepInfo;

	if (ShouldAdjustNetUpdateFrequency())
		foreach AllActors(class'ReplicationInfo', RepInfo)
			AdjustReplicationInfoNetUpdateFrequency(RepInfo);
}

function bool ShouldAdjustNetUpdateFrequency()
{
	return
		bAdjustNetUpdateFrequency &&
		Level.NetMode != NM_Standalone &&
		class'ReplicationInfo'.default.NetUpdateFrequency < 100;
}

static function AdjustReplicationInfoNetUpdateFrequency(ReplicationInfo RepInfo)
{
	if (RepInfo.NetUpdateFrequency == class'ReplicationInfo'.default.NetUpdateFrequency)
		RepInfo.NetUpdateFrequency = 100;
}

function DisableOrientToGround()
{
	local Decoration Deco;

	foreach AllActors(class'Decoration', Deco)
		Deco.bOrientToGround = false;
}

function RestrictMoversRetriggering()
{
	Level.Game.bRestrictMoversRetriggering = true;
}

function AddGameRules()
{
	if (GameRules == none)
		GameRules = Spawn(class'UGoldFixGameRules', self);
}


// Prevents Movers from being blocked by other actors
// Rationale: blocking some key Movers could make ending a level impossible
function InitMoverProtection()
{
	local Mover m;

	if (!AddMoverProtectionMutator())
	{
		foreach AllActors(class'Mover', m)
			if (m.MoverEncroachType == ME_ReturnWhenEncroach || m.MoverEncroachType == ME_StopWhenEncroach)
				m.MoverEncroachType = ME_IgnoreWhenEncroach;
	}
}

function bool AddMoverProtectionMutator()
{
	local class<Mutator> MoverProtectionMutatorClass;
	local Mutator MoverProtectionMutator;
	MoverProtectionMutatorClass =
		class<Mutator>(LoadClass("MoverProtection.MoverProtection", true));
	if (MoverProtectionMutatorClass != none)
	{
		MoverProtectionMutator = Spawn(MoverProtectionMutatorClass);
		AddMutator(MoverProtectionMutator);
		return MoverProtectionMutator != none;
	}
	return false;
}

function InitStationaryEquipmentList()
{
	local int i;
	local int space_pos, dot_pos;
	local string EquipmentList;
	local string ClassName;

	if (StationaryEquipment == "")
		return;

	EquipmentList = StationaryEquipment;
	i = 0;

	while (true)
	{
		space_pos = InStr(EquipmentList, " ");
		if (space_pos < 0)
			ClassName = EquipmentList;
		else
		{
			ClassName = Left(EquipmentList, space_pos);
			EquipmentList = Mid(EquipmentList, space_pos + 1);
		}
		dot_pos = InStr(ClassName, ".");
		if (dot_pos < 0)
		{
			StationaryEquipmentClasses[i].PackageName = '';
			StationaryEquipmentClasses[i].ClassName = StringToName(ClassName);
		}
		else
		{
			StationaryEquipmentClasses[i].PackageName = StringToName(Left(ClassName, dot_pos));
			StationaryEquipmentClasses[i].ClassName = StringToName(Mid(ClassName, dot_pos + 1));
		}

		if (StationaryEquipmentClasses[i].ClassName != '')
			++i;

		if (space_pos < 0)
			break;
	}
}

function InitCovertThingFactoryControllers()
{
	local ThingFactory Factory;
	local CovertThingFactoryController FactoryController;

	foreach AllActors(class'ThingFactory', Factory)
		if (Factory.bCovert && Level.Game.IsRelevant(Factory) && Factory.Class.Outer.Name == 'UnrealShare')
		{
			FactoryController = Spawn(class'CovertThingFactoryController');
			FactoryController.ControlledFactory = Factory;
			FactoryController.Timeout = CovertThingFactoryTimeout;
		}
}


function FixCurrentMap()
{
	local MapFixServer MapFixServer;

	MapFixClient = Spawn(class'MapFixClient', self);
	MapFixServer = Spawn(class'MapFixServer', self); // uses self.MapFixClient

	if (Level.NetMode == NM_Standalone)
		MapFixClient.Destroy();
	MapFixServer.Destroy();
}

function LevelPostStartupAdjustments()
{
	if (bCheckActorPackages && !bAllowAbnormalActors)
		CheckActorPackages();
	if (bEnableStationaryEquipment && Level.NetMode != NM_Standalone && !Level.Game.bDeathMatch)
		WrapStationaryEquipment();
}

function CheckActorPackages()
{
	local Inventory anInventory;
	local Pawn aPawn;

	if (Level.NetMode == NM_Standalone)
		return;

	foreach AllActors(class'Inventory', anInventory)
		if (!CheckActorPackage(anInventory))
			anInventory.Destroy();

	foreach AllActors(class'Pawn', aPawn)
		if (!CheckActorPackage(aPawn))
			aPawn.Destroy();
}

function WrapStationaryEquipment()
{
	local Inventory inv;

	foreach AllActors(class'Inventory', inv)
		if (inv.Owner == none && !inv.bHeldItem && IsStationaryEquipment(inv))
			Spawn(class'InventoryTrigger').AttachInventory(inv);
}

function MakeNonGameRelevant(class<Actor> ActorClass)
{
	ActorClass.default.bGameRelevant = false;
}


function bool IsStationaryEquipment(Inventory Inv)
{
	local int i, n;
	n = Array_Size(StationaryEquipmentClasses);
	for (i = 0; i < n && StationaryEquipmentClasses[i].ClassName != ''; ++i)
		if (Inv.class.name == StationaryEquipmentClasses[i].ClassName)
		{
			if (StationaryEquipmentClasses[i].PackageName != '')
			{
				if (Inv.Class.Outer.Name == StationaryEquipmentClasses[i].PackageName)
					return true;
			}
			else if (Inv.Class.Outer.Name == 'UnrealI' ||
				Inv.Class.Outer.Name == 'UnrealShare' ||
				Inv.Class.Outer.Name == 'UPak')
			{
				return true;
			}
		}
	return false;
}

function bool CreateFlashLightBeamReplacement(FlashLightBeam A)
{
	if (bReplaceFlashLightBeams && Level.NetMode != NM_Standalone)
		class'UnrealShare_FlashLightBeam'.static.CreateReplacement(A);
	return true;
}

function bool DisarmProjectile(Projectile Proj, bool bActual)
{
	if (!bActual)
		return true;
	Proj.bCollideWhenPlacing = false;
	Proj.bCollideWorld = false;
	Proj.SetCollision(false);
	Proj.Disable('ZoneChange');
	Proj.SpawnSound = none;
	return true;
}

function bool ReplaceExplosiveBullet(Actor A)
{
	local UPak_ExplosiveBullet proj;

	if (!bReplaceExplosiveBullets)
		return true;

	proj = A.Spawn(class'UPak_ExplosiveBullet',,, A.Location, A.Rotation);
	if (proj != none)
		proj.UGoldFix = self;

	A.SetLocation(vect(0, 0, -100000));
	return false;
}

function bool ReplaceUPakRocket(Actor A)
{
	local class<UPak_UPakRocket> rocket_class;
	local UPak_UPakRocket proj;

	if (!bReplaceUPakRockets)
		return true;

	if (A.class.name == 'TowRocket')
		rocket_class = class'UPak_TowRocket';
	else
		rocket_class = class'UPak_UPakRocket';

	proj = A.Spawn(rocket_class, A.Owner,, A.Location, A.Rotation);
	if (proj != none)
		proj.UGoldFix = self;

	A.SetLocation(vect(0, 0, -100000));
	return false;
}

function bool CheckSpaceMarineCarcass(Actor Carcass)
{
	if (!bAdjustSpaceMarineCarcasses)
		return true;
	return Carcass.Instigator == none || !Carcass.Instigator.bDeleteMe;
}


function InitPlayer(Pawn P)
{
	if (Level.NetMode != NM_Standalone && !Level.Game.bDeathMatch)
		GiveInitialInventoryTo(P);
}

function GiveInitialInventoryTo(Pawn Player)
{
	if (IsSpectator(Player) || Player.Health <= 0)
		return;
	if (bGiveUPakScubaGear && bRtnpMap && bStandardSPMap)
		CheckScubaGear(Player);
}

function bool IsSpectator(Pawn Player)
{
	return Player.PlayerReplicationInfo != none && Player.PlayerReplicationInfo.bIsSpectator;
}

function CheckScubaGear(Pawn Player)
{
	local Pickup newScubaGear;

	if (IsSpectator(Player) || Player.Health <= 0 ||
		class_UPakScubaGear == none ||
		Player.FindInventoryType(class_UPakScubaGear) != none)
	{
		return;
	}

	newScubaGear = Spawn(class_UPakScubaGear,,, Location);

	if (newScubaGear != none)
	{
		newScubaGear.bHeldItem = true;
		newScubaGear.GiveTo(Player);
		newScubaGear.PickupFunction(Player);
		if (Player.SelectedItem == none)
			Player.SelectedItem = newScubaGear;
	}
}

function bool EnabledDecorativeMapChanges()
{
	return bEnableDecorativeMapChanges;
}

function bool ShouldAdjustSpaceMarineCARDamage()
{
	return bAdjustSpaceMarineCARDamage;
}

function bool ShouldAdjustDynamicLightMover()
{
	return bEnableDecorativeMapChanges && bAdjustDynamicLightMover;
}

function bool ShouldCoverHolesInLevelsGeometry()
{
	return bEnableDecorativeMapChanges && bCoverHolesInLevelsGeometry;
}

function bool ShouldReplaceBlastDecals()
{
	return bReplaceBlastDecals;
}

function string GetHumanName()
{
	return "UGoldFix v10.4";
}

defaultproperties
{
	VersionInfo="UGoldFix v10.4 [2023-03-13]"
	Version="10.4"
	bEnableGameFix=True
	bEnableMapFix=True
	bAdjustActorsOutOfWorld=True
	bAdjustCrushingMovers=True
	bAdjustDispersionAmmoAmount=False
	bAdjustDispersionFireRate=True
	bAdjustDistanceLightnings=True
	bAdjustEnhancedSightCheck=True
	bAdjustExplodingWalls=True
	bAdjustGLGrenades=True
	bAdjustMoverMovements=True
	bAdjustNetUpdateFrequency=True
	bAdjustSelfDamageMomentum=False
	bAdjustSpaceMarineCarcasses=True
	bAdjustSpaceMarineCARDamage=False
	bAdjustSpawnedPlayerState=True
	bAdjustTransientSoundVolume=True
	bAdjustUPakBursts=True
	bAllowAbnormalActors=False
	bCheckActorPackages=True
	bDisableMoversGoodCollision=True
	bDisableNetInterpolatePos=True
	bDisableOrientToGround=True
	bDisableZoneEnvironmentMapping=True
	bExtraPlayerStartLookup=False
	bGiveUPakScubaGear=True
	bRemoveDestructibleBrushes=True
	bReplaceBigRocks=True
	bReplaceBlastDecals=True
	bReplaceExplosiveBullets=True
	bReplaceFlashLightBeams=True
	bReplaceGrenades=True
	bReplaceOctagons=True
	bReplaceRazorBlades=True
	bReplaceRockets=True
	bReplaceUPakRockets=True
	bReplaceWarlordRockets=True
	bRestrictMoversRetriggering=True
	bAdjustDynamicLightMover=True
	bAdjustFallingMovers=True
	bCoverHolesInLevelsGeometry=True
	bEnableDecorativeMapChanges=True
	bEnableLogicMapChanges=True
	bImproveNPCBehavior=True
	bModifyNalic2Exit=False
	bModifyNetRelevance=True
	bPreventFastRetriggering=True
	bUnlockNaliSecrets=False
	bEnableMoverProtection=True
	bEnableExtraProtection=True
	bEnableStationaryEquipment=True
	StationaryEquipment="AsbestosSuit JumpBoots SCUBAGear SearchLight ToxinSuit UPakScubaGear"
	bAdjustCovertThingFactories=False
	CovertThingFactoryTimeout=15
}

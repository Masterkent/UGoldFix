class MapFixClient expands UGoldFixInfo;

var bool bAdjustDynamicLightMover;
var bool bCoverHolesInLevelsGeometry;
var bool bEnableDecorativeMapChanges;

replication
{
	reliable if (Role == ROLE_Authority)
		bAdjustDynamicLightMover,
		bCoverHolesInLevelsGeometry,
		bEnableDecorativeMapChanges;
}

event PostBeginPlay()
{
	local UGoldFixBase UGoldFix;

	UGoldFix = UGoldFixBase(Owner);

	bAdjustDynamicLightMover = UGoldFix.ShouldAdjustDynamicLightMover(); // implies bEnableDecorativeMapChanges
	bCoverHolesInLevelsGeometry = UGoldFix.ShouldCoverHolesInLevelsGeometry();
	bEnableDecorativeMapChanges = UGoldFix.EnabledDecorativeMapChanges();

	if (Level.NetMode != NM_DedicatedServer)
		Client_FixCurrentMap();
}

simulated event PostNetBeginPlay()
{
	if (Level.NetMode != NM_Client)
		return;
	Client_FixCurrentMap();
	Destroy(); // Network clients don't need this actor anymore, but MapFixServer will use it server-side
}

simulated function Client_FixCurrentMap()
{
	local name CurrentMapName;
	local string CurrentMap;

	CurrentMapName = Level.Outer.Name;
	CurrentMap = string(CurrentMapName);

	// Unreal 1 maps
	if (CurrentMapName == 'Vortex2')
		Client_FixCurrentMap_Vortex2();
	else if (CurrentMapName == 'Dig')
		Client_FixCurrentMap_Dig();
	else if (CurrentMapName == 'Dug')
		Client_FixCurrentMap_Dug();
	else if (CurrentMapName == 'Chizra')
		Client_FixCurrentMap_Chizra();
	else if (CurrentMapName == 'Ceremony')
		Client_FixCurrentMap_Ceremony();
	else if (CurrentMapName == 'Dark')
		Client_FixCurrentMap_Dark();
	else if (CurrentMapName == 'TerraLift')
		Client_FixCurrentMap_TerraLift();
	else if (CurrentMapName == 'Noork')
		Client_FixCurrentMap_Noork();
	else if (CurrentMapName == 'Trench')
		Client_FixCurrentMap_Trench();
	else if (CurrentMapName == 'IsvKran32')
		Client_FixCurrentMap_IsvKran32();
	else if (CurrentMapName == 'SpireVillage')
		Client_FixCurrentMap_SpireVillage();
	else if (CurrentMapName == 'TheSunspire')
		Client_FixCurrentMap_TheSunspire();
	else if (CurrentMapName == 'SkyTown')
		Client_FixCurrentMap_SkyTown();
	else if (CurrentMapName == 'SkyBase')
		Client_FixCurrentMap_SkyBase();
	else if (CurrentMapName == 'Bluff')
		Client_FixCurrentMap_Bluff();
	else if (CurrentMapName == 'DasaCellars')
		Client_FixCurrentMap_DasaCellars();
	else if (CurrentMapName == 'NaliC')
		Client_FixCurrentMap_NaliC();
	else if (CurrentMapName == 'ExtremeLab')
		Client_FixCurrentMap_ExtremeLab();
	else if (CurrentMapName == 'ExtremeCore')
		Client_FixCurrentMap_ExtremeCore();
	else if (CurrentMapName == 'QueenEnd')
		Client_FixCurrentMap_QueenEnd();

	// RTNP maps
	else if (CurrentMapName == 'Eldora')
		Client_FixCurrentMap_Eldora();
	else if (CurrentMapName == 'Glathriel1')
		Client_FixCurrentMap_Glathriel1();
	else if (CurrentMapName == 'Glathriel2')
		Client_FixCurrentMap_Glathriel2();
	else if (CurrentMapName == 'Foundry')
		Client_FixCurrentMap_Foundry();
	else if (CurrentMapName == 'Toxic')
		Client_FixCurrentMap_Toxic();
}

//---------------------------------------------------------------------------------------------------------------------

simulated function Client_FixCurrentMap_Vortex2()
{
	if (bAdjustDynamicLightMover)
	{
		SetDynamicLightMover("Mover8");
		SetDynamicLightMover("Mover10");
		SetDynamicLightMover("Mover25");
		SetDynamicLightMover("Mover49");
		SetDynamicLightMover("Mover53");
	}
}

simulated function Client_FixCurrentMap_Dig()
{
	if (bAdjustDynamicLightMover)
	{
		SetDynamicLightMover("Mover15");
		SetDynamicLightMover("Mover24");
		SetDynamicLightMover("Mover27");
		SetDynamicLightMover("Mover38");
		SetDynamicLightMover("Mover46");
		SetDynamicLightMover("Mover47");
		SetDynamicLightMover("Mover48");
		SetDynamicLightMover("Mover49");
		SetDynamicLightMover("Mover67");
		SetDynamicLightMover("Mover80");
	}
}

simulated function Client_FixCurrentMap_Dug()
{
	if (bAdjustDynamicLightMover)
		SetDynamicLightMover("Mover69");
}

simulated function Client_FixCurrentMap_Chizra()
{
	if (bAdjustDynamicLightMover)
	{
		SetDynamicLightMover("Mover11");
		SetDynamicLightMover("Mover15");
		SetDynamicLightMover("Mover38");
		SetDynamicLightMover("Mover42");
		SetDynamicLightMover("Mover84");
	}
}

simulated function Client_FixCurrentMap_Ceremony()
{
	if (bAdjustDynamicLightMover)
	{
		SetDynamicLightMover("Mover89");
		SetDynamicLightMover("Mover90");
		SetDynamicLightMover("Mover91");
		SetDynamicLightMover("Mover97");
	}
}

simulated function Client_FixCurrentMap_Dark()
{
	if (bAdjustDynamicLightMover)
	{
		SetDynamicLightMover("Mover11");
		SetDynamicLightMover("Mover13");
	}
}

simulated function Client_FixCurrentMap_TerraLift()
{
	if (bEnableDecorativeMapChanges)
		LoadLevelActor("Light42").bCorona = false;
}

simulated function Client_FixCurrentMap_Noork()
{
	if (bAdjustDynamicLightMover)
	{
		SetDynamicLightMover("Mover5");
		SetDynamicLightMover("Mover9");
	}
}

simulated function Client_FixCurrentMap_Trench()
{
	if (bAdjustDynamicLightMover)
		SetDynamicLightMover("Mover17");
}

simulated function Client_FixCurrentMap_IsvKran32()
{
	if (bAdjustDynamicLightMover)
	{
		SetDynamicLightMover("Mover21");
		SetDynamicLightMover("Mover47");
		SetDynamicLightMover("Mover100");
		SetDynamicLightMover("Mover139");
	}
}

simulated function Client_FixCurrentMap_SpireVillage()
{
	Common_FixCurrentMap_SpireVillage();
}

simulated function Common_FixCurrentMap_SpireVillage()
{
	if (bCoverHolesInLevelsGeometry)
	{
		MakeWorldGeometryCollision("BlockAll12");
		MakeWorldGeometryCollision("BlockAll15");
		MakeWorldGeometryCollision("BlockAll16");
		MakeWorldGeometryCollision("BlockAll17");
		MakeWorldGeometryCollision("BlockAll18");
		MakeWorldGeometryCollision("BlockAll19");
		MakeWorldGeometryCollision("BlockAll20");
		MakeWorldGeometryCollision("BlockAll21");
		MakeWorldGeometryCollision("BlockAll22");
		MakeWorldGeometryCollision("BlockAll23");
		MakeWorldGeometryCollision("BlockAll24");
	}
}

simulated function Client_FixCurrentMap_TheSunspire()
{
	if (bAdjustDynamicLightMover)
		SetDynamicLightMover("Mover91");
}

simulated function Client_FixCurrentMap_SkyTown()
{
	if (bAdjustDynamicLightMover)
		SetDynamicLightMover("Mover0");
}

simulated function Client_FixCurrentMap_SkyBase()
{
	if (bAdjustDynamicLightMover)
	{
		SetDynamicLightMover("Mover30");
		SetDynamicLightMover("Mover41");
		SetDynamicLightMover("Mover134");
		SetDynamicLightMover("Mover142");
	}
}

simulated function Client_FixCurrentMap_Bluff()
{
	if (bAdjustDynamicLightMover)
	{
		SetDynamicLightMover("Mover5");
		SetDynamicLightMover("Mover49");
		SetDynamicLightMover("Mover50");
		SetDynamicLightMover("Mover73");
	}
}

simulated function Client_FixCurrentMap_DasaCellars()
{
	if (bAdjustDynamicLightMover)
	{
		SetDynamicLightMover("Mover7");
		SetDynamicLightMover("Mover164");
	}
}

simulated function Client_FixCurrentMap_NaliC()
{
	if (bAdjustDynamicLightMover)
	{
		SetDynamicLightMover("Mover46");
		SetDynamicLightMover("Mover47");
	}
}

simulated function Client_FixCurrentMap_ExtremeLab()
{
	if (bAdjustDynamicLightMover)
	{
		SetDynamicLightMover("Mover97");
		SetDynamicLightMover("Mover189");
	}
}

simulated function Client_FixCurrentMap_ExtremeCore()
{
	if (bAdjustDynamicLightMover)
	{
		SetDynamicLightMover("Mover101");
		SetDynamicLightMover("Mover103");
	}
}

simulated function Client_FixCurrentMap_QueenEnd()
{
	if (bAdjustDynamicLightMover)
		SetDynamicLightMover("Mover59");
}


simulated function Client_FixCurrentMap_Eldora()
{
	if (bAdjustDynamicLightMover)
		SetDynamicLightMover("AttachMover1");
}

simulated function Client_FixCurrentMap_Glathriel1()
{
	if (bAdjustDynamicLightMover)
		SetDynamicLightMover("AttachMover1");
}

simulated function Client_FixCurrentMap_Glathriel2()
{
	if (bAdjustDynamicLightMover)
	{
		SetDynamicLightMover("Mover2");
		SetDynamicLightMover("Mover3");
		SetDynamicLightMover("Mover25");
		SetDynamicLightMover("Mover26");
		SetDynamicLightMover("Mover27");
		SetDynamicLightMover("Mover28");
	}
}

simulated function Client_FixCurrentMap_Foundry()
{
	if (bAdjustDynamicLightMover)
	{
		SetDynamicLightMover("Mover10");
		SetDynamicLightMover("Mover11");
		SetDynamicLightMover("Mover12");
		SetDynamicLightMover("Mover13");
		SetDynamicLightMover("Mover23");
		SetDynamicLightMover("Mover74");
		SetDynamicLightMover("Mover107");
		SetDynamicLightMover("Mover130");
		SetDynamicLightMover("Mover131");
	}
}

simulated function Client_FixCurrentMap_Toxic()
{
	if (bAdjustDynamicLightMover)
	{
		SetDynamicLightMover("Mover22");
		SetDynamicLightMover("Mover23");
		SetDynamicLightMover("Mover30");
		SetDynamicLightMover("Mover85");
		SetDynamicLightMover("Mover92");
		SetDynamicLightMover("Mover113");
		SetDynamicLightMover("Mover128");
		SetDynamicLightMover("Mover140");
		SetDynamicLightMover("Mover153");
	}

	if (bEnableDecorativeMapChanges)
		DisableMoverGoodCollision(Mover(LoadLevelActor("Mover30"))); // end lift
}


//---------------------------------------------------------------------------------------------------------------------
// Aux functions

simulated function SetDynamicLightMover(string MoverName)
{
	Mover(LoadLevelActor(MoverName)).bDynamicLightMover = true;
}

simulated function MakeWorldGeometryCollision(string ActorName)
{
	LoadLevelActor(ActorName).SetPropertyText("bWorldGeometry", "true");
}

static function DisableMoverGoodCollision(Mover Mover)
{
	Mover.SetPropertyText("bUseGoodCollision", "false");
}

simulated function Actor LoadLevelActor(string ActorName)
{
	return Actor(DynamicLoadObject(Level.outer.name $ "." $ ActorName, class'Actor'));
}

defaultproperties
{
	bAlwaysRelevant=True
	bCarriedItem=True
	bNetTemporary=True
	RemoteRole=ROLE_SimulatedProxy
}

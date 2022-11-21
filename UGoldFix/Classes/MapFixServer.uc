class MapFixServer expands Info;

var UGoldFix Mutator;

event BeginPlay()
{
	Mutator = UGoldFix(Owner);
	Server_FixCurrentMap();
}

function Server_FixCurrentMap()
{
	local name CurrentMapName;

	CurrentMapName = Level.Outer.Name;

	if (Mutator.bStandardSPMap)
		ProtectMapMovers();

	switch (CurrentMapName)
	{
		// Unreal 1 SP maps
		case 'NyLeve':
			Server_FixCurrentMap_NyLeve();
			break;
		case 'Dig':
			Server_FixCurrentMap_Dig();
			break;
		case 'Dug':
			Server_FixCurrentMap_Dug();
			break;
		case 'Passage':
			Server_FixCurrentMap_Passage();
			break;
		case 'Chizra':
			Server_FixCurrentMap_Chizra();
			break;
		case 'Ceremony':
			Server_FixCurrentMap_Ceremony();
			break;
		case 'Dark':
			Server_FixCurrentMap_Dark();
			break;
		case 'Harobed':
			Server_FixCurrentMap_Harobed();
			break;
		case 'TerraLift':
			Server_FixCurrentMap_TerraLift();
			break;
		case 'Terraniux':
			Server_FixCurrentMap_Terraniux();
			break;
		case 'Noork':
			Server_FixCurrentMap_Noork();
			break;
		case 'Ruins':
			Server_FixCurrentMap_Ruins();
			break;
		case 'Trench':
			Server_FixCurrentMap_Trench();
			break;
		case 'IsvKran4':
			Server_FixCurrentMap_IsvKran4();
			break;
		case 'IsvKran32':
			Server_FixCurrentMap_IsvKran32();
			break;
		case 'IsvDeck1':
			Server_FixCurrentMap_IsvDeck1();
			break;
		case 'SpireVillage':
			Server_FixCurrentMap_SpireVillage();
			break;
		case 'TheSunspire':
			Server_FixCurrentMap_TheSunspire();
			break;
		case 'SkyCaves':
			Server_FixCurrentMap_SkyCaves();
			break;
		case 'SkyTown':
			Server_FixCurrentMap_SkyTown();
			break;
		case 'SkyBase':
			Server_FixCurrentMap_SkyBase();
			break;
		case 'VeloraEnd':
			Server_FixCurrentMap_VeloraEnd();
			break;
		case 'Bluff':
			Server_FixCurrentMap_Bluff();
			break;
		case 'DasaPass':
			Server_FixCurrentMap_DasaPass();
			break;
		case 'DasaCellars':
			Server_FixCurrentMap_DasaCellars();
			break;
		case 'NaliBoat':
			Server_FixCurrentMap_NaliBoat();
			break;
		case 'NaliC':
			Server_FixCurrentMap_NaliC();
			break;
		case 'NaliLord':
			Server_FixCurrentMap_NaliLord();
			break;
		case 'DCrater':
			Server_FixCurrentMap_DCrater();
			break;
		case 'ExtremeBeg':
			Server_FixCurrentMap_ExtremeBeg();
			break;
		case 'ExtremeLab':
			Server_FixCurrentMap_ExtremeLab();
			break;
		case 'ExtremeCore':
			Server_FixCurrentMap_ExtremeCore();
			break;
		case 'ExtremeGen':
			Server_FixCurrentMap_ExtremeGen();
			break;
		case 'ExtremeDGen':
			Server_FixCurrentMap_ExtremeDGen();
			break;
		case 'ExtremeDark':
			Server_FixCurrentMap_ExtremeDark();
			break;
		case 'ExtremeEnd':
			Server_FixCurrentMap_ExtremeEnd();
			break;
		case 'QueenEnd':
			Server_FixCurrentMap_QueenEnd();
			break;
		case 'EndGame':
			Server_FixCurrentMap_EndGame();
			break;

		// Unreal 1 DM maps
		case 'DmAriza':
			Server_FixCurrentMap_DmAriza();
			break;
		case 'DmDeck16':
			Server_FixCurrentMap_DmDeck16();
			break;
		case 'DmRadikus':
			Server_FixCurrentMap_DmRadikus();
			break;

		// RTNP SP maps:
		case 'Intro1':
			Server_FixCurrentMap_Intro1();
			break;
		case 'DuskFalls':
			Server_FixCurrentMap_DuskFalls();
			break;
		case 'Nevec':
			Server_FixCurrentMap_Nevec();
			break;
		case 'Eldora':
			Server_FixCurrentMap_Eldora();
			break;
		case 'Glathriel1':
			Server_FixCurrentMap_Glathriel1();
			break;
		case 'Glathriel2':
			Server_FixCurrentMap_Glathriel2();
			break;
		case 'Crashsite':
			Server_FixCurrentMap_Crashsite();
			break;
		case 'Crashsite1':
			Server_FixCurrentMap_Crashsite1();
			break;
		case 'Crashsite2':
			Server_FixCurrentMap_Crashsite2();
			break;
		case 'SpireLand':
			Server_FixCurrentMap_SpireLand();
			break;
		case 'Nagomi':
			Server_FixCurrentMap_Nagomi();
			break;
		case 'Velora':
			Server_FixCurrentMap_Velora();
			break;
		case 'NagomiSun':
			Server_FixCurrentMap_NagomiSun();
			break;
		case 'Foundry':
			Server_FixCurrentMap_Foundry();
			break;
		case 'Toxic':
			Server_FixCurrentMap_Toxic();
			break;
		case 'Glacena':
			Server_FixCurrentMap_Glacena();
			break;
		case 'Abyss':
			Server_FixCurrentMap_Abyss();
			break;
		case 'Nalic2':
			Server_FixCurrentMap_Nalic2();
			break;
		case 'End':
			Server_FixCurrentMap_End();
			break;
	}
}


//---------------------------------------------------------------------------------------------------------------------
// Unreal 1 maps:

function Server_FixCurrentMap_NyLeve()
{
	if (CoverHolesInLevelsGeometry())
		Spawn(class'DMesh_NyLeve_Brush968',,, class'DMesh_NyLeve_Brush968'.default.Location);
	ProtectMapMovers_NyLeve();
}

function Server_FixCurrentMap_Dig()
{
	if (CoverHolesInLevelsGeometry())
		Spawn(class'DMesh_Dig_Brush1259',,, class'DMesh_Dig_Brush1259'.default.Location);

	if (UnlockNaliSecrets())
	{
		LoadLevelMover("Mover21").bUseTriggered = true;
		LoadLevelMover("Mover44").bUseTriggered = true;
		LoadLevelMover("Mover74").bUseTriggered = true;
	}
}

function Server_FixCurrentMap_Dug()
{
	if (ImproveNPCBehavior())
		LoadLevelMover("Mover0").BumpType = BT_PawnBump;
	if (AdjustFallingMovers())
	{
		AddFallingMoverController("Mover6");
		LoadLevelDispatcher("Dispatcher0").OutDelays[1] = 0.6;
	}
	if (Mutator.bEnableDecorativeMapChanges)
		DisableActorCollision("ExplodingWall2", true);
}

function Server_FixCurrentMap_Passage()
{
	local Mover m;

	ProtectMapMovers_Passage();

	if (CoverHolesInLevelsGeometry())
		Spawn(class'DMesh_Passage_Brush274',,, class'DMesh_Passage_Brush274'.default.Location);

	if (!Mutator.bEnableLogicMapChanges)
		return;

	if (Mutator.bPreventFastRetriggering)
	{
		// fix for the front door lever
		m = LoadLevelMover("Mover15");
		AssignInitialState(m, 'TriggerOpenTimed');
		m.StayOpenTime = 0;
	}

	if (Level.NetMode != NM_Standalone)
	{
		// the exit door shouldn't be closed in Coop
		DisableTrigger("Trigger0");
	}
}

function Server_FixCurrentMap_Chizra()
{
	if (ImproveNPCBehavior())
	{
		LoadLevelMover("Mover42").BumpType = BT_PawnBump;
		MakeAIPawnTriggerFor("Trigger5");  // Mover46
		MakeAIPawnTriggerFor("Trigger10"); // Mover53
		MakeAIPawnTriggerFor("Trigger11"); // Mover12 + Mover13
		MakeAIPawnTriggerFor("Trigger18"); // Mover113
		MakeAIPawnTriggerFor("Trigger28"); // Mover43
	}

	if (UnlockNaliSecrets())
		LoadLevelMover("Mover61").bUseTriggered = true;
}

function Server_FixCurrentMap_Ceremony()
{
	if (Mutator.bEnableLogicMapChanges)
	{
		AdjustDamageTriggers('diefall');
		if (Level.NetMode != NM_Standalone)
			MakeCovertCreatureFactoryController("CreatureFactory3");
	}

	if (ImproveNPCBehavior())
	{
		LoadLevelMover("Mover38").BumpType = BT_PawnBump;
		MakeAIPawnTriggerFor("Trigger0");  // Mover1
		MakeAIPawnTriggerFor("Trigger2");  // Mover2
		MakeAIPawnTriggerFor("Trigger22"); // Mover21 + Mover22
	}

	if (UseExtraProtection() && Mutator.bEnableLogicMapChanges)
	{
		MakeMoverTriggerableOnceOnly("Mover28");
		MakeMoverTriggerableOnceOnly("Mover29");
		MakeMoverTriggerableOnceOnly("Mover30");
		MakeMoverTriggerableOnceOnly("Mover103");
		MakeMoverTriggerableOnceOnly("Mover104");
		MakeMoverTriggerableOnceOnly("Mover105");
		MakeMoverTriggerableOnceOnly("Mover106");
		MakeMoverTriggerableOnceOnly("Mover107");
		MakeMoverTriggerableOnceOnly("Mover108");
		MakeMoverTriggerableOnceOnly("Mover109");
		MakeMoverTriggerableOnceOnly("Mover110");
		MakeMoverTriggerableOnceOnly("Mover111");
	}
}

function Server_FixCurrentMap_Dark()
{
	if (ImproveNPCBehavior())
	{
		MakeAIPawnTriggerFor("Trigger1");  // Mover1 + Mover27
		MakeAIPawnTriggerFor("Trigger2");  // Mover0
		MakeAIPawnTriggerFor("Trigger4");  // Mover46
		MakeAIPawnTriggerFor("Trigger5");  // Mover76
		MakeAIPawnTriggerFor("Trigger8");  // Mover9
		MakeAIPawnTriggerFor("Trigger10"); // Mover12
		MakeAIPawnTriggerFor("Trigger16"); // Mover32
		MakeAIPawnTriggerFor("Trigger17"); // Mover2 + Mover3
		MakeAIPawnTriggerFor("Trigger18"); // Mover34
		MakeAIPawnTriggerFor("Trigger22"); // Mover22
	}
}

function Server_FixCurrentMap_Harobed()
{
	local Dispatcher disp;
	local Trigger tr, Trigger26;

	if (CoverHolesInLevelsGeometry())
	{
		// fix for two BSP holes in torches
		Spawn(class'DMesh_Harobed_Brush370',,, class'DMesh_Harobed_Brush370'.default.Location);
		Spawn(class'DMesh_Harobed_Brush392',,, class'DMesh_Harobed_Brush392'.default.Location);
		Spawn(class'DMesh_Harobed_Brush588',,, class'DMesh_Harobed_Brush588'.default.Location);
	}

	if (!Mutator.bEnableLogicMapChanges)
		return;

	// fix for the secret cave
	disp = Spawn(class'Dispatcher',,'Disp_Tomb');
	disp.OutEvents[0] = 'Tomb';
	disp.OutEvents[1] = 'dummy_event';
	disp.OutDelays[1] = 6; // the Dispatcher can't be retriggered during 6 seconds

	LoadLevelMover("Mover13").Event = 'Disp_Tomb';
	Trigger26 = LoadLevelTrigger("Trigger26");
	tr = Spawn(class'Trigger',, 'Tomb', Trigger26.Location);
	tr.SetCollisionSize(Trigger26.CollisionRadius, Trigger26.CollisionHeight);
	tr.Event = 'Disp_Tomb';
	AssignInitialState(tr, 'OtherTriggerToggles');

	if (ImproveNPCBehavior())
	{
		LoadLevelMover("Mover9").BumpType = BT_PawnBump;
		LoadLevelMover("Mover10").BumpType = BT_PawnBump;
		BlockNavigationPathThrough("Teleporter1");
	}
}

function Server_FixCurrentMap_TerraLift()
{
	local Dispatcher disp;

	if (CoverHolesInLevelsGeometry())
		Spawn(class'DMesh_TerraLift_Brush204',,, class'DMesh_TerraLift_Brush204'.default.Location);

	if (!Mutator.bEnableLogicMapChanges)
		return;

	// prevents the lift from being triggered before it arrives at the lower part of the level
	disp = LoadLevelDispatcher("Dispatcher5");
	disp.OutEvents[2] = 'dummy_event';
	disp.OutDelays[2] = 10;
}

function Server_FixCurrentMap_Terraniux()
{
	if (ImproveNPCBehavior())
	{
		LoadLevelTrigger("Trigger6").TriggerType = TT_PawnProximity;  // Mover57
		LoadLevelTrigger("Trigger8").TriggerType = TT_PawnProximity;  // Mover22
		LoadLevelTrigger("Trigger10").TriggerType = TT_PawnProximity; // Mover38
		LoadLevelTrigger("Trigger11").TriggerType = TT_PawnProximity; // Mover55
		LoadLevelTrigger("Trigger13").TriggerType = TT_PawnProximity; // Mover56
		LoadLevelTrigger("Trigger35").TriggerType = TT_PawnProximity; // Mover53
		LoadLevelTrigger("Trigger57").TriggerType = TT_PawnProximity; // Mover58
	}

	if (CoverHolesInLevelsGeometry())
	{
		// fix for two BSP holes at water zones
		Spawn(class'DMesh_Terraniux_Brush2653',,, class'DMesh_Terraniux_Brush2653'.default.Location);
		Spawn(class'DMesh_Terraniux_Brush2721',,, class'DMesh_Terraniux_Brush2721'.default.Location);
	}
}

function Server_FixCurrentMap_Noork()
{
	if (!Mutator.bEnableLogicMapChanges)
		return;

	if (ImproveNPCBehavior())
	{
		MakeAIPawnTriggerFor("Trigger8"); // Mover2
		LoadLevelTrigger("Trigger11").TriggerType = TT_PawnProximity; // Mover15 + Mover16
	}

	if (Level.NetMode != NM_Standalone)
	{
		// prevents grates from closing in Coop
		DisableTrigger("Trigger1");
		DisableTrigger("Trigger2");
	}
}

function Server_FixCurrentMap_Ruins()
{
	local int i;
	local Dispatcher TrapAltUnlocker;
	local Trigger t;
	local Actor Skaarj;
	local TracingTrigger SkaarjDetector;
	local AlarmTrigger BalcDoorsTrigger;
	local SpawnableAlarmPoint BalcDoorsAlarmPoint;
	local Mover BalconyGrateMover, BalconyAltMover;
	local MoverStateController MoverControllers[4];
	local MoverStateController BalconyGrateController;
	local MoverEventHandler TrapEventHandler;

	if (!Mutator.bEnableLogicMapChanges)
		return;

	LoadLevelActor("BlockMonsters23").bBlockActors = false;
	LoadLevelActor("BlockMonsters24").bBlockActors = false;
	LoadLevelActor("BlockMonsters25").bBlockActors = false;

	if (ImproveNPCBehavior())
	{
		t = LoadLevelTrigger("Trigger0");
		BalcDoorsAlarmPoint = Spawn(
			class'SpawnableAlarmPoint',,
			'BalcDoorsAlarmPoint',
			LoadLevelActor("Pathnode28").Location);
		BalcDoorsAlarmPoint.bStrafeTo = true;

		BalcDoorsTrigger = Spawn(class'AlarmTrigger',, t.Event, t.Location);
		BalcDoorsTrigger.SetCollisionSize(t.CollisionRadius, t.CollisionHeight);
		BalcDoorsTrigger.TriggerType = TT_PawnProximity;
		BalcDoorsTrigger.AlarmTag = 'BalcDoorsAlarmPoint';
		AssignInitialState(BalcDoorsTrigger, 'OtherTriggerTurnsOff');

		BalcDoorsTrigger = Spawn(class'AlarmTrigger',, t.Event,
			LoadLevelActor("BlockMonsters23").Location);
		BalcDoorsTrigger.SetCollisionSize(40, 80);
		BalcDoorsTrigger.TriggerType = TT_PawnProximity;
		BalcDoorsTrigger.AlarmTag = 'BalcDoorsAlarmPoint';
		AssignInitialState(BalcDoorsTrigger, 'OtherTriggerTurnsOff');

		BalcDoorsTrigger = Spawn(class'AlarmTrigger',, t.Event,
			LoadLevelActor("BlockMonsters25").Location);
		BalcDoorsTrigger.SetCollisionSize(40, 80);
		BalcDoorsTrigger.TriggerType = TT_PawnProximity;
		BalcDoorsTrigger.AlarmTag = 'BalcDoorsAlarmPoint';
		AssignInitialState(BalcDoorsTrigger, 'OtherTriggerTurnsOff');
	}

	// Trap with SkaarjScout
	Skaarj = LoadLevelActor("SkaarjScout2");
	Skaarj.Event = 'skaarj_scout_trap_unlock';
	SkaarjDetector = Spawn(class'TracingTrigger',,, LoadLevelActor("PathNode7").Location);
	SkaarjDetector.Event = 'skaarj_scout_trap_unlock';
	SkaarjDetector.SetTracedActor(Skaarj);

	t = LoadLevelTrigger("Trigger2");
	t.Event = 'skaarj_scout_trap_lock';

	for (i = 0; i < ArrayCount(MoverControllers); ++i)
		MoverControllers[i] = Spawn(class'MoverStateController');
	MoverControllers[0].SetControlledMover(LoadLevelMover("Mover25"));
	MoverControllers[1].SetControlledMover(LoadLevelMover("Mover26"));
	MoverControllers[2].SetControlledMover(LoadLevelMover("Mover27"));
	MoverControllers[3].SetControlledMover(LoadLevelMover("Mover28"));

	TrapEventHandler = Spawn(class'MoverEventHandler',, 'skaarj_scout_trap_lock');
	for (i = 0; i < ArrayCount(MoverControllers); ++i)
		TrapEventHandler.Controllers[i] = MoverControllers[i];
	TrapEventHandler.MoverPosChange = 'Open';

	TrapEventHandler = Spawn(class'MoverEventHandler',, 'skaarj_scout_trap_unlock');
	for (i = 0; i < ArrayCount(MoverControllers); ++i)
		TrapEventHandler.Controllers[i] = MoverControllers[i];
	TrapEventHandler.MoverPosChange = 'Close';
	TrapEventHandler.bPermanentChange = true;

	EventToEvent('skaarj_scout_trap_unlock', LoadLevelMover("Mover36").Tag);

	// Trap with Titan
	LoadLevelMover("Mover0").Tag = LoadLevelMover("Mover29").Tag;

	if (Level.NetMode != NM_Standalone)
	{
		// Trap with SkaarjBerserker
		BalconyGrateMover = LoadLevelMover("Mover5");
		BalconyAltMover = LoadLevelMover("Mover35");
		BalconyAltMover.MoverEncroachType = ME_IgnoreWhenEncroach;
		LoadLevelMover("Mover22").Event = 'open_balcony_grate';

		BalconyGrateController = Spawn(class'MoverStateController');
		TrapEventHandler = Spawn(class'MoverEventHandler',, BalconyGrateMover.Tag);
		TrapEventHandler.Controllers[0] = BalconyGrateController;
		TrapEventHandler.MoverPosChange = 'Toggle';
		TrapEventHandler = Spawn(class'MoverEventHandler',, 'open_balcony_grate');
		TrapEventHandler.Controllers[0] = BalconyGrateController;
		TrapEventHandler.MoverPosChange = 'Open';
		TrapEventHandler = Spawn(class'MoverEventHandler',, 'trap_alt_unlocker');
		TrapEventHandler.Controllers[0] = BalconyGrateController;
		TrapEventHandler.ClosePosEvent = BalconyAltMover.Tag;
		BalconyGrateController.SetControlledMover(BalconyGrateMover);

		TrapAltUnlocker = Spawn(class'Dispatcher',, 'open_balcony_grate');
		TrapAltUnlocker.OutEvents[0] = 'trap_alt_unlocker';
		TrapAltUnlocker.OutDelays[0] = 1;

		// Disable cave-in at the exit
		DisableTrigger("Trigger1");
	}
}

function Server_FixCurrentMap_Trench()
{
	if (CoverHolesInLevelsGeometry())
		Spawn(class'DMesh_Trench_Corner',,, class'DMesh_Trench_Corner'.default.Location);
	if (Mutator.bEnableDecorativeMapChanges)
		LoadLevelMover("Mover27").KeyRot[1] = rot(-2999, 0, 0); // fix for glitches at level start
}

function Server_FixCurrentMap_IsvKran4()
{
	if (!Mutator.bEnableLogicMapChanges)
		return;

	if (Mutator.bImproveNPCBehavior)
		LoadLevelTrigger("Trigger0").TriggerType = TT_PawnProximity; // Mover99 + Mover113

	if (Level.NetMode != NM_Standalone)
	{
		MakePawnEventTrigger(vect(0, -9450, -860), 2000, 50, 'attacksquad');
		MakePawnEventTrigger(LoadLevelTrigger("Trigger72").Location, 60, 200, 'attacksquad');
		MakePawnEventTrigger(LoadLevelTrigger("Trigger73").Location, 60, 200, 'attacksquad');
		MakeCovertCreatureFactoryController("CreatureFactory0");
		MakeCovertCreatureFactoryController("CreatureFactory2");
	}
	AdjustDamageTriggers('dieinthefan');

	LoadLevelTrigger("Trigger97").Tag = 'atticdoor';
}

function Server_FixCurrentMap_IsvKran32()
{
	local Dispatcher disp;
	local Trigger tr;

	if (PreventFastRetriggering())
	{
		// Turbolift
		tr = LoadLevelTrigger("Trigger49");
		tr.ReTriggerDelay = 0;
		tr.Event = 'Disp_turbolift';

		tr = LoadLevelTrigger("Trigger107");
		tr.ReTriggerDelay = 0;
		tr.Event = 'Disp_turbolift';

		disp = Spawn(class'Dispatcher',, 'Disp_turbolift');
		disp.OutEvents[0] = 'turbolift';
		disp.OutEvents[1] = 'dummy_event';
		disp.OutDelays[1] = 2;

		// North pipe
		tr = LoadLevelTrigger("Trigger100");
		tr.ReTriggerDelay = 0;
		tr.Event = 'Disp_pipesnorth';

		tr = LoadLevelTrigger("Trigger103");
		tr.ReTriggerDelay = 0;
		tr.Event = 'Disp_pipesnorth';

		disp = Spawn(class'Dispatcher',, 'Disp_pipesnorth');
		disp.OutEvents[0] = 'pipesnorth';
		disp.OutEvents[1] = 'dummy_event';
		disp.OutDelays[1] = 0.75;

		// South pipe
		tr = LoadLevelTrigger("Trigger101");
		tr.ReTriggerDelay = 0;
		tr.Event = 'Disp_pipesouth';

		tr = LoadLevelTrigger("Trigger102");
		tr.ReTriggerDelay = 0;
		tr.Event = 'Disp_pipesouth';

		disp = Spawn(class'Dispatcher',, 'Disp_pipesouth');
		disp.OutEvents[0] = 'pipesouth';
		disp.OutEvents[1] = 'dummy_event';
		disp.OutDelays[1] = 0.75;
	}

	if (Mutator.bEnableLogicMapChanges)
		AdjustDamageTriggers(LoadLevelActor("SpecialEvent102").Tag);
}

function Server_FixCurrentMap_IsvDeck1()
{
	local Dispatcher disp;
	local Trigger tr;

	if (!Mutator.bEnableLogicMapChanges)
		return;

	AdjustDamageTriggers('zap');

	if (Level.NetMode != NM_Standalone)
	{
		// prevents the exit teleporter from being blocked
		LoadLevelMover("Mover61").bBlockPlayers = False;
	}

	if (PreventFastRetriggering() && UseExtraProtection())
	{
		// Beams
		tr = LoadLevelTrigger("Trigger16");
		tr.ReTriggerDelay = 0;
		tr.Event = 'Disp_zapoff';

		tr = LoadLevelTrigger("Trigger24");
		tr.ReTriggerDelay = 0;
		tr.Event = 'Disp_zapoff';

		disp = Spawn(class'Dispatcher',, 'Disp_zapoff');
		disp.OutEvents[0] = 'zapoff';
		disp.OutEvents[1] = 'dummy_event';
		disp.OutDelays[1] = 1;
	}
}

function Server_FixCurrentMap_SpireVillage()
{
	local Trigger t;
	local TracingTrigger tt;
	local Actor end_skaarj;

	Mutator.MapFixClient.Common_FixCurrentMap_SpireVillage();

	if (Mutator.bEnableDecorativeMapChanges)
	{
		// fix for the forcefield Mover
		t = LoadLevelTrigger("Trigger0");
		Spawn(class'PlayerStartEvent',, t.Event).DelayTime = 0.6;
		t.Event = '';
	}

	if (!Mutator.bEnableLogicMapChanges)
		return;

	// if the SkaarjTrooper0 reached Sunspire, unlock the exit door
	end_skaarj = LoadLevelActor("SkaarjTrooper0");

	tt = Spawn(class'TracingTrigger',,, LoadLevelActor("AmbientSound72").Location);
	tt.Event = 'kEYtR';
	tt.SetTracedActor(end_skaarj);

	if (ImproveNPCBehavior())
	{
		MakeAIPawnTriggerFor("Trigger104"); // Mover10
		MakeAIPawnTriggerFor("Trigger106"); // Mover11
		MakeAIPawnTriggerFor("Trigger108"); // Mover16
		MakeAIPawnTriggerFor("Trigger110"); // Mover18
		MakeAIPawnTriggerFor("Trigger112"); // Mover20
	}
}

function Server_FixCurrentMap_TheSunspire()
{
	local Actor ExitTelep;
	local TeleportingTrigger t;
	local Mover m;

	if (!Mutator.bEnableLogicMapChanges)
		return;

	ExitTelep = LoadLevelActor("Teleporter5");
	t = Spawn(class'TeleportingTrigger', , , ExitTelep.Location + vect(0, 0, 8000));
	t.SetCollisionSize(ExitTelep.CollisionRadius, ExitTelep.CollisionHeight);
	t.Offset = (LoadLevelActor("PathNode660").Location.Z - t.Location.Z) * vect(0, 0, 1);

	if (ImproveNPCBehavior())
	{
		m = LoadLevelMover("Mover95");
		m.BumpEvent = m.PlayerBumpEvent;
		m.BumpType = BT_PawnBump;
		m.PlayerBumpEvent = '';
		LiftCenter(LoadLevelActor("LiftCenter1")).LiftTag = m.BumpEvent;
		LiftExit(LoadLevelActor("LiftExit2")).LiftTag = m.BumpEvent;
		LiftExit(LoadLevelActor("LiftExit3")).LiftTag = m.BumpEvent;
	}
}

function Server_FixCurrentMap_SkyCaves()
{
	local Trigger t;

	if (!Mutator.bEnableLogicMapChanges)
		return;

	if (ImproveNPCBehavior())
	{
		MakeAIPawnTriggerFor("Trigger9");  // Mover8 + Mover9
		MakeAIPawnTriggerFor("Trigger11"); // Mover24 + Mover25
		MakeAIPawnTriggerFor("Trigger12"); // Mover26 + Mover27

		t = MakeAIPawnTriggerFor("Trigger10"); // Mover23 + Mover55
		t.bInitiallyActive = False;
		t.Tag = t.Event;
		AssignInitialState(t, 'OtherTriggerTurnsOn');
	}

	if (UseExtraProtection())
	{
		MakeMoverTriggerableOnceOnly("Mover11");
		MakeMoverTriggerableOnceOnly("Mover12", true);
	}
}

function Server_FixCurrentMap_SkyTown()
{
	local Trigger Trigger73, KrallTrigger;

	// prevents the rifle from being destroyed
	LoadLevelActor("Rifle0").SetOwner(self);

	if (ImproveNPCBehavior())
	{
		// Krall14 won't attack other monsters when they touch Trigger73
		Trigger73 = LoadLevelTrigger("Trigger73");
		KrallTrigger = Spawn(class'Trigger',, Trigger73.Tag, Trigger73.Location, Trigger73.Rotation);
		KrallTrigger.bInitiallyActive = Trigger73.bInitiallyActive; // False
		KrallTrigger.TriggerType = TT_PlayerProximity;
		KrallTrigger.Event = 'upperbarndoors1_krall';
		KrallTrigger.SetCollisionSize(Trigger73.CollisionRadius, Trigger73.CollisionHeight);
		AssignInitialState(KrallTrigger, Trigger73.InitialState);
		LoadLevelActor("Krall14").Tag = KrallTrigger.Event;
	}

	if (CoverHolesInLevelsGeometry())
	{
		Spawn(class'DMesh_SkyTown_Brush1020',,, class'DMesh_SkyTown_Brush1020'.default.Location);
		Spawn(class'DMesh_SkyTown_Brush1845',,, class'DMesh_SkyTown_Brush1845'.default.Location);
	}

	if (Mutator.bEnableDecorativeMapChanges)
		DisableActorCollision("ExplodingWall2", true);

	if (UseExtraProtection() && Mutator.bEnableLogicMapChanges)
	{
		MakeMoverTriggerableOnceOnly("Mover17");
		MakeMoverTriggerableOnceOnly("Mover21");
		MakeMoverTriggerableOnceOnly("Mover95", true);
		MakeMoverTriggerableOnceOnly("Mover96", true);
		MakeMoverTriggerableOnceOnly("Mover100", true);
		MakeMoverTriggerableOnceOnly("Mover101", true);
		MakeMoverTriggerableOnceOnly("Mover107", true);
	}
}

function Server_FixCurrentMap_SkyBase()
{
	local Dispatcher disp;

	if (Level.NetMode != NM_Standalone)
	{
		if (Mutator.bEnableLogicMapChanges)
			DisablePlayerStart("PlayerStart1");

		if (Mutator.bEnableDecorativeMapChanges)
			LoadLevelActor("MusicEvent0").Trigger(self, none);
	}

	if (PreventFastRetriggering())
	{
		disp = Spawn(class'Dispatcher',, 'Disp_BigBayDoors1');
		disp.OutEvents[0] = 'BigBayDoors1';
		disp.OutEvents[1] = 'dummy_event';
		disp.OutDelays[1] = 5;

		LoadLevelTrigger("Trigger9").Event = 'Disp_BigBayDoors1';
		LoadLevelTrigger("Trigger10").Event = 'Disp_BigBayDoors1';
		LoadLevelTrigger("Trigger15").Event = 'Disp_BigBayDoors1';

		disp = Spawn(class'Dispatcher',, 'Disp_LargeHangarDoor1');
		disp.OutEvents[0] = 'LargeHangarDoor1';
		disp.OutEvents[1] = 'dummy_event';
		disp.OutDelays[1] = 5;

		LoadLevelTrigger("Trigger25").Event = 'Disp_LargeHangarDoor1';
		LoadLevelTrigger("Trigger82").Event = 'Disp_LargeHangarDoor1';

		disp = Spawn(class'Dispatcher',, 'Disp_HangarForceField');
		disp.OutEvents[0] = 'HangarForceField';
		disp.OutEvents[1] = 'dummy_event';
		disp.OutDelays[1] = 5;

		LoadLevelTrigger("Trigger26").Event = 'Disp_HangarForceField';

		disp = Spawn(class'Dispatcher',, 'Disp_LargeHangarDoor2');
		disp.OutEvents[0] = 'LargeHangarDoor2';
		disp.OutEvents[1] = 'dummy_event';
		disp.OutDelays[1] = 5;
		if (UseExtraProtection())
			disp.OutDelays[1] = 7;

		LoadLevelTrigger("Trigger3").Event = 'Disp_LargeHangarDoor2';
		LoadLevelTrigger("Trigger23").Event = 'Disp_LargeHangarDoor2';

		disp = Spawn(class'Dispatcher',, 'Disp_LargeBackDoors');
		disp.OutEvents[0] = 'LargeBackDoors';
		disp.OutEvents[1] = 'dummy_event';
		disp.OutDelays[1] = 5;

		LoadLevelTrigger("Trigger20").Event = 'Disp_LargeBackDoors';

		if (UseExtraProtection())
		{
			LoadLevelTrigger("Trigger77").bTriggerOnceOnly = True;

			disp = Spawn(class'Dispatcher',, 'Disp_LLCDoors');
			disp.OutEvents[0] = 'LLCDoors';
			disp.OutEvents[1] = 'dummy_event';
			disp.OutDelays[1] = 1;

			LoadLevelTrigger("Trigger1").Event = 'Disp_LLCDoors';
			LoadLevelTrigger("Trigger72").Event = 'Disp_LLCDoors';
		}
		else
			LoadLevelTrigger("Trigger77").ReTriggerDelay = 5;
	}
}

function Server_FixCurrentMap_VeloraEnd()
{
	local Dispatcher disp;
	local InstantDispatcher chair_disp;

	if (!Mutator.bEnableLogicMapChanges)
		return;

	disp = LoadLevelDispatcher("Dispatcher0");
	disp.OutEvents[5] = 'Bridge';
	disp.OutEvents[6] = 'ChairTR';

	LoadLevelMover("Mover32").Tag = 'chair_mover';
	chair_disp = Spawn(class'InstantDispatcher',, 'Bridge');
	chair_disp.ConditionTrigger = LoadLevelTrigger("Trigger5");
	chair_disp.OutEvents[0] = 'chair_mover';

	if (ImproveNPCBehavior())
		MakeAIPawnTriggerFor("Trigger0");  // Mover0 + Mover1
}

function Server_FixCurrentMap_Bluff()
{
	local MoverStateSensor LiftSensor;
	local Mover Lift;
	local MusicEvent MusicEvent;
	local Trigger Trigger;

	if (Mutator.bEnableLogicMapChanges)
	{
		AssignInitialState(LoadLevelMover("Mover85"), 'TriggerOpenTimed');

		AdjustDamageTriggers('vapordeath'); // control room, bottom
		AdjustDamageTriggers('splooge'); // tower

		if (UseExtraProtection())
		{
			// tower lift
			Lift = LoadLevelMover("Mover11");
			LiftSensor = Spawn(class'MoverStateSensor',, Lift.Tag);
			LiftSensor.ControlledMover = Lift;
			LiftSensor.bCanTriggerWhenOpened = true;
			LiftSensor.bCanTriggerWhenClosed = true;
			Lift.Tag = 'HighTowerLift';
		}

		if (UnlockNaliSecrets())
		{
			LoadLevelMover("Mover12").bUseTriggered = true;
			LoadLevelMover("Mover78").bUseTriggered = true;
			LoadLevelMover("Mover80").bUseTriggered = true;
			LoadLevelMover("Mover82").bUseTriggered = true;
			LoadLevelMover("Mover83").bUseTriggered = true;
			LoadLevelMover("Mover86").bUseTriggered = true;
		}
	}

	if (Mutator.bEnableDecorativeMapChanges)
	{
		foreach AllActors(class'MusicEvent', MusicEvent)
			MusicEvent.bOnceOnly = true;

		Trigger = LoadLevelTrigger("Trigger47");
		Trigger.Tag = 'mainopus';
		AssignInitialState(Trigger, 'OtherTriggerTurnsOff');
	}
}

function Server_FixCurrentMap_DasaPass()
{
	local AIPawnTrigger t;

	if (ImproveNPCBehavior())
	{
		t = MakeAIPawnTriggerFor("Trigger2");
		t.AssociatedMovers[0] = LoadLevelMover("Mover3");
		t.AssociatedMovers[1] = LoadLevelMover("Mover7");

		t = MakeAIPawnTriggerFor("Trigger47");
		t.AssociatedMovers[0] = LoadLevelMover("Mover144");
	}
}

function Server_FixCurrentMap_DasaCellars()
{
	local AIPawnTrigger t;

	if (Mutator.bEnableLogicMapChanges && Level.NetMode != NM_Standalone)
	{
		MakePawnEventTrigger(vect(6824, -512, -56), 128, 120, 'liftboxBARS');
		MakePawnEventTrigger(vect(7952, 0, -224), 512, 160, 'liftboxBARS');
		MakeCovertCreatureFactoryController("CreatureFactory2");
	}

	if (ImproveNPCBehavior())
	{
		t = MakeAIPawnTriggerFor("Trigger35");
		t.AssociatedMovers[0] = LoadLevelMover("Mover163");
		t.AssociatedMovers[1] = LoadLevelMover("Mover167");

		t = MakeAIPawnTriggerFor("Trigger49");
		t.AssociatedMovers[0] = LoadLevelMover("Mover127");
		t.AssociatedMovers[1] = LoadLevelMover("Mover177");

		LoadLevelTrigger("Trigger46").TriggerType = TT_PawnProximity; // Mover184 - Mover180 + Mover182
		LoadLevelTrigger("Trigger48").TriggerType = TT_PawnProximity; // Mover184 - Mover180 + Mover182
	}

	if (Mutator.bEnableDecorativeMapChanges)
		Spawn(class'PawnPhysicsAdjustment').SetPawnAdjustment(
			Pawn(LoadLevelActor("SkaarjBerserker0")), PHYS_Walking, 1, false);

	if (CoverHolesInLevelsGeometry())
	{
		Spawn(class'DMesh_DasaCellars_Brush2738',,, class'DMesh_DasaCellars_Brush2738'.default.Location_Brush2738);
		Spawn(class'DMesh_DasaCellars_Brush2738',,, class'DMesh_DasaCellars_Brush2738'.default.Location_Brush2742);
		Spawn(class'DMesh_DasaCellars_Brush2738',,, class'DMesh_DasaCellars_Brush2738'.default.Location_Brush2746);
		Spawn(class'DMesh_DasaCellars_Brush2738',,, class'DMesh_DasaCellars_Brush2738'.default.Location_Brush2750);
	}
}

function Server_FixCurrentMap_NaliBoat()
{
	if (Mutator.bEnableLogicMapChanges)
	{
		Counter(LoadLevelActor("Counter1")).NumToCount = 2;

		// makes boat movement smooth
		Spawn(class'SpawnableObjectPath').Replace(ObjectPath(LoadLevelActor("ObjectPath1")));

		if (Level.NetMode != NM_Standalone)
		{
			// prevents the exit from being blocked
			DisableTrigger("Trigger0");
		}
	}
}

function Server_FixCurrentMap_NaliC()
{
	local Mover m;
	local Trigger t;

	if (!Mutator.bEnableLogicMapChanges)
		return;

	m = LoadLevelMover("Mover23");
	m.bBlockActors = false;
	m.bBlockPlayers = false;
	AssignInitialState(m, 'TriggerOpenTimed');
	m.Tag = 'right_cell_doors_lever';
	t = Spawn(class'Trigger',,, m.Location);
	t.SetCollisionSize(60, 40);
	t.Event = 'right_cell_doors_lever';
	if (ImproveNPCBehavior())
		t.TriggerType = TT_PawnProximity;

	m = LoadLevelMover("Mover24");
	m.bBlockActors = false;
	m.bBlockPlayers = false;
	AssignInitialState(m, 'TriggerOpenTimed');
	m.Tag = 'left_cell_doors_lever';
	t = Spawn(class'Trigger',,, m.Location);
	t.SetCollisionSize(60, 40);
	t.Event = 'left_cell_doors_lever';
	if (ImproveNPCBehavior())
		t.TriggerType = TT_PawnProximity;

	if (ImproveNPCBehavior())
	{
		MakeAIPawnTriggerFor("Trigger3");  // Mover9 + Mover10
		MakeAIPawnTriggerFor("Trigger4");  // Mover44 + Mover56
		MakeAIPawnTriggerFor("Trigger6");  // Mover14 + Mover55
		MakeAIPawnTriggerFor("Trigger7");  // Mover15 + Mover16
		MakeAIPawnTriggerFor("Trigger10"); // Mover17 + Mover31
		MakeAIPawnTriggerFor("Trigger11"); // Mover33 + Mover34
		MakeAIPawnTriggerFor("Trigger13"); // Mover42 + Mover43
		MakeAIPawnTriggerFor("Trigger18"); // Mover50 + Mover51
	}

	if (Level.NetMode != NM_Standalone)
		DisableTrigger("Trigger12"); // prevents the exit from being blocked

	if (UnlockNaliSecrets())
		LoadLevelMover("Mover60").bUseTriggered = true;
}

function Server_FixCurrentMap_NaliLord()
{
	if (AdjustFallingMovers())
		AddFallingMoverController("Mover0");
}

function Server_FixCurrentMap_DCrater()
{
	local Dispatcher Disp;

	if (!Mutator.bEnableLogicMapChanges)
		return;

	MakeMoverTriggerableOnceOnly("Mover27");
	Disp = Spawn(class'Dispatcher',, 'SE2');
	Disp.OutDelays[0] = 20;
	Disp.OutEvents[0] = 'SlideDoor';
}

function Server_FixCurrentMap_ExtremeBeg()
{
	if (ImproveNPCBehavior())
	{
		LoadLevelTrigger("Trigger2").TriggerType = TT_PawnProximity; // Mover14 + Mover15 + Mover17
		LoadLevelTrigger("Trigger4").TriggerType = TT_PawnProximity; // Mover14 + Mover15 + Mover17
		LoadLevelTrigger("Trigger5").TriggerType = TT_PawnProximity; // Mover4 + Mover5 + Mover6
	}
}

function Server_FixCurrentMap_ExtremeLab()
{
	if (Mutator.bEnableDecorativeMapChanges)
		AdjustMoons();

	if (!Mutator.bEnableLogicMapChanges)
		return;

	AdjustDamageTriggers('ouchj');
	AdjustDamageTriggers('Death');
	AdjustDamageTriggers('Death3');
	AdjustDamageTriggers('Death4');
	AdjustDamageTriggers('Death10');

	if (ImproveNPCBehavior())
	{
		LoadLevelTrigger("Trigger3").TriggerType = TT_PawnProximity;  // Mover16 + Mover26
		LoadLevelTrigger("Trigger22").TriggerType = TT_PawnProximity; // Mover51 + Mover52
		LoadLevelTrigger("Trigger23").TriggerType = TT_PawnProximity; // Mover53 + Mover54
		LoadLevelTrigger("Trigger24").TriggerType = TT_PawnProximity; // Mover55 + Mover56
		LoadLevelTrigger("Trigger38").TriggerType = TT_PawnProximity; // Mover58 + Mover59
		LoadLevelTrigger("Trigger81").TriggerType = TT_PawnProximity; // Mover22 + Mover23 + Mover24
	}

	if (Level.NetMode != NM_Standalone)
		DisablePlayerStart("PlayerStart1");
}

function Server_FixCurrentMap_ExtremeCore()
{
	local CollidingCylinder block;

	if (Mutator.bEnableLogicMapChanges)
	{
		DisablePlayerStart("PlayerStart1");

		if (Level.NetMode != NM_Standalone)
		{
			MakeCovertCreatureFactoryController("CreatureFactory2");
			MakeCovertCreatureFactoryController("CreatureFactory3");
		}

		AdjustDamageTriggers('Death7');
		AdjustDamageTriggers('Death8');
		AdjustDamageTriggers('Death9');
	}

	if (ImproveNPCBehavior())
	{
		// Monsters shouldn't affect this Trigger
		LoadLevelTrigger("Trigger38").TriggerType = TT_PlayerProximity;
	}

	if (Mutator.bEnableLogicMapChanges || CoverHolesInLevelsGeometry())
	{
		// Fix for BSP holes at the bridge
		// Note: some mobs should die in order to initiate certain map events;
		//       destruction out of the world may not produce an expected event
		block = Spawn(class'CollidingCylinder',,, LoadLevelActor("Light72").Location);
		block.SetCollisionSize(150, 20);

		MakeVerticalWall(Level, vect(-1008, 128, -140), vect(-768, 128, -132), 30);

		if (CoverHolesInLevelsGeometry())
			Spawn(class'DMesh_ExtremeCore_Brush2347',,, class'DMesh_ExtremeCore_Brush2347'.default.Location);
	}
}

function Server_FixCurrentMap_ExtremeGen()
{
	local Mover Lift;
	local Trigger LiftTrigger;
	local Actor LiftCounter;
	local MoverStateController LiftController;
	local MoverEventHandler LiftEventHandler;
	local MoverStateSensor LiftSensor;
	local Teleporter ExitTeleporter;

	if (CoverHolesInLevelsGeometry())
		Spawn(class'DMesh_ExtremeGen_Brush14_Patch',,, class'DMesh_ExtremeGen_Brush14_Patch'.default.Location);

	if (!Mutator.bEnableLogicMapChanges)
		return;

	if (Level.NetMode != NM_Standalone)
		MakeCovertCreatureFactoryController("CreatureFactory0");

	Lift = LoadLevelMover("Mover9");
	LiftController = Spawn(class'MoverStateController');
	LiftController.SetControlledMover(Lift);

	LiftEventHandler = Spawn(class'MoverEventHandler',, 'Die');
	LiftEventHandler.Controllers[0] = LiftController;
	LiftEventHandler.MoverPosChange = 'Open';

	LiftEventHandler = Spawn(class'MoverEventHandler',, 'toggle_gen_lift');
	LiftEventHandler.Controllers[0] = LiftController;
	LiftEventHandler.MoverPosChange = 'Toggle';

	LiftEventHandler = Spawn(class'MoverEventHandler',, 'down_gen_lift');
	LiftEventHandler.Controllers[0] = LiftController;
	LiftEventHandler.MoverPosChange = 'Open';
	LiftEventHandler.bPermanentChange = true;

	LiftTrigger = LoadLevelTrigger("Trigger2");
	LiftTrigger.Event = 'trigger_gen_lift';

	LiftSensor = Spawn(class'MoverStateSensor',, 'trigger_gen_lift');
	LiftSensor.ControlledMover = Lift;
	LiftSensor.Event = 'toggle_gen_lift';
	LiftSensor.bCanTriggerWhenOpened = true;
	LiftSensor.bCanTriggerWhenClosed = true;

	LiftCounter = LoadLevelActor("Counter4");
	LiftCounter.Event = 'down_gen_lift';

	if (CoopGame(Level.Game) != none)
	{
		// prevents replacement of original ExtremeDGen with ExtremeDarkGen
		ExitTeleporter = Teleporter(LoadLevelActor("Teleporter1"));
		ExitTeleporter.URL = " " $ ExitTeleporter.URL;
	}
}

function Server_FixCurrentMap_ExtremeDGen()
{
	local PlayerStart ps;
	local SpawnablePlayerStart coopPlayerStart;
	local vector offset;
	local Dispatcher disp;
	local SpecialEvent specEvent;

	if (!Mutator.bEnableLogicMapChanges)
		return;

	if (Level.NetMode != NM_Standalone)
	{
		offset = Transporter(LoadLevelActor("Transporter0")).Offset;

		foreach AllActors(class'PlayerStart', ps)
		{
			if (SpawnablePlayerStart(ps) != None)
				continue;
			ps.bSinglePlayerStart = False;
			ps.bCoopStart = False;

			coopPlayerStart = Spawn(class'SpawnablePlayerStart',, 'moveit', ps.Location, ps.Rotation);
			coopPlayerStart.NextLocation = ps.Location + offset;
			coopPlayerStart.NextRotation = ps.Rotation;
		}

		LoadLevelTrigger("Trigger6").Event = 'Disp_go';
		disp = Spawn(class'Dispatcher',, 'Disp_go');
		disp.OutEvents[0] = 'go';
		disp.OutDelays[0] = 5;
	}

	foreach AllActors(class'SpecialEvent', specEvent)
	{
		if (specEvent.Tag == 'moveit')
			specEvent.Tag = 'post_moveit';
	}
	disp = LoadLevelDispatcher("Dispatcher0");
	disp.OutEvents[7] = 'post_moveit';
	disp.OutDelays[7] = 0.1;
}

function Server_FixCurrentMap_ExtremeDark()
{
	if (Mutator.bEnableLogicMapChanges)
	{
		DisablePlayerStart("PlayerStart6");
		DisablePlayerStart("PlayerStart7");

		AdjustDamageTriggers('Death');
		AdjustDamageTriggers('Death7');
		AdjustDamageTriggers('Death8');
		AdjustDamageTriggers('Death9');
		AdjustDamageTriggers('Tag0');

		if (Level.NetMode != NM_Standalone)
			AssignInitialState(LoadLevelTrigger("Trigger25"), 'OtherTriggerTurnsOn'); // prevents the exit from being blocked
	}
}

function Server_FixCurrentMap_ExtremeEnd()
{
	local Trigger FlightTrigger;

	if (Level.NetMode != NM_Standalone)
	{
		if (Mutator.bEnableLogicMapChanges)
		{
			EventToEvent(LoadLevelTrigger("Trigger16").Event, LoadLevelTrigger("Trigger17").Tag);

			FlightTrigger = LoadLevelTrigger("Trigger0");
			FlightTrigger.bTriggerOnceOnly = false;
			FlightTrigger.ReTriggerDelay = 2;
		}
		if (Mutator.bEnableDecorativeMapChanges)
			MusicEvent(LoadLevelActor("MusicEvent0")).bOnceOnly = true;
	}
}

function Server_FixCurrentMap_QueenEnd()
{
	local Dispatcher Disp;

	if (Mutator.bEnableLogicMapChanges)
	{
		// fix for glitch with Mover59 caused by ThrowStuff1
		Disp = Spawn(class'Dispatcher',, 'yoka');
		Disp.OutEvents[0] = 'QueenMover_Tag';
		Disp.OutEvents[1] = 'Dummy_Event';
		Disp.OutDelays[1] = 1;
		LoadLevelMover("Mover59").Tag = 'QueenMover_Tag';
		LoadLevelMover("Mover5").Tag = LoadLevelMover("Mover0").Tag;

		AdjustDamageTriggers('Dead');
	}

	if (Mutator.bEnableDecorativeMapChanges)
		AdjustMoons();

	if (ImproveNPCBehavior())
		LoadLevelTrigger("Trigger13").TriggerType = TT_PawnProximity;

	if (ModifyNetRelevance())
	{
		MakeNetVisibilityCylinderAt('NetVisCylinder_1', "Light11", 6000, 5000);
		MakeNetVisibilityCylinderAt('NetVisCylinder_1', "Light43", 3000, 2000);
		MakeNetVisibilityCylinderAt('NetVisCylinder_1', "Teleporter4", 2000, 2000);
		MakeNetVisibilityCylinderAt('NetVisCylinder_2', "Light53", 800, 250);
		MakeNetVisibilityCylinderAt('NetVisCylinder_2', "Light78", 2000, 200);
	}
}

function Server_FixCurrentMap_EndGame()
{
	if (Mutator.bEnableLogicMapChanges)
		Mutator.bDisablePlayerMoves = true;
}

function Server_FixCurrentMap_DmAriza()
{
	if (CoverHolesInLevelsGeometry())
		Spawn(class'DMesh_DmAriza_Brush178',,, class'DMesh_DmAriza_Brush178'.default.Location);
}

function Server_FixCurrentMap_DmDeck16()
{
	if (CoverHolesInLevelsGeometry())
	{
		Spawn(class'DMesh_DmDeck16_Brush15',,, class'DMesh_DmDeck16_Brush15'.default.Location_Brush15);
		Spawn(class'DMesh_DmDeck16_Brush15',,, class'DMesh_DmDeck16_Brush15'.default.Location_Brush16);
		Spawn(class'DMesh_DmDeck16_Brush15',,, class'DMesh_DmDeck16_Brush15'.default.Location_Brush17);
		Spawn(class'DMesh_DmDeck16_Brush15',,, class'DMesh_DmDeck16_Brush15'.default.Location_Brush18);
	}
}

function Server_FixCurrentMap_DmRadikus()
{
	if (ModifyNetRelevance())
	{
		MakeNetVisibilityCylinderAt('NetVisCylinder_1', "PathNode70", 1000, 700);
		MakeNetVisibilityCylinderAt('NetVisCylinder_1', "PathNode100", 1000, 250);
		MakeNetVisibilityCylinderAt('NetVisCylinder_1', "PathNode101", 1000, 500);
		MakeNetVisibilityCylinderAt('NetVisCylinder_2', "PathNode8", 2000, 500);
		MakeNetVisibilityCylinderAt('NetVisCylinder_2', "PathNode23", 1000, 500);
		MakeNetVisibilityCylinderAt('NetVisCylinder_2', "PathNode97", 1000, 200);
		MakeNetVisibilityCylinderAt('NetVisCylinder_2', "PathNode102", 1000, 500);
		MakeNetVisibilityCylinderAt('NetVisCylinder_3', "Light9", 800, 1200);
		MakeNetVisibilityCylinderAt('NetVisCylinder_3', "PathNode16", 2000, 300);
	}
}


function ProtectMapMovers_NyLeve()
{
	ProtectMover("Mover38");
	ProtectMover("Mover41");
}

function ProtectMapMovers_Passage()
{
	ProtectMover("Mover10");
	ProtectMover("Mover11");
}

//---------------------------------------------------------------------------------------------------------------------
// RTNP maps:

function Server_FixCurrentMap_Intro1()
{
	if (Mutator.bEnableLogicMapChanges)
		class'SpawnableTeleporter'.static.StaticReplaceTeleporter(Teleporter(LoadLevelActor("UPakTeleporter0")));
}

function Server_FixCurrentMap_DuskFalls()
{
	local Actor Tentacle10;

	if (Mutator.bEnableDecorativeMapChanges)
	{
		Tentacle10 = LoadLevelActor("Tentacle10");
		if (Tentacle10 != none)
			Tentacle10.SetLocation(Tentacle10.Location - vect(0, 0, 34));
	}

	if (!Mutator.bEnableLogicMapChanges)
		return;

	ReplaceGameTypeTrigger("GameTypeTrigger0", Level.NetMode == NM_Standalone);

	if (Level.NetMode != NM_Standalone)
	{
		// the doors to the room with Predators and nearby doors cannot be closed anymore
		MakeMoverTriggerableOnceOnly("Mover16", true);
		MakeMoverTriggerableOnceOnly("Mover17", true);

		MakeMoverTriggerableOnceOnly("Mover51", true);
		MakeMoverTriggerableOnceOnly("Mover52", true);
	}

	if (ImproveNPCBehavior())
	{
		LoadLevelTrigger("Trigger3").TriggerType = TT_PawnProximity;  // Mover9 + Mover12
		LoadLevelTrigger("Trigger4").TriggerType = TT_PawnProximity;  // Mover7 + Mover8
		LoadLevelTrigger("Trigger10").TriggerType = TT_PawnProximity; // Mover32 + Mover33
		LoadLevelTrigger("Trigger16").TriggerType = TT_PawnProximity; // Mover38 + Mover39
		LoadLevelTrigger("Trigger17").TriggerType = TT_PawnProximity; // Mover40 + Mover41
		LoadLevelTrigger("Trigger18").TriggerType = TT_PawnProximity; // Mover42 + Mover43

		SetDelayedPawnTrigger("Trigger2"); // Mover2 + Mover3
		SetDelayedPawnTrigger("Trigger8"); // Mover22 + Mover23

		// TriggerType of Trigger19 and Trigger20 was intentionally left unmodified (TT_PlayerProximity)
		// Brutes shouldn't try to enter the room with slime (they still will under some circumstances)
		BlockNavigationPathThrough("PathNode282");
		BlockNavigationPathThrough("PathNode283");
		BlockNavigationPathThrough("PathNode284");
	}
}

function Server_FixCurrentMap_Nevec()
{
	if (ImproveNPCBehavior())
		LoadLevelTrigger("Trigger1").TriggerType = TT_PawnProximity; // Mover0 + Mover1
}

function Server_FixCurrentMap_Eldora()
{
	local PlayerStart ps;
	local SpawnablePlayerStart coopPlayerStart;
	local Teleporter telep;
	local vector next_start;
	local Dispatcher disp;
	local InstantDispatcher inst_disp;
	local Mover m;

	if (ModifyNetRelevance())
	{
		MakeNetVisibilityCylinderAt('NetVisCylinder_1', "Light100", 2500, 1000);
		MakeNetVisibilityCylinderAt('NetVisCylinder_1', "PathNode30", 1500, 500);
		MakeNetVisibilityCylinderAt('NetVisCylinder_2', "Light143", 600, 300);
		MakeNetVisibilityCylinderAt('NetVisCylinder_2', "Light148", 200, 300);
		MakeNetVisibilityCylinderAt('NetVisCylinder_2', "Light151", 800, 300);
		MakeNetVisibilityCylinderAt('NetVisCylinder_2', "Light182", 600, 300);
	}

	if (!Mutator.bEnableLogicMapChanges)
		return;

	// Disable all existing PlayerStarts, their location is not sensible
	foreach AllActors(class'PlayerStart', ps)
	{
		ps.bEnabled = False;
		ps.bSinglePlayerStart = False;
		ps.bCoopStart = False;
	}

	// Make entrance at the original beginning
	telep = Teleporter(LoadLevelActor("Teleporter1"));
	Spawn(class'SpawnablePlayerStart',,, telep.Location, telep.Rotation);

	if (Level.NetMode != NM_Standalone)
	{
		// When the water begins to rise, the entrance will be moved to the center of the control room
		next_start = LoadLevelActor("PathNode30").Location;

		Spawn(class'SpawnablePlayerStart',,, telep.Location + vect(-50, -50, 0), telep.Rotation);
		Spawn(class'SpawnablePlayerStart',,, telep.Location + vect(+50, -50, 0), telep.Rotation);
		Spawn(class'SpawnablePlayerStart',,, telep.Location + vect(-50, +50, 0), telep.Rotation);
		Spawn(class'SpawnablePlayerStart',,, telep.Location + vect(+50, +50, 0), telep.Rotation);

		foreach AllActors(class'SpawnablePlayerStart', coopPlayerStart)
		{
			coopPlayerStart.NextLocation = next_start;
			coopPlayerStart.Tag = 'risewater';
		}

		Spawn(class'Map_Eldora_CoopController',, 'risewater', next_start);

		// The water won't rise when the lift is not in the initial position 
		LoadLevelMover("Mover35").Event = 'disp_lift';
		m = LoadLevelMover("Mover1");

		disp = Spawn(class'Dispatcher',, 'disp_lift');
		disp.OutEvents[0] = 'disp_lift_start';
		disp.OutEvents[1] = 'disp_lift_end';
		disp.OutDelays[1] = m.MoveTime * 2 + m.StayOpenTime + 0.1;

		inst_disp = Spawn(class'InstantDispatcher',, 'disp_lift_start');
		inst_disp.OutEvents[0] = 'lift';
		inst_disp.ConditionTrigger = MakeConditionTrigger('counter_risewater', 'OtherTriggerTurnsOff', true);

		LoadLevelActor("Counter0").Event = 'counter_risewater';

		inst_disp = Spawn(class'InstantDispatcher',, 'counter_risewater');
		inst_disp.OutEvents[0] = 'risewater';
		inst_disp.ConditionTrigger = MakeConditionTrigger('lift_movement', 'OtherTriggerToggles', true);

		Spawn(class'InstantDispatcher',, 'disp_lift_start').OutEvents[0] = 'lift_movement';
		Spawn(class'InstantDispatcher',, 'disp_lift_end').OutEvents[0] = 'lift_movement';

		inst_disp = Spawn(class'InstantDispatcher',, 'disp_lift_end');
		inst_disp.OutEvents[0] = 'lift_risewater';
		inst_disp.ConditionTrigger = MakeConditionTrigger('counter_risewater', 'OtherTriggerTurnsOn', false);

		inst_disp = Spawn(class'InstantDispatcher',, 'lift_risewater');
		inst_disp.OutEvents[0] = 'risewater';
		inst_disp.ConditionTrigger = MakeConditionTrigger('risewater', 'OtherTriggerTurnsOff', true);


		ReplaceGameTypeTrigger("GameTypeTrigger0", true);

		DisableTrigger("Trigger3");
		DisableTrigger("Trigger8");
	}
}

function Server_FixCurrentMap_Glathriel1()
{
	local PlayerStart InitialStart;
	local SpawnablePlayerStart MovableStart;
	local Dispatcher disp;

	if (!Mutator.bEnableLogicMapChanges)
		return;

	InitialStart = PlayerStart(LoadLevelActor("PlayerStart1"));
	MovableStart = Spawn(class'SpawnablePlayerStart',,, vect(4910, 4900, -425), InitialStart.Rotation);
	MovableStart.AttachTag = 'YetAnotherBoat2';

	DisablePlayerStart("PlayerStart0");
	DisablePlayerStart("PlayerStart2");
	DisablePlayerStart("PlayerStart3");
	DisablePlayerStart("PlayerStart4");
	DisablePlayerStart("PlayerStart5");

	Spawn(class'Map_Glathriel1_CoopController',, 'YetAnotherBoat2').Init(InitialStart, MovableStart);

	disp = Spawn(class'Dispatcher',, 'YetAnotherBoat2');
	disp.OutEvents[0] = 'MoveStart';
	disp.OutDelays[0] = 15;

	if (ImproveNPCBehavior())
	{
		LoadLevelTrigger("Trigger1").TriggerType = TT_PawnProximity; // Mover83 + Mover85

		// The following potential improvements need additional changes in AI
		// MakeAIPawnTriggerFor("Trigger0"); // Mover81 + Mover82
		// MakeAIPawnTriggerFor("Trigger1"); // Mover83 + Mover85
		// MakeAIPawnTriggerFor("Trigger3"); // Mover84 + Mover86
	}
}

function Server_FixCurrentMap_Glathriel2()
{
	local Trigger Trigger;
	local Mover Mover;
	local Dispatcher Disp;

	if (!Mutator.bEnableLogicMapChanges)
		return;

	// If Nali won't open the door for some reason, the door will be opened anyway
	Disp = LoadLevelDispatcher("Dispatcher1");
	Disp.OutEvents[6] = 'fleenali_door';
	Disp.OutDelays[6] = 6.0;

	// Modifying the lever that opens tavern and library gates
	Mover = LoadLevelMover("Mover22");
	Mover.bTriggerOnceOnly = false;
	Trigger = LoadLevelTrigger("Trigger41");
	Trigger.bTriggerOnceOnly = false;
	Trigger.Event = 'OpenMover_TavernGateDispatcher';
	class'MoverOpening'.static.CreateInstance(Mover, 'OpenMover_TavernGateDispatcher', 'TavernGateDispatcher');

	// If the tavern gate is open, the lever won't close it; similarly for library gates
	Disp = LoadLevelDispatcher("Dispatcher9");
	Disp.OutEvents[2] = 'OpenMover_taverngate';
	Disp.OutEvents[3] = 'OpenMover_librarygate';
	class'MoverOpening'.static.CreateInstance(LoadLevelMover("Mover13"), 'OpenMover_taverngate');
	class'MoverOpening'.static.CreateInstance(LoadLevelMover("Mover19"), 'OpenMover_librarygate');

	// Let Skaarj close the library gates, but not open them
	LoadLevelActor("AlarmPoint7").Event = 'CloseMover_librarygate';
	class'MoverClosing'.static.CreateInstance(LoadLevelMover("Mover19"), 'CloseMover_librarygate');

	if (ImproveNPCBehavior())
	{
		MakeAIPawnTriggerFor("Trigger7"); // Mover25 + Mover26
		MakeAIPawnTriggerFor("Trigger8"); // Mover2 + Mover3
	}
}

function Server_FixCurrentMap_Crashsite()
{
	if (Mutator.bEnableLogicMapChanges)
	{
		DisablePlayerStart("PlayerStart0");
		DisablePlayerStart("PlayerStart2");
		DisablePlayerStart("PlayerStart4");
		AdjustDamageTriggers('KillPlayer');
	}
	if (Mutator.bEnableDecorativeMapChanges)
	{
		AdjustCollisionSizeByDrawScale("WoodenBox0");
		AdjustCollisionSizeByDrawScale("WoodenBox1");
		AdjustCollisionSizeByDrawScale("WoodenBox2");
		AdjustCollisionSizeByDrawScale("WoodenBox3");
	}
}

function Server_FixCurrentMap_Crashsite1()
{
	local Mover m;

	if (!Mutator.bEnableLogicMapChanges)
		return;

	m = LoadLevelMover("Mover50");
	m.Tag = LoadLevelTrigger("Trigger67").Event;
	m.StayOpenTime = FMax(0, 4 - m.MoveTime);
	AssignInitialState(m, 'TriggerOpenTimed');

	m = LoadLevelMover("Mover96");
	m.Tag = LoadLevelTrigger("Trigger55").Event;
	m.StayOpenTime = FMax(0, 4 - m.MoveTime);
	AssignInitialState(m, 'TriggerOpenTimed');

	m = LoadLevelMover("Mover120");
	m.Tag = LoadLevelTrigger("Trigger57").Event;
	m.StayOpenTime = FMax(0, 4 - m.MoveTime);
	AssignInitialState(m, 'TriggerOpenTimed');

	SpecialEvent(LoadLevelActor("SpecialEvent7")).DamageType = 'Burned';
	AdjustDamageTriggers('LavaDamage'); // SpecialEvent7

	if (ImproveNPCBehavior())
	{
		LoadLevelTrigger("Trigger27").TriggerType = TT_PawnProximity; // Mover24
		MakeAIPawnTriggerFor("Trigger55"); // Dispatcher0 - Mover96
		MakeAIPawnTriggerFor("Trigger57"); // Dispatcher2 - Mover120
		MakeAIPawnTriggerFor("Trigger67"); // Dispatcher5 - Mover50
	}
}

function Server_FixCurrentMap_Crashsite2()
{
	local Actor a;
	local Dispatcher d;
	local Mover m, sound_sample;
	local Trigger t;
	local Counter c;

	if (!Mutator.bEnableLogicMapChanges)
		return;

	// Dispatcher4 is controlled by two Triggers: Trigger11 and Trigger18;
	// when any is triggered, both will be disabled
	t = LoadLevelTrigger("Trigger11");
	AssignInitialState(t, 'OtherTriggerTurnsOff');
	t.Tag = 'Plunder3Dispatcher';

	LoadLevelTrigger("Trigger18").Tag = 'Plunder3Dispatcher';

	Spawn(class'CompTabletTrigger').AssignCompTablet(Pickup(LoadLevelActor("CompTablet0")));

	if (Level.NetMode != NM_Standalone)
	{
		// The door near to the CompTablet will be opened when the nearby Trigger will be
		// triggered and the scene with Mercenaries behind will be finished.
		LoadLevelTrigger("Trigger47").Event = 'LogDoorsCounter';
		d = LoadLevelDispatcher("Dispatcher4");
		d.OutEvents[5] = 'LogDoorsCounter';
		d.OutDelays[5] = 22;

		c = Spawn(class'Engine.Counter');
		c.NumToCount = 2;
		c.Tag = 'LogDoorsCounter';
		c.Event = 'LogDoors';

		// Fix the elevator to bridge, so it can be used several times
		d = LoadLevelDispatcher("Dispatcher1");

		d.OutEvents[1] = 'BridgeElevatorDoorsSound';
		d.OutEvents[2] = 'ToBridge';
		d.OutEvents[3] = 'BridgeElevatorDoors_2';
		d.OutEvents[4] = 'BridgeElevatorDoorsSound';
		d.OutEvents[5] = 'BridgeElevatorDoors_2';
		d.OutEvents[6] = 'BridgeElevatorDoors';
		d.OutEvents[7] = 'BridgeElevatorDoorsSound';

		d.OutDelays[1] = 0;
		d.OutDelays[2] = 1.5;
		d.OutDelays[3] = 3.0;
		d.OutDelays[4] = 0;
		d.OutDelays[5] = 3.0;
		d.OutDelays[6] = 3.0;
		d.OutDelays[7] = 0;

		LoadLevelActor("SpecialEvent5").Tag = 'BridgeElevatorDoorsSound';

		m = LoadLevelMover("Mover4");
		m.bTriggerOnceOnly = False;
		m.StayOpenTime = 6.0;
		m.MoverEncroachType = ME_CrushWhenEncroach;

		sound_sample = LoadLevelMover("Mover86");

		m = LoadLevelMover("Mover5");
		m.Tag = 'BridgeElevatorDoors_2';
		m.DoClose();
		m.OpenedSound = sound_sample.OpenedSound;
		m.ClosingSound = sound_sample.ClosingSound;

		m = LoadLevelMover("Mover83");
		m.Tag = 'BridgeElevatorDoors_2';
		m.DoClose();
		m.OpenedSound = sound_sample.OpenedSound;
		m.ClosingSound = sound_sample.ClosingSound;

		DisableTrigger("Trigger3");
	}

	// Assign greater radius to the killing trigger
	LoadLevelTrigger("Trigger36").SetCollisionSize(30720, 80);
	AdjustDamageTriggers('KillPawn'); // Trigger36

	// SpaceMarines and their weapons will be adjusted
	Spawn(class'Map_Crashsite2_SpaceMarinesController', self, 'StartMarineWaves');

	if (ImproveNPCBehavior())
		LoadLevelTrigger("Trigger38").TriggerType = TT_PawnProximity;

	LoadLevelTrigger("Trigger0").bTriggerOnceOnly = true; // ExitBeamTrigger

	// Makes events happen in right order: explosions first, then destruction of rocks
	d = LoadLevelDispatcher("Dispatcher5");
	d.OutEvents[1] = 'ExitExplosions';
	d.OutEvents[2] = 'ExitRocks';
	d.OutDelays[1] = 0.3;
	d.OutDelays[2] = 0.5;

	// More free space for the octagon beam
	a = LoadLevelActor("BeamPoint0");
	a = Spawn(class'SpawnableBeamPoint').Replace(a);
	a.SetLocation(a.Location + vect(0, 0, 40));
}

function Server_FixCurrentMap_SpireLand()
{
	local Actor AutoMag0;

	if (Mutator.bEnableDecorativeMapChanges)
	{
		AutoMag0 = LoadLevelActor("AutoMag0");
		if (AutoMag0 != none)
			AutoMag0.SetLocation(AutoMag0.Location + vect(0, 0, 6));
	}
}

function Server_FixCurrentMap_Nagomi()
{
	if (ImproveNPCBehavior())
	{
		BlockNavigationPathThrough("InventorySpot222");
		BlockNavigationPathThrough("InventorySpot241");
		BlockNavigationPathThrough("InventorySpot248");
	}
}

function Server_FixCurrentMap_Velora()
{
	if (CoverHolesInLevelsGeometry())
		Spawn(class'DMesh_Velora_Brush440',,, class'DMesh_Velora_Brush440'.default.Location);
}

function Server_FixCurrentMap_NagomiSun()
{
	if (Mutator.bEnableLogicMapChanges)
	{
		DisablePlayerStart("PlayerStart22");
		DisablePlayerStart("PlayerStart23");
		DisablePlayerStart("PlayerStart24");
		DisablePlayerStart("PlayerStart25");
	}

	if (ImproveNPCBehavior())
	{
		BlockNavigationPathThrough("InventorySpot264");
		BlockNavigationPathThrough("InventorySpot270");
		LoadLevelTrigger("Trigger0").TriggerType = TT_PawnProximity; // Mover0 + Mover1
	}
}

function Server_FixCurrentMap_Foundry()
{
	local ZoneInfo lava;

	if (Mutator.bEnableDecorativeMapChanges)
	{
		FixInvisibleChests();
		Spawn(class'PawnPhysicsAdjustment').SetPawnAdjustment(
			Pawn(LoadLevelActor("SkaarjBerserker0")), PHYS_Walking, 1, false);
	}

	// adjust the lava zone
	lava = ZoneInfo(LoadLevelActor("ZoneInfo1"));
	if (Mutator.bEnableLogicMapChanges)
	{
		lava.DamageType = 'Burned';
		lava.bDestructive = True;
	}
	if (Mutator.bEnableDecorativeMapChanges)
	{
		lava.EntryActor = class'UnrealShare.FlameExplosion';
		lava.ExitActor = class'UnrealShare.FlameExplosion';
		lava.EntrySound = Sound'UnrealShare.Generic.LavaEn';
		lava.ExitSound = Sound'UnrealShare.Generic.LavaEx';
	}

	if (!Mutator.bEnableLogicMapChanges)
		return;

	// fix the doors in front of Behemoth
	AssignInitialState(LoadLevelMover("Mover49"), 'TriggerOpenTimed');
	AssignInitialState(LoadLevelMover("Mover50"), 'TriggerOpenTimed');
	LoadLevelMover("Mover50").MoverEncroachType = ME_IgnoreWhenEncroach;

	// makes the lift button usable an unliminted number of times
	LoadLevelMover("Mover132").bTriggerOnceOnly = False;
	// fix the exit door
	LoadLevelTrigger("Trigger49").bTriggerOnceOnly = True;

	LoadLevelActor("ThrowStuff0").Tag = '';

	if (ImproveNPCBehavior())
	{
		LoadLevelTrigger("Trigger23").TriggerType = TT_PawnProximity; // Mover90 + Mover91
		LoadLevelTrigger("Trigger29").TriggerType = TT_PawnProximity; // Mover81
		LoadLevelTrigger("Trigger50").TriggerType = TT_PawnProximity; // Mover92 + Mover93

		SetDelayedPawnTrigger("Trigger2"); // Mover1 + Mover95
	}

	if (UseExtraProtection())
		Spawn(class'Map_Foundry_EndLiftController').Initialize(self);
}

function Server_FixCurrentMap_Toxic()
{
	local Mover m;
	local Trigger tr;
	local Mover end_skaarj_lift;
	local Pawn end_skaarj;
	local TracingTrigger skaarj_detector;
	local MoverStateSensor lift_sensor;
	local MoverStateController lift_controller;
	local MoverEventHandler lift_event_handler;
	local TriggeredPawnTeleporter skaarj_telep;

	if (Mutator.bEnableLogicMapChanges)
	{
		if (Level.NetMode != NM_Standalone)
			MakePermanentInventoryPointsFor(class'UnrealI.ToxinSuit');

		ReplaceGameTypeTrigger("GameTypeTrigger1", false);

		EnablePlayerStart("PlayerStart0");
		DisablePlayerStart("PlayerStart37");
		DisablePlayerStart("PlayerStart38");
		DisablePlayerStart("PlayerStart39");
		DisablePlayerStart("PlayerStart40");
		DisablePlayerStart("PlayerStart41");

		tr = LoadLevelTrigger("Trigger44");
		m = LoadLevelMover("Mover149");
		m.Event = tr.Event;
		m.Tag = '';
		m.BumpType = BT_PawnBump;
		tr.Event = '';

		if (ImproveNPCBehavior())
			MakeAIPawnTriggerFor("Trigger14"); // Mover9 + Mover10

		if (Level.NetMode != NM_Standalone)
			ZoneInfo(LoadLevelActor("ZoneInfo1")).ZoneTerminalVelocity = 980;

		end_skaarj_lift = LoadLevelMover("Mover30");

		// if the SkaarjLord0 fell through the lift, he will be moved back in the room
		end_skaarj = Pawn(LoadLevelActor("SkaarjLord0"));

		if (end_skaarj != none)
		{
			skaarj_detector = Spawn(class'TracingTrigger',,, end_skaarj.Location);
			skaarj_detector.Event = 'end_skaarj_detected';
			skaarj_detector.SetTracedActor(end_skaarj);

			lift_sensor = Spawn(class'MoverStateSensor',, skaarj_detector.Event);
			lift_sensor.ControlledMover = end_skaarj_lift;
			lift_sensor.Event = 'return_end_skaarj';
			lift_sensor.bCanTriggerWhenOpened = true;

			skaarj_telep = Spawn(
				class'TriggeredPawnTeleporter',,
				'return_end_skaarj',
				end_skaarj.Location + vect(0, 0, 700));
			skaarj_telep.ControlledPawn = end_skaarj;

			lift_controller = Spawn(class'MoverStateController');

			lift_event_handler = Spawn(class'MoverEventHandler',, end_skaarj_lift.Tag);
			lift_event_handler.Controllers[0] = lift_controller;
			lift_event_handler.MoverPosChange = 'Open';

			lift_event_handler = Spawn(class'MoverEventHandler',, 'down_end_skaarj_lift');
			lift_event_handler.Controllers[0] = lift_controller;
			lift_event_handler.MoverPosChange = 'Close';
			lift_event_handler.bPermanentChange = true;

			end_skaarj.Event = 'down_end_skaarj_lift';
			lift_controller.SetControlledMover(end_skaarj_lift);
		}
	}
	if (Mutator.bEnableDecorativeMapChanges)
	{
		FixInvisibleChests();
		DisableMoverGoodCollision(end_skaarj_lift);
	}
}

function Server_FixCurrentMap_Glacena()
{
	if (Level.NetMode != NM_Standalone && Mutator.bEnableLogicMapChanges)
		class'SafeFall'.static.CreateAtActor(Mutator, "Light43", 512, 256);
}

function Server_FixCurrentMap_Abyss()
{
	if (ModifyNetRelevance())
	{
		LoadLevelActor("Flag0").bAlwaysRelevant = true;
		LoadLevelActor("Flag1").bAlwaysRelevant = true;
	}
}

function Server_FixCurrentMap_Nalic2()
{
	local Dispatcher Disp;
	local Teleporter ExitTelep;

	if (!Mutator.bEnableLogicMapChanges)
		return;

	ReplaceGameTypeTrigger("GameTypeTrigger0", Level.NetMode != NM_Standalone);
	ReplaceGameTypeTrigger("GameTypeTrigger1", Level.NetMode == NM_Standalone);

	Disp = Spawn(class'Dispatcher',, 'SkaarjLord');
	Disp.OutDelays[0] = 20;
	Disp.OutEvents[0] = 'bustwall';

	if (Mutator.bModifyNalic2Exit)
	{
		LoadLevelMover("Mover33").Tag = 'gotme';
		ExitTelep = Teleporter(LoadLevelActor("UPakTeleporter0"));
		ExitTelep.bEnabled = false;
		ExitTelep.Tag = 'gotme';
		if (Level.NetMode != NM_Standalone)
			MakePawnEventTrigger(LoadLevelTrigger("Trigger72").Location, 128, 200, 'gotme');
	}

	if (ImproveNPCBehavior())
	{
		SetDelayedPawnTrigger("Trigger0");           // Mover0 + Mover1
		SetDelayedPawnTrigger("Trigger1", 'adoor1'); // Mover2 + Mover3
		LoadLevelTrigger("Trigger2").TriggerType = TT_PawnProximity;  // Mover4 + Mover5
		LoadLevelTrigger("Trigger4").TriggerType = TT_PawnProximity;  // Mover11 + Mover12
		LoadLevelTrigger("Trigger5").TriggerType = TT_PawnProximity;  // Mover13 + Mover14
		LoadLevelTrigger("Trigger9").TriggerType = TT_PawnProximity;  // Mover21 + Mover22
		LoadLevelTrigger("Trigger10").TriggerType = TT_PawnProximity; // Mover23 + Mover24
		LoadLevelTrigger("Trigger11").TriggerType = TT_PawnProximity; // Mover25 + Mover26
		LoadLevelTrigger("Trigger12").TriggerType = TT_PawnProximity; // Mover27 + Mover28
		LoadLevelTrigger("Trigger13").TriggerType = TT_PawnProximity; // Mover40
		LoadLevelTrigger("Trigger15").TriggerType = TT_PawnProximity; // Mover34 + Mover41
		LoadLevelTrigger("Trigger17").TriggerType = TT_PawnProximity; // Mover36 + Mover37
		LoadLevelTrigger("Trigger18").TriggerType = TT_PawnProximity; // Mover17 + Mover18
		LoadLevelTrigger("Trigger19").TriggerType = TT_PawnProximity; // Mover43 + Mover44
		LoadLevelTrigger("Trigger20").TriggerType = TT_PawnProximity; // Mover19 + Mover20

		DisableTrigger("Trigger26"); // Mover19 + Mover20
		DisableTrigger("Trigger27"); // Mover23 + Mover24
		DisableTrigger("Trigger28"); // Mover27 + Mover28
		DisableTrigger("Trigger30"); // Mover43 + Mover44
		DisableTrigger("Trigger31"); // Mover4 + Mover5
		DisableTrigger("Trigger40"); // Mover27 + Mover28

		MakeNavigationPathController("InventorySpot33", 'Scoutdoor', true, true);
		MakeNavigationPathController("PathNode39", 'onward', true, true);
	}
}

function Server_FixCurrentMap_End()
{
	if (Mutator.bEnableLogicMapChanges && Level.NetMode == NM_Standalone)
		Spawn(class'Map_End_HUDController');
}


//---------------------------------------------------------------------------------------------------------------------
// Aux functions

function bool UseExtraProtection()
{
	return Mutator.bEnableExtraProtection && Level.NetMode != NM_Standalone;
}

function bool ImproveNPCBehavior()
{
	return Mutator.bEnableLogicMapChanges && Mutator.bImproveNPCBehavior;
}

function bool PreventFastRetriggering()
{
	return Mutator.bEnableLogicMapChanges && Mutator.bPreventFastRetriggering;
}

function bool AdjustFallingMovers()
{
	return Mutator.bEnableLogicMapChanges && Mutator.bAdjustFallingMovers;
}

function bool CoverHolesInLevelsGeometry()
{
	return Mutator.ShouldCoverHolesInLevelsGeometry();
}

function bool ModifyNetRelevance()
{
	return Level.NetMode != NM_Standalone && Mutator.bEnableDecorativeMapChanges && Mutator.bModifyNetRelevance;
}

function bool UnlockNaliSecrets()
{
	return Mutator.bEnableLogicMapChanges && Mutator.bUnlockNaliSecrets;
}

function Mover LoadLevelMover(string MoverName)
{
	return Mover(LoadLevelActor(MoverName));
}

function MakeMoverTriggerableOnceOnly(string MoverName, optional bool bProtect)
{
	local Mover m;
	m = LoadLevelMover(MoverName);
	SetMoverTriggerableOnceOnly(m);
	if (bProtect)
		m.MoverEncroachType = ME_IgnoreWhenEncroach;
}

function SetMoverTriggerableOnceOnly(Mover m)
{
	m.bTriggerOnceOnly = True;
	AssignInitialState(m, 'TriggerOpenTimed');
}

function ProtectMover(string MoverName)
{
	LoadLevelMover(MoverName).MoverEncroachType = ME_IgnoreWhenEncroach;
}

function ProtectMapMovers()
{
	local Mover m;

	foreach AllActors(class'Mover', m)
		if (m.bTriggerOnceOnly &&
			m.MoverEncroachType == ME_ReturnWhenEncroach &&
			(m.InitialState == 'TriggerOpenTimed' ||
				m.InitialState == 'TriggerControl' ||
				m.InitialState == 'BumpOpenTimed' ||
				m.InitialState == 'BumpButton' ||
				m.InitialState == 'StandOpenTimed'))
		{
			m.MoverEncroachType = ME_IgnoreWhenEncroach;
		}
}

function Trigger LoadLevelTrigger(string TriggerName)
{
	return Trigger(LoadLevelActor(TriggerName));
}

function DisableTrigger(string TriggerName)
{
	LoadLevelTrigger(TriggerName).Event = '';
}

function Dispatcher LoadLevelDispatcher(string DispatcherName)
{
	return Dispatcher(LoadLevelActor(DispatcherName));
}

function EnablePlayerStart(string PlayerStartName)
{
	local PlayerStart ps;
	ps = PlayerStart(LoadLevelActor(PlayerStartName));
	ps.bSinglePlayerStart = true;
	ps.bCoopStart = true;
	ps.bEnabled = true;
}

function DisablePlayerStart(string PlayerStartName)
{
	local PlayerStart ps;
	ps = PlayerStart(LoadLevelActor(PlayerStartName));
	ps.bSinglePlayerStart = false;
	ps.bCoopStart = false;
	ps.bEnabled = false;
}

function MakePermanentInventoryPointsFor(class<Inventory> InventoryClass)
{
	local Actor inv;

	foreach AllActors(InventoryClass, inv)
		if (inv.Owner == none && !Inventory(inv).bHeldItem)
			Spawn(class'InventoryTrigger').AttachInventory(Inventory(inv));
}

function Trigger MakeConditionTrigger(name ConditionTag, name InitialStateName, bool InitialCondition)
{
	local Trigger result;

	result = Spawn(class'Trigger',, ConditionTag);
	AssignInitialState(result, InitialStateName);
	result.bInitiallyActive = InitialCondition;

	return result;
}

function AIPawnTrigger MakeAIPawnTriggerFor(string OriginalTriggerName)
{
	local Trigger original_trigger;
	local AIPawnTrigger pawn_trigger;

	original_trigger = LoadLevelTrigger(OriginalTriggerName);

	pawn_trigger = Spawn(
		class'AIPawnTrigger',
		original_trigger.Owner,
		original_trigger.Tag,
		original_trigger.Location);
	AssignInitialState(pawn_trigger, original_trigger.InitialState);
	pawn_trigger.SetCollisionSize(original_trigger.CollisionRadius, original_trigger.CollisionHeight);
	pawn_trigger.bInitiallyActive = original_trigger.bInitiallyActive;
	pawn_trigger.Event = original_trigger.Event;

	return pawn_trigger;
}

function SetDelayedPawnTrigger(string TriggerName, optional name ModTag)
{
	Spawn(class'DelayedPawnTriggerInfo').AssignTrigger(LoadLevelTrigger(TriggerName), ModTag);
}

function Trigger ReplaceGameTypeTrigger(string TriggerName, bool bRelevant)
{
	local Trigger OriginalTrigger, Replacement;
	OriginalTrigger = LoadLevelTrigger(TriggerName);

	if (!bRelevant)
	{
		OriginalTrigger.Event = ''; // disable original trigger
		return none;
	}

	Replacement = Spawn(class'Trigger',, OriginalTrigger.Tag, OriginalTrigger.Location, OriginalTrigger.Rotation);

	// copy collision properties
	Replacement.SetCollision(OriginalTrigger.bCollideActors, OriginalTrigger.bBlockActors, OriginalTrigger.bBlockPlayers);
	Replacement.SetCollisionSize(OriginalTrigger.CollisionRadius, OriginalTrigger.CollisionHeight);

	// copy event
	Replacement.Event = OriginalTrigger.Event;

	// copy trigger-specific properties
	Replacement.bInitiallyActive = OriginalTrigger.bInitiallyActive;
	Replacement.bTriggerOnceOnly = OriginalTrigger.bTriggerOnceOnly;
	Replacement.ClassProximityType = OriginalTrigger.ClassProximityType;
	Replacement.DamageThreshold = OriginalTrigger.DamageThreshold;
	Replacement.Message = OriginalTrigger.Message;
	Replacement.RepeatTriggerTime = OriginalTrigger.RepeatTriggerTime;
	Replacement.RetriggerDelay = OriginalTrigger.RetriggerDelay;
	Replacement.TriggerType = OriginalTrigger.TriggerType;

	AssignInitialState(Replacement, OriginalTrigger.InitialState);

	OriginalTrigger.Event = ''; // disable original trigger

	return Replacement;
}

static function MakeVerticalWall(LevelInfo level, vector corner1, vector corner2, float segments)
{
	local float half_height, half_width, segment_radius;
	local vector middle, start_point, offset;
	local int i;
	local CollidingCylinder u;

	middle = (corner1 + corner2) / 2;
	half_height = Abs(corner1.Z - corner2.Z);

	corner1.Z = middle.Z;
	corner2.Z = middle.Z;

	half_width = VSize(corner1 - corner2) / 2;

	segment_radius = half_width / (segments - 1);
	start_point = corner1;
	offset = (corner2 - corner1) / (segments - 1);

	for (i = 0; i < segments; ++i)
	{
		u = level.Spawn(class'CollidingCylinder',,, start_point + offset * i);
		u.SetCollisionSize(segment_radius, half_height);
	}
}

static function DisableMoverGoodCollision(Mover M)
{
	class'MapFixClient'.static.DisableMoverGoodCollision(M);
}

function MakeWorldGeometryCollision(string ActorName)
{
	LoadLevelActor(ActorName).SetPropertyText("bWorldGeometry", "true");
}

function AddFallingMoverController(string MoverName)
{
	local Mover M;

	M = LoadLevelMover(MoverName);
	if (M != none)
		Spawn(class'FallingMoverController', M, M.Tag);
}

function FixInvisibleChests()
{
	local Chest ChestA;

	// fix invisible wooden boxes
	foreach AllActors(class'UnrealShare.Chest', chestA)
	{
		if (ChestA.DrawType == DT_Mesh && ChestA.Mesh == none)
			ChestA.Mesh = Mesh'WoodenBoxM';

		chestA.SetPhysics(PHYS_Falling);
	}
}

function AdjustCollisionSizeByDrawScale(string ActorName)
{
	local Actor A;

	A = LoadLevelActor(ActorName);
	A.SetCollisionSize(A.CollisionRadius * A.DrawScale, A.CollisionHeight * A.DrawScale);
}

static function int BlockedNavigationPathCost()
{
	return 2147483647;
}

function BlockNavigationPathThrough(string NavigationPointName)
{
	NavigationPoint(LoadLevelActor(NavigationPointName)).ExtraCost = BlockedNavigationPathCost();
}

function MakeNavigationPathController(
	string NavigationPointName,
	name TriggerTag,
	bool bInitiallyBlocked,
	bool bTriggerOnceOnly)
{
	local NavigationPathController Controller;
	Controller = Spawn(class'NavigationPathController',, TriggerTag);
	Controller.Initialize(
		NavigationPoint(LoadLevelActor(NavigationPointName)),
		bInitiallyBlocked,
		bTriggerOnceOnly);
}

function DisableActorCollision(string ActorName, optional bool bOptionalActor)
{
	local Actor A;

	A = LoadLevelActor(ActorName, true);
	if (A != none)
		A.SetCollision(false);
}

function MakeNetVisibilityCylinderAt(name CylinderTag, string ActorName, float CylinderRadius, float CylinderHeight)
{
	MakeNetVisibilityCylinder(CylinderTag, LoadLevelActor(ActorName).Location, CylinderRadius, CylinderHeight); 
}

function MakeNetVisibilityCylinder(
	name CylinderTag,
	vector CylinderLocation,
	float CylinderRadius,
	float CylinderHeight)
{
	local NetVisibilityCylinder Cylinder;

	Cylinder = Spawn(class'NetVisibilityCylinder',, CylinderTag, CylinderLocation);
	if (Cylinder != none)
		Cylinder.SetCollisionSize(CylinderRadius, CylinderHeight);
}

function MakePawnEventTrigger(vector TriggerLocation, float CollisionRadius, float CollisionHeight, name EventName)
{
	local PawnEventTrigger Tr;
	Tr = Spawn(class'PawnEventTrigger',,, TriggerLocation);
	Tr.SetCollisionSize(CollisionRadius, CollisionHeight);
	Tr.Event = EventName;
}

function MakeCovertCreatureFactoryController(string CreatureFactoryName)
{
	local CovertThingFactoryController FactoryController;

	if (Level.NetMode == NM_Standalone || Mutator.bAdjustCovertThingFactories || Mutator.CovertThingFactoryTimeout <= 0)
		return;
	FactoryController = Spawn(class'CovertThingFactoryController');
	FactoryController.ControlledFactory = CreatureFactory(LoadLevelActor(CreatureFactoryName));
	FactoryController.Timeout = Mutator.CovertThingFactoryTimeout;
}

function AdjustDamageTriggers(name TriggerEventName)
{
	local Trigger Tr;
	foreach AllActors(class'Trigger', Tr)
		if (Tr.Event == TriggerEventName)
		{
			Tr.TriggerType = TT_ClassProximity;
			Tr.ClassProximityType = class'Pawn';
			Tr.bTriggerOnceOnly = false;
			if (Tr.RepeatTriggerTime == 0)
				Tr.RepeatTriggerTime = 1;
		}
}

function AdjustMoons()
{
	local Moon Moon;
	local int Count;

	if (Level.NetMode == NM_Standalone)
		return;

	foreach AllActors(class'Moon', Moon)
		if (Moon.Class.Outer.Name == 'UnrealI' &&
			!Moon.bStatic &&
			bool(Moon.RotationRate) &&
			Moon.Physics == PHYS_Rotating &&
			Moon.RemoteRole == ROLE_DumbProxy)
		{
			if (Moon.bNoDelete || IsExactlyReplicableRotator(Moon.RotationRate))
				Moon.RemoteRole = ROLE_SimulatedProxy;
			else if (Count < 16 && Spawn(class'SyncInitialRotationRate', Moon) != none)
			{
				Moon.bAlwaysRelevant = true;
				Moon.RemoteRole = ROLE_SimulatedProxy;
				++Count;
			}
		}
}

function bool IsExactlyReplicableRotator(rotator R)
{
	return
		IsExactlyReplicableRotatorComponent(R.Pitch) &&
		IsExactlyReplicableRotatorComponent(R.Yaw) &&
		IsExactlyReplicableRotatorComponent(R.Roll);
}

function bool IsExactlyReplicableRotatorComponent(int Value)
{
	return 0 <= Value && Value < 65536 && (Value & 255) == 0;
}

function EventToEvent(name OriginalEventName, name NewEventName)
{
	Spawn(class'InstantDispatcher',, OriginalEventName).OutEvents[0] = NewEventName;
}

function AssignInitialState(Actor A, name StateName)
{
	A.InitialState = StateName;
	if (!A.IsInState(A.InitialState))
		A.GotoState(A.InitialState);
}

function Actor LoadLevelActor(string ActorName, optional bool bMayFail)
{
	return Actor(DynamicLoadObject(Level.outer.name $ "." $ ActorName, class'Actor', bMayFail));
}

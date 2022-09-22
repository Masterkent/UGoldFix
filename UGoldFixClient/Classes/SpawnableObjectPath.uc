class SpawnableObjectPath expands Info;

var() name     PathActorTag;
var() bool     bAlterPitch;
var() bool     bAlterYaw;
var() bool     bAlterRoll;
var() rotator  RAdjust;

var Actor   	PathActor;
var PathPoint Path[35];
var int 		numPathNodes;
var int 		curNode;
var float 	uValue;
var bool 	bTriggeredOnce;
var bool		bPlayedOnce;
var int		lastNode;
var vector	lastPosition;
var rotator lastRotation;

var name RepTag;
var int RepCurNode;
var float RepUValue;
var bool bIsInitialized;

replication
{
	reliable if (Role == ROLE_Authority)
		bAlterPitch,
		bAlterYaw,
		bAlterRoll,
		RAdjust,
		PathActor,
		bTriggeredOnce,
		RepTag,
		RepCurNode,
		RepUValue;
}

function Replace(ObjectPath OriginalObjectPath)
{
	if (OriginalObjectPath == none)
	{
		Destroy();
		return;
	}

	Tag = OriginalObjectPath.Tag;
	RepTag = Tag;
	PathActorTag = OriginalObjectPath.PathActorTag;
	bAlterPitch = OriginalObjectPath.bAlterPitch;
	bAlterYaw = OriginalObjectPath.bAlterYaw;
	bAlterRoll = OriginalObjectPath.bAlterRoll;
	RAdjust = OriginalObjectPath.RAdjust;

	bTriggeredOnce = false;

	PathActor = none;
	foreach AllActors(class'Actor', PathActor)
	{
		if (PathActor.Tag == PathActorTag)
			break;
	}
	if (PathActor == none)
	{
		Log("SpawnableObjectPath: No object to be moved.  Aborting.");
		Destroy();
		return;
	}

	OriginalObjectPath.PathActor = none;
	OriginalObjectPath.Tag = '';
	OriginalObjectPath.PathActorTag = '';
	PathActor.Tag = '';
}

simulated function Initialize()
{
	local int i, l;
	local PathPoint tempPP;

	numPathNodes = 0;
	foreach AllActors(class'PathPoint', tempPP)
	{
		if (tempPP.Tag == RepTag)
		{
			Path[numPathNodes] = tempPP;
			numPathNodes++;
			if (numPathNodes > 35)
			{
				log("ObjectPath: Maximum number of path elements exceeded.  Aborting.");
				log("            Tag = " $ tempPP.Tag);
				Destroy();
				return;
			}
		}
	}

	if (numPathNodes < 4)
	{
		log("ObjectPath: Not enough PathPoints specified.  Needed 4.  Aborting.");
		Destroy();
		return;
	}

	for (i = 0; i < numPathNodes - 1; i++)
	{
		for (l=i+1; l<numPathNodes; l++)
		{
			if (Path[i].sequence_Number > Path[l].sequence_Number)
			{
				tempPP  = Path[i];
				Path[i] = Path[l];
				Path[l] = tempPP;
			}
		}
	}

	Path[1].pVelocity = Normal(Path[1].Location -
							   Path[0].Location) * Path[1].curvespeed;
	Path[numPathNodes - 2].pVelocity =
		Normal(Path[numPathNodes - 1].Location - Path[numPathNodes - 2].Location) * Path[numPathNodes - 2].curvespeed;

	for (i = 2; i <= numPathNodes - 3; i++)
		Path[i].pVelocity = Normal(Path[i + 1].Location - Path[i - 1].Location) * Path[i].curvespeed;

	curNode = 1;
	uValue = 0;
	lastNode = 0;
	lastPosition = vect(0,0,0);
	lastRotation = PathActor.Rotation;
	PathActor.SetLocation(Path[1].Location);
	PathActor.bAlwaysRelevant = true;
	if (Role == ROLE_Authority)
		PathActor.RemoteRole = ROLE_SimulatedProxy;

	bIsInitialized = true;
}

function Trigger(Actor Other, Pawn EventInstigator)
{
	bTriggeredOnce = true;
}

simulated function Tick(float DeltaTime)
{
	if (!bIsInitialized)
		Initialize();

	if (!bTriggeredOnce)
		return;

	if (bPlayedOnce)
	{
		Disable('Tick');
		return;
	}

	UpdatePathActor(DeltaTime);
}

simulated function UpdatePathActor(float DeltaTime)
{
	local float curSpeedU;
	local vector actorPosition;
	local rotator actorRotation;
	local vector nextNodeOffset;

	curSpeedU = (Path[curNode + 1].speedU - Path[curNode].speedU) * uValue + Path[curNode].speedU;
	uValue += curSpeedU * DeltaTime;

	while (uValue >= 1 && curNode < numPathNodes - 2)
	{
		curNode++;
		uValue -= 1;
	}

	if (Level.NetMode != NM_Client)
	{
		RepCurNode = curNode;
		RepUValue = uValue;
	}
	else if (RepCurNode + RepUValue > curNode + uValue)
	{
		curNode = RepCurNode;
		uValue = RepUValue;
	}

	if (curNode >= numPathNodes - 2)
	{
		PathActor.Move(Path[numPathNodes - 2].Location - PathActor.Location);
		PathActor.GotoState('');
		///if (PathActor.Role == ROLE_Authority)
		///	PathActor.RemoteRole = ROLE_DumbProxy;

		bPlayedOnce = true;
		return;
	}

	// offset has better precision than location
	nextNodeOffset = Path[curNode+1].Location - Path[curNode].Location;

	actorPosition  = Path[curNode].pVelocity * (3 * uValue * ((1-uValue)**2)) +
					 (nextNodeOffset - Path[curNode+1].pVelocity) * (3 * (uValue**2) * (1-uValue)) +
					 nextNodeOffset * (uValue**3);

	PathActor.Move(Path[curNode].Location + actorPosition - PathActor.Location);

	if (lastNode != curNode)
	{
		lastPosition += Path[lastNode].Location - Path[curNode].Location;
		lastNode = curNode;
	}

	actorRotation = rotator(actorPosition - lastPosition);
	actorRotation += RAdjust;

	if (!bAlterPitch)
		actorRotation.Pitch = lastRotation.Pitch;
	if (!bAlterYaw)
		actorRotation.Yaw = lastRotation.Yaw;
	if (!bAlterRoll)
		actorRotation.Roll = lastRotation.Roll;
	else
		actorRotation.Roll = 0.4 * (actorRotation.Yaw - lastRotation.Yaw);

	PathActor.SetRotation( actorRotation );

	lastRotation = actorRotation;
	lastPosition = actorPosition;
}

defaultproperties
{
	bAlwaysRelevant=True
	RemoteRole=ROLE_SimulatedProxy
}

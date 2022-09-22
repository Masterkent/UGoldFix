class SpawnableBeamPoint expands Keypoint;

var class<Effects> class_Octagon;
var class<CreatureCarcass> class_PresetMarineCarcass;
var Effects Beam;

function PostBeginPlay()
{
	class_Octagon = class<Effects>(DynamicLoadObject("UPak.Octagon", class'class'));
	class_PresetMarineCarcass = class<CreatureCarcass>(DynamicLoadObject("UPak.PresetMarineCarcass", class'class'));
}

function SpawnableBeamPoint Replace(Actor OriginalBeamPoint)
{
	SetLocation(OriginalBeamPoint.Location);
	SetRotation(OriginalBeamPoint.Rotation);
	Tag = OriginalBeamPoint.Tag;
	OriginalBeamPoint.Tag = '';
	return self;
}

function Trigger(Actor Other, Pawn EventInstigator)
{
	if (class_Octagon != none)
		Beam = Spawn(class_Octagon,,, Location);
	SetTimer(0.5, false);
}

function Timer()
{
	local CreatureCarcass carc;

	if (class_PresetMarineCarcass == none)
		return;
	carc = Spawn(class_PresetMarineCarcass,,, Location);
	if (carc != none)
		carc.ChunkUp(0);
}

defaultproperties
{
	bStatic=False
}

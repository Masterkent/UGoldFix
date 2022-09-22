class UGoldFixBase expands Mutator;

static function UGoldFixBase GetInstance(LevelInfo Level, out UGoldFixBase UGoldFix)
{
	if (UGoldFix != none)
		return UGoldFix;
	foreach Level.AllActors(class'UGoldFixBase', UGoldFix)
		return UGoldFix;
	return none;
}

function bool EnabledDecorativeMapChanges();
function bool ShouldAdjustDynamicLightMover();
function bool ShouldAdjustSpaceMarineCARDamage();
function bool ShouldCoverHolesInLevelsGeometry();
function bool ShouldReplaceBlastDecals();

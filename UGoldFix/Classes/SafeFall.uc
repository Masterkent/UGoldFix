class SafeFall expands Triggers;

static function CreateAtActor(
	UGoldFix UGoldFix,
	string ActorName,
	float CollisionRadius,
	float CollisionHeight)
{
	local Actor A;

	A = Actor(DynamicLoadObject(UGoldFix.Outer.Name $ "." $ ActorName, class'Actor'));
	if (A != none)
		A = UGoldFix.Spawn(class'SafeFall',,, A.Location);
	if (A != none)
		A.SetCollisionSize(CollisionRadius, CollisionHeight);

	UGoldFix.AddGameRules();
	if (UGoldFix.GameRules != none)
		UGoldFix.GameRules.bHandleSafeFall = true;
}

class ExplodingWallsController expands Info;

var array<ExplodingWall> ExplodingWalls;

function AddExplodingWall(ExplodingWall ExplodingWall)
{
	ExplodingWalls[Array_Size(ExplodingWalls)] = ExplodingWall;
}

event Tick(float DeltaTime)
{
	local int i;

	for (i = 0; i < Array_Size(ExplodingWalls); ++i)
	{
		if (ExplodingWalls[i] == none || ExplodingWalls[i].bDeleteMe)
			Array_Remove(ExplodingWalls, i);
		else if (ExplodingWalls[i].GetStateName() == 'Inactive')
		{
			ExplodingWalls[i].Destroy();
			Array_Remove(ExplodingWalls, i);
		}
	}
}

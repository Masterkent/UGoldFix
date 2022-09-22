class DMesh_ExtremeGen_Brush14_Patch extends DMeshBase;

#exec mesh import mesh=Mesh_ExtremeGen_Brush14_Patch anivfile=Models\Mesh_ExtremeGen_Brush14_Patch_a.3d datafile=Models\Mesh_ExtremeGen_Brush14_Patch_d.3d x=0 y=0 z=0 mlod=0
#exec mesh origin mesh=Mesh_ExtremeGen_Brush14_Patch x=0 y=0 z=0
#exec mesh sequence mesh=Mesh_ExtremeGen_Brush14_Patch seq=All startframe=0 numframes=1

#exec meshmap new meshmap=Mesh_ExtremeGen_Brush14_Patch mesh=Mesh_ExtremeGen_Brush14_Patch
#exec meshmap scale meshmap=Mesh_ExtremeGen_Brush14_Patch x=0.27441 y=0.27441 z=0.54883

defaultproperties
{
	Location=(X=272.500000,Y=0.000000,Z=167.000000)
	Mesh=Mesh'Mesh_ExtremeGen_Brush14_Patch'
	CollisionRadius=140.50000
	CollisionHeight=56.00000
}

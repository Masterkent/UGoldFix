class DMesh_Terraniux_Brush2721 extends DMeshBase;

#exec mesh import mesh=Mesh_Terraniux_Brush2721 anivfile=Models\Mesh_Terraniux_Brush2721_a.3d datafile=Models\Mesh_Terraniux_Brush2721_d.3d x=0 y=0 z=0 mlod=0
#exec mesh origin mesh=Mesh_Terraniux_Brush2721 x=0 y=0 z=0
#exec mesh sequence mesh=Mesh_Terraniux_Brush2721 seq=All startframe=0 numframes=1

#exec meshmap new meshmap=Mesh_Terraniux_Brush2721 mesh=Mesh_Terraniux_Brush2721
#exec meshmap scale meshmap=Mesh_Terraniux_Brush2721 x=1.00000 y=1.00000 z=2.00000

defaultproperties
{
	Location=(X=203.000000,Y=-16485.000000,Z=-512.000000)
	Mesh=Mesh'Mesh_Terraniux_Brush2721'
	CollisionRadius=72.000000
	CollisionHeight=256.000000
}

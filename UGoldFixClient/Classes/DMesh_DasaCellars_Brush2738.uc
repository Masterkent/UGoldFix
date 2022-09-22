class DMesh_DasaCellars_Brush2738 extends DMeshBase;

#exec mesh import mesh=Mesh_DasaCellars_Brush2738 anivfile=Models\Mesh_DasaCellars_Brush2738_a.3d datafile=Models\Mesh_DasaCellars_Brush2738_d.3d x=0 y=0 z=0 mlod=0
#exec mesh origin mesh=Mesh_DasaCellars_Brush2738 x=0 y=0 z=0
#exec mesh sequence mesh=Mesh_DasaCellars_Brush2738 seq=All startframe=0 numframes=1

#exec meshmap new meshmap=Mesh_DasaCellars_Brush2738 mesh=Mesh_DasaCellars_Brush2738
#exec meshmap scale meshmap=Mesh_DasaCellars_Brush2738 x=0.25000 y=0.25000 z=0.50000

var() vector Location_Brush2738;
var() vector Location_Brush2742;
var() vector Location_Brush2746;
var() vector Location_Brush2750;

defaultproperties
{
	Location_Brush2738=(X=7656.000000,Y=4480.000000,Z=-112.000000)
	Location_Brush2742=(X=8168.000000,Y=4480.000000,Z=-112.000000)
	Location_Brush2746=(X=8168.000000,Y=3968.000000,Z=-112.000000)
	Location_Brush2750=(X=7656.000000,Y=3968.000000,Z=-112.000000)
	Mesh=Mesh'Mesh_DasaCellars_Brush2738'
	CollisionRadius=128.00000
	CollisionHeight=64.00000
}

class MoverEventHandler expands UGoldFixServerInfo;

var MoverStateController Controllers[4];
var name MoverPosChange;
var bool bPermanentChange;
var name OpenPosEvent;
var name ClosePosEvent;

function Trigger(Actor A, Pawn EventInstigator)
{
	local int i;

	for (i = 0; i < ArrayCount(Controllers); ++i)
		if (Controllers[i] != none)
		{
			if (MoverPosChange != '')
				Controllers[i].SetCurrentChange(MoverPosChange, bPermanentChange, A, EventInstigator);
			if (OpenPosEvent != '')
				Controllers[i].OpenPosEvent = OpenPosEvent;
			if (ClosePosEvent != '')
				Controllers[i].ClosePosEvent = ClosePosEvent;
			OpenPosEvent = '';
			ClosePosEvent = '';
		}
}

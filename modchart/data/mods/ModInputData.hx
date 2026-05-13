package modchart.data.mods;

import modchart.data.MusicSync;
import modchart.data.arrows.*;
import modchart.data.mods.ModEntryFlags;

typedef ModInputData = {
	// The entry value of this mod.
	value:Float,

	// The entry flag of this mod.
	currentFlag:ModEntryFlags,

	// Relative distance from the arrow to the receptor, in miliseconds.
	distance:Float,

	musicSync:MusicSync,

	// Arrow data.
	column:Int,
	player:Int,

	// The type of this note.
	type:ArrowType,
}

package;

import modchart.impl.components.*;

interface ICompat {
	public function create():Void;
	public function dispose():Void;

	public function uploadMusicSync(data:MusicSync):Void;

	public function getBeatFromStep(step:Float):Float;
	public function getMeasureFromBeat(beat:Float):Float;

	public function uploadQueue():RenderQueue;
}

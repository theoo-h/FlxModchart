package modchart.impl;

import haxe.exceptions.NotImplementedException;
import modchart.impl.components.MusicSync;
import modchart.impl.components.RenderQueue;

@:nullSafety(Strict)
abstract class CompatImpl implements ICompat {
	public function create():Void {}

	public function dispose():Void {}

	/**
	 * Upload the music sync variables.
	 * Should be called everytime the music position changes (multiple times a frame).
	 * @param data 
	 */
	public function uploadMusicSync(data:Null<MusicSync>):Void {
		if (data == null) {
			ModchartLog("Failed to upload music sync: the data is null, keeping last data samples.");
			return;
		}
		Global.musicSync = data;
	}

	// Get beat position from step position.
	public function getBeatFromStep(step:Float):Float {
		throw new NotImplementedException();
		return 0;
	}

	// Get measure position from beat position.
	public function getMeasureFromBeat(beat:Float):Float {
		throw new NotImplementedException();
		return 0;
	}

	/**
	 * Upload the render queue.
	 * Should be called after your arrows, receptors and holds are up to date.
	 * @param data 
	 */
	public function uploadQueue():Null<RenderQueue> {
		throw new NotImplementedException();
		return null;
	}
}

package;

import flixel.FlxState;
import modchart.internal.Renderer;

class PlayState extends FlxState
{
	var renderer:Renderer;

	override public function create()
	{
		super.create();

		renderer = new Renderer();
	}

	override public function update(elapsed:Float)
	{
		super.update(elapsed);
	}

	override function draw()
	{
		super.draw();
	}
}

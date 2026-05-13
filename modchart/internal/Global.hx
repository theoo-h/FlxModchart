package modchart.internal;

import flixel.FlxG;
import lime.graphics.WebGLRenderContext;
import lime.graphics.opengl.GLBuffer;
import modchart.data.MusicSync;
import openfl.display3D.Context3D;

class Global {
	private static var _nextActorID:Int = 0;

	public static var musicSync:MusicSync;

	public static var gl(get, null):WebGLRenderContext;
	public static var context3D(get, null):Context3D;

	public static var quadVBO:GLBuffer;

	inline static function get_GL()
		return @:privateAccess FlxG.stage.context3D.gl;

	inline static function get_context3D()
		return @:privateAccess FlxG.stage.context3D;

	public static function init() {}

	public static function resetVariables() {
		_nextActorID = 0;
	}

	public static function updateVariables() {}

	macro public static function log(message:String) {
		#if !FLX_MODCHART_NO_LOGS
		return macro {};
		#else
		return macro {trace("[ FunkinModchart ] " + message)};
		#end
	}
}

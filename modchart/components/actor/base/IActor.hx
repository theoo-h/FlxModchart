package modchart.components.actor.base;

interface IActor {
	public var ID(default, null):Int;

	public var parent(default, null):IActor;
	private var _children(default, null):Array<IActor>;

	public function addChild(child:IActor):Void;
	public function removeChild(child:IActor):Void;

	public function forEachActor(fn:IActor->Void):Void;
}

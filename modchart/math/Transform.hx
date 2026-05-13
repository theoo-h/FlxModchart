package modchart.math;

import lime.math.Matrix4;
import lime.math.Vector4;

class Transform {
	public var x:Float = 0;
	public var y:Float = 0;
	public var z:Float = 0;

	public var rotationX:Float = 0;
	public var rotationY:Float = 0;
	public var rotationZ:Float = 0;

	public var scaleX:Float = 1;
	public var scaleY:Float = 1;
	public var scaleZ:Float = 1;

	public var skewX:Float = 0;
	public var skewY:Float = 0;

	public var alpha:Float = 1;

	var _matrix:Matrix4 = new Matrix4();
	var _dirty:Bool = true;

	public function new() {}

	public inline function markDirty():Void
		_dirty = true;

	@:pure public inline function isDirty():Bool
		return _dirty;

	public function getMatrix():Matrix4 {
		if (_dirty) {
			_matrix.identity();
			_matrix.appendTranslation(x, y, z);
			_matrix.appendRotation(rotationX, new Vector4(1, 0, 0));
			_matrix.appendRotation(rotationY, new Vector4(0, 1, 0));
			_matrix.appendRotation(rotationZ, new Vector4(0, 0, 1));
			_matrix.appendScale(scaleX, scaleY, scaleZ);

			// skew (lime doesn't have it)
			var skew = new Matrix4();
			skew[4] = Math.tan(skewX * Math.PI / 180);
			skew[1] = Math.tan(skewY * Math.PI / 180);
			_matrix.append(skew);

			_dirty = false;
		}
		return _matrix;
	}

	public function combine(parent:Transform):Transform {
		var result = new Transform();
		result._matrix.copyFrom(parent.getMatrix());
		result._matrix.append(getMatrix());
		result.alpha = parent.alpha * alpha;
		result._dirty = false;
		return result;
	}

	public inline function reset():Void {
		x = 0;
		y = 0;
		z = 0;
		rotationX = 0;
		rotationY = 0;
		rotationZ = 0;
		scaleX = 1;
		scaleY = 1;
		scaleZ = 1;
		skewX = 0;
		skewY = 0;
		alpha = 1;
		_dirty = true;
	}

	public inline function copyFrom(other:Transform):Void {
		x = other.x;
		y = other.y;
		z = other.z;
		rotationX = other.rotationX;
		rotationY = other.rotationY;
		rotationZ = other.rotationZ;
		scaleX = other.scaleX;
		scaleY = other.scaleY;
		scaleZ = other.scaleZ;
		skewX = other.skewX;
		skewY = other.skewY;
		alpha = other.alpha;
		_dirty = true;
	}
}

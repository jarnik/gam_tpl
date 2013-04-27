package ;
import nme.display.Sprite;
import nme.geom.Point;
import pug.render.RenderGroupStates;
import pug.render.Render;
import gaxe.Debug;

enum CREATURE_TYPE {
	TINY;
	SMALL;
	MEDIUM;
	LARGE;
}

/**
 * ...
 * @author Jarnik
 */
class Creature extends Grid {

	private var target:Point;
	private var position:Point;
	private var speed:Float;
	
	public var full:Bool;
	public var alive:Bool;
	public var size:CREATURE_TYPE;
	
	public function new( t:CREATURE_TYPE ) {
		super( "creature" );
		this.size = t;
		alive = true;
		
		switch ( t ) {
			case TINY: skin.render( 0 );
			case SMALL: skin.render( 1 );
			case MEDIUM: skin.render( 2 );
			case LARGE: skin.render( 3 );
		}
		
		full = false;
		target = new Point();
		position = new Point();
		speed = 80;
	}
	
	public function moveTo( x:Float, y:Float ):Void {
		position.x = x;
		position.y = y;
		this.x = Math.round( position.x );
		this.y = Math.round( position.y );
	}
	
	public function setTarget( x:Float, y:Float ):Void {
		target.x = x;
		target.y = y;
	}
	
	public function touches( c:Creature ):Bool {
		var threshold:Float = 16;
		if ( Point.distance( new Point( x, y ), new Point( c.x, c.y ) ) < threshold )
			return true;
		return false;
	}
	
	public function devours( c:Creature ):Bool {
		if ( Type.enumIndex( size ) == Type.enumIndex( c.size ) + 1 && !full )
			return true;
		return false;
	}
	
	public function mates( c:Creature ):Bool {
		return ( size == c.size && full && c.full );
	}
	
	public function setFull( f:Bool ):Void {
		full = f;
	}
	
	private function onTargetReached():Void {
	}
	
	public function update( timeElapsed:Float ):Void {
		var direction:Point = target.clone();
		direction = direction.subtract( position );
		var threshold:Float = 1;
		if ( direction.length < threshold ) {
			onTargetReached();
			return;
		}
		
		var d:Float = Math.min( direction.length, timeElapsed * speed );
		direction.normalize( d );
		
		position = position.add( direction );
		moveTo( position.x, position.y );
	}
}
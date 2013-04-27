package ;

import Creature;
import nme.geom.Point;

/**
 * ...
 * @author Jarnik
 */
class Player extends Creature
{
	private var taint:CREATURE_TYPE;
	private var lastDrop:Point;

	public function new( x:Float, y:Float ) {
		super( TINY );
		moveTo( x, y );
		setTaint( null );
		lastDrop = new Point( Math.POSITIVE_INFINITY, Math.POSITIVE_INFINITY );
	}
	
	public function hasDrop():Pheromone {
		var threshold:Float = 16;
		if ( taint != null && Point.distance( lastDrop, position ) > threshold ) {
			lastDrop.x = position.x;
			lastDrop.y = position.y;
			return new Pheromone( taint, position.x, position.y );
		}
		return null;
	}
	
	public function setTaint( t:CREATURE_TYPE ):Void {
		taint = t;
	}
}
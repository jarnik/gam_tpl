package ;

import nme.geom.Point;
import Creature;


/**
 * ...
 * @author Jarnik
 */
class CreatureAI extends Creature
{
	public var idleTimer:Float;
	public var pheromoneTarget:Bool;

	public function new( t:CREATURE_TYPE, x:Float, y:Float ) {
		super( t );
		moveTo( x, y );
		idleTimer = -1;
		pheromoneTarget = false;
		
		setRandomTarget();
	}
	
	private function setRandomTarget():Void {
		var range:Float = 80;
		var a:Float = Math.random() * Math.PI * 2;
		var d:Float = ( Math.random() + 0.5 ) *  range;
		
		var tx:Float;
		var ty:Float;
		
		do {
			a += Math.PI / 2;
			tx = position.x + Math.sin( a ) * d;
			ty = position.y + Math.cos( a ) * d;
		} while (
			tx < 0 || tx > Board.W ||
			ty < 0 || ty > Board.H
		);
		
		setTarget( tx, ty );
	}
	
	override private function onTargetReached():Void {
		//setRandomTarget();
		target == null;
		idleTimer = Math.random() * 1;
	}
	
	override public function update(timeElapsed:Float):Void 
	{
		if ( idleTimer > 0 ) {
			idleTimer -= timeElapsed;
			if ( idleTimer <= 0)
				setRandomTarget();
		}
		speed = pheromoneTarget ? 80 : ( full ? 40 : 60 );
		super.update(timeElapsed);
		pheromoneTarget = false;
	}
	
	public function smell( p:Pheromone ):Void {
		var consumeThreshold:Float = 16;
		var smellThreshold:Float = 50;
		var d:Float = Point.distance( position, new Point( p.x, p.y ) );
		if ( d < consumeThreshold ) {
			p.active = false;
		} else if ( d < smellThreshold ) {
			setTarget( p.x, p.y );
			pheromoneTarget = true;
		}
	}
	
}
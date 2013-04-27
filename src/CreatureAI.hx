package ;

import Creature;

/**
 * ...
 * @author Jarnik
 */
class CreatureAI extends Creature
{

	public function new( t:CREATURE_TYPE, x:Float, y:Float ) {
		super( t );
		moveTo( x, y );
		//speed = 10;
		
		setRandomTarget();
	}
	
	private function setRandomTarget():Void {
		var range:Float = 20;
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
		setRandomTarget();
	}
	
}
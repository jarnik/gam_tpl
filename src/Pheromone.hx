package ;

import Creature;

/**
 * ...
 * @author Jarnik
 */
class Pheromone extends Grid
{
	public var kind:CREATURE_TYPE;
	public var active:Bool;
	private var life:Float;
	
	public function new( kind:CREATURE_TYPE, x:Float, y:Float ) {
		this.kind = kind;
		super( "pheromone" );
		switch ( kind ) {
			case SMALL: 
				skin.switchState("small");
			case MEDIUM: 
				skin.switchState("medium");
			case LARGE: 
				skin.switchState("large");
			default:
		}
		skin.render( 0, false );
		active = true;
		life = 4;
		
		this.x = x;
		this.y = y;
	}
	
	public function update( elapsed:Float ):Void {
		life -= elapsed;
		if ( life < 0 ) 
			active = false;
		else
			alpha = life / 4;
		
	}
	
}
package ;
import Creature;
/**
 * ...
 * @author Jarnik
 */
class Pool extends Grid
{
	public var kind:CREATURE_TYPE;

	public function new( kind:CREATURE_TYPE, x:Float, y:Float ) {
		this.kind = kind;
		super( "pool" );
		skin.render( Type.enumIndex( kind ) - 1 );
		
		this.x = x;
		this.y = y;
	}
	
}
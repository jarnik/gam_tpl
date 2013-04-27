package ;
import nme.display.Sprite;
import pug.render.Render;
import pug.render.RenderGroup;
import gaxe.Debug;

/**
 * ...
 * @author Jarnik
 */
class Board extends Sprite
{
	private var player:Creature;
	private var creatures:Array<Creature>;
	private var map:RenderGroup;
	
	public function new() {
		super();
		
		addChild( map = cast( Render.renderSymbol( GAM.lib.get("playscreen") ), RenderGroup ) );
		map.render( 0 );		
		
		creatures = [];
		
		addChild( player = new Creature( TINY ) );
		player.moveTo( 50, 50 );
		player.setTarget( 100, 50 );
		creatures.push( player );
	}
	
	public function update( timeElapsed:Float ):Void {
		for ( c in creatures ) {
			c.update( timeElapsed );
		}
	}
	
	public function setPlayerTarget( key:String ):Void {
		var r:Render = map.fetch( key );
		player.setTarget( r.x, r.y );
	}
	
}
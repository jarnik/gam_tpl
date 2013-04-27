package ;
import nme.display.Sprite;
import pug.render.RenderGroupStates;
import pug.render.Render;
import nme.geom.Point;

/**
 * ...
 * @author Jarnik
 */
class Grid extends Sprite
{
	
	private var skin:RenderGroupStates;
	
	public function new( skinName:String ) {
		super();
		skin = cast( Render.renderSymbol( GAM.lib.get( skinName ) ), RenderGroupStates );
		skin.render( 0, false );
		addChild( skin );
	}
	
	public function touches( c:Grid ):Bool {
		var threshold:Float = 25;
		if ( Point.distance( new Point( x, y ), new Point( c.x, c.y ) ) < threshold )
			return true;
		return false;
	}
}
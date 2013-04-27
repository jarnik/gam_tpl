package ;
import nme.display.Sprite;
import pug.render.RenderGroupStates;
import pug.render.Render;

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
	
}
package;
import gaxe.Scene;
import nme.events.KeyboardEvent;
import nme.ui.Keyboard;
import pug.render.RenderGroupStates;
import pug.render.Render;

/**
 * ...
 * @author Jarnik
 */
class PlayScene extends Scene
{
	private var heart:RenderGroupStates;
 
	override private function create():Void {
		heart = cast( Render.renderSymbol( GAM.lib.get("heart") ), RenderGroupStates );
		heart.render( 0 );
		addChild( heart );
	}
	
	override public function handleKey( e:KeyboardEvent ):Void {
		switch ( e.keyCode ) {
			case Keyboard.RIGHT:
				heart.x += 5;
		}
	}
	
}
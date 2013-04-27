package;
import gaxe.Scene;
import nme.events.KeyboardEvent;
import nme.ui.Keyboard;
import pug.render.RenderGroupStates;
import pug.render.Render;
import Creature;

/**
 * ...
 * @author Jarnik
 */
class PlayScene extends Scene
{
	private var board:Board;
 
	override private function create():Void {
		addChild( board = new Board() );
		board.y = 120;
	}
	
	override public function update(elapsed:Float):Void {
		super.update(elapsed);
		board.update( elapsed );
	}
	
	override public function handleKey( e:KeyboardEvent ):Void {
		if ( e.type == KeyboardEvent.KEY_DOWN ) {
			switch ( e.keyCode ) {
				case Keyboard.Q:
					board.setPlayerTarget( "Q" );
				case Keyboard.P:
					board.setPlayerTarget( "P" );
				case Keyboard.Z:
					board.setPlayerTarget( "Z" );
				case Keyboard.M:
					board.setPlayerTarget( "M" );
			}
		}
	}
	
}
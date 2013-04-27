package;
import gaxe.Scene;
import nme.events.KeyboardEvent;
import nme.ui.Keyboard;
import pug.render.RenderGroupStates;
import pug.render.Render;
import Creature;
import gaxe.Debug;

import nme.events.MouseEvent;

/**
 * ...
 * @author Jarnik
 */
class PlayScene extends Scene
{
	private var board:Board;
	private var hDir:Int;
	private var vDir:Int;
 
	override private function create():Void {
		addChild( board = new Board() );
		board.y = 120;
		
		hDir = 0;
		vDir = 0;
		
		board.mouseChildren = false;
		board.addEventListener( MouseEvent.CLICK, onClick );
	}
	
	override public function update(elapsed:Float):Void {
		super.update(elapsed);
		board.update( elapsed );
		
		if ( hDir != 0 || vDir != 0 ) {
			board.stepPlayer( hDir, vDir );
		}
	}
	
	override public function handleKey( e:KeyboardEvent ):Void {
		if ( e.type == KeyboardEvent.KEY_DOWN ) {
			switch ( e.keyCode ) {
				case Keyboard.Q:
					board.setPlayerTarget( "Q", e.shiftKey );
				case Keyboard.P:
					board.setPlayerTarget( "P", e.shiftKey );
				case Keyboard.Z:
					board.setPlayerTarget( "Z", e.shiftKey );
				case Keyboard.M:
					board.setPlayerTarget( "M", e.shiftKey );
				case Keyboard.T:
					board.setPlayerTarget( "T", e.shiftKey );
				case Keyboard.V:
					board.setPlayerTarget( "V", e.shiftKey );
				case Keyboard.LEFT:
					if ( hDir == 0 )
						hDir = -1;
				case Keyboard.RIGHT:
					if ( hDir == 0 )
						hDir = 1;
				case Keyboard.UP:
					if ( vDir == 0 )
						vDir = -1;
				case Keyboard.DOWN:
					if ( vDir == 0 )
						vDir = 1;
			}
		} else {
			switch ( e.keyCode ) {
				case Keyboard.LEFT:
					if ( hDir == -1 )
						hDir = 0;
				case Keyboard.RIGHT:
					if ( hDir == 1 )
						hDir = 0;
				case Keyboard.UP:
					if ( vDir == -1 )
						vDir = 0;
				case Keyboard.DOWN:
					if ( vDir == 1 )
						vDir = 0;
			}
		}
	}
	
	private function onClick( e:MouseEvent ):Void {
		board.setPlayerTargetPoint( e.localX, e.localY, e.shiftKey );
	}
	
}
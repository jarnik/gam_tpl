package;
import gaxe.Gaxe;
import gaxe.Scene;
import gaxe.GameLog;
import nme.events.KeyboardEvent;
import nme.ui.Keyboard;
import pug.render.RenderGroupStates;
import pug.render.Render;
import Creature;
import gaxe.Debug;

import nme.events.MouseEvent;


enum PLAY_STATE {
    STATE_PLAY;
    STATE_WIN;
    STATE_FAIL;
}

/**
 * ...
 * @author Jarnik
 */
class PlayScene extends Scene
{
	private var board:Board;
	private var overlays:RenderGroupStates;
	private var hDir:Int;
	private var vDir:Int;
 
	override private function create():Void {
		addChild( board = new Board() );
		board.onMenuClicked.bindVoid( onMenuClicked );
		
		addChild( overlays = cast( Render.renderSymbol( GAM.lib.get("overlays") ), RenderGroupStates ) );
		//map.switchState( "main" );
		overlays.switchState( "gameover" );
		overlays.render( 0, false );
		overlays.fetch("continue").onClick( onContinueClick );		
		
		//board.mouseChildren = false;
		//board.addEventListener( MouseEvent.CLICK, onClick );
	}
	
	override private function reset():Void 
	{
		super.reset();
		switchState( STATE_PLAY );
		//switchState( STATE_FAIL );
	}
	
	override public function update(elapsed:Float):Void {
		super.update(elapsed);
		overlays.update( elapsed );
		
		switch ( state ) {
			case STATE_PLAY:				
				board.updateAnims( elapsed );
				board.update( elapsed );
				
				if ( hDir != 0 || vDir != 0 ) {
					board.stepPlayer( hDir, vDir );
				}
				
				if ( board.IsGameOver() )
					switchState( STATE_FAIL );
			case STATE_FAIL:
				board.updateAnims( elapsed );
			default:
		}
	}
	
	override private function handleSwitchState(id:Dynamic):Bool 
	{
		GameLog.log( { state: "PlayState", action: Std.string( id ) } );
		switch ( id ) {
			case STATE_PLAY:
				hDir = 0;
				vDir = 0;
				board.reset();
				overlays.play( false, 30, "play" );
			case STATE_FAIL:
				overlays.play( false, 30, "gameover" );
			default:
		}
		return super.handleSwitchState(id);
	}
	
	override public function handleKey( e:KeyboardEvent ):Void {
		if ( state != STATE_PLAY )
			return;
			
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
		if ( state != STATE_PLAY )
			return;
		
		board.setPlayerTargetPoint( e.localX, e.localY, e.shiftKey );
	}
	
	private function onContinueClick( e:MouseEvent ):Void {
		switchState( STATE_PLAY );
		refocus();
	}
	
	private function onMenuClicked():Void {
		Gaxe.head.switchScene( TitleScene );
	}
	
}
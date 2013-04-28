package;

import gaxe.Gaxe;
import gaxe.Scene;
import gaxe.Debug;
import hsl.haxe.DirectSignaler;
import hsl.haxe.Signaler;
import nme.events.KeyboardEvent;
import nme.events.MouseEvent; 
import nme.ui.Keyboard;
import pug.render.RenderGroupStates;
import pug.render.Render;
import com.eclecticdesignstudio.motion.Actuate;


class TitleScene extends Scene
{
    //private var board:Board;
	private var title:RenderGroupStates;
    
	override public function create():Void
	{
		title = cast( Render.renderSymbol( GAM.lib.get("title") ), RenderGroupStates );
		title.render( 0, false );
		addChild( title );
		
		//title.fetch("planetix_logo439").onClick( onTitleClicked );
		title.fetch("btnStart").onEvents( [ MouseEvent.MOUSE_UP ], onTitleClicked );
		title.fetch("btnHowto").onEvents( [ MouseEvent.MOUSE_UP ], onHowtoClicked );
		
        /*Levels.current = 0;

		FlxG.mouse.hide();
        
        board = new Board();
        board.switchStateSignaler.bind( onSwitchedState );
        add( board );

        add( screen = new FlxSprite( 80, 60 ) );
        screen.visible = false;
        screen.scale.x = 2;
        screen.scale.y = 2;

        add( bottomLine = new FlxSprite( 0, FlxG.height - 32 ) );
        bottomLine.makeGraphic( FlxG.width, 32, 0xFF000000 );
        add( bottomText = new FlxText( 0, FlxG.height - 28, FlxG.width, "PRESS SPACE" ) );
        bottomText.setFormat( null, 16, 0xf0f0f0, "center" );
                
        Levels.config = Levels.levels[ 0 ];

        onSwitchedState( STATE_COUNTDOWN );*/
	}
	
	override private function reset():Void 
	{
		super.reset();
		title.stop();
		title.play();
	}

    override public function update( elapsed:Float ):Void {
		title.update( elapsed );
    }

	private function onTitleClicked( e:MouseEvent ):Void {
		Gaxe.head.switchScene( PlayScene );
	}
	
	private function onHowtoClicked( e:MouseEvent ):Void {
		Gaxe.head.switchScene( GuideScene );
	}
	
	override public function handleKey( e:KeyboardEvent ):Void {
		switch ( e.keyCode ) {
			case Keyboard.RIGHT:
				if ( e.type == KeyboardEvent.KEY_UP )
					Gaxe.head.switchScene( PlayScene );
		}
	}

}

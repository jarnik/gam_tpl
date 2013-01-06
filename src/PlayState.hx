package;

import nme.Assets;
import nme.display.DisplayObjectContainer;
import nme.geom.Rectangle;
import nme.net.SharedObject;
import org.flixel.FlxButton;
import org.flixel.FlxG;
import org.flixel.FlxPath;
import org.flixel.FlxSave;
import org.flixel.FlxSprite;
import org.flixel.FlxState;
import org.flixel.FlxText;
import org.flixel.FlxU;

import hsl.haxe.DirectSignaler;
import hsl.haxe.Signaler;

import com.eclecticdesignstudio.motion.Actuate;
import com.eclecticdesignstudio.motion.easing.Elastic;

enum PLAY_STATE {
    STATE_PLAY;
    STATE_WIN;
    STATE_FAIL;
}

class PlayState extends FlxState
{
    // signals
    //public var spellCastSignaler(default, null):Signaler<Int>;
        
    private var state:PLAY_STATE;
    private var board:Board;
    private var screen:FlxSprite;

	override public function create():Void
	{
        /*
        spellCastSignaler = new DirectSignaler(this);
		
        spellCastSignaler.bind( onSpellCast );
        spellCastSignaler.dispatch( 3 );
        */
        
        //Actuate.tween( this, 0.3, { scaleX: 1 } );

        // generator seeding
        /*
        FlxG.log("random hash "+ Generator.getRandomHash() );
        Generator.init("kokodak");
        for ( i in 0...10 )
            FlxG.log("number "+(Generator.random()*100));
        */
        
        board = new Board();
        board.switchStateSignaler.bind( onSwitchedState );
        add( board );

        add( screen = new FlxSprite( 80, 60 ) );
        screen.visible = false;
        screen.scale.x = 2;
        screen.scale.y = 2;
        
        //state = STATE_PLAY;
        //onSwitchedState( STATE_FAIL );
        onSwitchedState( STATE_PLAY );
	}

    override public function update():Void {
        switch ( state ) {
            case STATE_FAIL:
                if ( FlxG.keys.justPressed( "SPACE" ) )
                    onSwitchedState( STATE_PLAY );
            case STATE_WIN:
                if ( FlxG.keys.justPressed( "SPACE" ) )
                    onSwitchedState( STATE_PLAY );
            case STATE_PLAY:
                if ( FlxG.keys.justPressed( "UP" )  )
                    board.setFocused( board.focused-1 );
                if ( FlxG.keys.justPressed( "DOWN" )  )
                    board.setFocused( board.focused+1 );
                if ( FlxG.keys.justPressed( "LEFT" )  )
                    board.moveRow( -1 );
                if ( FlxG.keys.justPressed( "RIGHT" )  )
                    board.moveRow( 1 );

                board.updateRound();
            default:
        }

        super.update();
    }

    private function onSwitchedState( newState:PLAY_STATE ):Void {
        FlxG.keys.reset();
        state = newState;
        switch ( state ) {
            case STATE_FAIL:
                showScreen( "assets/screen_fail.png" );
            case STATE_WIN:
                showScreen( "assets/screen_win.png" );
            case STATE_PLAY:
                hideScreen();
                board.restart();
            default:
        }
    }

    private function showScreen( url:String ):Void {
        screen.loadGraphic( url );
        screen.y = 300;
        screen.visible = true;
        Actuate.tween( screen, 1, { y:60 } ).ease( Elastic.easeOut );
    }

    private function hideScreen():Void {
        Actuate.tween( screen, 0.2, { y:300 } ).ease( Elastic.easeIn );
    }
	
}

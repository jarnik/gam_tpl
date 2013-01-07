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
    STATE_COUNTDOWN;
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
    private var bottomLine:FlxSprite;
    private var bottomText:FlxText;
    private var countdown:CountDown;

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

		FlxG.mouse.hide();
        
        board = new Board();
        board.switchStateSignaler.bind( onSwitchedState );
        add( board );

        add( countdown = new CountDown() );
        countdown.countdownSignaler.bindVoid( onCountDown );

        add( screen = new FlxSprite( 80, 60 ) );
        screen.visible = false;
        screen.scale.x = 2;
        screen.scale.y = 2;

        add( bottomLine = new FlxSprite( 0, FlxG.height - 32 ) );
        bottomLine.makeGraphic( FlxG.width, 32, 0xFF000000 );
        add( bottomText = new FlxText( 0, FlxG.height - 28, FlxG.width, "PRESS THY SPACE" ) );
        bottomText.setFormat( null, 16, 0xf0f0f0, "center" );
        
        Levels.config = Levels.levels[ 0 ];

        //state = STATE_PLAY;
        //onSwitchedState( STATE_FAIL );
        //onSwitchedState( STATE_PLAY );
        onSwitchedState( STATE_COUNTDOWN );
	}

    override public function update():Void {
        switch ( state ) {
            case STATE_FAIL:
                if ( FlxG.keys.justPressed( "SPACE" ) )
                    onSwitchedState( STATE_COUNTDOWN );
            case STATE_WIN:
                if ( FlxG.keys.justPressed( "SPACE" ) )
                    onSwitchedState( STATE_COUNTDOWN );
            case STATE_COUNTDOWN:
                if ( FlxG.keys.justPressed( "UP" )  )
                    board.setFocused( board.focused-1 );
                if ( FlxG.keys.justPressed( "DOWN" )  )
                    board.setFocused( board.focused+1 );
                if ( FlxG.keys.justPressed( "LEFT" )  )
                    board.moveRow( -1 );
                if ( FlxG.keys.justPressed( "RIGHT" )  )
                    board.moveRow( 1 );
                board.updateRound( false );
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
        GAM.track("PlayState",Std.string(newState));
        //FlxG.destroySounds();
        FlxG.keys.reset();
        state = newState;
        switch ( state ) {
            case STATE_FAIL:
                FlxG.music.stop();
                FlxG.shake( 0.01, 0.3 );
                FlxG.play("assets/sfx/fail.mp3");
                FlxG.play("assets/sfx/crash.mp3");
                showScreen( "assets/screen_fail.png" );
            case STATE_WIN:
                FlxG.music.stop();
                FlxG.play("assets/sfx/win.mp3");
                showScreen( "assets/screen_win.png" );
            case STATE_PLAY:
            case STATE_COUNTDOWN:
                board.restart();
                FlxG.playMusic( "assets/music/music.mp3" );
                //FlxG.play("assets/sfx/start.mp3");
                hideScreen();
                countdown.start();
            default:
        }
    }

    private function showScreen( url:String ):Void {
        screen.loadGraphic( url );
        screen.y = 300;
        screen.visible = true;
        Actuate.tween( screen, 0.8, { y:45 } ).ease( Elastic.easeOut );
        bottomLine.visible = true;
        bottomText.visible = true;
    }

    private function hideScreen():Void {
        Actuate.tween( screen, 0.2, { y:300 } ).ease( Elastic.easeIn );
        bottomLine.visible = false;
        bottomText.visible = false;
    }
	
    private function onCountDown():Void {
        onSwitchedState( STATE_PLAY );
    }

}

package;

import nme.Assets;
import nme.display.DisplayObjectContainer;
import nme.geom.Rectangle;
import nme.net.SharedObject;
import org.flixel.FlxButton;
import org.flixel.FlxG;
import org.flixel.FlxSave;
import org.flixel.FlxSprite;
import org.flixel.FlxState;
import org.flixel.FlxText;

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

        Levels.current = 0;

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

        onSwitchedState( STATE_COUNTDOWN );
	}

    override public function update():Void {
        if ( FlxG.keys.justPressed( "R" ) )
            onSwitchedState( STATE_COUNTDOWN );
        if ( FlxG.keys.justPressed( "N" ) ) {
            nextLevel();
            return;
        }

        switch ( state ) {
            case STATE_FAIL:
                if ( FlxG.keys.justPressed( "SPACE" ) )
                    onSwitchedState( STATE_COUNTDOWN );
            case STATE_WIN:
                if ( FlxG.keys.justPressed( "SPACE" ) ) {
                    nextLevel();
                }
            case STATE_COUNTDOWN, STATE_PLAY:
            default:
        }

        super.update();
    }

    private function nextLevel():Void {
        Levels.current++;
        if ( Levels.current == Levels.levels.length ) {
            FlxG.switchState( new EndState() );
            return;
        }

        onSwitchedState( STATE_COUNTDOWN );
    }

    private function onSwitchedState( newState:PLAY_STATE ):Void {
        //GAM.track("PlayState",Std.string(newState)+" "+Std.string( Levels.current + 1 ));
        FlxG.keys.reset();
        state = newState;
        switch ( state ) {
            case STATE_FAIL:
                FlxG.music.stop();
                FlxG.shake( 0.01, 0.3 );
                //showScreen( "assets/screen_fail.png" );
            case STATE_WIN:
                FlxG.music.stop();
                //showScreen( "assets/screen_win.png" );
            case STATE_PLAY:
            case STATE_COUNTDOWN:
                Levels.config = Levels.levels[ Levels.current ];
                board.restart();
                //FlxG.playMusic( "assets/music/music.mp3" );

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

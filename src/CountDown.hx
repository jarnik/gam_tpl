package;

import nme.Lib;
import org.flixel.FlxGame;
import org.flixel.FlxG;
import org.flixel.FlxSprite;

import hsl.haxe.DirectSignaler;
import hsl.haxe.Signaler;

class CountDown extends FlxSprite
{	
    // signals
    public var countdownSignaler(default, null):Signaler<Void>;
 
    private var parent:Tile;
    private var countdown:Float;

	public function new():Void {
        super( 0, 0 );

        countdownSignaler = new DirectSignaler(this);

        loadGraphic("assets/countdown.png", true,false, 64, 32);
        x = (FlxG.width - width)/2;
        y = (FlxG.height - height)/2;
        countdown = -1;
        visible = false;
	}

    override public function update():Void {
        super.update();
        if ( countdown >= 0 ) {
            countdown += FlxG.elapsed;
            var frame:UInt = Math.floor( countdown / 0.4 );
            if ( cast( frame, Int ) >= frames ) {
                countdown = -1;
                visible = false;
                countdownSignaler.dispatch();
                return;
            }
            if ( frame != this.frame )
                this.frame = frame;
        }
    }

    public function start():Void {
        // TODO
        countdown = 0;
        visible = true;
    }
    
}

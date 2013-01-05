package;

import nme.Lib;
import org.flixel.FlxGame;
import org.flixel.FlxG;
import org.flixel.FlxSprite;

class Crash extends FlxSprite
{	
  
    private var parent:Tile;

	public function new( x:Float, y:Float ):Void {
        super( 0, 0 );
        loadGraphic( "assets/crash.png", true );
        offset.x = 16;
        offset.y = 16;

        this.x = x;
        this.y = y;

        addAnimation("crash",[0,1,2,3,4],8);
        play("crash");
	}

    override public function update():Void {
        super.update();
        if ( finished )
            kill();
    }

}

package;

import nme.Lib;
import org.flixel.FlxGame;
import org.flixel.FlxG;
import org.flixel.FlxSprite;

class Cow extends Movable
{	

	public function new( facing:Int ):Void {
        super( 0, 0 );
        loadGraphic( "assets/cow.png",true, true );
        offset.x = 8;
        offset.y = 8;
        addAnimation( "run", [0,1], 8 );
        play("run");
        this.facing = facing;
	}

}

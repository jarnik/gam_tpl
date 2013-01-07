package;

import nme.Lib;
import org.flixel.FlxGame;
import org.flixel.FlxG;
import org.flixel.FlxSprite;

class Block extends Movable
{	

	public function new():Void {
        super( 0, 0 );
        loadGraphic( "assets/mountain.png",true );
        offset.x = 16;
        offset.y = 16;
        speed = 0;
	}

}

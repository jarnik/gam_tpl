package;

import nme.Lib;
import org.flixel.FlxGame;
import org.flixel.FlxG;
import org.flixel.FlxSprite;

class Cow extends Movable
{	

	public function new( x:Float, y:Float ):Void {
        super( 0, 0 );
        loadGraphic( "assets/castle.png" );
        offset.x = 16;
        offset.y = 16;

        this.x = x;
        this.y = y;
	}
}

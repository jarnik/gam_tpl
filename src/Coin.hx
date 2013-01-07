package;

import nme.Lib;
import org.flixel.FlxGame;
import org.flixel.FlxG;
import org.flixel.FlxSprite;

class Coin extends Movable 
{	
  
    private var parent:Tile;

	public function new( parent:Tile ):Void {
        this.parent = parent;
        super( 0, 0, "assets/coin.png" );
        offset.x = 8;
        offset.y = 12;
        speed = 0;
	}

    public function pickup():Void {
        FlxG.play("assets/sfx/coin.mp3");
        kill();
    }

}

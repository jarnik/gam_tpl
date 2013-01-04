package;

import nme.Lib;
import org.flixel.FlxGame;
import org.flixel.FlxG;
import org.flixel.FlxSprite;

class Coin extends FlxSprite
{	
  
    private var parent:Tile;

	public function new( parent:Tile ):Void {
        this.parent = parent;
        super( 0, 0, "assets/coin.png" );
        offset.x = 8;
        offset.y = 12;
        copyParent();
	}

    override public function update():Void {
        super.update();
        copyParent();
    }

    private function copyParent():Void {
        x = parent.x;
        y = parent.y;
    }

    public function pickup():Void {
        kill();
    }

}

package;

import nme.Lib;
import org.flixel.FlxGame;
import org.flixel.FlxG;
import org.flixel.FlxSprite;

class Castle extends FlxSprite
{	
  
    public var parent:Tile;
    public var isOpen:Bool;

	public function new( parent:Tile ):Void {
        this.parent = parent;
        super( 0, 0 );
        loadGraphic("assets/tile_castle.png", true );
        offset.x = 16;
        offset.y = 16;
        frame = 0;
        isOpen = false;
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

    public function open( makeSound:Bool = true ):Void {
        if ( makeSound )
            FlxG.play("assets/sfx/door.mp3");
        frame = 1;
        isOpen = true;
    }

}

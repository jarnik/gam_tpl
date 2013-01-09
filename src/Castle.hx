package;

import nme.Lib;
import org.flixel.FlxGame;
import org.flixel.FlxG;
import org.flixel.FlxSprite;
import addons.NestedSprite;

class Castle extends NestedSprite
{	
  
    public var parent:Tile;
    public var isOpen:Bool;
    private var door:NestedSprite;

	public function new( parent:Tile, skin:String ):Void {
        this.parent = parent;
        super( 0, 0 );
        loadGraphic("assets/"+skin, true );
        offset.x = 16;
        offset.y = 16;
        frame = 0;
        isOpen = false;
        copyParent();

        door = new NestedSprite( 0, 0, "assets/tile_door_open.png" );
        if ( isOpen )
            add( door );
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
        add( door );
    }

}

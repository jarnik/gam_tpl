package;

import nme.Lib;
import org.flixel.FlxGame;
import org.flixel.FlxG;
import org.flixel.FlxSprite;
import org.flixel.FlxObject;

import Tile;

class Hen extends Movable
{	

	public function new( facing:Int ):Void {
        super( 0, 0 );
        loadGraphic( "assets/hen.png",true, true );
        offset.x = 8;
        offset.y = 8;
        addAnimation( "run", [0,1], 8 );
        play("run");
        this.facing = facing;
	}

    override private function setOrientation( a:Float ):Void {
        if ( t < 0.5 ) {
            facing = ( entry == RIGHT ? FlxObject.LEFT : FlxObject.RIGHT );
        } else {
            facing = ( exit == RIGHT ? FlxObject.RIGHT : FlxObject.LEFT );
        }
    }

    override private function getNewExit( b:Board, newTile:Tile, entry:WAY ):WAY {
        if ( Player.instance.x > newTile.x ) {
            return RIGHT;
        } else {
            return LEFT;
        }
    }

}

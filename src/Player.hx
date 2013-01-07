package;

import nme.Lib;
import org.flixel.FlxGame;
import org.flixel.FlxG;
import org.flixel.FlxSprite;

import hsl.haxe.DirectSignaler;
import hsl.haxe.Signaler;

import Tile; 
	
class Player extends Movable 
{	
    public var winSignaler(default, null):Signaler<Void>;
    public static var instance:Player;

	public function new():Void {
        super( 0, 0, "assets/player.png" );
        winSignaler = new DirectSignaler(this);
        offset.x = Board.TILE_SIZE/2;
        offset.y = Board.TILE_SIZE/2;
        instance = this;
	}

    override public function getNewExit( b:Board, newTile:Tile, entry:WAY ):WAY {
        var newExit:WAY = NOWAY;
        if ( newTile == b.castle.parent ) {
            if ( entry == BOTTOM && b.castle.isOpen ) {
                winSignaler.dispatch();
                return NOWAY;
            } else {
                crashSignaler.dispatch();
                return NOWAY;
            }
        }

        if  ( !newTile.hasWay( entry ) ) {
            crashSignaler.dispatch();
            return NOWAY;
        }

        var openWays:Array<WAY> = [];
        for ( w in newTile.wayConfig ) {
            if ( w == entry )
                continue;
            openWays.push( w );
        }
        if ( openWays.length == 0 ) {
            newExit = NOWAY;
        } else
            newExit = openWays[ Math.floor( Math.random() * openWays.length ) ];
        return newExit;
    }

    override private function setOrientation( a:Float ):Void {
        this.angle = a/Math.PI*180;
    }
}

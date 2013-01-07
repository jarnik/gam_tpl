package;

import nme.Lib;
import org.flixel.FlxGame;
import org.flixel.FlxG;
import org.flixel.FlxSprite;
import org.flixel.FlxObject;

import hsl.haxe.DirectSignaler;
import hsl.haxe.Signaler;

import Tile; 

class Movable extends FlxSprite
{	
    // signals
    public var crashSignaler(default, null):Signaler<Void>;

    public var currentTile:Tile;
    public var entry:WAY;
    public var exit:WAY;
    public var t:Float;

    public var speed:Float;

	public function new( x:Float = 0, y:Float = 0, Graphic:Dynamic = null ):Void {
        super( x, y, Graphic );
        crashSignaler = new DirectSignaler(this);
        speed = 0.8;
        t = -1;
        entry = BOTTOM;
        exit = TOP;
	}

    private function updatePosition():Void {
        var angle:Float = 0;
        var d:Float = 0;
        var tileSize:Float = Board.TILE_SIZE;
        var faceAngle:Float = 0;

        d = tileSize * Math.abs( t - 0.5 );
        if ( t < 0.5 ) {
            angle = Tile.getWayAngle( entry );
            faceAngle = angle + Math.PI;
        } else if ( t < 1 ) {
            if ( exit == NOWAY ) {
                t = -1;
                crashSignaler.dispatch();
            }
            angle = Tile.getWayAngle( exit );
            faceAngle = angle;
        } else
            return;

        if ( currentTile != null ) {
            setOrientation( faceAngle );
            x = currentTile.x + Math.sin( angle ) * d;
            y = currentTile.y - Math.cos( angle ) * d;
        }
    }

    private function setOrientation( a:Float ):Void {
    }

    public function enterNewTile( tile:Tile, entry:WAY, exit:WAY ):Void {
        currentTile = tile;
        this.entry = entry;
        this.exit = exit;
        t = 0;
        if ( speed == 0 )
            t = 0.5;
    }

    public function updateRound( enableMovement:Bool = false ):Void {
        if ( !visible )
            return;

        if ( t >= 0 ) {
            if ( enableMovement )
                t += FlxG.elapsed * speed;
            updatePosition();
        }
    }

    public function pendingSwap():Bool {
        return t > 1;
    }

    public function findNextStep( b:Board ):Void {
        var newTile:Tile;
        var newTileAngle:Float = Tile.getWayAngle( exit );
        var dx:Int = Math.round( Math.sin( newTileAngle ) );
        var dy:Int = Math.round( -Math.cos( newTileAngle ) );
        if ( currentTile == null ) {
            dx = Math.floor(Board.COLUMNS / 2); 
            dy = Board.ROWS-1; 
        } else {
            dx += currentTile.gx; 
            dy += currentTile.gy; 
            dx = (dx + Board.COLUMNS) % Board.COLUMNS;
            dy = (dy + Board.ROWS) % Board.ROWS;
        }

        newTile = b.getTile( dx, dy );
        if ( newTile == null ) {
            crashSignaler.dispatch();
            return;
        }

        entry = Tile.invertWay( exit );
        exit = getNewExit( b, newTile, entry );

        enterNewTile( newTile, entry, exit );
    }

    private function getNewExit( b:Board, newTile:Tile, entry:WAY ):WAY {
        return Tile.invertWay( entry );
    }


}

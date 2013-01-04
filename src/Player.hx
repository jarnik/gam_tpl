package;

import nme.Lib;
import org.flixel.FlxGame;
import org.flixel.FlxG;
import org.flixel.FlxSprite;

import Tile; 
	
class Player extends FlxSprite
{	
  
    public var currentTile:Tile;
    //public var nextTile:Tile;
    public var entry:WAY;
    public var exit:WAY;
    public var t:Float;

    public var speed:Float;

	public function new():Void {
        super( 0, 0, "assets/player.png" );
        speed = 0.4;
        t = -1;
        entry = BOTTOM;
        exit = TOP;
        offset.x = Board.TILE_SIZE/2;
        offset.y = Board.TILE_SIZE/2;
	}

    override public function update():Void {
        super.update();
        
        if ( t >= 0 ) {
            t += FlxG.elapsed * speed;
            //FlxG.log("t "+t+" curr "+currentTile);
            updatePosition();
        }
    }

    private function updatePosition():Void {
        var angle:Float = 0;
        var d:Float = 0;
        var tileSize:Float = Board.TILE_SIZE;

        d = tileSize * Math.abs( t - 0.5 );
        if ( t < 0.5 ) {
            angle = Tile.getWayAngle( entry );
        } else if ( t < 1 ) {
            angle = Tile.getWayAngle( exit );
        } else
            return;

        if ( currentTile != null ) {
            //FlxG.log(" entry "+entry+" exit "+exit+" t "+t+" d "+d+" angle "+angle);
            x = currentTile.x + Math.sin( angle ) * d;
            y = currentTile.y - Math.cos( angle ) * d;
            //this.angle = angle + Math.PI;
        }
    }

    public function pendingSwap():Bool {
        return t > 1;
    }

    public function enterNewTile( tile:Tile, entry:WAY, exit:WAY ):Void {
        /*
        if ( currentTile != null ) {
            entry = Tile.getEntryWay( currentTile, tile );
        }*/
        currentTile = tile;
        this.entry = entry;
        this.exit = exit;
        //this.nextTile = next;
        //exit = Tile.getExitWay( tile, next );
        t = 0;
    }


}

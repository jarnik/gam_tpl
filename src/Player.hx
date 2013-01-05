package;

import nme.Lib;
import org.flixel.FlxGame;
import org.flixel.FlxG;
import org.flixel.FlxSprite;

import hsl.haxe.DirectSignaler;
import hsl.haxe.Signaler;

import Tile; 
	
class Player extends FlxSprite
{	
    // signals
    public var crashSignaler(default, null):Signaler<Void>;
  
    public var currentTile:Tile;
    //public var nextTile:Tile;
    public var entry:WAY;
    public var exit:WAY;
    public var t:Float;

    public var speed:Float;

	public function new():Void {
        super( 0, 0, "assets/player.png" );
        crashSignaler = new DirectSignaler(this);
        speed = 0.8;
        t = -1;
        entry = BOTTOM;
        exit = TOP;
        offset.x = Board.TILE_SIZE/2;
        offset.y = Board.TILE_SIZE/2;
	}

    override public function update():Void {
        super.update();
        
        if ( !visible )
            return;

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
            //FlxG.log(" entry "+entry+" exit "+exit+" t "+t+" d "+d+" angle "+angle);
            x = currentTile.x + Math.sin( angle ) * d;
            y = currentTile.y - Math.cos( angle ) * d;
            this.angle = faceAngle/Math.PI*180;
        }
    }

    public function pendingSwap():Bool {
        return t > 1;
    }

    public function enterNewTile( tile:Tile, entry:WAY, exit:WAY ):Void {
        currentTile = tile;
        this.entry = entry;
        this.exit = exit;
        t = 0;
    }


}

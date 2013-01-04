package;

import nme.Lib;
import org.flixel.FlxGame;
import org.flixel.FlxG;
	
class Player extends FlxSprite
{	
  
    public var currentTile:Tile;
    public var nextTile:Tile;
    public var entry:WAY;
    public var exit:WAY;
    public var t:Float;

    public var speed:Float;

	public function new():Void {
        super( 0, 0, "assets/player.png" );
        speed = 10;
        t = -1;
        entry = BOTTOM;
        exit = TOP;
	}

    override public function update():Void {
        super.update();
        
        if ( t >= 0 ) {
            t += FlxG.elapsed * speed;
            updatePosition();
        }
    }

    private function updatePosition():Void {
        var angle:Float = 0;
        var d:Float = 0;
        var tileSize:Float = 32;

        if ( t < 0.5 ) {
            angle = Tile.getWayAngle( entry );
            d = tileSize*0.5 * (1 - t);
        } else if ( t < 1 ) {
            angle = Tile.getWayAngle( exit );
            d = tileSize*0.5 * (t - 0.5);
        } else
            return;

        x = currentTile.x + Math.sin( angle ) * d;
        y = currentTile.y - Math.cos( angle ) * d;
        this.angle = angle + Math.PI;
    }

    public function pendingSwap():Bool {
        return t > 1;
    }

    public function enterNewTile( tile:Tile, next:Tile ):Void {
        if ( currentTile != null ) {
            entry = Tile.getEntryWay( currentTile, tile );
            currentTile = t;
        }
        this.nextTile = next;
        exit = Tile.getExitWay( tile, next );
        t = 0;
    }


}

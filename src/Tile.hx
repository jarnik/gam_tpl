package;

import nme.Lib;
import org.flixel.FlxGame;
import org.flixel.FlxG;
import org.flixel.FlxSprite;
	
enum WAY {
    TOP;
    RIGHT;
    BOTTOM;
    LEFT;
}

typedef WAY_CONFIG = {
    top: Bool,
    right: Bool,
    bottom: Bool,
    left: Bool
}

class Tile extends FlxSprite, implements IGrid
{	
  
    public var gx:Int;
    public var gy:Int;
    public var wayConfig:Array<WAY>;

    private var ways:Array<FlxSprite>;
    private var center:FlxSprite;

	public function new():Void {
        super( 0, 0, "assets/tile_grass.png" );
        offset.x = 16;
        offset.y = 16;

        wayConfig = [];
	}

    public function updateWays():Void {
        ways = [];
        var w:FlxSprite;
        for ( i in 0...wayConfig.length ) {
            w = new FlxSprite( x, y );
            w.loadRotatedGraphic( "assets/tile_B.png", 4 );
            w.offset = offset;
            ways.push( w );
            w.angle = getWayAngle( wayConfig[ i ] ) / Math.PI * 180 + 180;
            w.preUpdate();
            w.update();
            w.postUpdate();
        }

        if ( hasWay( TOP ) && hasWay( RIGHT ) )
            addCentralPiece( true, -90 );
        if ( hasWay( RIGHT ) && hasWay( BOTTOM ) )
            addCentralPiece( true, 0 );
        if ( hasWay( BOTTOM ) && hasWay( LEFT ) )
            addCentralPiece( true, 90 );
        if ( hasWay( LEFT ) && hasWay( TOP ) )
            addCentralPiece( true, 180 );
        if ( hasWay( TOP ) && hasWay( BOTTOM ) )
            addCentralPiece( false, 0 );
        if ( hasWay( LEFT ) && hasWay( RIGHT ) )
            addCentralPiece( false, 90 );
    }

    private function hasWay( w:WAY ):Bool {
        for ( way in wayConfig )
            if ( way == w )
                return true;
        return false;
    }

    private function addCentralPiece( isCurve:Bool, a:Float ):Void {
        var w:FlxSprite;
        w = new FlxSprite( x, y );
        w.loadRotatedGraphic( "assets/tile_"+(isCurve ? "curve_BR":"straight_TB" )+".png", 4 );
        w.offset = offset;
        w.angle = a;
        w.preUpdate();
        w.update();
        w.postUpdate();
        ways.push( w );
    }

    override public function update():Void {
        for ( w in ways ) {
            w.x = x;
            w.y = y;
        }
        super.update();
    }

    override public function draw():Void {
        super.draw();
        for ( w in ways ) {
            w.draw();
        }

    }

    public static function getEntryWay( a:Tile, b:Tile ):WAY {
        if ( a.gx < b.gx )
            return LEFT;
        else if ( a.gx > b.gx )
            return RIGHT;
        else if ( a.gy > b.gy )
            return BOTTOM;
        else if ( a.gy < b.gy )
            return TOP;
        return BOTTOM;
    }

    public static function getExitWay( a:Tile, b:Tile ):WAY {
        if ( a.gx < b.gx )
            return RIGHT;
        else if ( a.gx > b.gx )
            return LEFT;
        else if ( a.gy > b.gy )
            return TOP;
        else if ( a.gy < b.gy )
            return BOTTOM;
        return BOTTOM;
    }

    public static function invertWay( w:WAY ):WAY {
        switch ( w ) {
            case TOP: return BOTTOM;
            case BOTTOM: return TOP;
            case RIGHT: return LEFT;
            case LEFT: return RIGHT;
        }
        return TOP;
    }

    public static function getWayAngle( w:WAY ):Float {
        switch ( w ) {
            case TOP: return 0;
            case BOTTOM: return Math.PI;
            case RIGHT: return Math.PI/2;
            case LEFT: return Math.PI/2*3;
        }
        return 0;
    }

}

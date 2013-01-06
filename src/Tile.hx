package;

import nme.Lib;
import org.flixel.FlxGame;
import org.flixel.FlxG;
import org.flixel.FlxSprite;
import org.flixel.FlxPoint;
import addons.NestedSprite;

import com.eclecticdesignstudio.motion.Actuate;    
import com.eclecticdesignstudio.motion.easing.Linear;

enum WAY {
    TOP;
    RIGHT;
    BOTTOM;
    LEFT;
    NOWAY;
}

typedef WAY_CONFIG = {
    top: Bool,
    right: Bool,
    bottom: Bool,
    left: Bool
}

class Tile extends NestedSprite, implements IGrid
{	
  
    public var gx:Int;
    public var gy:Int;
    public var wayConfig:Array<WAY>;

    private var tileFrame:NestedSprite;

	public function new():Void {
        super( 0, 0, "assets/tile_grass.png" );
        offset.x = 16;
        offset.y = 16;

        wayConfig = [];
	}

    public function updateWays():Void {
        var w:NestedSprite;
        for ( i in 0...wayConfig.length ) {
            w = new NestedSprite( x, y );
            w.loadRotatedGraphic( "assets/tile_B.png", 4 );
            w.relativeAngle = getWayAngle( wayConfig[ i ] ) / Math.PI * 180 + 180;
            w.preUpdate();
            w.update();
            w.postUpdate();
            add( w );
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

        tileFrame = new NestedSprite( 0, 0, "assets/tile_frame.png" );
        tileFrame.alpha = 0.5;
        add( tileFrame );
        move( gx, gy );
    }

    public function hasWay( w:WAY ):Bool {
        for ( way in wayConfig )
            if ( way == w )
                return true;
        return false;
    }

    private function addCentralPiece( isCurve:Bool, a:Float ):Void {
        var w:NestedSprite;
        w = new NestedSprite( x, y );
        w.loadRotatedGraphic( "assets/tile_"+(isCurve ? "curve_BR":"straight_TB" )+".png", 4 );
        w.relativeAngle = a;
        w.preUpdate();
        w.update();
        w.postUpdate();
        add( w );
    }

    public function addWay( w:WAY ):Void {
        wayConfig.remove( w );
        wayConfig.push( w );
    }

    public function removeWay( w:WAY ):Void {
        wayConfig.remove( w );
    }

    public function move( x:Int, y:Int, tween:Bool = false ):Void {
        gx = x;
        gy = y;
        var tx:Float = Board.TILE_SIZE/2 + x*Board.TILE_SIZE + Board.OFFSET_X;
        var ty:Float = Board.TILE_SIZE/2 + y*Board.TILE_SIZE + Board.OFFSET_Y;
        if ( tween ) {
            Actuate.stop( this );
            Actuate.tween( this, 0.05, { x: tx, y: ty } ).ease( Linear.easeNone );
        } else {
            this.x = tx;
            this.y = ty;
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
            default: return NOWAY;
        }
        return TOP;
    }

    public static function getWayAngle( w:WAY ):Float {
        switch ( w ) {
            case TOP: return 0;
            case BOTTOM: return Math.PI;
            case RIGHT: return Math.PI/2;
            case LEFT: return Math.PI/2*3;
            default: return 0;
        }
        return 0;
    }

}

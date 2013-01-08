package;

import nme.Lib;
import org.flixel.FlxGame;
import org.flixel.FlxG;
import org.flixel.FlxGroup;
import org.flixel.FlxSprite;
import org.flixel.FlxObject;
import org.flixel.FlxEmitter;
import org.flixel.tweens.motion.LinearMotion;
import org.flixel.tweens.util.Ease;
import org.flixel.tweens.FlxTween;

import hsl.haxe.DirectSignaler;
import hsl.haxe.Signaler;

import com.eclecticdesignstudio.motion.Actuate;
import com.eclecticdesignstudio.motion.easing.Linear;

import Tile;
import PlayState;
	
class Board extends FlxGroup
{	
    // signals
    public var crashSignaler(default, null):Signaler<Void>;
    public var switchStateSignaler(default, null):Signaler<PLAY_STATE>;

    public static var OFFSET_X:Float;
    public static var OFFSET_Y:Float;

    public static inline var ROWS:Int = 7;
    public static inline var COLUMNS:Int = 7;
    public static inline var TILE_SIZE:Float = 32;

    public var player:Player;
    public var crashSprite:Crash;
    public var tileLayer:FlxGroup;
    public var movableLayer:FlxGroup;
    public var map:Array<Array<Tile>>;
    private var coinsRemaining:Int;
    public var castle:Castle;
    private var movables:Array<Movable>;

    private var focus:FlxSprite;
    public var focused:Int;
    public var focusLocked:Bool;

    private var dirt:FlxEmitter;

	public function new():Void {
        super();

        OFFSET_X = (FlxG.width - TILE_SIZE*COLUMNS) / 2;
        OFFSET_Y = (FlxG.height - TILE_SIZE*ROWS) / 2;

        add( tileLayer = new FlxGroup() );
        add( movableLayer = new FlxGroup() );

        add( focus = new FlxSprite() );
        focus.makeGraphic( COLUMNS*TILE_SIZE, TILE_SIZE, 0x80800080 );
        focused = 4;
        focusLocked = false;

        add( player = new Player() );
        add( dirt = new FlxEmitter() );
        dirt.makeParticles( "assets/dirt.png", 20, 0, true, 0 );
        dirt.setXSpeed( -8, 8 );
        dirt.setYSpeed( -8, 8 );
        dirt.setRotation( 0, 0 );

        switchStateSignaler = new DirectSignaler(this);

        crashSignaler = new DirectSignaler(this);
        crashSignaler.bindVoid( crash );
        player.crashSignaler.bindVoid( crash );
        player.winSignaler.bindVoid( win );

        updateFocus();
	}

    public function restart():Void {
        player.visible = true;
        player.speed = Levels.config.speed;

        dirt.start( false, 1.6, 0.2 );

        while ( tileLayer.length > 0 )
            tileLayer.remove( tileLayer.members[ 0 ], true );
        while ( movableLayer.length > 0 )
            movableLayer.remove( movableLayer.members[ 0 ], true );

        map = [];
        build();
        
        player.currentTile = null;
        player.exit = TOP;
        player.findNextStep( this );

        updateRound();
    }

    public function build():Void {
        var t:Tile;
        var row:Array<Tile>;
        var emptyTiles:Array<Tile> = [];
        for ( y in 0...ROWS ) {
            row = [];
            for ( x in 0...COLUMNS ) {
                t = new Tile( Levels.config.tile );
                t.wayConfig = [ TOP, BOTTOM ];
                addTile( x, y, t );
                row.push( t );
                emptyTiles.push( t );
            }
            map.push( row );
        }

        var w:WAY;
        for ( y in 0...ROWS ) {
            for ( x in 0...COLUMNS ) {
                t = getTile( x, y );
                if ( Math.random() < Levels.config.swapP ) {
                    if ( Math.random() > Levels.config.crossP )
                        t.removeWay( TOP );
                    w = Math.random() > 0.5 ? LEFT: RIGHT;
                    t.addWay( w );
                    emptyTiles.remove( t );
                    t = getTile( t.gx + ( w == LEFT ? -1 : 1 ), t.gy );
                    emptyTiles.remove( t );
                    if ( t != null ) {
                        if ( Math.random() > Levels.config.crossP )
                            t.removeWay( BOTTOM );
                        t.addWay( Tile.invertWay( w ) );
                    }                    
                }
            }
        }

        var startTile:Tile = getTile( Math.floor( COLUMNS / 2 ), ROWS-1 );
        startTile.addWay( BOTTOM );        
        startTile.addWay( TOP );        
        emptyTiles.remove( startTile ); 

        var endTile:Tile = getTile( Math.floor( COLUMNS / 2 ), 0 );
        castle = new Castle( endTile );
        movableLayer.add( castle );
        emptyTiles.remove( endTile ); 
        endTile.addWay( BOTTOM );

        movables = [];
        movables.push( player );

        var coinCount:Int = Levels.config.coins;
        coinsRemaining = coinCount;
        var c:Coin;
        var randIndex:Int;
        var goRight:Bool;
        for ( i in 0...coinCount ) {
            randIndex = Math.floor( Math.random()*emptyTiles.length );
            goRight = (Math.random() > 0.5);
            c = new Coin( emptyTiles[ randIndex ], Levels.config.coinSpeed );
            c.enterNewTile( emptyTiles[ randIndex ], goRight ? LEFT : RIGHT, goRight ? RIGHT : LEFT );
            movableLayer.add( c );
            movables.push( c );
            emptyTiles.remove( emptyTiles[ randIndex ] );
        }
        if ( coinCount == 0 )
            castle.open( false );

        var cowCount:Int = Levels.config.cows;
        var cow:Cow;
        for ( i in 0...cowCount ) {
            randIndex = Math.floor( Math.random()*emptyTiles.length );
            goRight = (Math.random() > 0.5);
            cow = new Cow( goRight ? FlxObject.RIGHT : FlxObject.LEFT );
            movableLayer.add( cow );
            cow.enterNewTile( emptyTiles[ randIndex ], goRight ? LEFT : RIGHT, goRight ? RIGHT : LEFT );
            emptyTiles.remove( emptyTiles[ randIndex ] );
            movables.push( cow );
        }

        var henCount:Int = Levels.config.hens;
        var hen:Hen;
        for ( i in 0...henCount ) {
            randIndex = Math.floor( Math.random()*emptyTiles.length );
            goRight = (Math.random() > 0.5);
            hen = new Hen( goRight ? FlxObject.RIGHT : FlxObject.LEFT );
            movableLayer.add( hen );
            hen.enterNewTile( emptyTiles[ randIndex ], goRight ? LEFT : RIGHT, goRight ? RIGHT : LEFT );
            emptyTiles.remove( emptyTiles[ randIndex ] );
            movables.push( hen );
        }

        var blockCount:Int = Levels.config.blocks;
        var block:Block;
        for ( i in 0...blockCount ) {
            randIndex = Math.floor( Math.random()*emptyTiles.length );
            block = new Block();
            movableLayer.add( block );
            block.enterNewTile( emptyTiles[ randIndex ], RIGHT, LEFT );
            emptyTiles.remove( emptyTiles[ randIndex ] );
            movables.push( block );
        }

        for ( y in 0...ROWS )
            for ( x in 0...COLUMNS ) 
                getTile( x,y ).updateWays();

    }

    private function addTile( x:Int, y:Int, t:Tile ):Void {
        tileLayer.add( t );
        t.move( x, y );
    }

    public function getTile( x:Int, y:Int ):Tile {
        if ( x < 0 || x >= COLUMNS || y < 0 || y >= ROWS )
            return null;
        return map[y][x];
    }

    public function updateRound( enableMovement:Bool = true ):Void {
        for ( m in movables ) {  
            m.updateRound( enableMovement );
            if ( enableMovement && m.pendingSwap() ) {
                m.findNextStep( this );
            }
        }

        dirt.x = player.x + Math.sin( player.angle / 180 * Math.PI + Math.PI )*16;
        dirt.y = player.y - Math.cos( player.angle / 180 * Math.PI + Math.PI )*16;
        dirt.setSize( 2, 2 ); 

        if ( !enableMovement )
            return;
        var d:Float = 0;
        for ( m in movables ) {
            if ( m == player || !m.alive )
                continue;
            d = Math.sqrt( Math.pow( m.x-player.x, 2 ) + Math.pow( m.y-player.y, 2 ) );
            switch ( Type.getClass( m )) {
                case Coin:
                    if ( d < 10 ) {
                        cast(m,Coin).pickup();
                        coinsRemaining--;
                    }
                case Cow, Hen:
                    if ( d < 5 ) {
                        crashSignaler.dispatch();
                        return;
                    }
                case Block:
                    if ( d < 8 ) {
                        crashSignaler.dispatch();
                        return;
                    }
                default:
            }
        }

        if ( !castle.isOpen && coinsRemaining == 0 )
            castle.open();          
    }

    public function setFocused( index:Int ):Void {
        focused = (index + ROWS) % ROWS;
        updateFocus();
    }

    public function moveRow( step:Int ):Void {
        if ( focusLocked )
            return;

        var row:Array<Tile> = map[ focused ];
        var t:Tile;
        
        if ( step == 1 ) {
            t = row.pop();
            row.unshift( t );
        } else {
            t = row.shift();
            row.push( t );
        }
        for ( i in 0...row.length ) {
            row[ i ].move( i, focused, true );
        }
    }
    
    private function updateFocus():Void {
        focusLocked = true;
        focus.x = OFFSET_X;
        Actuate.stop( focus );
        Actuate.tween( focus, 0.05, { y: TILE_SIZE*focused + OFFSET_Y } ).ease( Linear.easeNone ).onComplete( unlockFocus );
    }

    private function unlockFocus():Void {
        focusLocked = false;
    }

    private function crash():Void {
        player.visible = false;
        if ( crashSprite != null )
            remove( crashSprite );
        add( crashSprite = new Crash( player.x, player.y ) );
        switchStateSignaler.dispatch( STATE_FAIL );
        dirt.kill();
        FlxG.log("crash");
    }

    private function win():Void {
        player.visible = false;
        dirt.kill();
        switchStateSignaler.dispatch( STATE_WIN );
        FlxG.log("win");
    }

}

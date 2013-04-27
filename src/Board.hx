package ;
import nme.display.Sprite;
import nme.geom.Point;
import pug.render.Render;
import pug.render.RenderGroup;
import gaxe.Debug;
import Creature;

typedef RACE_CONF = {
	size:CREATURE_TYPE,
	count:Int
}

/**
 * ...
 * @author Jarnik
 */
class Board extends Sprite
{
	public static inline var W:Float = 640;
	public static inline var H:Float = 240;
	
	private var player:Player;
	private var creatures:Array<Creature>;
	private var pendingSpawns:Array<Creature>;
	private var pools:Array<Pool>;
	private var pheromones:Hash<Array<Pheromone>>;
	private var map:RenderGroup;
	
	private var creatureLayer:Sprite;
	private var groundLayer:Sprite;
	private var pheromoneLayer:Sprite;
	
	public function new() {
		super();
		
		addChild( map = cast( Render.renderSymbol( GAM.lib.get("playscreen") ), RenderGroup ) );
		map.render( 0 );		
		
		addChild( groundLayer = new Sprite() );
		addChild( pheromoneLayer = new Sprite() );
		addChild( creatureLayer = new Sprite() );
		
		creatures = [];
		pheromones = new Hash<Array<Pheromone>>();
		pheromones.set( Std.string( Type.enumIndex( SMALL ) ), [] );
		pheromones.set( Std.string( Type.enumIndex( MEDIUM ) ), [] );
		pheromones.set( Std.string( Type.enumIndex( LARGE ) ), [] );
		
		var p:Pool;
		pools = [];
		addPool( SMALL, "Q" );
		addPool( MEDIUM, "P" );
		addPool( LARGE, "V" );
		//groundLayer.addChild( p = new Pool( SMALL, 8, 8 ) );
		//pools.push( p );
		
		creatureLayer.addChild( player = new Player( 50, 0 ) );
		creatures.push( player );
		
		distributeCreatures();
		
		/*
		spawnCreature( LARGE, 400, 100 );		
		spawnCreature( LARGE, 40, 100 );		
		spawnCreature( MEDIUM, 280, 20 );		
		spawnCreature( MEDIUM, 280, 120 );		
		spawnCreature( SMALL, 80, 120 );		
		spawnCreature( SMALL, 280, 120 );
		*/		
	}
	
	private function distributeCreatures():Void {
		var gridW:Float = 600;
		var gridH:Float = 160;
		var gridX:Float = (Board.W - gridW) / 2;
		var gridY:Float = (Board.H - gridH) / 2;
		var cols:Int = 10;
		var rows:Int = 3;
		
		var empty:Array<Point> = [];
		for ( x in 0...cols )
			for ( y in 0...rows )
				empty.push( new Point( gridX + gridW / (cols - 1) * x, gridY + gridH / (rows - 1) * y ) );
		
		var conf:Array<RACE_CONF> = [
			{ size:SMALL, count: 3 }, 
			{ size:MEDIUM, count: 3 }, 
			{ size:LARGE, count: 3 }
		];
		
		var r:Int;
		for ( c in conf ) {
			for ( i in 0...c.count ) {
				r = Math.floor( Math.random() * empty.length );
				spawnCreature( c.size, empty[ r ].x, empty[ r ].y );
				empty.remove( empty[ r ] );
			}
		}
	}
	
	private function spawnCreature( type:CREATURE_TYPE, x:Float, y:Float ):Creature {
		var c:CreatureAI = new CreatureAI( type, x, y );
		addCreature( c );		
		c.setFull( true );
		return c;
	}
	
	private function addPool( type:CREATURE_TYPE, template:String ):Void {
		var r:Render = map.fetch( template );
		var p:Pool = new Pool( type, r.x, r.y );
		groundLayer.addChild( p );
		pools.push( p );
	}
	
	private function sortByY( c1:Creature, c2:Creature ):Int {
		if ( c1.y == c2.y )
			return 0;
		if ( c1.y < c2.y )
			return -1;
		else
			return 1;
	}
	
	public function sortCreatures():Void {
		creatures.sort( sortByY );
		for ( i in 0...creatures.length )
			creatureLayer.setChildIndex( creatures[ i ], i );
	}
	
	public function update( timeElapsed:Float ):Void {
		for ( c in creatures ) {
			c.update( timeElapsed );
		}
		sortCreatures();
		var c1:Creature;
		var c2:Creature;
		var dead:Array<Creature> = [];
		var deadPheromones:Array<Pheromone> = [];
		pendingSpawns = [];
		for ( i in 0...creatures.length ) {
			c1 = creatures[ i ];
			for ( j in (i + 1)...creatures.length ) {
				c2 = creatures[ j ];
				if ( !c1.alive || !c2.alive )
					continue;
				
				if ( !c1.touches( c2 ) )
					continue;
					
				c2 = creatures[ j ];
				// devouring
				if ( c1.devours( c2 ) ) {
					c1.setFull( true );
					devourCreature( c2 );
				} else if ( c2.devours( c1 ) ) {
					c2.setFull( true );
					devourCreature( c1 );
				}
				// mating
				if ( c1.mates( c2 ) ) {
					bornCreature( c1, c2 );
				} else if ( c1.mates( c2 ) ) {
					bornCreature( c1, c2 );
				}
			}
			
			if ( !c1.alive )
				dead.push( c1 );
			
			// swamp interaction
			// pheromone interaction
			if ( Std.is( c1, CreatureAI ) )
				for ( p in pheromones.get( Std.string( Type.enumIndex( c1.size ) ) ) ) {
					if ( p.active ) {
						cast( c1, CreatureAI ).smell( p );						
					}
				}
		}
		
		for ( k in Type.enumIndex( SMALL )...Type.enumIndex( LARGE )+1 ) {
			for ( p in pheromones.get( Std.string( k ) ) ) {
				p.update( timeElapsed );
				if ( !p.active )
					deadPheromones.push( p );
			}
		}
		
		for ( c in dead ) {
			creatureLayer.removeChild( c );
			creatures.remove( c );
		}
		
		for ( p in deadPheromones )
			removePheromone( p );
		
		for ( s in pendingSpawns )
			addCreature( s );
			
		var drop:Pheromone = player.hasDrop();
		if ( drop != null )
			addPheromone( drop );
		
		if ( !player.alive ) {
			player.alive = true;
			addCreature( player );
			var r:Render = map.fetch( "T" );
			player.moveTo( r.x, r.y );
			player.setTarget( r.x, r.y );
			player.setTaint( null );
		} else {
			for ( p in pools ) 
				if ( p.touches( player ) )
					player.setTaint( p.kind );
		}
	}
	
	private function addPheromone( p:Pheromone ):Void {
		var ps:Array<Pheromone> = pheromones.get( Std.string( Type.enumIndex( p.kind ) ) );
		ps.push( p );
		pheromoneLayer.addChild( p );
	}
	
	private function removePheromone( p:Pheromone ):Void {
		var ps:Array<Pheromone> = pheromones.get( Std.string( Type.enumIndex( p.kind ) ) );
		ps.remove( p );
		pheromoneLayer.removeChild( p );
	}
	
	public function devourCreature( c:Creature ):Void {
		c.alive = false;
	}
	
	public function bornCreature( c1:Creature, c2:Creature ):Void {
		c1.setFull( false );
		c2.setFull( false );
		var p:Point = Point.interpolate( c1.position, c2.position, 0.5 );
		var c:Creature = new CreatureAI( c1.size, p.x, p.y );
		pendingSpawns.push( c );
	}
	
	public function addCreature( c:Creature ):Void {
		creatureLayer.addChild( c );
		creatures.push( c );
	}
	
	public function setPlayerTarget( key:String, instant:Bool ):Void {
		var r:Render = map.fetch( key );
		if ( instant )
			player.moveTo( r.x, r.y );
		player.setTarget( r.x, r.y );
	}
	
	public function stepPlayer( dx:Int, dy:Int ):Void {
		var step:Float = 4;
		player.setTarget( player.x + dx * step, player.y + dy * step, true );
	}
	
	public function setPlayerTargetPoint( x:Float, y:Float, instant:Bool ):Void {
		if ( instant )
			player.moveTo( x, y );
		player.setTarget( x, y );
	}
	
}
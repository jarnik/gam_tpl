package;

import nme.Assets;
import nme.display.DisplayObjectContainer;
import nme.geom.Rectangle;
import nme.net.SharedObject;
import org.flixel.FlxButton;
import org.flixel.FlxG;
import org.flixel.FlxPath;
import org.flixel.FlxSave;
import org.flixel.FlxSprite;
import org.flixel.FlxState;
import org.flixel.FlxText;
import org.flixel.FlxU;

import hsl.haxe.DirectSignaler;
import hsl.haxe.Signaler;

import com.eclecticdesignstudio.motion.Actuate;

import faxe.core.Layout;
import faxe.core.FaXe;

class PlayState extends FlxState
{
    // signals
    public var spellCastSignaler(default, null):Signaler<Int>;

	override public function create():Void
	{
        spellCastSignaler = new DirectSignaler(this);
		
        spellCastSignaler.bind( onSpellCast );
        spellCastSignaler.dispatch( 3 );
        
        //Actuate.tween( this, 0.3, { scaleX: 1 } );

        // generator seeding
        FlxG.log("random hash "+ Generator.getRandomHash() );
        Generator.init("kokodak");
        for ( i in 0...10 )
            FlxG.log("number "+(Generator.random()*100));


        add( new FlxSprite( "assets/planetix_logo.png" ) );

        // FaXe layout
        var layout:Layout = FaXe.load("assets/layouts/layout.xcf");
        var gui:DisplayObjectContainer = layout.render();
        FlxG._game.addChild( gui ); 

	}

    private function onSpellCast( q:Int):Void {
        // TODO
        FlxG.log("magic: "+q);
    }
	
}

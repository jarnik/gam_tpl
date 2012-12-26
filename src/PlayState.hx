package;

import nme.Assets;
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
	}

    private function onSpellCast( q:Int):Void {
        // TODO
        FlxG.log("magic: "+q);
    }
	
}

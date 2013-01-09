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

class EndState extends FlxState
{    
    private var bottomLine:FlxSprite;
    private var bottomText:FlxText;

	override public function create():Void
	{
		FlxG.mouse.hide();

        var bgr:FlxSprite = new FlxSprite( 80,60,"assets/screen_outro.png" );
        bgr.scale.x = 2;
        bgr.scale.y = 2;
        add( bgr );

        FlxG.playMusic( "assets/music/music.mp3" );
        
        GAM.track("EndState");

	}
		
}

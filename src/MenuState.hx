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

class MenuState extends FlxState
{    
    private var bottomLine:FlxSprite;
    private var bottomText:FlxText;

	override public function create():Void
	{
		#if !neko
		FlxG.bgColor = 0xff131c1b;
		#else
		FlxG.bgColor = {rgb: 0x131c1b, a: 0xff};
		#end		
		FlxG.mouse.show();

        var bgr:FlxSprite = new FlxSprite( 80,60,"assets/screen_start.png" );
        bgr.scale.x = 2;
        bgr.scale.y = 2;
        add( bgr );

        add( new FlxButton(210,130,"COMMENCE", onStartClicked) );

        add( bottomLine = new FlxSprite( 0, FlxG.height - 16 ) );
        bottomLine.makeGraphic( FlxG.width, 32, 0xFF000000 );
        add( bottomText = new FlxText( 0, FlxG.height - 15, FlxG.width, " #OneGameAMonth entry #1 by @Jarnik, Jan 2013" ) );
        bottomText.setFormat( null, 8, 0x808080, "left" );

        FlxG.playMusic( "assets/music/music.mp3" );

	}
	
	override public function destroy():Void
	{
		super.destroy();
	}

    private function onStartClicked():Void {
        FlxG.switchState( new PlayState() );
    }

	override public function update():Void
	{
		super.update();
        if ( FlxG.keys.justPressed( "SPACE" ) ) {
            onStartClicked();
        }

	}	
}

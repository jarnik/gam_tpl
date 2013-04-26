package;

import nme.Assets;
import nme.events.Event;
import nme.events.MouseEvent;
import nme.geom.Point;
import nme.geom.Matrix;
import nme.display.Bitmap;
import nme.display.BitmapData;
import nme.display.FPS;
import nme.display.Graphics;
import nme.display.Sprite;
import nme.display.Stage;
import nme.display.StageAlign;
import nme.display.StageScaleMode;
import nme.display.DisplayObject;
import nme.filters.GlowFilter;
import nme.geom.Rectangle;
import nme.Lib;
import nme.text.TextField;
import nme.text.TextFormat;
import nme.text.TextFormatAlign;
import nme.events.KeyboardEvent;

import gaxe.SoundLib;
import gaxe.Gaxe;
import gaxe.Debug;
import gaxe.Scene;
import gaxe.IMenu;

enum MenuState {
    MENU_TITLE;
    MENU_TITLE_IN_PROGRESS;
    MENU_INGAME;
    MENU_INGAME_FAIL;
}

class Menu extends Sprite, implements IMenu 
{   

    /*private var menuLayer:Sprite;
    private var btnNewGame:Button;
    private var btnContinue:Button;
    private var btnQuit:Button;
    private var menuState:MenuState;
    private var fade:Bitmap;
    private var title:Bitmap;
    private var map:Map;
    public var volume:Scrollbar;
    public var gamma:Scrollbar;

    private var prevVolume:Float;
    private var prevGamma:Float;*/

	public function new () 
	{
		super();
        createMenu();
    }

    private function createMenu():Void {
        //create menu
        /*addChild( title = new Bitmap(Assets.getBitmapData( "assets/screen_title.png" ), nme.display.PixelSnapping.AUTO, false ) );

        addChild( fade = new Bitmap(Assets.getBitmapData( "assets/fade.png" ), nme.display.PixelSnapping.AUTO, false ) );
        fade.alpha = 0.7;
        fade.visible = false;

        addChild( this.gamma = new Scrollbar( 150, 60, 200, "GAMMA", 0 ) );
        addChild( this.volume = new Scrollbar( 150, 260, 200, "VOLUME", 0 ) );

        addChild( menuLayer = new Sprite() );
        menuLayer.addChild( btnContinue = new Button( "CONTINUE", 180, 80 ) );
        menuLayer.addChild( btnNewGame = new Button( "NEW GAME", 180, 120 ) );
        menuLayer.addChild( btnQuit = new Button( "QUIT", 180, 160 ) ); // BACK TO TITLE

        menuLayer.addChild( map = new Map() );
        map.y = Gaxe.h - 100; 

        btnContinue.addEventListener( MouseEvent.CLICK, onContinueClick );
        btnNewGame.addEventListener( MouseEvent.CLICK, onNewGameClick );
        btnQuit.addEventListener( MouseEvent.CLICK, onQuitClick );*/
    }

    public function init( params:Dynamic ):Void {
        /*prevVolume = params.volume;
        prevGamma = params.gamma;
        this.volume.setValue( params.volume );
        this.gamma.setValue( params.gamma );*/
    }

    public function getDisplayObject():DisplayObject { return this; }
    public function isVisible():Bool { return visible; }

    public function show( s:EnumValue, params:Dynamic = null ):Void {
        /*menuState = (s == null ? MENU_INGAME : Type.createEnum( MenuState, Type.enumConstructor( s ) ));

        var stops:Int = ( params != null ? params.stops : 0 );

        Debug.log("menu "+menuState);
        visible = true;
        btnContinue.visible = ( menuState != MENU_TITLE );
        btnContinue.setText( menuState != MENU_INGAME_FAIL ? "CONTINUE" : "TRY AGAIN" );
        btnNewGame.visible = ( menuState != MENU_INGAME && menuState != MENU_INGAME_FAIL );
        btnQuit.setText( menuState == MENU_INGAME || menuState == MENU_INGAME_FAIL ? "< TITLE" : "QUIT" );
        fade.visible = ( menuState == MENU_INGAME || menuState == MENU_INGAME_FAIL );
        map.visible = ( menuState == MENU_INGAME );
        title.visible = ( menuState == MENU_INGAME );

        switch ( menuState ) {
            case MENU_TITLE:
            case MENU_TITLE_IN_PROGRESS:
            case MENU_INGAME:
                map.show( 
                    Story.lines[ SaveGame.getCurrentLine() ].name.toUpperCase()+": "+
                    Story.lines[ SaveGame.getCurrentLine() ].stations[ SaveGame.current.progress ].name,
                    Story.lineStationStops( SaveGame.getCurrentLine(), SaveGame.current.progress )+1,
                    stops,
                    false
                );
            default: 
        }*/
    }

    public function update( elapsed:Float ):Void {
        if ( !visible )
            return;

        /*if ( prevVolume != volume.getValue() || prevGamma != gamma.getValue() ) {
            SoundLib.setMasterVolume( volume.getValue() );
            Gaxe.setGamma( gamma.getValue() );
            SaveGame.saveSettings( volume.getValue(), gamma.getValue() );
            prevGamma = gamma.getValue();
            prevVolume = volume.getValue();
        }*/
    }

    public function hide():Void {
        visible = false;
    }

	/*
    private function onContinueClick( e:MouseEvent ):Void {
        if ( menuState == MENU_TITLE_IN_PROGRESS ) {
            hide();
            Gaxe.head.switchScene( LineSelectScene );
        } else if ( menuState == MENU_INGAME_FAIL ) {
            hide();
            Gaxe.head.switchScene( PlayScene );
        } else
            hide();
    }

    private function onNewGameClick( e:MouseEvent ):Void {
        SaveGame.reset();
        hide();
        Gaxe.head.switchScene( LineSelectScene );
    }

    private function onQuitClick( e:MouseEvent ):Void {
        // TODO
        if ( menuState == MENU_INGAME || menuState == MENU_INGAME_FAIL ) {
            hide();
            Gaxe.head.switchScene( TitleScene );
        } else {
            //Main.switchState( STATE_TITLE );
            nme.system.System.exit( 0 );
        }

    }*/

}

//	IRUStreamView.as
//	Compile with mxmlc
	
package {

import mx.core.*;
import mx.controls.*;
import mx.controls.Alert;
import flash.system.*;
import flash.net.*;
import flash.display.*;
import flash.text.*;
import flash.external.*;
import flash.events.*;
import flash.utils.*;

public class IRUStreamView extends Sprite {
	
	private var logicClass:Class; // defaults to nil, loaded dynamically
	private var viewer:Object; // loaded dynamically too
	private var channelID:String; // defaults to nil
	private var viewerMuted:Boolean = false; // defaults to NO
	private var relativeURIPrefix:String = "";
	private var callbackName:String; // defaults to nil, if exists, calls javascript function with this name
	
	public function IRUStreamView () {
		
		Security.allowDomain("ustream.tv");
		
		var flashVars:Object = LoaderInfo(this.root.loaderInfo).parameters;	
				
		this.channelID = flashVars.channelID || null;
		this.relativeURIPrefix = flashVars.relativeURIPrefix || "";
		this.callbackName = flashVars.callbackName || null;
		this.viewerMuted = flashVars.viewerMuted || this.viewerMuted;
		
		ExternalInterface.addCallback("setChannelID", this.setChannelID);
		ExternalInterface.addCallback("getViewer", this.getViewer);
		
		stage.scaleMode = StageScaleMode.NO_SCALE;
		stage.align = StageAlign.TOP_LEFT;	
		stage.addEventListener(Event.RESIZE, this.handleResize, false, 0, true);
		
		var loader:Loader = new Loader();
		var loaderContext:LoaderContext = new LoaderContext();
		var loaderRequest:URLRequest = new URLRequest("http://www.ustream.tv/flash/viewer.rsl.swf"); // RSL can update, don’t cache at all
		loaderContext.applicationDomain = ApplicationDomain.currentDomain;
		var capturedThis:Object = this;
		loader.contentLoaderInfo.addEventListener(Event.COMPLETE, function(event:Event):void {
			
			capturedThis.logicClass = loader.contentLoaderInfo.applicationDomain.getDefinition("tv.ustream.viewer.logic.Logic" ) as Class;
			capturedThis.handleRSLDidLoad();
			
		});
		
		stage.addChild(loader);
		loader.load(loaderRequest, loaderContext);
				
	}
	
	private function handleRSLDidLoad():void {
		
		this.viewer = new this.logicClass();
		stage.addChild(this.viewer.display);
		
		this.updateViewer();
		this.emitCallback("RSLLoaded", null);
					
	}
	
	private function emitCallback(methodName:String, methodArguments:String):void {
				
		if (ExternalInterface.available)
		ExternalInterface.call((this.callbackName || "IRUStreamViewDefaultCallback"), methodName, methodArguments);
		
	}
	
	private function setChannelID(intendedID:String):void {
		
		this.channelID = intendedID;
		this.updateViewer();
		
	}
	
	private function getViewer():Object {
		
		return this.viewer;
		
	}
	
	private function updateViewer():void {
		
		if (!this.viewer)
		return;
		
		if (!this.viewer.channel) {
			this.viewer.createChannel(this.channelID, true);
			this.viewer.muted = this.viewerMuted;
		}
		
		this.handleResize(null);
		
	}
	
	private function handleResize(event:Event):void {	
		
		if (!this.viewer)
		return;
		
		this.viewer.display.x = 0;
		this.viewer.display.y = 0;
		this.viewer.display.width = stage.stageWidth;
		this.viewer.display.height = stage.stageHeight;
				
	}
	
}

}

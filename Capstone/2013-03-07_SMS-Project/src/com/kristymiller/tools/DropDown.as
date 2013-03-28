﻿/***************************** Manuel Gonzalez           ** design@stheory.com        ** www.stheory.com           ** www.codingcolor.com       ******************************/package com.dropdown{	import flash.display.Sprite;	import flash.display.MovieClip;	import flash.display.DisplayObject;	import flash.events.TimerEvent;	import flash.events.Event;	import flash.events.MouseEvent;	import flash.text.TextField;	import flash.text.TextFormat;	import flash.text.TextFieldAutoSize;	import flash.text.Font;	import flash.utils.Timer;	import flash.geom.ColorTransform;	public class DropDown extends MovieClip {		private var _dp:Array;		private var _w:Number;		private var _h:Number;		private var _timer:Timer;		private var _open:Boolean = false;		private var _menuCreated:Boolean = false;		private var _direction:String;		private var _labelField:TextField;		private var _hit:Sprite;		//		private var _selectedObj:Object;		private var _lastSelectedItem:MovieClip;		private var _selectedIndex:int = 0;		private var _timerDuration:Number = 2000;		//		private var _fontDefaultColor:uint = 0x000000;		private var _fontOverColor:uint = 0x0000ff;		private var _fontSize:Number = 12;		private var _fontName:String = "Arial";		private var _customFont:Font;		//		private var _itemDefaultBkgColor:uint = 0xCCCCCC;		private var _itemOverBkgColor:uint = 0xFFFFFF;				public function set dataProvider(inDp:Array):void		{			if(_menuCreated){			refreshMenu();			}						_dp = inDp;			_lastSelectedItem = null;			createDropDownMenu();			setSelectedFlag(_dp[_selectedIndex].mc)			setlabel(_dp[_selectedIndex].label)		}		public function get dataProvider():Array		{			return _dp;		}		public function set selectedIndex(inInt:int):void		{			_selectedIndex = inInt;		}		public function get selectedIndex():int		{			return _selectedIndex;		}		public function set selectedObject(inObj:Object):void {			_selectedObj = inObj;		}		public function get selectedObject():Object {			return _selectedObj;		}		public function set duration(inNum:Number):void {			_timerDuration = inNum*1000;		}		public function get duration():Number {			return _timerDuration;		}		public function set itemColors(inArray:Array):void		{			_itemDefaultBkgColor = inArray[0];			_itemOverBkgColor = inArray[1];			if(_menuCreated){			setItemColor();			}		}		public function get itemColors():Array		{			return [_itemDefaultBkgColor,_itemOverBkgColor];		}		public function set itemFontColors(inArray:Array):void		{			_fontDefaultColor = inArray[0];			_fontOverColor = inArray[1];			if(_menuCreated){			setFont();			}		}		public function get itemFontColors():Array		{			return [_fontDefaultColor,_fontOverColor];		}		public function set fontSize(inNum:Number):void		{			_fontSize = inNum;			if(_menuCreated){			setFont();			}		}		public function get fontSize():Number		{			return _fontSize;		}		public function set fontName(inStr:String):void		{			_fontName = inStr;			if(_menuCreated){			setFont();			}		}		public function get fontName():String		{			return _fontName;		}		public function set customFont(inFont:Font):void		{			_customFont = inFont;			if(_menuCreated){			setFont();			}		}		public function get customFont():Font		{			return _customFont;		}		/* Constructor*/		public function DropDown() {		}		/*		Method:init		Parameters:		inDataProvider:Array		w:Number		h:Number		direction:String="down"		Returns:		*/		public function init(inDataProvider:Array, w:Number, h:Number,direction:String="down"):void		{			_w = w;			_h = h;			_dp = inDataProvider;			_direction = direction;			_timer = new Timer(_timerDuration);			_timer.addEventListener( TimerEvent.TIMER, checkDropDown);			_selectedObj = _dp[_selectedIndex];			adjustBackground();			adjustArrow();			createDropDownMenu();						createlabelField();			createHit();			setSelectedFlag(_dp[_selectedIndex].mc)		}		/*		Method:createHit		Parameters:		Returns:		*/		private function createHit():void		{			_hit = new Sprite();			_hit.graphics.clear();			_hit.graphics.beginFill(0x000000, 1 );			_hit.graphics.drawRect( 0, 0, _w, _h);			_hit.graphics.endFill();			_hit.alpha=0;			addChild(_hit);			_hit.buttonMode = true;			_hit.addEventListener( MouseEvent.CLICK, openDropDown );		}		/*		Method:createlabelField		Parameters:		Returns:		*/		private function createlabelField():void		{				_labelField = new TextField();				_labelField.selectable = false;				_labelField.autoSize = TextFieldAutoSize.LEFT;				_labelField.x = 5;				addChild(_labelField)				var format:TextFormat = new TextFormat();				format.color = _fontDefaultColor;				format.size = _fontSize + 2;				if(_customFont == null)				{				format.font = _fontName;				}else{				format.font = _customFont.fontName;				_labelField.embedFonts = true;				}				           		_labelField.defaultTextFormat = format;				setlabel(_selectedObj.label);				_labelField.y = ( ddBkg.height/2 ) - ( _labelField.height/2);														}		/*		Method:adjustLabel		Parameters:		Returns:		*/		private function adjustLabel():void		{				var format:TextFormat = new TextFormat();				format.color = _fontDefaultColor;				format.size = _fontSize + 2;								if(_customFont == null)				{				format.font = _fontName;				}else{				format.font = _customFont.fontName;				_labelField.embedFonts = true;				}				           		_labelField.defaultTextFormat = format;				setlabel(_selectedObj.label);				_labelField.y = ( ddBkg.height/2 ) - ( _labelField.height/2 );						}		/*		Method:setlabel		Parameters:		inStr:String		Returns:		*/		private function setlabel(inStr:String):void {			_labelField.text = inStr;		}		/*		Method:adjustBackground		Parameters:		Returns:		*/		private function adjustBackground():void {			ddBkg.width =_w;			ddBkg.height = _h;		}		/*		Method:adjustArrow		Parameters:		Returns:		*/		private function adjustArrow():void {			if ( _direction == "up" ) {				ddArrow.rotation = 180;			}			ddArrow.x = ddBkg.x + ddBkg.width - 15;			ddArrow.y = ddBkg.height/2;		}		/*		Method:formatField		Parameters:		inTf:TextField		inColor:uint		Returns:		*/		private function formatField(inTf:TextField,inColor:uint):void {			var format:TextFormat = new TextFormat();			if(_customFont == null)			{				format.font = _fontName;			}else{				format.font = _customFont.fontName;				inTf.embedFonts = true;			}			format.color = inColor;			format.size = _fontSize;			inTf.setTextFormat(format);		}		/*		Method:checkDropDown		Parameters:		event:TimerEvent		Returns:		*/		private function checkDropDown(event:TimerEvent):void {			if (_open) {				closeDropDown();			}		}		/*		Method:refreshMenu		Parameters:		Returns:		*/		private function refreshMenu():void		{			var dpLen:uint = _dp.length			for (var i=0; i< dpLen; i++) {								removeItemListeners(_dp[i].mc);				var MC = _dp[i].mc;				removeChild(MC);							}			_dp = [];								}		/*		Method:createDropDownMenu		Parameters:		Returns:		*/		private function createDropDownMenu():void {			var dpLen:uint = _dp.length			for (var i=0; i< dpLen; i++) {				var container:MovieClip = new MovieClip();				container.name = _dp[i].label;				container.obj = _dp[i];				container.isSelected =false;								var back:Sprite = new Sprite();				back.name = "bkg";				back.graphics.clear();				back.graphics.beginFill( _itemDefaultBkgColor, 1 );				back.graphics.drawRect( 0, 0, _w, _h);				back.graphics.endFill();				back.mouseEnabled = false;								container.spr = back;				container.addChild(back);								var t = new TextField();				t.mouseEnabled = false;				t.name = "tField";				t.x = 5;				t.selectable = false;				t.autoSize = TextFieldAutoSize.LEFT;				t.text = _dp[i].label;				formatField(t,_fontDefaultColor);								t.y = ( back.height/2 ) - ( t.height/2 );				container.tField = t;				container.visible = false;				addItemListeners(container)												container.addChild( t );				addChild(container);								_dp[i].mc = container;							}			_menuCreated = true;		}		/*		Method:addItemListeners		Parameters:		inMC:MovieClip		Returns:		*/		private function addItemListeners(inMC:MovieClip):void		{							    inMC.buttonMode = true;				inMC.addEventListener( MouseEvent.CLICK, itemSelected ,false,0,true);				inMC.addEventListener( MouseEvent.MOUSE_OUT, itemOut,false,0,true);				inMC.addEventListener( MouseEvent.MOUSE_OVER, itemOver,false,0,true);		}		/*		Method:removeItemListeners		Parameters:		inMC:MovieClip		Returns:		*/		private function removeItemListeners(inMC:MovieClip):void		{			    inMC.buttonMode = false;				inMC.removeEventListener( MouseEvent.CLICK, itemSelected );				inMC.removeEventListener( MouseEvent.MOUSE_OUT, itemOut);				inMC.removeEventListener( MouseEvent.MOUSE_OVER, itemOver);		}		/*		Method:setFont		Parameters:		Returns:		*/		private function setFont():void		{				for (var i=0; i<_dp.length; i++) {					var item:MovieClip = _dp[i].mc;					var t:TextField = item.tField;					formatField(t,_fontDefaultColor);				}				adjustLabel();		}		/*		Method:setItemColor		Parameters:		Returns:		*/		private function setItemColor():void		{			for (var i=0; i<_dp.length; i++) 			{					var item:MovieClip = _dp[i].mc;					item.removeChild(item.spr )					var back:Sprite = new Sprite();					back.name = "bkg";					back.graphics.clear();					if(item.isSelected){						back.graphics.beginFill( _itemOverBkgColor, 1 );					}else{						back.graphics.beginFill( _itemDefaultBkgColor, 1 );					}					back.graphics.drawRect( 0, 0, _w, _h);					back.graphics.endFill();					item.spr = back;					item.addChildAt(back,0);			}					}		/*		Method:itemOver		Parameters:		event:Event		Returns:		*/		private function itemOver(event:Event):void {			_timer.stop();			changeItemBackgroundColor(event.target.spr,_itemOverBkgColor);			formatField(event.target.tField,_fontOverColor);		}		/*		Method:itemOut		Parameters:		event:Event		Returns:		*/		private function itemOut(event:Event):void {			changeItemBackgroundColor(event.target.spr,_itemDefaultBkgColor);			formatField(event.target.tField,_fontDefaultColor);			_timer.start();		}		/*		Method:changeItemBackgroundColor		Parameters:		inDo:DisplayObject		inColor:uint		Returns:		*/		private function changeItemBackgroundColor(inDo:DisplayObject,inColor:uint):void {			var _color:ColorTransform  = inDo.transform.colorTransform;			_color.color = inColor;			inDo.transform.colorTransform = _color;		}		/*		Method:itemSelected		Parameters:		event:Event		Returns:		*/		private function itemSelected(event:Event):void {			_timer.stop();			var tLbl:String = event.target.obj.label;			_selectedObj = event.target.obj;			var mc:MovieClip = event.target as MovieClip;			setSelectedFlag(mc)			setlabel(tLbl);			closeDropDown();			dispatchEvent(new Event(Event.CHANGE));		}		/*		Method:setSelectedFlag		Parameters:		inMC:MovieClip		Returns:		*/		private function setSelectedFlag(inMC:MovieClip):void		{			if(_lastSelectedItem != null){				_lastSelectedItem.isSelected = false;				changeItemBackgroundColor(_lastSelectedItem.spr,_itemDefaultBkgColor);				formatField(_lastSelectedItem.tField,_fontDefaultColor);				addItemListeners(_lastSelectedItem);			}			inMC.isSelected = true;			removeItemListeners(inMC);			changeItemBackgroundColor(inMC.spr,_itemOverBkgColor);			formatField(inMC.tField,_fontOverColor);			_lastSelectedItem = inMC;					}		/*		Method:openDropDown		Parameters:		Returns:		*/		private function openDropDown( event:Event ) {			if ( !_open ) {				for (var i=0; i<_dp.length; i++) {					var item:DisplayObject = _dp[i].mc;										item.alpha = 0;					item.visible = true;					if ( _direction == "down" ) {						item.y = _h + ( _h * i );						item.alpha =1;					} else {						item.y = -_h - ( _h * i );						item.alpha = 1;					}				}				_open = true;			} else {				closeDropDown();			}			_timer.start();		}		/*		Method:closeDropDown		Parameters:		Returns:		*/		private function closeDropDown() {			if ( _open ) {				_timer.stop();				for (var i=0; i<_dp.length; i++) {					var item:DisplayObject = _dp[i].mc;					item.visible = false;					item.y =0;					item.alpha=0;				}			}			_open = false;		}	}}
// app for analysing accelerometer data

using Toybox.WatchUi;
using Toybox.Graphics;
using Toybox.Sensor;
using Toybox.Timer;
using Toybox.Math;
using Toybox.Attention;

class AcceleratorView extends WatchUi.View {

    var dataTimer;
    var width;
    var height;
	
    var accel;
    
    var treshold = 6000;
    

    function initialize() {
        View.initialize();
    }
	function testCallback(val) {
		Toybox.System.println("Invoked with: " + val);
		if (Attention has :vibrate) {
			Attention.vibrate([
		        new Attention.VibeProfile(100, 1000), 
		    ]);
	    }
	}

    // Load your resources here
    function onLayout(dc) {
        dataTimer = new Timer.Timer();
        dataTimer.start(method(:timerCallback), 100, true);

        width = dc.getWidth();
        height = dc.getHeight();
       
        
        accel = new AccelAnalyzer();
        accel.setAlertCallback(method(:testCallback));
        accel.setTreshold(treshold);
        accel.start();
    }

    // Restore the state of the app and prepare the view to be shown
    function onShow() {
    }

    // Update the view
    function onUpdate(dc) {
        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_BLACK);
        dc.clear();
		

        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);
        if (accel != null) {
            dc.drawText(width / 2,  3, Graphics.FONT_TINY, "Ax = " + accel.currX, Graphics.TEXT_JUSTIFY_CENTER);
            dc.drawText(width / 2, 23, Graphics.FONT_TINY, "Ay = " + accel.currY, Graphics.TEXT_JUSTIFY_CENTER);
            dc.drawText(width / 2, 43, Graphics.FONT_TINY, "Az = " + accel.currZ, Graphics.TEXT_JUSTIFY_CENTER);
            
            dc.drawText(width / 2,  63, Graphics.FONT_TINY, "Amx = " + accel.maxX, Graphics.TEXT_JUSTIFY_CENTER);
            dc.drawText(width / 2, 83, Graphics.FONT_TINY, "Amy = " + accel.maxY, Graphics.TEXT_JUSTIFY_CENTER);
            dc.drawText(width / 2, 103, Graphics.FONT_TINY, "Amz = " + accel.maxZ, Graphics.TEXT_JUSTIFY_CENTER);
            
            dc.drawText(width / 2, 123, Graphics.FONT_TINY, "Treshold = " + treshold, Graphics.TEXT_JUSTIFY_CENTER);
        } else {
            dc.drawText(width / 2, 3, Graphics.FONT_TINY, "no Accel", Graphics.TEXT_JUSTIFY_CENTER);
        } 

    }

    function timerCallback() {
        
        WatchUi.requestUpdate();
    }
	

    // Called when this View is removed from the screen. Save the
    // state of your app here.
    function onHide() {
    }
    
    function resetMaximums() {
    	accel.resetMaximums();
    	WatchUi.requestUpdate();
    }
    
    function incTreshold() {
    	if(treshold < 8000) {
    		treshold += 500;
    		accel.setTreshold(treshold);
    	}
    	WatchUi.requestUpdate();
    }
    
    function decTreshold() {
    	if(treshold > 500) {
    		treshold -= 500;
    		accel.setTreshold(treshold);
    	}
    	WatchUi.requestUpdate();
    }
}

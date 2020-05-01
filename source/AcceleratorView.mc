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
        
        
        accel = new AccelAnalyzer();
        accel.setAlertCallback(method(:testCallback));
        accel.setTreshold(treshold);
        accel.start();
        
        setLayout( Rez.Layouts.MainLayout( dc ) );
    }

    // Restore the state of the app and prepare the view to be shown
    function onShow() {
    }

    // Update the view
    function onUpdate(dc) {
    	
        if (accel != null) {
        	
        	View.findDrawableById("currx").setText(accel.currX+""); // cast potential null to string
        	View.findDrawableById("curry").setText(accel.currY+"");
        	View.findDrawableById("currz").setText(accel.currZ+"");
        	
        	View.findDrawableById("maxx").setText(accel.maxX+"");
        	View.findDrawableById("maxy").setText(accel.maxY+"");
        	View.findDrawableById("maxz").setText(accel.maxZ+"");
        	
        	View.findDrawableById("timebetween").setText(accel.tBetweenAlerts.format("%02.2f"));
        	
        	View.findDrawableById("treshold").setText(treshold+"");
        	
        } else {
            dc.drawText(width / 2, 3, Graphics.FONT_TINY, "no Accel", Graphics.TEXT_JUSTIFY_CENTER);
        } 
		View.onUpdate( dc );
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

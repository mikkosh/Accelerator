class AccelAnalyzer {
	
	var sampleRate;
	var loggingPeriod = 1;
	var isLogging;
	
	var treshold = 0;
	var callback = null;
	
	// maximum values for the current logging period 
	var currX;
	var currY;
	var currZ;
	
	// all time max values
	var maxX;
	var maxY;
	var maxZ;
	
	// sample count for identifying peaks
	var sampleCount = 0;
	// when was the last peak
	var lastTriggerSampleCount = 0;
	
	// cooldown period between samples
	var cooldown = 2; // do not trigger more often than every 3 samples
	
	// time between alerts
	var tBetweenAlerts = 0.0d;
	
	function initialize() {
    	sampleRate = Sensor.getMaxSampleRate();  
    	isLogging = false;
    	resetMaximums();
    	
    	Toybox.System.println("Logging at rate: " + sampleRate); 
    	Toybox.System.println("Logging period: " + loggingPeriod); 
    }
	
	function start() {
		isLogging = true;
		_startLogging();
	}
	
	function stop() {
		isLogging = false;
		_stopLogging();
	}
	
	function resetMaximums() {
		maxX = null;
		maxY = null;
		maxZ = null;
	}
	
	// treshold to trigger alert, in milli-g
	function setTreshold(tr) {
		treshold = tr;
	}
	
	// set the callback to trigger when treshold exceeded
	function setAlertCallback(cb) {
		callback = cb;
	}
	
	// @todo: rename method as this does not always invoke alert
	function invokeAlert(accelValue) {
		
		// cooldown might be necessary to avoid interpreting one shot twice 
		if((sampleCount - lastTriggerSampleCount) <= cooldown) {
			Toybox.System.println("Ignored alert due to cooldown");
			return;
		}
		
		tBetweenAlerts = (sampleCount-lastTriggerSampleCount)*(1.0d/sampleRate);
		Toybox.System.println("Samplecount: " + sampleCount);
		Toybox.System.println("Lastalert: " + lastTriggerSampleCount);
		Toybox.System.println("Time between alerts: " + tBetweenAlerts);
		
		lastTriggerSampleCount = sampleCount;
		if(callback instanceof Method) {
			callback.invoke(accelValue);
		}
	}
	
	function _dataReceivedCallback(sensorData){
	
		for(var i=0; i<sensorData.accelerometerData.x.size(); i++) {
			sampleCount++;
			var x = sensorData.accelerometerData.x[i];
			var y = sensorData.accelerometerData.y[i];
			var z = sensorData.accelerometerData.z[i];
			
			// alert is triggered only for one axis per time
			if(x.abs() > treshold.abs()) {
				invokeAlert(x);
			} else if(y.abs() > treshold.abs()) {
				invokeAlert(y);
			} else if(z.abs() > treshold.abs()) {
				invokeAlert(z);
			}
		}
		// get max values from the sample array
		currX = _absMax(sensorData.accelerometerData.x);
		currY = _absMax(sensorData.accelerometerData.y);
		currZ = _absMax(sensorData.accelerometerData.z);
		
		Toybox.System.println("Raw samples, X axis("+sensorData.accelerometerData.x.size()+"): " + sensorData.accelerometerData.x);
		Toybox.System.println("Raw samples, Y axis("+sensorData.accelerometerData.y.size()+"): " + sensorData.accelerometerData.y);
		Toybox.System.println("Raw samples, Z axis("+sensorData.accelerometerData.z.size()+"): " + sensorData.accelerometerData.z);
		
		Toybox.System.println("Max X axis: " + currX);
		Toybox.System.println("Max Y axis: " + currY);
		Toybox.System.println("Max Z axis: " + currZ);
		
		// update all time high values
		if(maxX == null || maxX.abs() < currX.abs()) {
			maxX = currX;
		}
		if(maxY == null || maxY.abs() < currY.abs()) {
			maxY = currY;
		}
		if(maxZ == null || maxZ.abs() < currZ.abs()) {
			maxZ = currZ;
		}
		
	}
	
	
	private function _absMax(arrData) {
		var maxData = null;
		for( var i = 0; i < arrData.size(); i++ ) {
			if(maxData == null || maxData.abs() < arrData[i].abs()) {
				maxData = arrData[i];
			}
		}
		return maxData;
	} 
	
	private function _startLogging() {
		
		var options = {:period => loggingPeriod, :sampleRate => sampleRate, :enableAccelerometer => true};
		try {
			Sensor.registerSensorDataListener(method(:_dataReceivedCallback), options);
		}
		catch(e) {
			System.println(e.getErrorMessage());
		}
	}
	
	private function _stopLogging() {
		Sensor.unregisterSensorDataListener();
	}
	
}
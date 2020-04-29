class AccelAnalyzer {
	
	var maxSampleRate;
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
	
	function initialize() {
    	maxSampleRate = Sensor.getMaxSampleRate();  
    	isLogging = false;
    	resetMaximums();
    	
    	Toybox.System.println("Logging at rate: " + maxSampleRate); 
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
	
	function _dataReceivedCallback(sensorData){
		currX = _absMax(sensorData.accelerometerData.x);
		currY = _absMax(sensorData.accelerometerData.y);
		currZ = _absMax(sensorData.accelerometerData.z);
		
		Toybox.System.println("Raw samples, X axis: " + sensorData.accelerometerData.x);
		Toybox.System.println("Raw samples, Y axis: " + sensorData.accelerometerData.y);
		Toybox.System.println("Raw samples, Z axis: " + sensorData.accelerometerData.z);
		
		Toybox.System.println("Max X axis: " + currX);
		Toybox.System.println("Max Y axis: " + currY);
		Toybox.System.println("Max Z axis: " + currZ);
		
		if(currX.abs() > treshold.abs() && callback instanceof Method) {
			callback.invoke(currX);
		}
		if(currY.abs() > treshold.abs() && callback instanceof Method) {
			callback.invoke(currY);
		}
		if(currZ.abs() > treshold.abs() && callback instanceof Method) {
			callback.invoke(currZ);
		}
		
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
		
		var options = {:period => loggingPeriod, :sampleRate => maxSampleRate, :enableAccelerometer => true};
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
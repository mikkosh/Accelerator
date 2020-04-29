using Toybox.WatchUi;

class AcceleratorDelegate extends WatchUi.BehaviorDelegate {
    var parentView;

    function initialize(view) {
        BehaviorDelegate.initialize();
        parentView = view;
    }

    function onSelect() {
        parentView.resetMaximums();
        return true;
    }
    
    function onNextPage() {
    	parentView.incTreshold();
    	return true;
    }
    function onPreviousPage() {
    	parentView.decTreshold();
    	return true;
    }
}
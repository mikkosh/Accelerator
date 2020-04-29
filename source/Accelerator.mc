using Toybox.Application;

class Accelerator extends Application.AppBase {

    function initialize() {
        AppBase.initialize();
    }

    // onStart() is called on application start up
    function onStart(state) {
    }


    // onStop() is called when your application is exiting
    function onStop(state) {
    }

    // Return the initial view of your application here
    function getInitialView() {
        var mainView = new AcceleratorView();
        var viewDelegate = new AcceleratorDelegate( mainView );
        return [mainView, viewDelegate];
    }

}
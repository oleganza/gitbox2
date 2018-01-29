import Cocoa

class Later {
    var blocks: [()->()] = []
    var done: Bool = false
    
    func perform(block: @escaping ()->()) {
        if self.done {
            block()
        } else {
            blocks.append(block)
        }
    }
    
    func complete() {
        if self.done { return }
        self.done = true
        for block in blocks {
            block()
        }
        self.blocks = []
    }
}

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
    
    var launched: Later = Later()
    var mainWindowController: NSWindowController?
    
    func showMainWindow() {
        if self.mainWindowController == nil {
            self.mainWindowController = NSStoryboard.main?.instantiateController(withIdentifier: NSStoryboard.SceneIdentifier("MainWindowController")) as? NSWindowController;
        }
        self.mainWindowController?.window?.makeKeyAndOrderFront(nil);
    }
    
    
    // Application Delegate methods
    
    func application(_ sender: NSApplication, openFile filename: String) -> Bool {
        // Note: this may be called before app finished launching.
        launched.perform {
            // TODO: open the file
        }
        return true
    }
    
    func applicationDidFinishLaunching(_ notif: Notification) {
        showMainWindow()
        launched.complete()
    }

    func applicationWillTerminate(_ notif: Notification) {
    }
    
    func applicationDidBecomeActive(_ notif: Notification) {
        showMainWindow()
    }
    
    // This method is called when Dock icon is clicked. This brings window to front if the app was active.
    func applicationShouldOpenUntitledFile(_ sender: NSApplication) -> Bool {
        showMainWindow()
        return false
    }
}


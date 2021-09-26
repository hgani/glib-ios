#if INCLUDE_MDLIBS

import MaterialComponents.MaterialSnackbar

class MSnackbar: MDCSnackbarMessage {
    func text(_ text: String) -> Self {
        self.text = text
        return self
    }
    
    func action(title: String, onClick: @escaping (MSnackbar) -> (Void)) -> Self {
        let action = MDCSnackbarMessageAction()
        action.title = title
        action.handler = { () in
            MDCSnackbarManager.default.suspendAllMessages()
            onClick(self)
//            JsonAction.execute(spec: onClose, screen: screen, creator: creator)
        }
        self.action = action
        return self
    }
    
    func autoDismiss(_ autoDismiss: Bool) -> Self {
        self.automaticallyDismisses = autoDismiss
        return self
    }
    
    func show() {
        MDCSnackbarManager.default.show(self)
    }
    
    // TODO: Decouple from JSON UI
//    func action(_ spec: Json?, _ screen: UIViewController, _ creator: JsonAction) -> Self {
//        if let onClose = spec {
//            let action = MDCSnackbarMessageAction()
//            action.title = "CLOSE"
//            action.handler = { () in
//                MDCSnackbarManager.default.suspendAllMessages()
//                JsonAction.execute(spec: onClose, screen: screen, creator: creator)
//            }
//            self.action = action
//        }
//        return self
//    }
    
    // TODO: Decouple from JSON UI
    func position(_ verticalPosition: Json?) -> Self {
        var bottomOffset = CGFloat(0)
        if let position = verticalPosition {
            switch(position) {
            case "top":
                bottomOffset = CGFloat(UIScreen.main.bounds.height - 100)
                break
            default:
                GLog.d("Default vertical position")
            }
        }
        
        MDCSnackbarManager.default.setBottomOffset(bottomOffset)
        return self
    }
}

#endif

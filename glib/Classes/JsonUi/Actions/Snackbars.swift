import MaterialComponents.MaterialSnackbar
//import MaterialComponents.MaterialSnackbar_ColorThemer

class JsonAction_Snackbars_Alert: JsonAction {
    override func silentExecute() -> Bool {
        guard let message = spec["message"].string else {
            return false
        }
        
        // Currently no color theming for snackbar
        // https://material.io/develop/ios/components/snackbars/#color-theming
//        let colorScheme = MDCSemanticColorScheme()
//        colorScheme.backgroundColor = .green
//        MDCSnackbarColorThemer.applySemanticColorScheme(colorScheme)
        
        let snackbar = MSnackbar()
        snackbar.text(message)
            .action(spec["onClose"].presence, screen, self)
            .position(spec["verticalPosition"].presence)
        MDCSnackbarManager.show(snackbar)
        
        return true
    }
}

class JsonAction_Snackbars_Select: JsonAction {
    override func silentExecute() -> Bool {
        guard let message = spec["message"].string else {
            return false
        }
        
        let snackbar = MSnackbar()
        snackbar.text(message)
            .action(spec["onClose"].presence, screen, self)
            .position(spec["verticalPosition"].presence)
        MDCSnackbarManager.show(snackbar)
        
        return true
    }
}

class MSnackbar: MDCSnackbarMessage {
    func text(_ str: String) -> Self {
        text = str
        return self
    }
    
    func action(_ spec: Json?, _ screen: UIViewController, _ creator: JsonAction) -> Self {
        if let onClose = spec {
            let action = MDCSnackbarMessageAction()
            action.title = "CLOSE"
            action.handler = { () in
                MDCSnackbarManager.suspendAllMessages()
                JsonAction.execute(spec: onClose, screen: screen, creator: creator)
            }
            self.action = action
        }
        return self
    }
    
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
        
        MDCSnackbarManager.setBottomOffset(bottomOffset)
        return self
    }
}

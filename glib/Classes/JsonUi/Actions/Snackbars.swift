//import MaterialComponents.MaterialSnackbar
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
            .action(title: "Close", onClick: { _ in
                JsonAction.execute(spec: self.spec["onClose"], screen: self.screen, creator: self)
            })
            .position(spec["verticalPosition"].presence)
            .show()
        
        MSnackbar()
            .text("Server error")
            .action(title: "Retry", onClick: { _ in
            })
            .position("teT")
            .show()
        
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
            .action(title: "Close", onClick: { _ in
                JsonAction.execute(spec: self.spec["onClose"], screen: self.screen, creator: self)
            })
            .position(spec["verticalPosition"].presence)
            .show()
        
//        let snackbar = MSnackbar()
//        snackbar.text(message)
//            .action(spec["onClose"].presence, screen, self)
//            .position(spec["verticalPosition"].presence)
//        MDCSnackbarManager.default.show(snackbar)
        
        return true
    }
}

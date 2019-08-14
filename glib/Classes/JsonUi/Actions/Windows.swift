class JsonAction_Windows_OpenV1: JsonAction {
    override func silentExecute() -> Bool {
        nav.push(JsonUiScreen(url: spec["url"].stringValue))
        return true
    }
}

class JsonAction_Windows_CloseV1: JsonAction {
    override func silentExecute() -> Bool {
        CATransaction.begin()
        if let onClose = spec["onClose"].presence {
            CATransaction.setCompletionBlock {
                let previousScreen = self.nav.previousScreen() ?? self.screen
                JsonAction.execute(spec: onClose, screen: previousScreen, creator: self)
            }
        }
        nav.pop().done()
        CATransaction.commit()
        return true
    }
}

class JsonAction_Windows_CloseAllV1: JsonAction {
    override func silentExecute() -> Bool {
        nav.backToHome().done()
        JsonAction.execute(spec: spec["onClose"], screen: screen, creator: self)
        return true
    }
}

class JsonAction_Windows_ReloadV1: JsonAction {
    override func silentExecute() -> Bool {
        guard let currentScreen = screen as? JsonUiScreen else {
            return false
        }
        let url = spec["url"].string ?? currentScreen.getUrl()

        nav.pop(animated: false)
        nav.push(JsonUiScreen(url: url))

        return true
    }
}

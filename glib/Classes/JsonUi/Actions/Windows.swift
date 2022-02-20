class JsonAction_Windows_Open: JsonAction {
    override func silentExecute() -> Bool {
//        nav.push(JsonUiScreen(url: spec["url"].stringValue, hideBackButton: nav.isRoot()))
        
        CATransaction.begin()
        let nextScreen = JsonUiScreen(url: spec["url"].stringValue, hideBackButton: nav.isRoot())
        if let onOpen = spec["onOpen"].presence {
            CATransaction.setCompletionBlock {
                JsonAction.execute(spec: onOpen, screen: nextScreen, creator: self)
            }
        }
        nav.push(nextScreen)
        CATransaction.commit()
        return true
    }
}

class JsonAction_Windows_Close: JsonAction {
    override func silentExecute() -> Bool {
        guard let previousScreen = nav.previousScreen() as? JsonUiScreen else {
            GLog.w("Previous screen doesn't exist")
            return false
        }

        CATransaction.begin()
        if let onClose = spec["onClose"].presence {
            CATransaction.setCompletionBlock {
//                let previousScreen = self.nav.previousScreen() ?? self.screen
                JsonAction.execute(spec: onClose, screen: previousScreen, creator: self)
            }
        }
        nav.pop()
        CATransaction.commit()
        return true
    }
}

class JsonAction_Windows_CloseAll: JsonAction {
    override func silentExecute() -> Bool {
        nav.backToHome()
        JsonAction.execute(spec: spec["onClose"], screen: screen, creator: self)
        return true
    }
}

class JsonAction_Windows_Reload: JsonAction {
    override func silentExecute() -> Bool {
        guard let currentScreen = screen as? JsonUiScreen else {
            GLog.e("Current screen doesn't exist")
            return false
        }

        let url = spec["url"].string ?? currentScreen.url
        currentScreen.update(url: url, onLoad: {
            JsonAction.execute(spec: self.spec["onReload"], screen: self.screen, creator: self)
        })

        return true
    }
}

class JsonAction_Windows_CloseWithReload: JsonAction {
    override func silentExecute() -> Bool {
        guard let previousScreen = nav.previousScreen() as? JsonUiScreen else {
            GLog.w("Previous screen doesn't exist")
            return false
        }

        CATransaction.begin()
        CATransaction.setCompletionBlock {
            previousScreen.update(url: previousScreen.url, onLoad: {
                //JsonAction.execute(spec: self.spec["onReload"], screen: self.screen, creator: self)
            })
        }
        nav.pop()
        CATransaction.commit()
        return true
    }
}

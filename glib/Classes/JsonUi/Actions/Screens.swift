// Deprecated. Use "windows/*" instead.
class JsonAction_Screens_CloseV1: JsonAction {
    override func silentExecute() -> Bool {
        nav.pop()
        return true
    }
}

class JsonAction_Screens_CloseAllV1: JsonAction {
    override func silentExecute() -> Bool {
        nav.backToHome()
        JsonAction.execute(spec: spec["onClose"], screen: screen, creator: self)
        return true
    }
}

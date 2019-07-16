class JsonAction_Auth_SaveCsrfTokenV1: JsonAction {
    private let csrfToken = "__csrfToken"

    override func silentExecute() -> Bool {
        UserDefaults.standard.set(spec["token"], forKey: csrfToken)
        JsonAction.execute(spec: spec["onSave"], screen: screen, creator: self)
        return true
    }
}

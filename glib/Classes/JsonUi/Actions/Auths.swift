class JsonAction_Auth_SaveCsrfToken: JsonAction {
    override func silentExecute() -> Bool {
        GLog.t("Storing \(spec["token"].string)")
        GAuth.csrfToken = spec["token"].string
        JsonAction.execute(spec: spec["onSave"], screen: screen, creator: self)
        return true
    }
}

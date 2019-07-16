class JsonAction_Auth_SaveCsrfTokenV1: JsonAction {
//    private let csrfToken = "__csrfToken"

    override func silentExecute() -> Bool {
        GLog.t("Storing \(spec["token"].string)")
//        UserDefaults.standard.set(spec["token"], forKey: csrfToken)
        DbJson.instance.set(spec["token"], forKey: GKeys.Db.csrfToken)
        JsonAction.execute(spec: spec["onSave"], screen: screen, creator: self)
        return true
    }
}

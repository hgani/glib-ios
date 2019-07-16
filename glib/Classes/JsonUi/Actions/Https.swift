class JsonAction_Http_DeleteV1: JsonAction {
    override func silentExecute() -> Bool {
        Rest.delete(url: spec["url"].stringValue).execute { response in
            JsonAction.execute(spec: response.content["onResponse"], screen: self.screen, creator: self)
            return true
        }

        return true
    }
}

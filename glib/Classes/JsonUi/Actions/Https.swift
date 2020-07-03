class JsonAction_Http_DeleteV1: JsonAction {
    override func silentExecute() -> Bool {
        Rest.delete(url: spec["url"].stringValue).execute { response in
            JsonAction.execute(spec: response.content["onResponse"], screen: self.screen, creator: self)
            return true
        }

        return true
    }
}

class JsonAction_Http_PostV1: JsonAction {
    override func silentExecute() -> Bool {
        let params: GParams = spec["formData"].dictionaryObject ?? GParams()
        Rest.post(url: spec["url"].stringValue, params: params).execute { response in
            JsonAction.execute(spec: response.content["onResponse"], screen: self.screen, creator: self)
            return true
        }
        
        return true
    }
}

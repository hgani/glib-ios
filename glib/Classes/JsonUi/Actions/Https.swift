class JsonAction_Http_Delete: JsonAction {
    override func silentExecute() -> Bool {
        var params: GParams = spec["formData"].dictionaryObject ?? GParams()
        params["authenticity_token"] = GAuth.csrfToken

        Rest.delete(url: spec["url"].stringValue, params: params).execute { response in
            JsonAction.execute(spec: response.content["onResponse"], screen: self.screen, creator: self)
            return true
        }

        return true
    }
}

class JsonAction_Http_Post: JsonAction {
    override func silentExecute() -> Bool {
        var params: GParams = spec["formData"].dictionaryObject ?? GParams()
        params["authenticity_token"] = GAuth.csrfToken

        Rest.post(url: spec["url"].stringValue, params: params).execute { response in
            JsonAction.execute(spec: response.content["onResponse"], screen: self.screen, creator: self)
            return true
        }
        
        return true
    }
}

class JsonAction_Http_Patch: JsonAction {
    override func silentExecute() -> Bool {
        var params: GParams = spec["formData"].dictionaryObject ?? GParams()
        params["authenticity_token"] = GAuth.csrfToken

        Rest.patch(url: spec["url"].stringValue, params: params).execute { response in
            JsonAction.execute(spec: response.content["onResponse"], screen: self.screen, creator: self)
            return true
        }

        return true
    }
}

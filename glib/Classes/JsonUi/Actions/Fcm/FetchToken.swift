
import FirebaseMessaging

//class JsonAction_Windows_Open: JsonAction {
//    override func silentExecute() -> Bool {
//        nav.push(JsonUiScreen(url: spec["url"].stringValue, hideBackButton: nav.isRoot()))
//        return true
//    }
//}

#if INCLUDE_FIREBASE

class JsonAction_Fcm_FetchToken: JsonAction {
    override func silentExecute() -> Bool {
        Messaging.messaging().token { token, error in
          if let error = error {
            print("Error fetching FCM registration token: \(error)")
          } else if let token = token {
            print("FCM registration token: \(token)")
            
            let parameterizedSpec = self.spec["onFetch"].mergeFormDataParam(
                key: self.spec["paramNameForToken"].string ?? "token", value: token
            )
            JsonAction.execute(spec: parameterizedSpec, screen: self.screen, creator: self)
          }
        }

        return true
    }
}

#endif

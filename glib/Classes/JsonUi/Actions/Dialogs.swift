#if INCLUDE_MDLIBS

import MaterialComponents.MaterialDialogs
import MaterialComponents.MaterialSnackbar
import MaterialComponents.MaterialActionSheet

class JsonAction_Dialogs_Alert: JsonAction {
    override func silentExecute() -> Bool {
        guard let message = spec["message"].string else {
            return false
        }

        let alertController = MDCAlertController(title: "", message: message)
        alertController.addAction(MDCAlertAction(title: "OK") { _ in JsonAction.execute(spec: self.spec["onClose"], screen: self.screen, creator: self) })
        screen.present(alertController, animated: true, completion: nil)

        return true
    }
}

class JsonAction_Dialogs_Snackbar: JsonAction {
    override func silentExecute() -> Bool {
        guard let message = spec["message"].string else {
            return false
        }

        let action = MDCSnackbarMessageAction()
        action.title = "CLOSE"
        action.handler = { () in
            MDCSnackbarManager.suspendAllMessages()
        }

        let snackbar = MDCSnackbarMessage()
        snackbar.text = message
        snackbar.action = action
        MDCSnackbarManager.show(snackbar)

        return true
    }
}

class JsonAction_Dialogs_Options: JsonAction {
    override func silentExecute() -> Bool {
        guard let buttons = spec["buttons"].array else { return false }
        let message = spec["message"].string
        let sheet = MDCActionSheetController(title: nil, message: message)
        for button in buttons {
            let action = MDCActionSheetAction(title: button["text"].stringValue, image: nil) { (_) in
                JsonAction.execute(spec: button["onClick"], screen: self.screen, creator: self)
            }
            sheet.addAction(action)
        }
        screen.present(sheet, animated: true, completion: nil)

        return true
    }
}

class JsonAction_Dialogs_Open: JsonAction {
    private let dialogTransitionController = MDCDialogTransitionController()

    override func silentExecute() -> Bool {
        guard let url = spec["url"].string else { return false }

        let dialogController = JsonUiScreen(url: url, contentOnly: true)
        dialogController.modalPresentationStyle = .custom
        dialogController.transitioningDelegate = dialogTransitionController
        screen.present(dialogController, animated: true, completion: nil)

        return true
    }
}

#endif



#if INCLUDE_OAUTH

import FBSDKCoreKit
import FBSDKLoginKit

class JsonAction_Dialogs_Oauth: JsonAction {
    override func silentExecute() -> Bool {
        if spec["provider"]["name"].stringValue == "facebook" {
            Settings.appID = spec["provider"]["clientId"].stringValue
            let loginManager = LoginManager()
            
            loginManager.logIn(permissions: spec["provider"]["permissions"].stringValue.components(separatedBy: ","), from: screen) { (result, error) in
                if let fbError = error {
                    GLog.e("Error Facebook Login", error: fbError)
                } else if let fbResult = result, !fbResult.isCancelled, let token = fbResult.token {
                    var onSuccessSpec = self.spec["onSuccess"]
                    
                    do {
                        try onSuccessSpec["formData"].merge(with: [
                            "provider": "facebook",
                            "uid": token.userID,
                            "credentials[expires]": true,
                            "credentials[expires_at]": token.expirationDate.timeIntervalSince1970,
                            "credentials[token]": token.tokenString
                        ])
                    } catch {
                        GLog.e("Error formData json merge")
                    }
                    
                    JsonAction.execute(spec: onSuccessSpec, screen: self.screen, creator: self)
                }
            }
        }
        
        return true
    }
}

#endif

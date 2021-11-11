#if INCLUDE_MDLIBS

import MaterialComponents.MaterialDialogs
import MaterialComponents.MaterialSnackbar
import MaterialComponents.MaterialActionSheet

class JsonAction_Dialogs_Alert: JsonAction {
    override func silentExecute() -> Bool {
        guard let message = spec["message"].string else {
            return false
        }
        
        // TODO: Reuse static method
        let alertController = MDCAlertController(title: "", message: message)
        alertController.mdc_dialogPresentationController?.dismissOnBackgroundTap = false
        alertController.addAction(MDCAlertAction(title: "OK") { _ in JsonAction.execute(spec: self.spec["onClose"], screen: self.screen, creator: self) })
        screen.present(alertController, animated: true, completion: nil)

        return true
    }
    
    static func show(message: String, screen: UIViewController, onCloseSpec: Json? = nil, jsonAction: JsonAction? = nil) {
        let alertController = MDCAlertController(title: "", message: message)
        alertController.mdc_dialogPresentationController?.dismissOnBackgroundTap = false
        alertController.addAction(
            MDCAlertAction(title: "OK") { _ in
                if let spec = onCloseSpec {
                    JsonAction.execute(spec: spec, screen: screen, creator: jsonAction?.targetView)
                }
            }
        )
        screen.present(alertController, animated: true, completion: nil)
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
            MDCSnackbarManager.default.suspendAllMessages()
        }

        let snackbar = MDCSnackbarMessage()
        snackbar.text = message
        snackbar.action = action
        MDCSnackbarManager.default.show(snackbar)

        return true
    }
}

class JsonAction_Dialogs_Open: JsonAction {
    private let dialogTransitionController = MDCDialogTransitionController()

    override func silentExecute() -> Bool {
        guard let url = spec["url"].string else { return false }

        let dialogController = JsonUiScreen(url: url, contentOnly: true)
//        let dialogController = TestJsonUiDialog()
        dialogController.modalPresentationStyle = .custom
        dialogController.transitioningDelegate = dialogTransitionController

        if let mdcPresentationController = dialogController.presentationController as? MDCDialogPresentationController {
            mdcPresentationController.dismissOnBackgroundTap = false
        }

        screen.present(dialogController, animated: true, completion: nil)

        return true
    }
}

// See https://material.io/components/dialogs/ios#alert-dialog
// https://github.com/material-components/material-components-ios/blob/develop/components/Dialogs/examples/DialogsCustomShadowExampleViewController.swift
class TestJsonUiDialog: UIViewController {
    private let container = GVerticalPanel()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .red
        view.addSubview(container)

        container.snp.makeConstraints { make in
            make.centerX.equalTo(view)
            make.width.equalTo(view)

            make.top.equalTo(view)
            make.bottom.equalTo(view)
        }
        container.append(GLabel().text("TEST"))
    }

    override var preferredContentSize: CGSize {
      get {
        return CGSize(width:200.0, height:140.0);
      }
      set {
        super.preferredContentSize = newValue
      }
    }
}

class JsonAction_Dialogs_ShowV1: JsonAction {
    private let dialogTransitionController = MDCDialogTransitionController()
    
    override func silentExecute() -> Bool {
        let dialogScreen = JsonScreen(spec: spec)
        dialogScreen.modalPresentationStyle = .custom
        dialogScreen.transitioningDelegate = dialogTransitionController
        screen.present(dialogScreen, animated: true, completion: nil)
        
        return true
    }
}

class JsonAction_Dialogs_Close: JsonAction {
    override func silentExecute() -> Bool {
        guard let currentScreen = nav.currentScreen() as? JsonUiScreen else {
            GLog.w("Current screen doesn't exist")
            return false
        }

        if var rootScreen = UIApplication.shared.keyWindow?.rootViewController {
            while let presentedScreen = rootScreen.presentedViewController {
                rootScreen = presentedScreen
            }
            rootScreen.dismiss(animated: true, completion: {
                JsonAction.execute(spec: self.spec["onClose"], screen: currentScreen, creator: self)
            })
        }
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

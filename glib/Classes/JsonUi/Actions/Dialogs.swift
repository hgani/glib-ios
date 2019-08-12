import MaterialComponents.MaterialDialogs
import MaterialComponents.MaterialSnackbar

class JsonAction_Dialogs_AlertV1: JsonAction {
    override func silentExecute() -> Bool {
        guard let message = spec["message"].string else {
            return false
        }

        let alertController = MDCAlertController(title: "", message: message)
        alertController.addAction(MDCAlertAction(title:"OK") { _ in JsonAction.execute(spec: self.spec["onClose"], screen: self.screen, creator: self) })
        screen.present(alertController, animated: true, completion: nil)

        return true
    }
}

class JsonAction_Dialogs_SnackbarV1: JsonAction {
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

class JsonAction_Dialogs_OptionsV1: JsonAction {
    override func silentExecute() -> Bool {
        guard let buttons = spec["buttons"].array else { return false }
        let message = spec["message"].string
        let sheet = UIAlertController(title: nil, message: message, preferredStyle: .actionSheet)
        for button in buttons {
            let action = UIAlertAction(title: button["text"].string, style: .default) { _ in
                JsonAction.execute(spec: button["onClick"], screen: self.screen, creator: self)
            }
            sheet.addAction(action)
        }
        screen.present(sheet, animated: true, completion: nil)

        return true
    }
}

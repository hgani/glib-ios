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

#if INCLUDE_MDLIBS

import MaterialComponents.MaterialActionSheet

class JsonAction_Sheets_Select: JsonAction {
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

#endif

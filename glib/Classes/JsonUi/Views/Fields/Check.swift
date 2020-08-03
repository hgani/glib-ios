#if INCLUDE_MDLIBS

import MBRadioCheckboxButton2

class JsonView_Fields_CheckV1: JsonView_AbstractField, SubmittableField, CheckboxButtonDelegate {
    private let checkbox = MCheckBox()

    var name: String?
    var value: String {
        return checkbox.isOn ? spec["value"].stringValue : (spec["uncheckValue"].string ?? "")
    }

    override func initView() -> UIView {
        self.name = spec["name"].string

//        self.registerToClosestForm(field: checkbox)

        return checkbox
            .delegate(self)
            .width(.matchParent)
            .title(spec["label"].stringValue)
    }

    func validate() -> Bool {
        return true
    }
    
    func chechboxButtonDidSelect(_ button: CheckboxButton) {
        updateJsonLogic(button)
    }
    
    func chechboxButtonDidDeselect(_ button: CheckboxButton) {
        updateJsonLogic(button)
    }
    
    func updateJsonLogic(_ checkbox: CheckboxButton) {
        do {
            if let fieldName = spec["name"].string {
                let isOn = checkbox.isOn ? "on" : ""
                try Generic.sharedInstance.formData.value.merge(with: Json(parseJSON:
                    """
                    { "\(fieldName)" : "\(isOn)" }
                    """
                ))
            }
        } catch {
            GLog.d("Invalid json")
        }
    }
}

#endif

//class JsonView_Fields_CheckV1: JsonView, SubmittableField {
//    private let panel = GSplitPanel().width(.matchParent)
//    private let switchView = GSwitch()
//
//    var name: String?
//    var value: String {
//        return switchView.isOn ? "1" : "0"
//    }
//
//    override func initView() -> UIView {
//        name = spec["name"].string
//
//        return panel.withViews(
//            left: GLabel().text(spec["label"].stringValue),
//            right: switchView.checked(spec["value"].stringValue == "1")
//        )
//    }
//}

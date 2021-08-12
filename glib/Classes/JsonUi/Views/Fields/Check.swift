#if INCLUDE_MDLIBS

import MBRadioCheckboxButton2

class JsonView_Fields_Check: JsonView_AbstractField, CheckboxButtonDelegate {
    private let checkbox = MCheckBox()

//    var name: String?
    override var value: String {
        return checkbox.isOn ? spec["checkValue"].stringValue : spec["uncheckValue"].stringValue
    }

    override func initView() -> UIView {
//        self.name = spec["name"].string

//        self.registerToClosestForm(field: checkbox)

        return checkbox
            .delegate(self)
            .width(.matchParent)
            .title(spec["label"].stringValue)
    }

//    func validate() -> Bool {
//        return true
//    }
    
    func chechboxButtonDidSelect(_ button: CheckboxButton) {
        updateJsonLogic()
    }
    
    func chechboxButtonDidDeselect(_ button: CheckboxButton) {
        updateJsonLogic()
    }

    private func updateJsonLogic() {
        self.processJsonLogic(view: self.checkbox)
    }
    
//    func updateJsonLogic(_ checkbox: CheckboxButton) {
//        if let form = closest(JsonView_Panels_Form.FormPanel.self, from: checkbox),
//            let fieldName = spec["name"].string {
//            let isOn = checkbox.isOn ? "on" : ""
//            updateFormData(form, fieldName, isOn)
//        }
//    }
}

#endif

//class JsonView_Fields_Switch: JsonView, SubmittableField {
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

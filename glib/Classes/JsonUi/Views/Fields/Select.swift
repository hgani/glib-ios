#if INCLUDE_UILIBS

import RSSelectionMenu

class JsonView_Fields_Select: JsonView_AbstractField {
//    private let textLabel = GLabel()
//    private let valueLabel = GLabel()
    private let chipField = MChipField()
    private let errorLabel = GLabel()

//    var name: String?
    override var value: String {
        if selectedOptions.count > 0 {
            return selectedOptions.map({ (option) -> String in
                return option.value
            }).joined(separator: ",")
        } else {
            return ""
        }
    }

    var selectedOptions: [OptionModel] = [] {
        didSet {
            for chip in chipField.chips {
                chipField.removeChip(chip)
            }
            
            for (index, option) in selectedOptions.enumerated() {
                chipField.addChip(MChip().text(option.text)
                    .addClearButton()
                    .onClearClick { (chip) in
                        self.selectedOptions.remove(at: index)
                        self.chipField.removeChip(chip)
                    }
                )
            }
        }
    }
    
    override func validate() -> Bool {
        errors(nil)
        if let validation = spec["validation"].presence {
            if let required = validation["required"].presence, value == "" {
                self.errors(required["message"].stringValue)
                return false
            }
        }
        return true
    }

    override func initView() -> UIView {
//        name = spec["name"].string

//        let textStrLabel = spec["label"].stringValue
//        textLabel.font(RobotoFonts.Style.regular.font, size: 14)
//        valueLabel.font(RobotoFonts.Style.regular.font, size: 14)
//
//        return GVerticalPanel()
//            .append(textLabel.text(textStrLabel), top: 10)
//            .append(valueLabel.text("Select \(textStrLabel)").onClick({ (sender) in
//                let selectionMenu = RSSelectionMenu(
//                    selectionType: (self.spec["multiple"].bool ?? false ? .Multiple : .Single),
//                    dataSource: self.spec["options"].arrayValue.map({ (option) -> OptionModel in
//                        if let text = option.string {
//                            return OptionModel(text: text, value: text)
//                        }
//                        else {
//                            return OptionModel(text: option["text"].stringValue,
//                                               value: option["value"].stringValue)
//                        }
//                    })) { (cell, option, indexPath) in
//                        cell.textLabel?.text = option.text
//                    }
////                selectionMenu.setSelectedItems(items: self.selectedOptions) { (name, index, selected, selectedItems) in }
//                selectionMenu.onDismiss = { self.selectedOptions = $0 }
//                selectionMenu.show(style: .Actionsheet(title: self.spec["label"].stringValue, action: "Done", height: nil), from: self.screen)
//            }), top: 5)

        let strongScreen = self.screen

        chipField.width(.matchParent)
            .placeholder(spec["label"].stringValue)
            .onClick { (field) in
                let selectionType: SelectionType = self.spec["multiple"].bool ?? false ? .Multiple : .Single
                let options = self.spec["options"].arrayValue.map({ (option) -> OptionModel in
                    if let text = option.string {
                        return OptionModel(text: text, value: text)
                    }
                    else {
                        return OptionModel(text: option["text"].stringValue, value: option["value"].stringValue)
                    }
                })
                let selectionMenu = RSSelectionMenu(selectionType: selectionType, dataSource: options) { (cell, option, indexPath) in
                    cell.textLabel?.text = option.text
                }
                selectionMenu.onDismiss = {
                    self.errors(nil)
                    self.selectedOptions = $0
                    self.chipField.clearTextInput()
                    self.chipField.textField.resignFirstResponder()
//                    self.updateJsonLogic()
                }
                selectionMenu.show(style: .Actionsheet(title: self.spec["label"].stringValue, action: "Done", height: nil), from: self.screen)
            }
            .onEdit { _ in
                self.processJsonLogic(view: self.chipField)
            }
        
        errorLabel.width(.matchParent)
            .color(.red)
            .font(RobotoFonts.Style.regular.font, size: 12)
            .paddings(top: 10, left: 12, bottom: 0, right: 0)
        
        return GVerticalPanel().append(chipField, top: 10).append(errorLabel)
    }
    
//    func updateJsonLogic() {
//        if let fieldName = spec["name"].string, let form = closest(JsonView_Panels_Form.FormPanel.self, from: chipField) {
//            updateFormData(form, fieldName, value)
//        }
//    }
    
    func errors(_ text: String?) -> Void {
        if let errorText = text {
            chipField.layer.borderColor = UIColor.red.cgColor
            errorLabel.text(errorText)
        } else {
            chipField.layer.borderColor = UIColor.lightGray.cgColor
            errorLabel.text("")
        }
    }
    
    class OptionModel: NSObject, UniqueProperty  {
        func uniquePropertyName() -> String {
            return "value"
        }
        
        var text: String
        var value: String

        init(text: String, value: String) {
            self.text = text
            self.value = value
        }
    }
}

#endif

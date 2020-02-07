#if INCLUDE_UILIBS

import RSSelectionMenu
import MaterialComponents.MaterialChips

class JsonView_Fields_SelectV1: JsonView, SubmittableField {
    private let textLabel = GLabel()
    private let valueLabel = GLabel()
    private let chipField = MChipField()

    var name: String?
    var value: String {
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
    
    func validate() -> Bool {
        return true
    }

    override func initView() -> UIView {
        name = spec["name"].string

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
        
        chipField.width(.matchParent)
            .placeholder(spec["label"].stringValue)
            .onClick { (field) in
                let selectionMenu = RSSelectionMenu(
                    selectionType: (self.spec["multiple"].bool ?? false ? .Multiple : .Single),
                    dataSource: self.spec["options"].arrayValue.map({ (option) -> OptionModel in
                        if let text = option.string {
                            return OptionModel(text: text, value: text)
                        }
                        else {
                            return OptionModel(text: option["text"].stringValue,
                                               value: option["value"].stringValue)
                        }
                    })) { (cell, option, indexPath) in
                        cell.textLabel?.text = option.text
                }
                selectionMenu.onDismiss = {
                    self.selectedOptions = $0
                    self.chipField.clearTextInput()
                    self.chipField.textField.resignFirstResponder()
                }
                selectionMenu.show(style: .Actionsheet(title: self.spec["label"].stringValue, action: "Done", height: nil), from: self.screen)
            }
        
        return chipField
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

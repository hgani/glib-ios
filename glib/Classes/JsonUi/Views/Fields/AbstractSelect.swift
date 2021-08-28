#if INCLUDE_UILIBS

import RSSelectionMenu

class JsonView_AbstractSelect: JsonView_AbstractField {
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

    func initSelect(value: String?) -> UIView {
        let options = self.spec["options"].arrayValue.map({ (option) -> OptionModel in
            if let text = option.string {
                return OptionModel(text: text, value: text)
            }
            else {
                return OptionModel(text: option["text"].stringValue, value: option["value"].stringValue)
            }
        })
        
        let selectionType: SelectionStyle = self.spec["multiple"].boolValue ? .multiple : .single
        self.selectedOptions = options.filter { $0.value == value }
          
        // Making sure only one option is selected is important for the timeZone field because some options map to
        // the same timeZone ID.
        if selectionType == .single, let firstOption = self.selectedOptions.first {
            self.selectedOptions = [firstOption]
        }

        chipField.width(.matchParent)
            .placeholder(spec["label"].stringValue)
            .onClick { (field) in
                let selectionMenu = RSSelectionMenu(selectionStyle: selectionType, dataSource: options) { (cell, option, indexPath) in
                    cell.textLabel?.text = option.text
                }
                selectionMenu.setSelectedItems(items: self.selectedOptions) { _, _, _, _ in
                    // Nothing to do
                }
                selectionMenu.onDismiss = {
                    self.errors(nil)
                    self.selectedOptions = $0
                    self.chipField.clearTextInput()
                    self.chipField.textField.resignFirstResponder()
                }
//                selectionMenu.show(style: .popover(sourceView: self.chipField, size: CGSize(width: 200, height: 300), arrowDirection: .down, hideNavBar: true), from: self.screen)
//                                selectionMenu.show(style: .alert(title: self.spec["label"].stringValue, action: "Done", height: nil), from: self.screen)
//                selectionMenu.show(style: .push, from: self.screen)
                    selectionMenu.show(from: self.screen)
                
                // Unfortunately this style doesn't allow users to cancel in single select mode
                // selectionMenu.show(style: .actionSheet(title: self.spec["label"].stringValue, action: "Done", height: nil), from: self.screen)
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
    
    func errors(_ text: String?) -> Void {
        if let errorText = text {
            chipField.layer.borderColor = UIColor.red.cgColor
            errorLabel.text(errorText)
        } else {
            chipField.layer.borderColor = UIColor.lightGray.cgColor
            errorLabel.text("")
        }
    }
    
    // TODO:
    // Support grouping (type == label)
    // Support divider (type == divider)
    // Use Custom Cells as described in https://github.com/rushisangani/RSSelectionMenu
    class OptionModel: Equatable  {
        static func == (lhs: JsonView_Fields_Select.OptionModel, rhs: JsonView_Fields_Select.OptionModel) -> Bool {
            return lhs.value == rhs.value
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

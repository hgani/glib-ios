import RSSelectionMenu

class JsonView_Fields_SelectV1: JsonView, SubmittableField {
    private let label = GLabel()

    var name: String?
    var value: String {
        if selectedOptions.count > 0 {
            return selectedOptions.map({ (option) -> String in
                return option.value
            }).joined(separator: ",")
        }
        else {
            return ""
        }
    }

    var selectedOptions: [OptionModel] = [] {
        didSet {
            let textLabel = spec["label"].stringValue
            if selectedOptions.count > 0 {
                label.text(selectedOptions.map({ (option) -> String in
                    return option.text
                }).joined(separator: ", "))
            }
            else {
                label.text("Select \(textLabel)")
            }
        }
    }

    override func initView() -> UIView {
        name = spec["name"].string

        let textLabel = spec["label"].stringValue

        return GVerticalPanel()
            .append(GLabel().text(textLabel), top: 10)
            .append(label.text("Select \(textLabel)").onClick({ (sender) in
                let selectionMenu = RSSelectionMenu(selectionStyle: .multiple,
                                                    dataSource: self.spec["options"].arrayValue.map({ (option) -> OptionModel in
                                                        return OptionModel(text: option["text"].stringValue, value: option["value"].stringValue)
                                                    })) { (cell, option, indexPath) in
                    cell.textLabel?.text = option.text
                }
                selectionMenu.setSelectedItems(items: self.selectedOptions) { (name, index, selected, selectedItems) in }
                selectionMenu.onDismiss = { self.selectedOptions = $0 }
                selectionMenu.show(style: .actionSheet(title: self.spec["label"].stringValue, action: "Done", height: nil), from: self.screen)
            }), top: 5)
    }

    class OptionModel: NSObject, UniquePropertyDelegate {
        var text: String
        var value: String

        init(text: String, value: String) {
            self.text = text
            self.value = value
        }

        func getUniquePropertyName() -> String {
            return "value"
        }
    }
}


open class JsonTableViewCell: GTableViewCustomCell {
    internal var content: GVerticalPanel!

    func initPanel(_ panel: GVerticalPanel) {
        content = panel
        append(content)
    }
}

open class JsonTemplate : GObject {
    public let spec: Json
    public let screen: GScreen

    // This constructor allows dynamic instantiation of child classes.
    public required init(_ spec: Json, _ screen: GScreen) {
        self.spec = spec
        self.screen = screen
    }

    func createCell(tableView: GTableView) -> GTableViewCell {
        let cell = tableView.cellInstance(of: JsonTableViewCell.self, style: .default) { newCell in
            newCell.initPanel(self.instantiatePanel())
        }
        initPanel(cell.content, spec: spec)
        return cell
    }

    func createPanel() -> GVerticalPanel {
        let panel = instantiatePanel()
        initPanel(panel, spec: spec["data"])
        return panel
    }

    open func instantiatePanel() -> GVerticalPanel {
        mustBeOverridden()
    }

    open func initPanel(_ panel: GVerticalPanel, spec _: Json) {
        mustBeOverridden()
    }

    public static func create(spec: Json, screen: GScreen) -> JsonTemplate? {
        if let klass = JsonUi.loadClass(name: spec["template"].stringValue, type: JsonTemplate.self) as? JsonTemplate.Type {
            return klass.init(spec, screen)
        }
        GLog.w("Failed loading template: \(spec)")
        return nil
    }
}

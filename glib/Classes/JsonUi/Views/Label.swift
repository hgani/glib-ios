import jsonlogic

class JsonView_Label: JsonView {
    let label = GLabel()

    override func initView() -> UIView {
        label.font(RobotoFonts.Style.regular.font, size: 14)

        ifColor(code: spec["color"].string) {
            label.color($0)
        }

        if let text = spec["text"].string {
            _ = label.text(text)
        }

        if let align = spec["textAlign"].string {
            switch align {
            case "center":
                label.align(.center)
            case "right":
                label.align(.right)
            default:
                label.align(.left)
            }
        }

        if let onClick = spec["onClick"].presence {
            label.specs(.link)
            label.onClick { (_) in
                JsonAction.execute(spec: onClick, screen: self.screen, creator: self.label)
            }
        }

        return label
    }

    override func applyStyleClass(_ styleClass: String) {
        if let decorator = JsonUiStyling.labels[styleClass] {
            decorator.decorate(label)
        }
    }
    
    override func didAttach(to parent: UIView) {
        if let form = closest(JsonView_Panels_Form.FormPanel.self, from: label) {
            form.formData.asObservable().subscribe { _ in
                if let showIf = self.spec["showIf"].rawString() {
                    do {
                        let jsonlogic = try JsonLogic(showIf)
                        let result: Bool = try jsonlogic.applyRule(to: form.formData.value.rawString())
                        self.label.isHidden = !result
                    } catch {
                        GLog.d("Invalid rule")
                    }
                }
            }
        }
    }
}

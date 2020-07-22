import jsonlogic

class JsonView_LabelV1: JsonView {
    private let label = GLabel()

    override func initView() -> UIView {
        label.font(RobotoFonts.Style.regular.font, size: 14)

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
        
        Generic.sharedInstance.formData.asObservable().subscribe { _ in
            if let showIf = self.spec["showIf"].rawString() {
                GLog.d(showIf)
                do {
                    let jsonlogic = try JsonLogic(showIf)
                    let result: Bool = try jsonlogic.applyRule(to: Generic.sharedInstance.formData.value.rawString())
                    self.label.isHidden = !result
                } catch {
                    GLog.d("Invalid rule")
                }
            }
        }

        return label
    }
}

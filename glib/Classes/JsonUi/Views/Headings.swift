import jsonlogic

class JsonView_Heading: JsonView {
    fileprivate let label = GLabel().width(.matchParent)

    override func initView() -> UIView {
        if let text = spec["text"].string {
            _ = label.text(text)
        }
        label.font(RobotoFonts.Style.bold.font, traits: .traitBold)

        return label
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

class JsonView_H1: JsonView_Heading {
    override func initView() -> UIView {
        super.initView()
        label.font(nil, size: 18, traits: .traitBold)
        return label
    }
}

class JsonView_H2: JsonView_Heading {
    override func initView() -> UIView {
        super.initView()
        label.font(nil, size: 16, traits: .traitBold)
        return label
    }
}

class JsonView_H2V3: JsonView_Heading {
    override func initView() -> UIView {
        super.initView()
        label.font(nil, size: 15, traits: .traitBold)
        return label
    }
}

class JsonView_H2V4: JsonView_Heading {
    override func initView() -> UIView {
        super.initView()
        label.font(nil, size: 14, traits: .traitBold)
        return label
    }
}

class JsonView_H2V5: JsonView_Heading {
    override func initView() -> UIView {
        super.initView()
        label.font(nil, size: 13, traits: .traitBold)
        return label
    }
}

class JsonView_H2V6: JsonView_Heading {
    override func initView() -> UIView {
        super.initView()
        label.font(nil, size: 12, traits: .traitBold)
        return label
    }
}

class JsonView_H3V1: JsonView_Heading {
    override func initView() -> UIView {
        super.initView()
        label.font(nil, size: 14, traits: .traitBold)
        return label
    }
}

class JsonView_H4V1: JsonView_Heading {
    override func initView() -> UIView {
        super.initView()
        label.font(nil, size: 13, traits: .traitBold)
        return label
    }
}

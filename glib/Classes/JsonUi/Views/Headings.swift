import jsonlogic

class JsonView_Heading: JsonView_AbstractLabel {
}

class JsonView_H1: JsonView_Heading {
    override func initView() -> UIView {
        super.initView()
        label.font(nil, size: 24, traits: .traitBold)
        applyStyleClass("h1")
        return label
    }
}

class JsonView_H2: JsonView_Heading {
    override func initView() -> UIView {
        super.initView()
        label.font(nil, size: 20, traits: .traitBold)
        applyStyleClass("h2")
        return label
    }
}

class JsonView_H3: JsonView_Heading {
    override func initView() -> UIView {
        super.initView()
        label.font(nil, size: 14, traits: .traitBold)
        applyStyleClass("h3")
        return label
    }
}

class JsonView_H4: JsonView_Heading {
    override func initView() -> UIView {
        super.initView()
        label.font(nil, size: 13, traits: .traitBold)
        applyStyleClass("h4")
        return label
    }
}

class JsonView_H5: JsonView_Heading {
    override func initView() -> UIView {
        super.initView()
        label.font(nil, size: 13, traits: .traitBold)
        applyStyleClass("h5")
        return label
    }
}

class JsonView_H6: JsonView_Heading {
    override func initView() -> UIView {
        super.initView()
        label.font(nil, size: 15, traits: .traitBold)
        applyStyleClass("h6")
        return label
    }
}

class JsonView_Fields_RadioGroupV1: JsonView, SubmittableField {
    private let panel = GVerticalPanel()
    private var selectedJsonRadio: JsonView_Fields_RadioV1?
    private var jsonRadios: [JsonView_Fields_RadioV1] = []

    var name: String?
    var value: String {
        return self.selectedJsonRadio?.value ?? ""
    }

    override func initView() -> UIView {
        name = spec["name"].stringValue
        let childViews = spec["childViews"].arrayValue

        for childSpec in childViews {
            if let jsonView = JsonView.create(spec: childSpec, screen: screen) {
                if let radio = jsonView as? JsonView_Fields_RadioV1 {
                    self.jsonRadios.append(radio)
                    radio.onClick { _ in self.updateSelectedRadio(radio) }
                    panel.append(radio.createView(), top: 10)
                }
                else {
                    panel.append(jsonView.createView(), top: 10)
                }
            }
        }

        return panel
    }

    private func updateSelectedRadio(_ jsonRadio: JsonView_Fields_RadioV1) {
        self.selectedJsonRadio = jsonRadio
        for radio in jsonRadios {
            if radio.value != self.selectedJsonRadio?.value {
                radio.checked(false)
            }
        }
    }
}
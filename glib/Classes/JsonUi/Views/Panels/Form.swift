import RxSwift

class JsonView_Panels_Form: JsonView {
    private let panel = FormPanel()

    override func initView() -> UIView {
        panel.jsonView = self

        JsonViewDefaultPanel.initPanel(panel, spec: spec, screen: screen)

        return panel
    }

    class FormPanel: GVerticalPanel {
        var formData = Variable(Json(parseJSON: "{}"))
        
        // NOTE: needs to be a weak var?
        fileprivate var jsonView: JsonView_Panels_Form!

        private var fields = [SubmittableField]()

        func addField(_ field: SubmittableField) {
            fields.append(field)
        }

        func submit() {
            var params = GParams()
            var errorsCount = 0

            for field in fields {
                if let fileField = field as? SubmittableFileField, let completed = fileField.completed {
                    if !completed {
                        jsonView.screen.launch.alert("Please wait...")
                        return
                    }
                }

                if !field.validate() {
                    errorsCount += 1
                }

                if let name = field.name {
                    if name.hasSuffix("[]") {
                        if let oldArray = params[name] as? [String] {
                            var newArray = [String](oldArray)
                            newArray.append(field.value)
                            params[name] = newArray
                        } else {
                            params[name] = [field.value]
                        }
                    } else {
                        params[name] = field.value
                    }
                }
            }

            if errorsCount > 0 {
                return
            }

            Generic.sharedInstance.genericIsBusy.value = true

            let spec = jsonView.spec
            let screen = jsonView.screen
            _ = Rest.from(method: spec["method"].stringValue, url: spec["url"].stringValue, params: params)?.execute(
                indicator: .standard,
                localCache: false,
                onHttpFailure: { _ in
                    Generic.sharedInstance.genericIsBusy.value = false
                    return false
                }, onHttpSuccess: { response in
                    Generic.sharedInstance.genericIsBusy.value = false
                    JsonAction.execute(spec: response.content["onResponse"], screen: screen, creator: self)
                    return true
                })
        }
    }
}

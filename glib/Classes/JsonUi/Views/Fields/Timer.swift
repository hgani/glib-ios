class JsonView_Fields_Timer: JsonView_AbstractText {
//class JsonView_Fields_Timer: JsonView_AbstractField, SubmittableField {

//    var name: String?
//    var value: String {
//        return textField.text ?? ""
//    }

    private var valueInSeconds: Int = 0
    private var minValue: Int = 0
    private var maxValue: Int = 0

//    private var textField: MTextField!

    override func initView() -> UIView {
        let view = super.initTextField()

        valueInSeconds = spec["value"].intValue

        if let min = spec["min"].int {
            minValue = min
        }
        if let max = spec["max"].int {
            maxValue = max
        }

//        textField = MTextField(outlined: spec["styleClasses"].arrayValue.contains("outlined"))
//
//        // TODO: Remove
//        textField.width(.matchParent)
//
//        let controller = GViewController()
////        let controller = GScreen()
//        controller.view.translatesAutoresizingMaskIntoConstraints = false
//        controller.view.addSubview(textField)
//
//        controller.view.backgroundColor = .red
//
////            view.addSubview(container)
//        controller.view.snp.makeConstraints { make in
//                make.centerX.equalTo(textField)
////                make.width.equalTo(textField)
//
//            make.width.equalTo(200)
//
//                make.top.equalTo(textField)
//                make.bottom.equalTo(textField)
//            }
//
////        // TODO: Destroy timer
////        Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] _ in
//////            NSLog("adjustValue0")
//////            self?.adjustValue()
////
////                NSLog("adjustValue2")
////        }

        screen.scheduleTimer(intervalInSeconds: 1) {
            self.adjustValue()
            NSLog("adjustValue300")
        }

        return view
//        return controller.view
    }

    func adjustValue() {
        NSLog("adjustValue1")
        if spec["forward"].boolValue {
            if valueInSeconds < maxValue {
                valueInSeconds += 1
            }
        } else {
            if valueInSeconds > minValue {
                valueInSeconds -= 1
            }
        }

        text(String(valueInSeconds))
    }

//    func validate() -> Bool {
//        return true
//    }

}

//class GViewController: UIViewController {
//    override func viewWillAppear(_ animated: Bool) {
//        NSLog("viewWillAppear2")
//
//    }
//    override func viewWillDisappear(_ animated: Bool) {
//        NSLog("viewWillDisappear1")
//    }
//
//    override func viewDidDisappear(_ animated: Bool) {
//
//            NSLog("viewDidDisappear1")
//    }
//}

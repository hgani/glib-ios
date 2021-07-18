class JsonView_Fields_Timer: JsonView_AbstractText {
    private var valueInSeconds: Int = 0
    private var minValue: Int = -1000000
    private var maxValue: Int = 1000000

    override func initView() -> UIView {
        let view = super.initTextField()

        valueInSeconds = spec["value"].intValue

        if let min = spec["min"].int {
            minValue = min
        }
        if let max = spec["max"].int {
            maxValue = max
        }

        screen.scheduleTimer(intervalInSeconds: 1) {
            self.adjustValue()
        }

        return view
    }

    func adjustValue() {
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
}

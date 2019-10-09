import Charts

class JsonView_Charts_LineV1: JsonView {
    private var chartView = MLineChartView()

    override func initView() -> UIView {
        let data = LineChartData(dataSets: [])
        for series in spec["dataSeries"].arrayValue {
            var entries = [ChartDataEntry]()
            var index = 0
//            for (key, value) in series["dataPoints"].dictionaryValue {
//                // TODO: json value didn't loop in order
//                GLog.d("\(key) \(value.doubleValue)")
//                entries.append(ChartDataEntry(x: Double(index), y: value.doubleValue))
//                index = index + 1
//            }
            for point in series["dataPoints"].arrayValue {
                entries.append(ChartDataEntry(x: Double(index), y: point["y"].doubleValue))
                index = index + 1
            }
            let color = UIColor(red: .random(in: 0...1), green: .random(in: 0...1), blue: .random(in: 0...1), alpha: 1.0)
            let set = LineChartDataSet(entries: entries, label: series["title"].stringValue)
            set.mode = .cubicBezier
            set.setColor(color)
            set.setCircleColor(color)

            data.addDataSet(set)
        }
        chartView.width(.matchParent).height(300).data(data)

        return chartView
    }
}

class MLineChartView: LineChartView {
    fileprivate var helper: ViewHelper!

    init() {
        super.init(frame: .zero)
        initialize()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(frame: .zero)
        initialize()
    }

    private func initialize() {
        helper = ViewHelper(self)
    }

    public func width(_ width: Int) -> Self {
        helper.width(width)
        return self
    }

    public func width(_ width: LayoutSize) -> Self {
        helper.width(width)
        return self
    }

    public func height(_ height: Int) -> Self {
        helper.height(height)
        return self
    }

    public func height(_ height: LayoutSize) -> Self {
        helper.height(height)
        return self
    }

    public func data(_ data: LineChartData) -> Self {
        self.data = data
        return self
    }
}

import Charts

class JsonView_Charts_Column: JsonView {
    private var chartView = MBarChartView()
    
    override func initView() -> UIView {        
        chartView.width(.matchParent).height(200).fitBars(true).fitScreen()
        
        if let stacked = spec["stacked"].bool, stacked == true {
            var xEntries = [Double]()
            var yEntries = [[Double]]()
            var titles = [String]()
            var barColors = [UIColor]()
            
            for (dataIndex, data) in spec["dataGroups"].arrayValue.enumerated() {
                titles.append(data["title"].stringValue)
                barColors.append(UIColor(red: .random(in: 0...1), green: .random(in: 0...1), blue: .random(in: 0...1), alpha: 1.0))
                
                for point in data["points"].dictionaryValue {
                    if let index = xEntries.firstIndex(of: Double(point.key)!) {
                        yEntries[index].append(Double(point.value.intValue))
                    } else {
                        xEntries.append(Double(point.key)!)
                        yEntries.append([Double(point.value.intValue)])
                    }
                }
            }
            
            let yVals = xEntries.enumerated().map { (index, xEntry) -> BarChartDataEntry in
                return BarChartDataEntry(x: xEntry, yValues: yEntries[index])
            }
            let set = BarChartDataSet(values: yVals, label: "")
            set.drawIconsEnabled = false
            set.colors = barColors
            set.stackLabels = titles
            
            let data = BarChartData(dataSet: set)
            chartView.data(data)
        }
        else {
            var sets = [BarChartDataSet]()
            for (dataIndex, data) in spec["dataGroups"].arrayValue.enumerated() {
                var values = [BarChartDataEntry]()
                for point in data["points"].dictionaryValue {
                    values.append(BarChartDataEntry(x: Double(point.key)!, y: Double(point.value.intValue)))
                }
                
                let set = BarChartDataSet(values: values, label: data["title"].stringValue)
                set.setColor(UIColor(red: .random(in: 0...1), green: .random(in: 0...1), blue: .random(in: 0...1), alpha: 1.0))
                sets.append(set)
            }
            
            let data = BarChartData(dataSets: sets)
            data.barWidth = 0.25
            data.groupBars(fromX: sets[0].xMin, groupSpace: 0.1, barSpace: 0.05)
            
            chartView.xAxis.axisMinimum = sets[0].xMin
            chartView.xAxis.axisMaximum = sets[0].xMin + data.groupWidth(groupSpace: 0.1, barSpace: 0.05) * Double(sets.count)
            chartView.data = data
        }
        
        return chartView
    }
}

class MBarChartView: BarChartView {
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
    
    public func data(_ data: BarChartData) -> Self {
        self.data = data
        return self
    }
    
    public func fitBars(_ value: Bool) -> Self {
        self.fitBars = value
        return self
    }
}

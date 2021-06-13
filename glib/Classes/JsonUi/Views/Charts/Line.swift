#if INCLUDE_UILIBS

import Charts

class JsonView_Charts_Line: JsonView {
    private var chartView = GLineChartView()
    private let data = LineChartData(dataSets: [])
    
    override func initView() -> UIView {
        renderData(spec["dataSeries"].presence)
        fetchData(spec["nextPage"].presence)
        
        let chartFormatter = DateValueFormatter()
        let xAxis = XAxis()
        xAxis.valueFormatter = chartFormatter
        chartView.xAxis.valueFormatter = xAxis.valueFormatter
        chartView.width(.matchParent).height(200).data(data).fitScreen()
        
        return chartView
    }
    
    private func renderData(_ specDataSeries: Json?) {
        if let dataSeries = specDataSeries?.array {
            for series in dataSeries {
                var entries = [ChartDataEntry]()
                for point in series["points"].arrayValue {
                    entries.append(ChartDataEntry(x: timestamp(point["x"].stringValue),
                                                  y: point["y"].doubleValue))
                }
                let color = UIColor(red: .random(in: 0...1), green: .random(in: 0...1), blue: .random(in: 0...1), alpha: 1.0)
                let set = LineChartDataSet(values: entries, label: series["title"].stringValue)
                set.mode = .cubicBezier
                set.setColor(color)
                set.setCircleColor(color)
                data.addDataSet(set)
            }
            chartView.notifyDataSetChanged()
        }
    }
    
    private func fetchData(_ nextPage: Json?) {
        if let url = nextPage?["url"].string {
            Rest.get(url: url).execute { (response) -> Bool in
                self.renderData(response.content["dataSeries"].presence)
                self.fetchData(response.content["nextPage"].presence)
                return true
            }
        }
    }
    
    private func timestamp(_ dateStr: String) -> Double {
        let dateFormatterGet = DateFormatter()
        
        dateFormatterGet.dateFormat = "yyyy-MM-dd"
        if let date = try dateFormatterGet.date(from: dateStr) {
            return Double(date.timeIntervalSince1970)
        }
        
        dateFormatterGet.dateFormat = "EEE, dd MMM yyyy"
        if let date = try dateFormatterGet.date(from: dateStr) {
            return Double(date.timeIntervalSince1970)
        }
        
        return Double(0)
    }
}

public class DateValueFormatter: NSObject, IAxisValueFormatter {
    private let dateFormatterGet = DateFormatter()
    private let dateFormatterPrint = DateFormatter()
    
    public func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        let date = Date(timeIntervalSince1970: value)
        dateFormatterPrint.dateFormat = "MMM dd"
        return dateFormatterPrint.string(from: date)
    }
}

#endif

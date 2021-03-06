//
//  BarChartViewController.swift
//  SMEEI
//
//  Created by Mac19 on 15/01/21.
//
import Charts
import UIKit

class BarChartViewController: UIViewController, ChartViewDelegate {

    
    var barChart = BarChartView()
    var dataEntries : [Average] = []
    var dataDescription : String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        barChart.delegate = self
        barChart.animate(xAxisDuration: 2.5)
        //Setting chartDescription
        barChart.chartDescription?.text = dataDescription
        barChart.chartDescription?.font = UIFont(name: "Futura", size: 15)!
        barChart.chartDescription?.xOffset = barChart.frame.width + 140
        barChart.chartDescription?.yOffset = 350
        barChart.chartDescription?.textAlign = NSTextAlignment.center
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        barChart.frame = CGRect(x:0, y:0, width: self.view.frame.size.width, height: self.view.frame.size.width)
        barChart.center = view.center
        view.addSubview(barChart)
        
        var entries = [BarChartDataEntry]()
        for x in 0..<dataEntries.count{
            entries.append(BarChartDataEntry(x: Double(x), y: Double(dataEntries[x].average)))
        }
        let set = BarChartDataSet(entries: entries)
        set.colors = ChartColorTemplates.material()
        switch dataEntries.count {
        case 7:
            set.label = "Días"
        case 4...5:
            set.label = "Semanas"
        default:
            set.label = "Meses"
        }
        let data = BarChartData(dataSet: set)
        barChart.data = data    }
}

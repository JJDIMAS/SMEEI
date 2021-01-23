//
//  LineChartViewController.swift
//  SMEEI
//
//  Created by Mac19 on 15/01/21.
//
import Charts
import UIKit

class LineChartViewController: UIViewController, ChartViewDelegate {

    var lineChart = LineChartView()
    var dataEntries : [Average] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        lineChart.delegate = self
        // Do any additional setup after loading the view.
    }
    
    override func viewDidLayoutSubviews() {
        
        super.viewDidLayoutSubviews()
        lineChart.frame = CGRect(x:0, y:0, width: self.view.frame.size.width, height: self.view.frame.size.width)
        lineChart.center = view.center
        view.addSubview(lineChart)
        
        var entries = [ChartDataEntry]()
        for x in 0..<dataEntries.count{
            entries.append(ChartDataEntry(x: Double(x), y: Double(dataEntries[x].average)))
        }
        let set = LineChartDataSet(entries: entries)
        set.colors = ChartColorTemplates.material()
        switch dataEntries.count {
        case 7:
            set.label = "Días"
        case 4...5:
            set.label = "Semanas"
        default:
            set.label = "Meses"
        }
        let data = LineChartData(dataSet: set)
        lineChart.data = data
        
    }

}

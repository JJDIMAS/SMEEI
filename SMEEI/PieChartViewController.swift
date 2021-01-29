//
//  PieChartViewController.swift
//  SMEEI
//
//  Created by Mac19 on 15/01/21.
//
import Charts
import UIKit

class PieChartViewController: UIViewController, ChartViewDelegate {

    var pieChart = PieChartView()
    var dataEntries : [Average] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        pieChart.delegate = self
        pieChart.animate(xAxisDuration: 2.5)        // Do any additional setup after loading the view.
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        pieChart.frame = CGRect(x:0, y:0, width: self.view.frame.size.width, height: self.view.frame.size.width)
        pieChart.center = view.center
        view.addSubview(pieChart)
        
        var entries = [ChartDataEntry]()
        for x in 0..<dataEntries.count{
            entries.append(ChartDataEntry(x: Double(x), y: Double(dataEntries[x].average)))
        }
        let set = PieChartDataSet(entries: entries)
        set.colors = ChartColorTemplates.material()
        switch dataEntries.count {
        case 7:
            set.label = "Días"
        case 4...5:
            set.label = "Semanas"
        default:
            set.label = "Meses"
        }
        let data = PieChartData(dataSet: set)
        pieChart.data = data
        
    }

}

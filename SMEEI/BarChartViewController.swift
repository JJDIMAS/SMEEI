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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        barChart.delegate = self
        // Do any additional setup after loading the view.
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        barChart.frame = CGRect(x:0, y:0, width: self.view.frame.size.width, height: self.view.frame.size.width)
        barChart.center = view.center
        view.addSubview(barChart)
        
        var entries = [BarChartDataEntry]()
        for x in 0..<10{
            entries.append(BarChartDataEntry(x: Double(x), y: Double(x)))
        }
        let set = BarChartDataSet(entries: entries)
        set.colors = ChartColorTemplates.material()
        let data = BarChartData(dataSet: set)
        barChart.data = data    }
}

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
        print("LineCV: \(dataEntries.count)")
        //prueba.AllData()
        //print("Mi view me dice: \(prueba.dataEntries)")
        // Do any additional setup after loading the view.
    }
    
    override func viewDidLayoutSubviews() {
        
        super.viewDidLayoutSubviews()
        lineChart.frame = CGRect(x:0, y:0, width: self.view.frame.size.width, height: self.view.frame.size.width)
        lineChart.center = view.center
        view.addSubview(lineChart)
        
        var entries = [ChartDataEntry]()
        for x in 0..<10{
            entries.append(ChartDataEntry(x: Double(x), y: Double(10)))
        }
        let set = LineChartDataSet(entries: entries)
        set.colors = ChartColorTemplates.material()
        let data = LineChartData(dataSet: set)
        lineChart.data = data
        
    }

}

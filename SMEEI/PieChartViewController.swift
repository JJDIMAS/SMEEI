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
    var dataDescription : String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        pieChart.delegate = self
        pieChart.animate(xAxisDuration: 2.5)
        
        //Setting chartDescription
        pieChart.chartDescription?.text = dataDescription
        pieChart.chartDescription?.font = UIFont(name: "Futura", size: 15)!
        pieChart.chartDescription?.xOffset = pieChart.frame.width + 160
        pieChart.chartDescription?.yOffset = 0
        pieChart.chartDescription?.textAlign = NSTextAlignment.center
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        pieChart.frame = CGRect(x:80, y:80, width: self.view.frame.size.width, height: self.view.frame.size.width)
        pieChart.center = view.center
        view.addSubview(pieChart)
        view.sendSubviewToBack(pieChart)
        
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

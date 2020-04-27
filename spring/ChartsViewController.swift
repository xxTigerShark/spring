//
//  ChartsViewController.swift
//  spring
//
//  Created by Kevin on 4/22/20.
//  Copyright © 2020 Kevin Makens. All rights reserved.
//

import UIKit
import Charts

class ChartsViewController: UIViewController {
	@IBOutlet var mainChart: LineChartView?
	@IBOutlet var compChart: LineChartView?

	private var posC = [Double]()
	private var pos = [Double]()
	private var multi = 5

	// MARK: View Did Load
    override func viewDidLoad() {
		// Retrieves data from NSUserDefaults for position arrays
		pos = UserDefaults.standard.array(forKey: "pos") as! [Double]
		posC = UserDefaults.standard.array(forKey: "posC") as! [Double]
		print(pos)
        super.viewDidLoad()
		
		// Calls set up methods for theory and actual
		setUp()
		getData()
    }
    
	// Closes view
	@IBAction func close()
	{
		self.dismiss(animated: true, completion: {
			//NotificationCenter.default.post(name: Notification.Name(rawValue: "close"), object: nil)
		})
	}

	// Retrieves data and processes to display on a line chart before displaying on line chart
	func getData()
	{
		let data = DataProcessing()
		let spring = Double(UserDefaults.standard.float(forKey: "sl1"))
		let damping = Double(UserDefaults.standard.float(forKey: "sl2"))
		let height = Double(UserDefaults.standard.float(forKey: "sl3"))*12.5*1.45
		let vals = data.beginProcess(m: 6.0*1.45*Double(1), c: damping*Double(multi)*1.45, k: spring*Double(multi), xStart: height, time: Double(pos.count/60), count: pos.count*40)
		print(vals)
		
		compChart?.backgroundColor = UIColor.clear
		
		
		// Sets data for bar chart and colors.
		var entries = [ChartDataEntry]()
		for val in 0...(vals.count-1)
		{
			if val % 40 == 0
			{
				entries.append(ChartDataEntry(x: Double(val), y: vals[val]))
			}
		}
		
		let chartDataSet = LineChartDataSet(entries: entries, label: "Theory")
		chartDataSet.circleRadius = 0
		chartDataSet.circleHoleRadius = 0
		chartDataSet.drawValuesEnabled = false
		let chartData = LineChartData(dataSets: [chartDataSet])
		compChart!.data = chartData
		compChart!.xAxis.drawLabelsEnabled = false
		compChart!.leftAxis.drawLabelsEnabled = false
		compChart!.rightAxis.drawLabelsEnabled = false
	}
	
	// Creates calculation based on Euler Cromer
	// data and processes to display on a line chart
	// before displaying on line chart.
	// Euler Cromer method is found in DataProcessing.
	func setUp()
	{
		mainChart?.backgroundColor = UIColor.clear
		
		
		// Sets data for bar chart and colors.
		var entries = [ChartDataEntry]()
		for val in 0...(pos.count-1)
		{
			entries.append(ChartDataEntry(x: Double(val), y: pos[val]))
		}
		
		let chartDataSet = LineChartDataSet(entries: entries, label: "Actual")
		chartDataSet.circleRadius = 0
		chartDataSet.circleHoleRadius = 0
		chartDataSet.drawValuesEnabled = false
		let chartData = LineChartData(dataSets: [chartDataSet])
		mainChart!.data = chartData
		mainChart!.xAxis.drawLabelsEnabled = false
		mainChart!.leftAxis.drawLabelsEnabled = false
		mainChart!.rightAxis.drawLabelsEnabled = false
		
	}
}

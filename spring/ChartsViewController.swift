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
	private var posC = [Double]()
	private var pos = [Double]()

    override func viewDidLoad() {
		pos = UserDefaults.standard.array(forKey: "pos") as! [Double]
		posC = UserDefaults.standard.array(forKey: "posC") as! [Double]
		print(pos)
        super.viewDidLoad()
		setUp()
        // Do any additional setup after loading the view.
    }
    
	@IBAction func close()
	{
		self.dismiss(animated: true, completion: {
			NotificationCenter.default.post(name: Notification.Name(rawValue: "close"), object: nil)
		})
	}

	
	func setUp()
	{
		mainChart?.backgroundColor = UIColor.clear
		
		
		// Sets data for bar chart and colors.
		var entries = [ChartDataEntry]()
		for val in 0...(pos.count-1)
		{
			entries.append(ChartDataEntry(x: Double(val), y: pos[val]))
		}
		
		let chartDataSet = LineChartDataSet(entries: entries, label: nil)
		chartDataSet.circleRadius = 0
		chartDataSet.circleHoleRadius = 0
		chartDataSet.drawValuesEnabled = false
		let chartData = LineChartData(dataSets: [chartDataSet])
		mainChart!.data = chartData
	}
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

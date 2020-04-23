//
//  DataProcessing.swift
//  spring
//
//  Created by Kevin on 4/22/20.
//  Copyright © 2020 Kevin Makens. All rights reserved.
//

import Foundation

public class data
{
	public func beginProcess(m: Double, c: Double, k: Double, xStart: Double, time: Double) -> [Double]
	{
		var y = [Double]()
		let x: Double = 0.0
		let y2: Double = 0.0
		 
		let x0: Double = 0.0
		let x1: Double = 10.0
		let dx: Double = 0.1
		 
		let n = Int(1 + (x1 - x0) / dx)
		 
		y.append(1)
		for i in 1..<n {
			y.append(rk4(dx: dx, x: x0 + dx * (Double(i) - 1), y: y[i - 1]) { (x: Double, y: Double) -> Double in
				return x * sqrt(y)
			})
		}
		
		return [0,1]
	}
	
	func rk4(dx: Double, x: Double, y: Double, f: (Double, Double) -> Double) -> Double {
		let k1 = dx * f(x, y)
		let k2 = dx * f(x + dx / 2, y + k1 / 2)
		let k3 = dx * f(x + dx / 2, y + k2 / 2)
		let k4 = dx * f(x + dx, y + k3)
	 
		return y + (k1 + 2 * k2 + 2 * k3 + k4) / 6
	}
	
	
	func f(y: [Double], t: [Double]) -> [Double]
	{
		return [y[1], y[2] - y[1]]
	}
}

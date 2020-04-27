//
//  DataProcessing.swift
//  spring
//
//  Created by Kevin on 4/22/20.
//  Copyright © 2020 Kevin Makens. All rights reserved.
//

import Foundation
import Accelerate
import LASwift

public class DataProcessing
{
	var mass : Double = 0
	var damping : Double = 0
	var spring : Double = 0
	
	public func beginProcess(m: Double, c: Double, k: Double, xStart: Double, time: Double, count:Int) -> [Double]
	{
		mass = m
		damping = c
		spring = k
		
		let x0 = xStart
		let y0 = 2
		let vals = ab2(x0: Double(x0), y0: Double(y0), dt: 1/600, count: count)
		
		return vals
	}
	
	func ab2(x0: Double, y0: Double, dt: Double, count:Int) -> [Double]
	{
		// Sets time array t
		var t = zeros(count)
		for i in 0...t.count-2
		{
			t[i+1] = t[i] + dt
		}
		
		// sets n
		let n = t.count-1
		
		// sets vectors
		var x = zeros(n);
		var y = zeros(n);
		
		// Initial conditions
		x[0] = x0;
		y[0] = y0;

		// Step equations forward in time
		// Euler-Cromer
		for i in 0...n-2
		{
			let v1 = spring*(y[i])
			let v2 = (-1*damping*(x[i]) - v1)
			x[i+1] = x[i] + (dt * (1/mass) * v2)
			y[i+1] = y[i] + dt*x[i+1];
		}
		
		// processes data to verify if data collected is correct.
		var b = Vector()
		var belowZ = false
		for i in x
		{
			if i <= 0
			{
				belowZ = true
			}
			
			if belowZ == true
			{
				b.append(i)
			}
		}
		
		return b
	}
}

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
		var t = zeros(count)
		for i in 0...t.count-2
		{
			t[i+1] = t[i] + dt
		}
		
		let n = t.count-1
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
	
//	func f(y: Vector, t: Double) -> Matrix
//	{
//		return zeros(0)
//	}
}

/*
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

var rowIndices: [Int32] = [0, 1,	// Column 0
0, 1]	// Column 1

var values = [0, 1.0,						// Column 0
-1*spring/mass, damping/mass]	// Column 1

var columnStarts = [0,    // Column 0
2]    // Column 1


var structure = SparseMatrixStructure(rowCount: 2,
columnCount: 2,
columnStarts: &columnStarts,
rowIndices: &rowIndices,
attributes: SparseAttributes_t(),
blockSize: 1)
let A = SparseMatrix_Double(structure: structure, data: &values)

rowIndices = [0, 1]	// Column 0

values = [0, 1.0]
columnStarts = [0]    // Column 1


structure = SparseMatrixStructure(rowCount: 2,
columnCount: 1,
columnStarts: &columnStarts,
rowIndices: &rowIndices,
attributes: SparseAttributes_t(),
blockSize: 1)
let x = SparseMatrix_Double(structure: structure, data: &values)


// Initial Condition
//		x[col: 0] = x0
//
//		// 1 Euler Step (this is cheap and possibly bad)
//		var fn = f(y: x[col:0], t: t[0])
//		x[col:1] = x[col:0] + h * fn
//
//		// AB2 the rest
//		for i in 1...n-1//i = 1:n-1
//		{
//			let fn_m1 = fn
//			fn = f(y: x[col:i], t: t[i])
//			x[col:i+1] = x[col:i] + h/2 .* ( 3 .* fn - fn_m1 )
//		}
//		return x
*/

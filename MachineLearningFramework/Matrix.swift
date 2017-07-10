//
//  Matrix.swift
//  MachineLearningFramework
//
//  Created by Yuma Antoine Decaux on 21/11/16.
//  Copyright © 2016 antoxicon. All rights reserved.
//

import Foundation
import Accelerate

struct Matrix{
	var grid:[Double]
	let n:Int!, m:Int!, count:Int!

	init(_ M: [String: [Any?]], _ bias: Bool){
		grid = [Double]()
		m = M.keys.count
		n = M[M.keys.first!]!.count
		count = n*m
		if bias{
			let zeros = [Double](repeating: 0.0, count: count)
			grid += zeros
		}
		for key in M.keys{
			grid += M[key] as! [Double]
		}
		var result = [Double](repeating: 0.0, count: count)
		vDSP_mtransD(grid, 1, &result, 1, UInt(n), UInt(m))
	}

	init(_ grid: [Double], _ n: Int, _ m: Int){
		self.grid = grid
		self.n = n
		self.m = m
		self.count = n*m
	}

	//Mark: Validation tools

	func isValid(row: Int, column: Int)->Bool{
		return row >= -1 && row < n && column >= 0 && column < m
	}

	//Mark: Vector operation

	func addVector(other: Matrix)->Matrix{
		var result = [Double](repeating: 0.0, count: count)
		vDSP_vsdivD(grid, 1, other.grid, &result, 1, UInt(count))
		return Matrix(result, n, m)
	}

	func subVector(other: Matrix)->Matrix{
		var result = [Double](repeating: 0.0, count: count)
		vDSP_vsubD(grid, 1, other.grid, 1, &result, 1, UInt(count))
		return Matrix(result, n, m)
	}

	func multVector(other: Matrix)->Matrix{
		var result = [Double](repeating: 0.0, count: count)
		vDSP_vmulD(grid, 1, other.grid, 1, &result, 1, UInt(count))
		return Matrix(result, n, m)
	}

	func divVector(other: Matrix)->Matrix{
		var result = [Double](repeating: 0.0, count: count)
		vDSP_vdivD(grid, 1, other.grid, 1, &result, 1, UInt(count))
		return Matrix(result, n, m)
	}

	func squareVector()->Matrix{
		var result = [Double](repeating: 0.0, count: count)
		vDSP_vsqD(grid, 1, &result, 1, UInt(count))
		return Matrix(result, n, m)
	}

	//Mark: Scalar operation

	func addScalar(scalar: Double)->Matrix{
		var result = [Double](repeating: 0.0, count: n)
		var alfa = scalar
		vDSP_vsaddD(grid, 1, &alfa, &result, 1, UInt(count))
		return Matrix(result, n, m)
	}

	func multScalar(scalar: Double)->Matrix{
		var result = [Double](repeating: 0.0, count: n)
		var alfa = scalar
		vDSP_vsmulD(grid, 1, &alfa, &result, 1, UInt(count))
		return Matrix(result, n, m)
	}

	func divScalar(scalar: Double)->Matrix{
		var result = [Double](repeating: 0.0, count: n)
		var alfa = scalar
		vDSP_vsmulD(grid, 1, &alfa, &result, 1, UInt(count))
		return Matrix(result, n, m)
	}

	//Mark: summation

	func sum(vector: Matrix)->Double{
		var result:Double = 0.0
		vDSP_sveD(vector.grid, 1, &result, UInt(vector.count))
		return result
	}

	//Mark: matrix operations

	func transpose()->Matrix{
		var result = [Double](repeating: 0.0, count: n*m)
		vDSP_mtransD(grid, 1, &result, 1, UInt(n), UInt(m))
		return Matrix(result, m, n)
	}

	func multiply(_ other: Matrix)->Matrix{
		var result = [Double](repeating: 0.0, count: m*other.n)
		vDSP_mmulD(grid, 1, other.grid, 1, &result, 1,UInt(m), UInt(other.n), UInt(other.m))
		return Matrix(result, m, other.n)
	}

	func invert()->Matrix{
		var result = grid
		var N = __CLPK_integer(sqrt(Double(count)))
		var pivot:__CLPK_integer = 0
		var error:__CLPK_integer = 0
		dgetrf_(&N, &N, &result, &N, &pivot, &error)
		return Matrix(result, n, n)
	}

	func sub(_ m1: Int, _ m2: Int? = nil)->Matrix{
		var result:[Double]
		var dist:Int!
		if m2 == nil{
			result = [Double](repeating: 0.0, count: n)
			dist = 0
		}else{
			dist = m2!+1
			result = [Double](repeating: 0.0, count: n*(dist-n))
		}
		vDSP_mmovD(grid, &result, UInt(n*(m1-1)), UInt(n*(m1-1)), UInt(n*(m2!-1)), UInt(n*(m2!-1)))
		return Matrix(result, n, abs(dist-m1))
	}

	subscript(row: Int, column: Int)->Matrix{
		get{
			assert(isValid(row: row, column: column), "Index out of range")
			return sub(row, column)
		}
	}

}

//Mark: Matrix to Matrix operations

infix operator **

func +(left: Matrix, right: Matrix)->Matrix{
	return left.addVector(other: right)
}

func -(left: Matrix, right: Matrix)->Matrix{
	return left.subVector(other: right)
}

func *(left: Matrix, right: Matrix)->Matrix{
	return left.multiply(right)
}

func +(left: Matrix, right: Double)->Matrix{
	return left.addScalar(scalar: right)
}

func *(left: Matrix, right: Double)->Matrix{
	return left.multScalar(scalar: right)
}

func /(left: Matrix, right: Double)->Matrix{
	return left.divScalar(scalar: right)
}

func /(left: Matrix, right: Int)->Matrix{
	return left.divScalar(scalar: Double(right))
}

func sum( _ vect: Matrix)->Double{
	return vect.sum(vector: vect)
}

func ^(left: Matrix, right: String)->Matrix{
	var result:Matrix!
	if right == "T"{
		result = result.transpose()
	}else if right == "I"{
		result = result.invert()
	}
	return result
}

func ^(left: Matrix, right: Int)->Matrix{
	var result = left
	for _ in 0..<right{
		result = result.multiply(left)
	}
	return result
}

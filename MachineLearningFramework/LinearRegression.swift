//
//  LinearRegression.swift
//  MachineLearningFramework
//
//  Created by Yuma Antoine Decaux on 18/11/16.
//  Copyright © 2016 antoxicon. All rights reserved.
//

import Foundation

class LinearRegression{

	class func costFunction(X: Matrix, Y: Matrix, theta: Matrix, alfa: Double)->Double{
		return sum((X*theta-Y)^2)/Double(2*X.m)
	}

}

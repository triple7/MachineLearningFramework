//
//  MTLInitialise.swift
//  MachineLearningFramework
//
//  Created by Yuma Antoine Decaux on 20/11/16.
//  Copyright © 2016 antoxicon. All rights reserved.
//

import Foundation
import Metal


class MTLInitialise:NSObject{
	let device:MTLDevice

	let commandQueue:MTLCommandQueue
	let library:MTLLibrary

	override init(){
		self.device = MTLCreateSystemDefaultDevice()!
		self.commandQueue = device.makeCommandQueue()
		self.library = device.newDefaultLibrary()!
	}
	
}

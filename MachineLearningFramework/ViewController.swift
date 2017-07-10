//
//  ViewController.swift
//  MachineLearningFramework
//
//  Created by Yuma Antoine Decaux on 18/11/16.
//  Copyright © 2016 antoxicon. All rights reserved.
//

import Cocoa

class ViewController: NSViewController {

	override func viewDidLoad() {
		super.viewDidLoad()

		let table = CSVImport.importCSV(name: "testCSV", directory: "Downloads")

	}

	override var representedObject: Any? {
		didSet {
		// Update the view, if already loaded.
		}
	}


}


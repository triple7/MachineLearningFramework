//
//  CSVImport.swift
//  MachineLearningFramework
//
//  Created by Yuma Antoine Decaux on 18/11/16.
//  Copyright © 2016 antoxicon. All rights reserved.
//

import Foundation

class CSVImport{

class func importCSV(name: String, directory: String)->[String: [Any]]{
		let userDirectory = "\(NSHomeDirectory())/\(directory)/\(name).csv"
		var table = [String: [Any?]]()
		var text:String
	do{
		 text = try String(contentsOfFile: userDirectory)
		text = text.replacingOccurrences(of: "\r", with: "\n")
		var lines = text.components(separatedBy: "\n")
		if !lines.isEmpty{
			let headers = lines.removeFirst().components(separatedBy: ",")
			let headerCount = headers.count
			print(headers.count)
			for i in 0...headerCount-1{
				table[headers[i]] = [[Any?]]()
			}
			print(table.keys)
			for line in lines{
				if !line.isEmpty{
					let columns = line.components(separatedBy: ",")
print("colums are \(columns)")
					for i in 0...headerCount-1{
						if !(columns[i].contains(".")){
							let row = Int(columns[i])
							table[headers[i]]?.append(row)
						}else{
							let row = Float(columns[i])
							table[headers[i]]?.append(row)
						}
					}
				}
			}
		}
	}catch{
		print("Couldn't load CSV")
		}
		return table
	}

}

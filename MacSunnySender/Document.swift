//
//  Document.swift
//  MacSunnySender
//
//  Created by Jan Verrept on 7/08/17.
//  Copyright © 2017 OneClick. All rights reserved.
//

import Cocoa

class Document: NSDocument {
	
	var inverter:SMAinverter?{
		get{
			if let docNumber = NSDocumentController.shared.documents.index(of: self){
				if SMAinverter.inverters.count-1 >= docNumber{
					return SMAinverter.inverters[docNumber]
				}
			}
			return nil
		}
	}
	
	override init() {
		// Add your subclass-specific initialization here.
		super.init()
	}
	
	override class var autosavesInPlace: Bool {
		return true
	}
	
	override func makeWindowControllers() {
		// Returns the Storyboard that contains your Document window.
		let storyboard = NSStoryboard(name: NSStoryboard.Name("Main"), bundle: nil)
		let windowController = storyboard.instantiateController(withIdentifier: NSStoryboard.SceneIdentifier("Document Window Controller")) as! NSWindowController
		self.addWindowController(windowController)
	}
	
	override func data(ofType typeName: String) throws -> Data {
		// Insert code here to write your document to data of the specified type. If outError != nil, ensure that you create and set an appropriate error when returning nil.
		// You can also choose to override fileWrapperOfType:error:, writeToURL:ofType:error:, or writeToURL:ofType:forSaveOperation:originalContentsURL:error: instead.
		throw NSError(domain: NSOSStatusErrorDomain, code: unimpErr, userInfo: nil)
	}
	
	override func read(from data: Data, ofType typeName: String) throws {
		// Insert code here to read your document from the given data of the specified type. If outError != nil, ensure that you create and set an appropriate error when returning false.
		// You can also choose to override readFromFileWrapper:ofType:error: or readFromURL:ofType:error: instead.
		// If you override either of these, you should also override -isEntireFileLoaded to return false if the contents are lazily loaded.
		throw NSError(domain: NSOSStatusErrorDomain, code: unimpErr, userInfo: nil)
	}
	
	
}


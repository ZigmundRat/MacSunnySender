//
//  MainViewController.swift
//  MacSunnySender
//
//  Created by Jan Verrept on 7/08/17.
//  Copyright © 2017 OneClick. All rights reserved.
//

import Cocoa

class MainViewController: NSViewController{
    
    @IBOutlet weak var mainTable: NSTableView!
    
    var inverter:SMAinverter?{
        get{
            return (view.window?.windowController?.document as? Document)?.inverter ?? nil
        }
    }
    
    // Standard ViewController methods
    override func viewWillAppear(){
        super.viewWillAppear()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        mainTable.dataSource = self
    }
    
    override var representedObject: Any? {
        didSet {
            // Update the view, if already loaded
        }
    }
    
    // Test methods
    @IBAction func testCode(sender:NSButton){
        
        //		let emailClient = EmailClient.sharedInstance
        //		emailClient.sendDataToSunnyPortal(inverter:SMAinverter.inverters[0])
        
    }
    
}


extension MainViewController: NSTableViewDataSource {
    
    func numberOfRows(in tableView: NSTableView) -> Int {
        return inverter?.currentMeasurements?.count ?? 0
    }
    
    func tableView(_ tableView: NSTableView, objectValueFor tableColumn: NSTableColumn?, row: Int) -> Any?{
        //    func tableView(_ tableView: NSTableView, dataCellFor tableColumn: NSTableColumn?, row: Int) -> NSCell?{
        
        // Find the dataItem for the row
        guard let dataItem = inverter?.currentMeasurements?[row] else {
            return nil
        }
        
        //        // Get the cell based on each column
        //        if tableColumn == tableView.tableColumns[0] {
        //            return NSCell(textCell:dataItem.name)
        //        } else if tableColumn == tableView.tableColumns[1] {
        //            return NSCell(textCell:String(dataItem.value))
        //        }else if tableColumn == tableView.tableColumns[2] {
        //            return NSCell(textCell:dataItem.unit)
        //        }
        
        // Get the cell based on each column
        if tableColumn == tableView.tableColumns[0] {
            return dataItem.name
        } else if tableColumn == tableView.tableColumns[1] {
            return dataItem.value
        }else if tableColumn == tableView.tableColumns[2] {
            return dataItem.unit
        }
        
        return nil
        
    }
    
}



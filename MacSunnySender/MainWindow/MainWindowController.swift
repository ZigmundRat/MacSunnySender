//
//  MainWindowController.swift
//  MacSunnySender
//
//  Created by Jan Verrept on 8/09/17.
//  Copyright © 2017 OneClick. All rights reserved.
//

import Cocoa

class MainWindowControler:NSWindowController{
    
    override func windowDidLoad(){
        super.windowDidLoad()
        window?.delegate = self
    }
    
}

extension MainWindowControler: NSWindowDelegate{

    override func synchronizeWindowTitleWithDocumentName() {
            window?.title = document?.displayName ?? "Untitled"
    }
    
}

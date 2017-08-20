//
//  CustomTableView.swift
//  PictureDesk
//
//  Created by Holger Hinzberg on 20.08.17.
//  Copyright © 2017 Holger Hinzberg. All rights reserved.
//

import Cocoa

class CustomTableView: NSTableView {

    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)

        // Drawing code here.
    }
    
    
    // Allows item selection with right click
    override func menu(for event: NSEvent) -> NSMenu?
    {
        let row = self.row(at: self.convert(event.locationInWindow, from: nil))
        if  row != -1
        {
            let indexSet : IndexSet = [row]
            self.selectRowIndexes(indexSet, byExtendingSelection: false)
        }
        return super.menu
    }
    
}

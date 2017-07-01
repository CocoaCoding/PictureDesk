//
//  MainWindowController.swift
//  PictureDesk
//
//  Created by Holger Hinzberg on 11.06.17.
//  Copyright © 2017 Holger Hinzberg. All rights reserved.
//

import Cocoa

class MainWindowController: NSWindowController {

    override func windowDidLoad()
    {
        super.windowDidLoad()
        self.windowFrameAutosaveName = NSWindow.FrameAutosaveName(rawValue: "MainWindow")
    }

}

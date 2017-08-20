//
//  CustomCollectionView.swift
//  PictureDesk
//
//  Created by Holger Hinzberg on 10.07.17.
//  Copyright © 2017 Holger Hinzberg. All rights reserved.
//

import Cocoa

class CustomCollectionView: NSCollectionView
{
    public var KeyHandler:KeyPressedProtocol?
    
    override func draw(_ dirtyRect: NSRect)
    {
        super.draw(dirtyRect)
        // Drawing code here.
    }
    
    override var acceptsFirstResponder: Bool
   {
        return true
    }
    
    override func keyDown(with event: NSEvent)
    {
        print("Code \(event.keyCode)")
        if self.KeyHandler != nil
        {
           self.KeyHandler?.keyPressed(keyCode: Int(event.keyCode))
        }
    }
    
    override func menu(for event: NSEvent) -> NSMenu?
    {
        let point = self.convert(event.locationInWindow, from: nil)
        let count = self.numberOfItems(inSection: 0)
       
        for index in 0 ..< count
        {
            let frame = self.frameForItem(at: index)
            if NSMouseInRect(point, frame, self.isFlipped)
            {
                self.deselectAll(nil)
                let indexPath = IndexPath(item: index, section: 0)
                self.selectItems(at: [indexPath], scrollPosition: NSCollectionView.ScrollPosition.centeredHorizontally)
                break
            }
        }
        return super.menu
    }
    
    
    
    
}

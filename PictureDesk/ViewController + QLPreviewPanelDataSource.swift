//
//  ViewController + QLPreviewPanelDataSource.swift
//  PictureDesk
//
//  Created by Holger Hinzberg on 10.07.17.
//  Copyright © 2017 Holger Hinzberg. All rights reserved.
//

import Cocoa
import Quartz

extension ViewController : QLPreviewPanelDataSource, QLPreviewPanelDelegate
{
    func spaceKeyPressed()
    {
            if let panel = QLPreviewPanel.shared()
            {
                panel.delegate = self
                panel.dataSource = self
                panel.makeKeyAndOrderFront(self)
            }
    }
    
    /*
    override func acceptsPreviewPanelControl(_ panel: QLPreviewPanel!) -> Bool
    {
        return true
    }
 */
    
    func numberOfPreviewItems(in panel: QLPreviewPanel!) -> Int
    {
        return 1
    }
    
    func previewPanel(_ panel: QLPreviewPanel!, previewItemAt index: Int) -> QLPreviewItem!
    {
        let imageSelection = self.collectionView.selectionIndexPaths
        if let firstSelection = imageSelection.first
        {
            let image = self.imageDirectoryLoader.imageFileForIndexPath(firstSelection)
            return image.fileURL! as QLPreviewItem
        }
        return nil
    }
    
}

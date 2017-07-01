//
//  ViewController + NSTableViewDataSource.swift
//  PictureDesk
//
//  Created by Holger Hinzberg on 11.06.17.
//  Copyright © 2017 Holger Hinzberg. All rights reserved.
//

// https://www.raywenderlich.com/143828/macos-nstableview-tutorial

import Cocoa

extension ViewController : NSTableViewDataSource, NSTableViewDelegate
{
    func numberOfRows(in tableView: NSTableView) -> Int
    {
        return self.folderRepository.getFolderCount()
    }
    
    func tableView(_ tableView: NSTableView, heightOfRow row: Int) -> CGFloat
    {
        return 25
    }
    
    func tableView(_ tableView: NSTableView, willDisplayCell cell: Any, for tableColumn: NSTableColumn?, row: Int)
    {
        
    }
    
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView?
    {
        
        if let cell = tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "AdvancedCell"), owner: nil) as? NSTableCellView
        {
            let url = self.folderRepository.getFolderAt(index: row)
            cell.textField?.stringValue = url.lastPathComponent
            cell.textField?.textColor = .black
            return cell
        }
        return nil
    }
    
    // A row as selected. Show images of the folder
    func tableView(_ tableView: NSTableView, shouldSelectRow row: Int) -> Bool
    {
        let url = self.folderRepository.getFolderAt(index: row)
        imageDirectoryLoader.loadDataForFolderWithUrl(url)
        self.collectionView.reloadData()
        return true
    }
    
    // Only allow drop on items not before or after items
    func tableView(_ tableView: NSTableView, validateDrop info: NSDraggingInfo, proposedRow row: Int, proposedDropOperation dropOperation: NSTableView.DropOperation) -> NSDragOperation
    {
        if dropOperation == .on
        {
            return .move
        }
        return []
    }
    
    func tableView(_ tableView: NSTableView, acceptDrop info: NSDraggingInfo, row: Int, dropOperation: NSTableView.DropOperation) -> Bool
    {
        // The folder the item was dropped upon
        let folder = self.folderRepository.getFolderAt(index: row)
        print(folder.absoluteString)
        
        self.dragDestination = folder
        
        self.draggedItems = [URL]()
        
        info.enumerateDraggingItems(options: NSDraggingItemEnumerationOptions.concurrent, for: tableView, classes: [NSURL.self], searchOptions: [NSPasteboard.ReadingOptionKey.urlReadingFileURLsOnly : NSNumber(value: true)])
        {
            (draggingItem, idx, stop) in
            // The object dragged was typ URL
            if let url = draggingItem.item as? URL
            {
                self.draggedItems?.append(url)
                print(url.absoluteString )
            }
        }
        return true
    }

}

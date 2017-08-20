//
//  ViewController + NSCollectionViewDataSource.swift
//  PictureDesk
//
//  Created by Holger Hinzberg on 14.01.17.
//  Copyright © 2017 Holger Hinzberg. All rights reserved.
//

import Cocoa

extension ViewController : NSCollectionViewDataSource, NSCollectionViewDelegate
{
    func numberOfSections(in collectionView: NSCollectionView) -> Int
    {
        return imageDirectoryLoader.numberOfSections
    }
    
    func collectionView(_ collectionView: NSCollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return imageDirectoryLoader.numberOfItemsInSection(section)
    }
    
    func collectionView(_ itemForRepresentedObjectAtcollectionView: NSCollectionView, itemForRepresentedObjectAt indexPath: IndexPath) -> NSCollectionViewItem
    {
        let item = collectionView.makeItem(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "CollectionViewItem"), for: indexPath)
        guard let collectionViewItem = item as? CollectionViewItem else {return item}
   
        let imageFile = imageDirectoryLoader.imageFileForIndexPath(indexPath)
        collectionViewItem.imageFile = imageFile
        return item
    }
    
    // Für Drag & Drop im CollectionView
    func collectionView(_ collectionView: NSCollectionView, canDragItemsAt indexes: IndexSet, with event: NSEvent) -> Bool
    {
        return true
    }
    
    // For Drag & Drop in CollectionView
    // Copy the fileUrl of the ImageFile into the Pasteboard
    func collectionView(_ collectionView: NSCollectionView, pasteboardWriterForItemAt indexPath: IndexPath) -> NSPasteboardWriting?
    {
        let imageFile = imageDirectoryLoader.imageFileForIndexPath(indexPath)
        return imageFile.fileURL!.absoluteURL as NSPasteboardWriting
    }

    func collectionView(_ collectionView: NSCollectionView, draggingSession session: NSDraggingSession, willBeginAt screenPoint: NSPoint, forItemsAt indexPaths: Set<IndexPath>)
    {
        indexPathsOfItemsBeingDragged = indexPaths as Set<NSIndexPath>
    }
    
    /*
    func collectionView(_ collectionView: NSCollectionView, validateDrop draggingInfo: NSDraggingInfo, proposedIndexPath proposedDropIndexPath: AutoreleasingUnsafeMutablePointer<NSIndexPath>, dropOperation proposedDropOperation: UnsafeMutablePointer<NSCollectionViewDropOperation>) -> NSDragOperation
    {
        if proposedDropOperation.pointee == NSCollectionViewDropOperation.on
        {
            proposedDropOperation.pointee = NSCollectionViewDropOperation.before
        }
        
        if indexPathsOfItemsBeingDragged == nil
        {
            return NSDragOperation.copy
        }
        else
        {
            return NSDragOperation.move
        }
    }
 */
    
    private func insertAtIndexPathFromURLs(urls: [NSURL], atIndexPath: NSIndexPath)
    {
        var indexPaths: Set<NSIndexPath> = []
        let section = atIndexPath.section
        var currentItem = atIndexPath.item

        for url in urls
        {
            let imageFile = ImageFile(url: url as URL)
            let currentIndexPath = NSIndexPath(forItem: currentItem, inSection: section)
            imageDirectoryLoader.insertImage(image: imageFile!, atIndexPath: currentIndexPath)
            indexPaths.insert(currentIndexPath)
            currentItem += 1
        }
        
        collectionView.insertItems(at: indexPaths as Set<IndexPath>)
    }

    // Do not drop in the CollectionView itself
    func collectionView(_ collectionView: NSCollectionView, acceptDrop draggingInfo: NSDraggingInfo, indexPath: IndexPath, dropOperation: NSCollectionView.DropOperation) -> Bool
    {
        return false
        
  /*
        if indexPathsOfItemsBeingDragged != nil
        {
            let indexPathOfFirstItemBeingDragged = indexPathsOfItemsBeingDragged.first!
            var toIndexPath: NSIndexPath
            if indexPathOfFirstItemBeingDragged.compare(indexPath as IndexPath) == .orderedAscending {
                toIndexPath = NSIndexPath(forItem: indexPath.item-1, inSection: indexPath.section)
            }
            else
            {
                toIndexPath = NSIndexPath(forItem: indexPath.item, inSection: indexPath.section)
            }
            imageDirectoryLoader.moveImageFromIndexPath(indexPath: indexPathOfFirstItemBeingDragged, toIndexPath: toIndexPath)
            collectionView.moveItem(at: indexPathOfFirstItemBeingDragged as IndexPath, to: toIndexPath as IndexPath)
        }
        else
        {
            var droppedObjects = Array<NSURL>()
            draggingInfo.enumerateDraggingItems(options: NSDraggingItemEnumerationOptions.concurrent, for: collectionView, classes: [NSURL.self], searchOptions: [NSPasteboardURLReadingFileURLsOnlyKey : NSNumber(value: true)]) { (draggingItem, idx, stop) in
                if let url = draggingItem.item as? NSURL {
                    droppedObjects.append(url)
                }
            }
            insertAtIndexPathFromURLs(urls: droppedObjects, atIndexPath: indexPath as NSIndexPath)
        }
        return true
 */
    }
    
    func collectionView(_ collectionView: NSCollectionView, draggingSession session: NSDraggingSession, endedAt screenPoint: NSPoint, dragOperation operation: NSDragOperation)
    {
        if operation.contains(.move)
        {
            let mover = FilesMover()
            let success = mover.MoveFiles(destination: self.dragDestination, sources: self.draggedItems)
            
            if success == true
            {
                imageDirectoryLoader.removeImagesByUrls(urls: self.draggedItems)
                self.collectionView.reloadData()
            }

            print("moved")
        }
        else
        {
            print("nothing")
        }
    }
}

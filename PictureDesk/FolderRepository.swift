//
//  FolderRepository.swift
//  PictureDesk
//
//  Created by Holger Hinzberg on 11.06.17.
//  Copyright © 2017 Holger Hinzberg. All rights reserved.
//

import Cocoa

class FolderRepository: NSObject
{
    private var folders = [URL]()
    
    override init()
    {
        super.init()
        self.Load()
    }
    
    var filePath : String
    {
        let manager = FileManager.default
        let url = manager.urls(for: .documentDirectory, in: .userDomainMask).first! as NSURL
        return url.appendingPathComponent("foldersArray")!.path
    }
    
    public func Load()
    {
        if let array = NSKeyedUnarchiver.unarchiveObject(withFile: filePath) as? [AnyObject]
        {
            self.folders = array as! [URL]
        }
        else
        {
            self.AddDefaultFolders()
        }
    }
    
    public func Save()
    {
        NSKeyedArchiver.archiveRootObject(folders, toFile: self.filePath)
    }
    
    private func AddDefaultFolders()
    {
        let paths = NSSearchPathForDirectoriesInDomains(.desktopDirectory, .userDomainMask, true)
        let desktopDirectory = URL.init(fileURLWithPath: paths[0])
        self.folders.append(desktopDirectory)
    }
    
    public func getFolderCount() -> Int
    {
        return self.folders.count
    }
    
    public func getFolderAt(index:Int) -> URL
    {
        return self.folders[index];
    }
    
    public func appendFolderAt(folder:URL)
    {
        self.folders.append(folder)
        self.Save()
    }
}

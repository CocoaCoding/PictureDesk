//
//  HHSFileHelper.swift
//  CollectionViewDemo
//
//  Created by Holger Hinzberg on 20.06.15.
//  Copyright (c) 2015 Holger Hinzberg. All rights reserved.
//

import Cocoa

public class HHSFileHelper: NSObject
{
    public func getDesktopUrl() -> URL
    {
        let paths = NSSearchPathForDirectoriesInDomains(.desktopDirectory, .userDomainMask, true)
        //let desktopUrl = FileManager.URLsForDirectory(.desktopDirectory, inDomains: .UserDomainMask).first as! NSURL
        return URL.init(fileURLWithPath: paths[0])
    }
    
    public func renameFile(source:URL, destination:URL) -> Bool
    {
        let filemanager = FileManager.default
        do
        {
            print(source.absoluteString)
            print(destination.absoluteString)
            try filemanager.moveItem(at: source, to: destination)
            return true
        }
        catch
        {
            print("rename error")
        }
        return false
    }
    
    /*
    
    public func getContentsOfDirectoryAtURL(directory:URL, withFileExtention extention:String ) -> [URL]
    {
        var content = [URL]()
        let files =  self.getContentsOfDirectoryAtURL(directory: directory)
        
        for file in files
        {
            let a = file.pathExtension.lowercased()
            let b = extention.lowercased()
            if (a == b)
            {
                content.append(file)
            }
        }
        return content
    }
    
    // Den kompletten Inhalt eines Verzeichnisses
    // Auch Ordner und verstecke Dateien
    public func getContentsOfDirectoryAtURL(directory:URL) -> [URL]
    {
        let fileManger = FileManager()
        var content = [URL]()
        
        let files =  fileManger.contentsOfDirectoryAtURL(directory, includingPropertiesForKeys: nil, options: nil, error: nil) as? [URL]
        if let files = files
        {
            for file in files
            {
                content.append(file)
            }
        }
        return content
    }
    
    // Alle Ordner unterhalb eines angegebenen Ordners holen
    // Funktioniert aus rekursiev mit Unterordnern
    public func getFolders(rootFolder:String) -> [URL]
    {
        var folderurl = URL(fileURLWithPath: rootFolder)
        var enumerator = getFolderEnumerator(folderurl!)

        var folders =  [URL]()
        
        while let url = enumerator?.nextObject() as? URL
        {
            folders.append(url)
        }
        return folders
    }
    
    private func getFolderEnumerator(directoryUrl:URL) -> NSDirectoryEnumerator?
    {
        var fileManger = FileManager()
        var keys = [NSURLIsDirectoryKey]
        
        var handler = {
            (url:NSURL!,error:NSError!) -> Bool in
            println(error.localizedDescription)
            println(url.absoluteString)
            return true
        }
        
        var enumarator = fileManger.enumeratorAtURL(
            directoryUrl, includingPropertiesForKeys:
            keys, options: NSDirectoryEnumerationOptions(), errorHandler:handler)
        
        return enumarator
    }
    */
}

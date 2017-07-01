//
//  FilesMover.swift
//  PictureDesk
//
//  Created by Holger Hinzberg on 19.06.17.
//  Copyright © 2017 Holger Hinzberg. All rights reserved.
//

import Cocoa

class FilesMover: NSObject
{
    func MoveFiles(destination:URL?, sources : [URL]?) -> Bool
    {
        let fileManager = FileManager.default;
        
        for source in sources!
        {
            do
            {
                var fullDestination = destination
                fullDestination?.appendPathComponent(source.lastPathComponent)
                try fileManager.copyItem(at: source, to: fullDestination!)
            }
            catch let error as NSError
            {
                print(error.localizedDescription)
                return false
            }
            
            do
            {
                try fileManager.removeItem(at: source)
            }
            catch let error as NSError
            {
                print(error.localizedDescription)
                return false
            }
        }
        
        return true
    }
}

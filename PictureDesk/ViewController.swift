//
//  ViewController.swift
//  PictureDesk
//
//  Created by Holger Hinzberg on 14.01.17.
//  Copyright © 2017 Holger Hinzberg. All rights reserved.
//

import Cocoa
import Quartz

class ViewController: NSViewController, KeyPressedProtocol
{
    public var Config:AppsConfig?
    public let imageDirectoryLoader = ImageDirectoryLoader()
    private var currentDirectory:URL?
    
    public var dragDestination:URL?
    public var draggedItems:[URL]?
    
    var indexPathsOfItemsBeingDragged: Set<NSIndexPath>!
    
    @IBOutlet weak var collectionView: CustomCollectionView!
    @IBOutlet weak var tableView: NSTableView!
    @IBOutlet weak var splitView: NSSplitView!
    public let folderRepository = FolderRepository()
    
    override func viewWillAppear()
    {
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.splitView.autosaveName = NSSplitView.AutosaveName(rawValue: "SplitView")
        
        let appDelegate = NSApplication.shared.delegate as! AppDelegate
        self.Config = appDelegate.Config
        
        print(self.Config!.itemSize)
        
        self.configureCollectionView()
        self.currentDirectory = URL(fileURLWithPath: "/Library/Desktop Pictures", isDirectory: true)
        imageDirectoryLoader.loadDataForFolderWithUrl(self.currentDirectory!)
        
        self.registerForDragAndDrop()
    }
    
    func registerForDragAndDrop()
    {
        // Registered for the dropped object types SlidesPro accepts
        let NSURLPboardType = NSPasteboard.PasteboardType(kUTTypeURL as String)
        collectionView.registerForDraggedTypes([NSURLPboardType])
        // Enabled dragging items within and into the collection view
        collectionView.setDraggingSourceOperationMask(NSDragOperation.every, forLocal: true)
        // Enabled dragging items from the collection view to other applications (Finder)
        //collectionView.setDraggingSourceOperationMask(NSDragOperation.every, forLocal: false)
        
        tableView.registerForDraggedTypes([NSURLPboardType])
    }
    
    fileprivate func configureCollectionView()
    {
        self.collectionView.KeyHandler = self
        
        // 1
        let flowLayout = NSCollectionViewFlowLayout()
        flowLayout.itemSize = NSSize(width: self.Config!.itemSize, height: self.Config!.itemSize)
        flowLayout.sectionInset = NSEdgeInsets(top: 10.0, left: 20.0, bottom: 10.0, right: 20.0)
        flowLayout.minimumInteritemSpacing = 10.0
        flowLayout.minimumLineSpacing = 10.0
        collectionView.collectionViewLayout = flowLayout
        view.wantsLayer = true
        collectionView.layer?.backgroundColor = NSColor.clear.cgColor
        collectionView.backgroundColors = [NSColor.clear]
    }
    
    override var representedObject: Any?
        {
        didSet
        {
        }
    }
    

    
    // MARK: Toolbar Buttons and other GUI
    
    @IBAction func desktopFolderButtonClicked(sender:AnyObject)
    {
        let paths = NSSearchPathForDirectoriesInDomains(.desktopDirectory, .userDomainMask, true)
        self.currentDirectory = URL.init(fileURLWithPath: paths[0])
        imageDirectoryLoader.loadDataForFolderWithUrl(self.currentDirectory!)
        self.collectionView.reloadData()
    }
    
    @IBAction func folderAddButtonClicked(_ sender: NSButton)
    {
        let openPanel = NSOpenPanel()
        openPanel.canChooseFiles = false
        openPanel.canChooseDirectories = true
        
        openPanel.beginSheetModal(for: self.view.window!, completionHandler:
            {
                (result:NSApplication.ModalResponse) in
                if(result == NSApplication.ModalResponse.OK)
                {
                    let fileURL = openPanel.url!
                    // print(fileURL)
                    // do something with the selected file. Its url = fileURL
                    self.folderRepository.appendFolderAt(folder: fileURL)
                    self.tableView.reloadData()
                }
        })
    }
    
    @IBAction func sliderValueChanged(_ sender: Any)
    {
        let slider = sender as! NSSlider
        self.Config?.itemSize = slider.doubleValue
        
        let layout = collectionView.collectionViewLayout as! NSCollectionViewFlowLayout
        layout.itemSize = NSSize(width: self.Config!.itemSize, height: self.Config!.itemSize)
    }
    
    // MARK: Context Menue
    
    @IBAction func renameContextmenuItemClicked(_ sender: Any)
    {
        let imageSelection = self.collectionView.selectionIndexPaths
        if let firstSelection = imageSelection.first
        {
            let image = self.imageDirectoryLoader.imageFileForIndexPath(firstSelection)
            self.showSheetWindowForRename( imagefile: image, imageSelection: imageSelection)
        }
    }
    
    func showSheetWindowForRename(imagefile: ImageFile, imageSelection:Set<IndexPath>) -> Void
    {
        let alertWindow = NSAlert()
        alertWindow.addButton(withTitle: "OK")      // 1st button
        alertWindow.addButton(withTitle: "Cancel")  // 2nd button
        alertWindow.messageText = "Rename"
        alertWindow.informativeText = "Enter new filename"
        
        // Add adtitional textfield to the window
        let textfield = NSTextField(frame: NSRect(x: 0, y: 0, width: 300, height: 24))
        textfield.stringValue = imagefile.fileName
        alertWindow.accessoryView = textfield
        
        // Run AlertWindow as Sheet
        alertWindow.beginSheetModal(for: self.view.window!, completionHandler:
            {
                (response:NSApplication.ModalResponse) in
                if(response == NSApplication.ModalResponse.alertFirstButtonReturn)
                {
                    let newTitle = textfield.stringValue
                    // The filename was changed and is not empty
                    if newTitle != imagefile.fileName && newTitle != ""
                    {
                        self.renameImage(image: imagefile, newTitle: newTitle)
                        // Refresh Collection View and recreate previous selection
                        self.collectionView.reloadData()
                        self.collectionView.selectItems(at: imageSelection, scrollPosition: NSCollectionView.ScrollPosition.right)
                    }
                }
        })
    }
    
    func renameImage(image: ImageFile, newTitle:String)
    {
        var newUrl = image.fileURL?.deletingLastPathComponent()
        newUrl?.appendPathComponent(newTitle)
        if let source = image.fileURL, let destination = newUrl
        {
            let fileHelper = HHSFileHelper()
            if fileHelper.renameFile(source: source, destination: destination) == true
            {
                image.fileName = newTitle
                image.fileURL = newUrl
            }
        }
    }
    
    @IBAction func deleteContextmenuItemClicked(_ sender: Any)
    {
        let imageSelection = self.collectionView.selectionIndexPaths
        for singleImage in imageSelection
        {
            let image = self.imageDirectoryLoader.imageFileForIndexPath(singleImage)
            let fileHelper = HHSFileHelper()
            if fileHelper.deleteFile(source: image.fileURL!) == true
            {
                self.imageDirectoryLoader.removeImagesByUrls(urls: [image.fileURL!])
            }
        }
       self.collectionView.reloadData()
    }
    
    func keyPressed(keyCode: Int)
    {
        if keyCode == 49
        {
            self.spaceKeyPressed()
        }
    }
}


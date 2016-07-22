//
//  ViewController.swift
//  NSFileManagerOpen
//
//  Created by 周磊 on 16/7/22.
//  Copyright © 2016年 周磊. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    
    
    //MARK:- 1.创建文件夹
    func createFolder () {
        
        let myFolder = NSHomeDirectory() + "/Documents/myFolder/Folder"
        let fileManager = NSFileManager.defaultManager()
        
        //withIntermediateDirectories为ture表示路径中间如果有不存在的文件夹都会创建
        try! fileManager.createDirectoryAtPath(myFolder, withIntermediateDirectories: true, attributes: nil)
    }
    
    
    //MARK:- 2.创建文件
    func createFile () {
        
        let manager = NSFileManager.defaultManager()
        let urlForDocuments = manager.URLsForDirectory(NSSearchPathDirectory.DocumentDirectory, inDomains: NSSearchPathDomainMask.UserDomainMask)
        let url = urlForDocuments[0]
        
        let file = url.URLByAppendingPathComponent("hehe.text")
        
        print("文件: \(file)")
        
        let exist = manager.fileExistsAtPath(file.path!)
        
        if !exist {
            
            let data = NSData(base64EncodedString:"aGVsbG8gd29ybGQ=",options:.IgnoreUnknownCharacters)
            
            let createSuccess = manager.createFileAtPath(file.path!,contents:data,attributes:nil)
            
            print("文件创建结果：\(createSuccess)")
            
        }
    }
    
    //MARK:- 3.遍历一个目录下的所有文件
    func enumeratorAtPath() {
        
        
        let manager = NSFileManager.defaultManager()
        let urlForDocument = manager.URLsForDirectory(NSSearchPathDirectory.DocumentDirectory, inDomains: NSSearchPathDomainMask.UserDomainMask)
        let url = urlForDocument[0]
        
        
        //对指定路径执行浅搜索，返回指定目录路径下的文件、子目录及符号链接的列表
        let contentsOfPath = try? manager.contentsOfDirectoryAtPath(url.path!)
        //Optional(["myFolder"])
        print(contentsOfPath)
        
        
        //对指定路径执行浅搜索，返回指定目录路径下的文件、子目录及符号链接的列表
        let contentsOfUrl = try? manager.contentsOfDirectoryAtURL(url, includingPropertiesForKeys: nil, options: NSDirectoryEnumerationOptions.SkipsHiddenFiles)
        print(contentsOfUrl)
        
        
        //深度遍历，会递归遍历子文件夹（但不会递归符号链接）
        let enumeratorAtPath = manager.enumeratorAtPath(url.path!)
        //Optional(<NSAllDescendantPathsEnumerator: 0x7f9933e90d80>)
        print(enumeratorAtPath)
        
        //深度遍历，会递归遍历子文件夹（但不会递归符号链接）
        let enumeratorAtUrl = manager.enumeratorAtURL(url, includingPropertiesForKeys: nil, options: NSDirectoryEnumerationOptions.SkipsHiddenFiles, errorHandler: nil)
        //Optional(<NSURLDirectoryEnumerator: 0x7fe3d34137b0>)
        print(enumeratorAtUrl)
        
        
        //深度遍历，会递归遍历子文件夹（包括符号链接，所以要求性能的话用enumeratorAtPath）
        let subPaths = manager.subpathsAtPath(url.path!)
        //Optional([])
        print(subPaths)
        
    }
    
    //MARK:- 4.判断文件或文件夹是否存在
    func fileIsexist() {
        
        let manager = NSFileManager.defaultManager()
        let filePath = NSHomeDirectory() + "/Documents/hehe.text"
        let exist = manager.fileExistsAtPath(filePath)
        //false
        print(exist)
        
    }
    
    
    
    //MARK:- 5..将对象写入文件
    func objectWriteToFile() {
        
        //把String保存到文件
        let stringPath = NSHomeDirectory() + "/Documents/myFolder/hehe.text"
        let info = "呵呵呵呵呵呵"
        try! info.writeToFile(stringPath, atomically: true, encoding: NSUTF8StringEncoding)
        
        //把图片保存到文件路径下
        let imagePath:String = NSHomeDirectory() + "/Documents/hehe.png"
        let image = UIImage(named: "apple.png")
        let data:NSData = UIImagePNGRepresentation(image!)!
        data.writeToFile(imagePath, atomically: true)
        
        //把NSArray保存到文件路径下
        let array = NSArray(objects: "aaa","bbb","ccc")
        let arrayPath:String = NSHomeDirectory() + "/Documents/array.plist"
        array.writeToFile(arrayPath, atomically: true)
        
        //把NSDictionary保存到文件路径下
        let dictionary = NSDictionary(objects: ["111","222"], forKeys: ["aaa","bbb"])
        let dictPath:String = NSHomeDirectory() + "/Documents/dictionary.plist"
        dictionary.writeToFile(dictPath, atomically: true)
        
    }
    
    //MARK:- 6..删除文件1
    func deleteFile() {
        let fileManager = NSFileManager.defaultManager()
        let fileUrl = NSHomeDirectory() + "/Documents/myFolder/hehe.text"
        try! fileManager.removeItemAtPath(fileUrl)
        
    }
    
    //MARK:- 6-1.删除文件2
    func deleteFileTwo() {
        // 定位到用户文档目录
        let manager = NSFileManager.defaultManager()
        let urlForDocument = manager.URLsForDirectory( NSSearchPathDirectory.DocumentDirectory,
                                                       inDomains:NSSearchPathDomainMask.UserDomainMask)
        let url = urlForDocument[0] as NSURL
        
        let toUrl = url.URLByAppendingPathComponent("hehe.txt")
        // 删除文档根目录下的toUrl路径的文件（hehe.txt文件）
        try! manager.removeItemAtURL(toUrl)
    }
    
    //MARK:- 6-2.删除所有文件
    func deleteAllFile() {
        //获取所有文件，然后遍历删除
        let fileManager = NSFileManager.defaultManager()
        let myDirectory = NSHomeDirectory() + "/Documents/Files"
        let fileArray:[AnyObject]? = fileManager.subpathsAtPath(myDirectory)
        for file in fileArray!{
            try! fileManager.removeItemAtPath(myDirectory + "/\(file)")
        }
        
        //还有一种方法： 删除目录后重新创建该目录
    }
    
    
    //MARK:- 7.复制文件
    func copyFile() {
        
        let fileManager = NSFileManager.defaultManager()
        let srcUrl = NSHomeDirectory() + "/Documents/hehe.text"
        let toUrl = NSHomeDirectory() + "/Documents/copy.text"
        try! fileManager.copyItemAtPath(srcUrl, toPath: toUrl)
    }
    
    //MARK:- 7-1.复制文件2
    func copyFileTwo() {
        
        // 定位到用户文档目录
        let manager = NSFileManager.defaultManager()
        let urlForDocument = manager.URLsForDirectory( NSSearchPathDirectory.DocumentDirectory, inDomains:NSSearchPathDomainMask.UserDomainMask)
        let url = urlForDocument[0] as NSURL
        
        // 将test.txt文件拷贝到文档目录根目录下的copyed.txt文件
        let srcUrl = url.URLByAppendingPathComponent("test.txt")
        let toUrl = url.URLByAppendingPathComponent("copyed.txt")
        
        try! manager.copyItemAtURL(srcUrl, toURL: toUrl)
        
    }
    
    //MARK:- 8.移动文件
    //和复制文件一样，只是把方法改成moveItemAtPath
    
    
    //MARK:- 9.读取文件
    func readFile() {
        
        let manager = NSFileManager.defaultManager()
        let urlsForDocDirectory = manager.URLsForDirectory(NSSearchPathDirectory.DocumentDirectory, inDomains:NSSearchPathDomainMask.UserDomainMask)
        let docPath:NSURL = urlsForDocDirectory[0] as NSURL
        let file = docPath.URLByAppendingPathComponent("hehe.txt")
        
        //方法1
        let readHandler = try! NSFileHandle(forReadingFromURL:file)
        let data = readHandler.readDataToEndOfFile()
        let readString = NSString(data: data, encoding: NSUTF8StringEncoding)
        print("文件内容: \(readString)")
        
        //方法2
        let fileData = manager.contentsAtPath(file.path!)
        let readFile = NSString(data: fileData!, encoding: NSUTF8StringEncoding)
        print("文件内容: \(readFile)")
        
    }
    
    //MARK:- 10.获取文件属性（创建时间，修改时间，文件大小，文件类型等信息）
    func accessFileProperties () {
        
        let manager = NSFileManager.defaultManager()
        let urlsForDocDirectory = manager.URLsForDirectory(NSSearchPathDirectory.DocumentDirectory,inDomains:NSSearchPathDomainMask.UserDomainMask)
        let docPath:NSURL = urlsForDocDirectory[0] as NSURL
        let file = docPath.URLByAppendingPathComponent("hehe.txt")
        
        let attributes = try? manager.attributesOfItemAtPath(file.path!) //结果为AnyObject类型
        print("attributes: \(attributes!)")
        
    }
    
    
}


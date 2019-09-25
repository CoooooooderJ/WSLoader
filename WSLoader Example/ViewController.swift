//
//  ViewController.swift
//  WSLoader
//
//  Created by Tina on 2019/9/24.
//  Copyright © 2019 Tina. All rights reserved.
//

import UIKit

class ViewController: UIViewController, URLSessionDownloadDelegate {

    
    
    var loader: WSLoader!
    var resumeData: Data? = Data()
    var imageView = UIImageView()
    var task: URLSessionDownloadTask!
    var session: URLSession!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(imageView)
        imageView.frame = CGRect(x: 0, y: 300, width: view.frame.width, height: view.frame.height - 300)
        
        let frame = CGRect(x: (view.frame.width - 150)/2, y: 100, width: 150, height: 150)
        
        loader = WSLoader(frame: frame, style: .excutable)
        view.addSubview(loader)
        
//        loader.textColor = .red
//        loader.textFont = .systemFont(ofSize: 50)
//        loader.trackWidth = 25
//        loader.fillColor = .green
//        loader.subTextColor = .yellow
//        loader.buttonTintColor = .red
//        loader.pulsingScale = 1.4
//        loader.pulsingDuration = 1.6
//        loader.isPulsing = true
        loader.pauseAction = { atPercentage in
            print(atPercentage, "====")
            self.task.cancel { (data) in
                if data != nil {
                    self.resumeData = data!
                    self.task = nil
                }
            }
        }
        
        loader.playAction = { atPercentage in
            if self.resumeData?.count != 0 {
                self.task = self.session.downloadTask(withResumeData: self.resumeData!)
            }
            self.task.resume()
            self.resumeData = nil
        }
        
        let config = URLSessionConfiguration.default
        session = URLSession(configuration: config, delegate: self, delegateQueue: OperationQueue())
        let url = URL(string: "https://images.pexels.com/photos/2939337/pexels-photo-2939337.jpeg")
        task = session.downloadTask(with: url!)

    }
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        
        let caches = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true).last
        let fileName = task.response?.suggestedFilename
        let filePath = "\(caches!)/\(fileName!)"
        print(filePath)
        do {
            try FileManager.default.moveItem(atPath: location.path, toPath: filePath)
        }catch {
            print(error)
        }
        
        DispatchQueue.main.async {
            self.imageView.image = UIImage(contentsOfFile: filePath)
        }
    }
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) {
        
        let percent = CGFloat(totalBytesWritten) / CGFloat(totalBytesExpectedToWrite)
        
        DispatchQueue.main.async {
            
            self.loader.value = percent
            if percent == 1 {
                self.loader.text = "OK"
            }
            
        }
    }
}


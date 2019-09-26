//
//  ViewController.swift
//  WSLoader
//
//  Created by CoooooooderJ on 2019/9/24.
//  Copyright © 2019 CoooooooderJ. All rights reserved.
//

import UIKit
import CoreTelephony

class ViewController: UIViewController, URLSessionDownloadDelegate {

    var loader: WSLoader!
    var resumeData: Data?
    var imageView = UIImageView()
    var task: URLSessionDownloadTask!
    var session: URLSession!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupImageView()
        setupLoader()
        setupCellularUpdateNotifier()
        
        setupSessionAndTestNetwork()
    }
    
    fileprivate func setupSessionAndTestNetwork() {
        let config = URLSessionConfiguration.default
        session = URLSession(configuration: config, delegate: self, delegateQueue: OperationQueue())
        let task = session.dataTask(with: URL(string: "https://www.baidu.com")!)
        task.resume()
    }
    
    fileprivate func setupCellularUpdateNotifier() {
        let cellularData = CTCellularData()
        cellularData.cellularDataRestrictionDidUpdateNotifier = { cellularState in
            DispatchQueue.main.async {
                self.loader.isUserInteractionEnabled = cellularState == .notRestricted
            }
        }
    }
    
    fileprivate func setupImageView() {
        view.addSubview(imageView)
        imageView.contentMode = .scaleAspectFill
        imageView.frame = CGRect(x: 0, y: 300, width: view.frame.width, height: view.frame.height - 300)
    }
    
    fileprivate func setupLoader() {
        let frame = CGRect(x: (view.frame.width - 150)/2, y: 100, width: 150, height: 150)
        loader = WSLoader(frame: frame, style: .excutable)
        view.addSubview(loader)
        
        loader.textColor = .red
        loader.textFont = .systemFont(ofSize: 28)
        loader.trackWidth = 25
        loader.subText = "已完成"
        loader.subTextColor = .pink
        loader.buttonTintColor = .red
        loader.pulsingScale = 1.4
        loader.pulsingDuration = 1.6
        loader.stopPulsingWhenFinish = true
        
        loader.pauseAction = { atPercentage in
            self.task.cancel { (data) in
                if data != nil {
                    self.resumeData = data!
                    self.task = nil
                    print("stop at \(data!.count)")
                }
            }
        }
        
        loader.playAction = { atPercentage in
            if self.resumeData != nil {
                self.task = self.session.downloadTask(withResumeData: self.resumeData!)
            } else {
                let url = URL(string: "https://images.pexels.com/photos/2939337/pexels-photo-2939337.jpeg")
                self.task = self.session.downloadTask(with: url!)
            }
            self.task.resume()
            self.resumeData = nil
        }
    }

    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        let caches = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true).last
        let fileName = task.response?.suggestedFilename
        let filePath = "\(caches!)/\(fileName!)"
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


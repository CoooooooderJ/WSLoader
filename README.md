# WSLoader
一个可自定义样式的圆形进度加载控件。 欢迎 issue

[English Version](https://github.com/CoooooooderJ/WSLoader/blob/master/EN_README.md)



## I. 效果

![](https://github.com/CoooooooderJ/WSLoader/blob/master/resource4readme/1569441940366065.gif)

```低配版```


![](https://github.com/CoooooooderJ/WSLoader/blob/master/resource4readme/1569441940198703.gif)

```高配版```





## II. 环境
swift version 5.1

iOS version 11.0+ （其他版本未测试。 没有使用过低版本不支持的 API， 所以改一下 target 的版本， 应该都能够兼容）




## III. 使用
1. 拿过源文件直接用
2. 初始化传入样式 style，就可以像正常控件一样使用了
   ```swift
        let frame = CGRect(x: (view.frame.width - 150)/2, y: 100, width: 150, height: 150)
        loader = WSLoader(frame: frame, style: .excutable)
        view.addSubview(loader)
        loader.value = 0.2
   ```
   height 值无所谓多少，因为 **loader** 的 rect 总是正方形， 只根据 frame 来构建视图和图层。
   之后，在合适的地方，给 **loader** 的 value 和 text 属性赋值就行了。 UI操作已经进行主线程异步处理，所以赋值操作不用再在主线程进行了
3. style 有四种：
    * none
  
        ![](https://github.com/CoooooooderJ/WSLoader/blob/master/resource4readme/41569444870_.pic.jpg)
    * label

        ![](https://github.com/CoooooooderJ/WSLoader/blob/master/resource4readme/51569445260_.pic.jpg)
    * bilabel

        ![](https://github.com/CoooooooderJ/WSLoader/blob/master/resource4readme/61569445379_.pic.jpg)
    * excutable

        效果如最开始的两张效果图。可以通过赋值 playAction 和 pauseAction 这两个闭包 来实现 loader 的点击
        当 **loader** value 值设置成 1.0 时，会自动切换成 label 样式
4. 使用 excutable 样式时，需要资源文件包含有 “play” 和 “pause” 两张图片。 请自行替换
5. 高配版本 loader 样式代码
    ```swift
        let frame = CGRect(x: (view.frame.width - 150)/2, y: 100, width: 150, height: 150)
        loader = WSLoader(frame: frame, style: .excutable)
        view.addSubview(loader)
        
        loader.textColor = .red
        loader.textFont = .systemFont(ofSize: 28)
        loader.trackWidth = 25

        loader.buttonTintColor = .red
        loader.isPulsing = true
        loader.pulsingScale = 1.4
        loader.pulsingDuration = 1.6
        loader.stopPulsingWhenFinish = true
        
        loader.pauseAction = { atPercentage in
            /*
            self.task.cancel { (data) in
                if data != nil {
                    self.resumeData = data!
                    self.task = nil
                    print("stop at \(data!.count)")
                }
            }
            */
        }
        
        loader.playAction = { atPercentage in
            /*
            if self.resumeData != nil {
                self.task = self.session.downloadTask(withResumeData: self.resumeData!)
            } else {
                let url = URL(string: "https://images.pexels.com/photos/2939337/pexels-photo-2939337.jpeg")
                self.task = self.session.downloadTask(with: url!)
            }
            self.task.resume()
            self.resumeData = nil
            */
        }
    ```



## IV. 注意
# *Demo中所包含的图片网址 或者本文档中的效果图所包含的下载图片， 来自于 pexels.com. 如有侵权，请联系删除！*




## V. 如果此 repo 对您有用， 不妨赞赏几枚硬币买杯咖啡哈😝
<img src="https://github.com/CoooooooderJ/WSLoader/blob/master/resource4readme/paypal.png" width=30 height=30> paypal： https://www.paypal.me/coooooooderj

<img src="https://github.com/CoooooooderJ/WSLoader/blob/master/resource4readme/wechat.png" width=30 height=30> 微信赞赏： <img src="https://github.com/CoooooooderJ/WSLoader/blob/master/resource4readme/coffee.jpg" width=180 height=180>






## VI. 联系
<img src="https://github.com/CoooooooderJ/WSLoader/blob/master/resource4readme/wechat.png" width=30 height=30> myjawdrops

<img src="https://github.com/CoooooooderJ/WSLoader/blob/master/resource4readme/tencent.png" width=30 height=30> 894318488




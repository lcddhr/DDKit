//
//  DDCircleView.swift
//  DouyuTV
//
//  Created by lovelydd on 16/1/15.
//  Copyright © 2016年 xiaomutou. All rights reserved.
//

import UIKit
import Neon

public typealias DDCircleViewCellRef = AutoreleasingUnsafeMutablePointer<DDCircleViewCell>

@objc public protocol DDCircleViewDelegate: NSObjectProtocol {
    
    //循环视图的总数
    func numberOfItemsInCircleView(circleVIew: DDCircleView) -> Int
    
    //视图的配置
//    func circleView(circleView: DDCircleView, configCell cellRef:DDCircleViewCellRef)
    
    //视图点击的回调
//    func circleView(circleView: DDCircleView, didSelectedAtIndex index: Int)
    
    //视图数据
    func imagesOfCircleView(circleView: DDCircleView) -> NSArray
    
    //视图的配置回调
//    func circleView(circleView: DDCircleView, imageView: UIImageView, configIndex index: Int)

}

public class DDCircleView: UIView {

    public weak var circleDelegate: DDCircleViewDelegate?
    
    private var timer = GCDTimer()
    private var currentIndex: Int = 0
    private var imageCount: Int = 0
    private var imageWithURLs: NSArray = []{
        
        didSet {
            if imageWithURLs.count == 1 {
                
                self.bannerView.pageControl.hidden = true;
            } else {
                
                self.bannerView.pageControl.hidden = false;
                self.bannerView.pageControl.numberOfPages = imageWithURLs.count
            }
            
        }

    }
    private var scrollTimerInterval:NSTimeInterval = 3.5
    

    var contentScrollView: UIScrollView!
    var currentImageView:   UIImageView!
    var lastImageView:      UIImageView!
    var nextImageView:      UIImageView!
    
    var indexOfCurrentImage: Int!  {                // 当前显示的第几张图片
        //监听显示的第几张图片，来更新分页指示器
        didSet {
            self.bannerView.pageControl.currentPage = indexOfCurrentImage
        }
    }
    
    
    lazy var bannerView: DDBannerView = {
    
        let bannerView = DDBannerView(frame: CGRectMake(0 , self.height - 50, self.width, 50))
        return bannerView
    }()
    


    //MARK: Life Cycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.conigUI()
    }
    override public func awakeFromNib() {
        
        super.awakeFromNib()
        self.conigUI()
    }
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    private func conigUI() {
        self.indexOfCurrentImage = 0
        self.contentScrollView = UIScrollView(frame: self.bounds)
//        contentScrollView.contentSize = CGSizeMake(self.frame.size.width * 3, 0)
        contentScrollView.delegate = self
        contentScrollView.bounces = false
        contentScrollView.pagingEnabled = true
        contentScrollView.backgroundColor = UIColor.greenColor()
        contentScrollView.showsHorizontalScrollIndicator = false
        self.addSubview(contentScrollView)
        
        self.lastImageView = createImageView(CGRectZero)
        self.currentImageView = createImageView(CGRectZero)
        self.nextImageView = createImageView(CGRectZero)
        
        contentScrollView.addSubview(currentImageView)
        contentScrollView.addSubview(lastImageView)
        contentScrollView.addSubview(nextImageView)
        
        let imageTap = UITapGestureRecognizer(target: self, action: Selector("imageTapAction:"))
        currentImageView.addGestureRecognizer(imageTap)

        self.setupTimer()
        
        self.addSubview(self.bannerView)
        
    }
    
    func createImageView(frame: CGRect) -> UIImageView{
        let imageView = UIImageView()
        imageView.frame = frame
        imageView.contentMode = UIViewContentMode.ScaleAspectFill
        imageView.clipsToBounds = true
        return imageView;
    }

    
    private func reloadData() {
        
        guard self.circleDelegate != nil else {
            return;
        }
        
        self.imageCount = (self.circleDelegate?.imagesOfCircleView(self).count)!
        self.imageWithURLs = (self.circleDelegate?.imagesOfCircleView(self))!
        contentScrollView.scrollEnabled = !(imageCount == 1)
        
        let nextIndex = self.getNextImageIndex(self.indexOfCurrentImage)
        let lastIndex = self.getLastImageIndex(self.indexOfCurrentImage)
        
        let currentImageUrl = self.imageWithURLs[self.indexOfCurrentImage] as! NSString
        let nextImageUrl = self.imageWithURLs[nextIndex] as! NSString
        let lastImageUrl = self.imageWithURLs[lastIndex] as! NSString
        
        self.currentImageView.setImageWithURL(currentImageUrl)
        self.nextImageView.setImageWithURL(nextImageUrl)
        self.lastImageView.setImageWithURL(lastImageUrl)
        
        
    }
    //MARK: Timer
    func setupTimer() {
        
        self.timer.stop();
        self.timer.start(scrollTimerInterval) { () -> Void in
            
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                self.runTimer()
            })
        }
    }
    
    func runTimer() {
         contentScrollView.setContentOffset(CGPointMake(self.frame.size.width * 2, 0), animated: true)
    }
    
    //MARK: Private Method
    
    //拿到上一张图片的下标
    private func getLastImageIndex(index: Int) -> Int {
        
        let tempIndex = index - 1
        
        if tempIndex == -1 {
            
            return self.imageCount - 1
        } else {
            
            return tempIndex
        }
    }
    
    //拿到下一张图片的下标
    private func getNextImageIndex(index: Int) -> Int {
        
        let tempIndex = index + 1
        return tempIndex < self.imageCount ? tempIndex : 0;
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        
        self.contentScrollView.frame = self.bounds
       self.contentScrollView.contentSize =  CGSizeMake( self.bounds.width, self.frame.size.height)
        
        self.lastImageView.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)
        self.currentImageView.frame = CGRectMake(self.frame.size.width, 0, self.frame.size.width, self.frame.size.height)
        self.nextImageView.frame = CGRectMake(self.frame.size.width * 2, 0, self.frame.size.width, self.frame.size.height)
        self.bannerView.frame = CGRectMake(0 , self.height - 50, self.width, 50);
    }
    
}

extension DDCircleView: UIScrollViewDelegate {
   
    public func scrollViewWillBeginDragging(scrollView: UIScrollView) {
        
        self.timer.stop()
    }
    
    public func scrollViewDidEndDragging(scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        self.setupTimer()
        
        if !decelerate {
            self.scrollViewDidEndDecelerating(scrollView)
        }

    }
    
    public func scrollViewDidEndScrollingAnimation(scrollView: UIScrollView) {

        self.scrollViewDidEndDecelerating(contentScrollView)
    }
    
    //滑动停止的时候执行这个方法
    public func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        

        let offset = scrollView.contentOffset.x
        if offset == 0 {
            self.indexOfCurrentImage = self.getLastImageIndex(self.indexOfCurrentImage)
        }else if offset == self.frame.size.width * 2 {
            self.indexOfCurrentImage = self.getNextImageIndex(self.indexOfCurrentImage)
        }
        // 重新布局图片
        self.reloadData()
        
        //布局后把contentOffset设为中间
        scrollView.setContentOffset(CGPointMake(self.frame.size.width, 0), animated: false)
        
        self.setupTimer()

    }

    
}



//MARK: DDCircleViewCell
public class DDCircleViewCell:UICollectionViewCell {
    
    static let reuseID = "DDCircleViewCellIdentifier"
    
    var index: Int?
    
    lazy var imageView: UIImageView = {
        let imageView = UIImageView(frame: self.bounds)
        imageView.contentMode = .ScaleAspectFill
        imageView.backgroundColor = UIColor.redColor()
        return imageView
    }()
    
    override init(frame: CGRect) {
        
        super.init(frame: frame);
        self.configUI()
    }

    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    private func configUI() {
       
        self.addSubview(self.imageView)
    }
    
    override public func layoutSubviews() {
        super.layoutSubviews()
        self.imageView.frame = self.bounds
    }
}

//MARK: DDBannerView 
public class DDBannerView: UIView {
    
    var titleLabel: UILabel!
    var pageControl: UIPageControl!
    
    public override init(frame: CGRect) {
        
        super.init(frame: frame)
        self.configUI()
    }
    public convenience init() {
        self.init(frame:CGRectZero)
        self.configUI()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func configUI() {
        
//        self.backgroundColor = UIColor.lightGrayColor()

        self.titleLabel = UILabel()
        self.titleLabel.font = UIFont.systemFontOfSize(14.0)
        self.titleLabel.textColor = UIColor.blackColor()
        self.titleLabel.text = "测试title"
        self.titleLabel.textAlignment = .Left
        
        self.pageControl = UIPageControl(frame: CGRectZero)
        self.pageControl.backgroundColor = UIColor.clearColor()
        self.pageControl.currentPage = 0
        self.pageControl.pageIndicatorTintColor = UIColor.grayColor()
        self.pageControl.currentPageIndicatorTintColor = UIColor.blackColor()
        
        
        self.addSubview(self.titleLabel)
        self.addSubview(self.pageControl)
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        self.titleLabel.anchorToEdge(.Left, padding: 20, width: 120, height: self.height)
        self.pageControl.anchorToEdge(.Right, padding: 5, width: 100, height: self.height)
    }
    
    
}

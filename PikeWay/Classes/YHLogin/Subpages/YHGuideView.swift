//
//  YHGuideView.swift
//  PikeWay
//
//  Created by YHIOS002 on 17/3/3.
//  Copyright © 2017年 YHSoft. All rights reserved.
//  引导图

import Foundation

class YHGuideView:UIView{
    
    fileprivate var viewBG = UIView() //灰色背景
    fileprivate var view1  = UIView() //指引1
    fileprivate var view2  = UIView() //指引2
    fileprivate var view3  = UIView() //指引3
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        //frame默认值
        self.frame = CGRect(x: 0, y: 0, width: ScreenWidth, height: ScreenHeight)
        
        //背景
        viewBG.backgroundColor = UIColor(red: 0/255.0, green: 0/255.0, blue: 0/255.0, alpha: 0.65)
        viewBG.frame = self.frame
        self.addSubview(viewBG)
        
        //先显示指引1
        showFirstGuide()
        //        showSecondGuide()
        //        showThirdGuide()
    }
    
    //显示指引一
    fileprivate func showFirstGuide(){
        let imgvircleW = CGFloat(ScreenWidth/2+30)
        let imgvircleH = CGFloat(135)
        let imgvHandW  = ScreenWidth - imgvircleW
        var imgvHandH  = CGFloat(90)
        if imgvHandW < 190 {
            imgvHandH  = imgvHandH * imgvHandW / 190
        }
        
        //圈
        let imgvircle = UIImageView(frame: CGRect(x: 0, y: 214, width:imgvircleW , height: imgvircleH))
        imgvircle.image = UIImage(named: "guide_img_circle1")
        viewBG.addSubview(imgvircle)
        
        //手
        let imgvHand = UIImageView(frame: CGRect(x: imgvircle.right+5, y:0 , width:imgvHandW , height: imgvHandH))
        imgvHand.top = imgvircle.centerY
        imgvHand.image = UIImage(named: "guide_img_hand1and2")
        viewBG.addSubview(imgvHand)
        
        //文字
        let imgvText = UIImageView(frame: CGRect(x: 0, y: imgvircle.bottom, width: 265, height: 50))
        imgvText.image = UIImage(named: "guide_img_text1")
        viewBG.addSubview(imgvText)
        
        //按钮“知道”
        let imgvKnow = UIImageView(frame: CGRect(x: 0, y: imgvText.bottom+30, width: 190, height: 81))
        imgvKnow.centerX = self.centerX
        imgvKnow.image = UIImage(named: "guide_img_know")
        imgvKnow.tag = 101
        imgvKnow.isUserInteractionEnabled = true
        let gesture = UITapGestureRecognizer(target: self, action: #selector(gestureOnKnow(aGesture:)))
        imgvKnow.addGestureRecognizer(gesture)
        viewBG.addSubview(imgvKnow)
    }
    
    //显示指引二
    fileprivate func showSecondGuide(){
        
        let imgvircleW = CGFloat(110)
        let imgvircleH = CGFloat(70)
        let imgvHandW  = CGFloat(190)
        let imgvHandH  = CGFloat(90)
        
        
        //圈
        let imgvircle = UIImageView(frame: CGRect(x: 0, y: 340, width: imgvircleW, height: imgvircleH))
        imgvircle.image = UIImage(named: "guide_img_circle2and3")
        viewBG.addSubview(imgvircle)
        
        //手
        let imgvHand = UIImageView(frame: CGRect(x: imgvircle.right+15, y:0 , width: imgvHandW, height: imgvHandH))
        imgvHand.top = imgvircle.centerY - 10
        imgvHand.image = UIImage(named: "guide_img_hand1and2")
        viewBG.addSubview(imgvHand)
        
        //文字
        let imgvText = UIImageView(frame: CGRect(x: 0, y: imgvircle.bottom+20, width: 265, height: 50))
        imgvText.image = UIImage(named: "guide_img_text2")
        viewBG.addSubview(imgvText)
        
        //按钮“知道”
        //适配iPhon4
        var knowFame = CGRect(x: 0, y: imgvText.bottom+10, width: 190, height: 81)
        if UIScreen.main.bounds.size.height < 500 {
            knowFame = CGRect(x: 0, y: 230, width: 190, height: 81)
        }
        
        let imgvKnow = UIImageView(frame: knowFame)
        imgvKnow.centerX = self.centerX
        imgvKnow.image = UIImage(named: "guide_img_know")
        imgvKnow.tag = 102
        imgvKnow.isUserInteractionEnabled = true
        let gesture = UITapGestureRecognizer(target: self, action: #selector(gestureOnKnow(aGesture:)))
        imgvKnow.addGestureRecognizer(gesture)
        viewBG.addSubview(imgvKnow)
    }
    
    //显示指引三
    fileprivate func showThirdGuide(){
        
        let imgvircleW = CGFloat(110)
        let imgvircleH = CGFloat(70)
        var imgvHandW  = CGFloat(190)
        var imgvHandH  = CGFloat(90)
        if  imgvHandW > ScreenWidth/2 - imgvircleW/4 {
            imgvHandW = ScreenWidth/2 - imgvircleW/4
            imgvHandH = imgvHandH * imgvHandW / 190
        }
        
        
        
        //圈
        let imgvircle = UIImageView(frame: CGRect(x: 0, y: self.bottom-imgvircleH, width: imgvircleW, height: imgvircleH))
        imgvircle.centerX = self.centerX
        imgvircle.image = UIImage(named: "guide_img_circle2and3")
        viewBG.addSubview(imgvircle)
        
        //手
        let imgvHand = UIImageView(frame: CGRect(x: 0, y: 0, width: imgvHandW, height: imgvHandH))
        imgvHand.bottom = imgvircle.centerY + 5
        imgvHand.right  = self.right
        imgvHand.image = UIImage(named: "guide_img_hand3")
        viewBG.addSubview(imgvHand)
        
        //文字
        let imgvText = UIImageView(frame: CGRect(x: 0, y: 0, width: 180, height: 35))
        imgvText.bottom = imgvircle.top - 30
        imgvText.centerX = self.centerX
        imgvText.image = UIImage(named: "guide_img_text3")
        viewBG.addSubview(imgvText)
        
        //按钮“立即体验”
        let imgvKnow = UIImageView(frame: CGRect(x: 0, y: 0, width: 190, height: 81))
        imgvKnow.bottom = imgvText.top - 10
        imgvKnow.centerX = self.centerX
        imgvKnow.image = UIImage(named: "guide_img_experience")
        imgvKnow.tag = 103
        imgvKnow.isUserInteractionEnabled = true
        let gesture = UITapGestureRecognizer(target: self, action: #selector(gestureOnKnow(aGesture:)))
        imgvKnow.addGestureRecognizer(gesture)
        viewBG.addSubview(imgvKnow)
    }
    
    @objc func gestureOnKnow(aGesture:UITapGestureRecognizer){
        guard let view = aGesture.view else{return}
        switch view.tag {
        case 101:
            viewBG.removeAllSubviews()
            //显示下一张
            showSecondGuide()
            break
        case 102:
            viewBG.removeAllSubviews()
            //显示下一张
            showThirdGuide()
            break
        case 103:
            viewBG.removeAllSubviews()
            //移除指引图
            self.removeFromSuperview()
            //标记已读
            UserDefaults.standard.set(true, forKey: "HasReadWelcomePage")
            UserDefaults.standard.synchronize()
            break
        default:
            break
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    class func show() -> YHGuideView{
        let v = YHGuideView()
        UIApplication.shared.keyWindow?.addSubview(v)
        return v
    }
    
    
    deinit {
        YHPrint("YHGuideView is deinit")
    }
    
}

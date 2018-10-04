//
//  YHScanLoginToTax.swift
//  PikeWay
//  扫码登录到财税+
//  Created by YHIOS002 on 2018/8/23.
//  Copyright © 2018年 YHSoft. All rights reserved.
//

import Foundation
//import MBProgressHUD

class YHScanLoginToTax:UIViewController {
    
    var QRCodeId:String? = nil
    var btnClose:UIButton {
        let _btnClose = UIButton(type: .custom)
        _btnClose.frame = CGRect(x: 5, y: 5, width: 60, height: 40)
        _btnClose.setTitleColor(kBlueColor, for: .normal)
        _btnClose.setTitle("关闭", for: .normal)
        _btnClose.titleLabel?.textAlignment = .left
        _btnClose.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        _btnClose.addTarget(self, action: #selector(YHLoginByWebVC.onClose), for: .touchUpInside)
        return _btnClose
    }
    
    var imgvLogin:UIImageView {
        let _imgvLogin = UIImageView()
        _imgvLogin.image = UIImage(named: "login_img_PC")
        _imgvLogin.frame = CGRect(origin: CGPoint.zero, size:CGSize(width: 158, height: 158))
        _imgvLogin.center = CGPoint(x: self.view.center.x, y: (self.view.center.y - 120))
        return _imgvLogin
    }
    
    var lbLogin:UILabel {
        let _lbLogin = UILabel()
        _lbLogin.textColor = UIColor.black
        _lbLogin.textAlignment = .center
        _lbLogin.frame = CGRect(origin: CGPoint.zero, size: CGSize(width: self.view.frame.width-40, height: 40))
        _lbLogin.center = self.view.center
        _lbLogin.font = UIFont.systemFont(ofSize: 18)
        _lbLogin.text = "财税+登录确认"
        return _lbLogin
    }
    
    var btnLogin:UIButton {
        let _btnLogin = UIButton(type: .custom)
        _btnLogin.frame = CGRect(x: 0, y: 0, width: 200, height: 40)
        _btnLogin.center = CGPoint(x: self.view.center.x, y: lbLogin.center.y+150)
        _btnLogin.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        _btnLogin.layer.cornerRadius  = 5
        _btnLogin.layer.borderColor = kBlueColor.cgColor
        _btnLogin.layer.borderWidth = 1
        _btnLogin.layer.masksToBounds = true
        _btnLogin.setTitle("登录", for: .normal)
        _btnLogin.setTitleColor(kBlueColor, for: .normal)
        _btnLogin.addTarget(self, action: #selector(onLogin), for: .touchUpInside)
        return _btnLogin
    }
    
    var btnCancelLogin:UIButton {
        let _btnCancelLogin = UIButton(type: .custom)
        _btnCancelLogin.frame = CGRect(x: 0, y: 0, width: 80, height: 40)
        _btnCancelLogin.center = CGPoint(x: self.view.center.x, y: btnLogin.center.y + 50)
        _btnCancelLogin.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        _btnCancelLogin.setTitleColor(kGrayColor, for: .normal)
        _btnCancelLogin.addTarget(self, action: #selector(YHLoginByWebVC.onCancel), for: .touchUpInside)
        _btnCancelLogin.setTitle("取消登录", for: .normal)
        return _btnCancelLogin
    }
    
    // MARK: - Life
    override func viewDidLoad() {
        
        self.view.addSubview(btnClose)
        self.view.addSubview(imgvLogin)
        self.view.addSubview(lbLogin)
        self.view.addSubview(btnLogin)
        self.view.addSubview(btnCancelLogin)
        
        self.view.backgroundColor = UIColor.white
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    // MARK: - Action
    @objc func onClose() {
        self.dismiss(animated: true, completion:nil)
        NotificationCenter.default.post(name: Notification.Name("event.closeScanPage"), object: nil)
    }
    
    @objc func onLogin() {
        guard self.QRCodeId != nil else{
            YHPrint("QRCodeId is nil ")
            return
        }
        
        //扫码登录
        MBProgressHUD.showAdded(to: self.view, animated: true)
        
        NetManager.sharedInstance().postLogin(byTaxQRCode: QRCodeId) { [weak self](success, obj) in
            if let weakSelf = self{
                MBProgressHUD.hide(for: weakSelf.view, animated: true)
                if success{
                    postTips("财税+登录成功", "财税+登录成功")
                    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()+1, execute: {
                        weakSelf.onClose()
                    })
                    
                }else{
                    
                    if obj is Dictionary <String,AnyObject> {
                        if let dict = obj as? Dictionary<String,AnyObject>{
                            if let msg = dict["msg"] as? String{
                                postTips(msg, "财税+登录失败")
                            }
                        }else{
                            postTips(obj, "财税+登录失败")
                        }
                        
                    }else{
                        postTips(obj, "财税+登录失败")
                    }
                }
            }
        }
            
        
        

    }
    
    @objc func onCancel(){
        self.dismiss(animated: true, completion:nil)
        NotificationCenter.default.post(name: Notification.Name("event.closeScanPage"), object: nil)
    }
    
    // MARK: -
    
}

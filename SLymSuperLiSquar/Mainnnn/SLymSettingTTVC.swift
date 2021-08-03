//
//  SLymSettingTTVC.swift
//  SLymSuperLiSquar
//
//  Created by JOJO on 2021/7/28.
//

import UIKit
import MessageUI
import StoreKit
import Defaults
import NoticeObserveKit
import DeviceKit


let AppName: String = "PicFrame"
let purchaseUrl = ""
let TermsofuseURLStr = "https://www.app-privacy-policy.com/live.php?token=pu7pw6ay347q7ZvyNhhYv9mfJ0PMVGQS"
let PrivacyPolicyURLStr = "https://www.app-privacy-policy.com/live.php?token=BDErxQV7kGfpGiEtR3UKoZBYyB03KE2S"
let feedbackEmail: String = "bushmask@yandex.com"
let AppAppStoreID: String = ""




class SLymSettingTTVC: UIViewController {

    
    let backBtn = UIButton(type: .custom)
    
    let userPlaceIcon = UIImageView()
    let userNameLabel = UILabel()
    let feedbackBtn = SettingContentBtn(frame: .zero, name: "Feedback", iconImage: UIImage(named: "setting_feedback"))
    let privacyLinkBtn = SettingContentBtn(frame: .zero, name: "Privacy Policy", iconImage: UIImage(named: "setting_privacy"))
    let termsBtn = SettingContentBtn(frame: .zero, name: "Terms of use", iconImage: UIImage(named: "setting_term"))
    let logoutBtn = SettingContentBtn(frame: .zero, name: "Log out", iconImage: UIImage(named: "setting_logout"))
    let loginBtn = UIButton(type: .custom)
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupContentView()
        updateUserAccountStatus()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateUserAccountStatus()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    @objc func backBtnClick(sender: UIButton) {
        if self.navigationController != nil {
            self.navigationController?.popViewController()
        } else {
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    func setupView() {
        view.backgroundColor = UIColor.white
        backBtn
            .title("Back")
            .titleColor(UIColor.black)
            .font(20, "Quicksand-Bold")
//            .image(UIImage(named: "ic_back"))
        backBtn.addTarget(self, action: #selector(backBtnClick(sender:)), for: .touchUpInside)

//
        
        view.addSubview(backBtn)
        backBtn.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(10)
            $0.left.equalTo(24)
            $0.width.greaterThanOrEqualTo(1)
            $0.height.equalTo(44)
        }
        
        let topTitleLabel = UILabel()
            .fontName(20, "Quicksand-Bold")
            .color(UIColor.black)
            .text("Setting")
        view.addSubview(topTitleLabel)
        topTitleLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.centerY.equalTo(backBtn)
            $0.width.height.greaterThanOrEqualTo(1)
        }
        
        //
        view.addSubview(userPlaceIcon)
        userPlaceIcon
            .image("setting_head")
        
        userPlaceIcon.snp.makeConstraints {
            $0.centerY.equalTo(backBtn.snp.centerY)
            $0.right.equalTo(-26)
            $0.height.equalTo(34)
        }
        
        //
        userNameLabel.font = UIFont(name: "Quicksand-Bold", size: 18)
//        userNameLabel.layer.shadowColor = UIColor(hexString: "#292929")?.cgColor
//        userNameLabel.layer.shadowOffset = CGSize(width: 0, height: 0)
//        userNameLabel.layer.shadowRadius = 3
//        userNameLabel.layer.shadowOpacity = 0.8
        userNameLabel.textColor = UIColor(hexString: "#000000")
        userNameLabel.textAlignment = .center
        userNameLabel.text = "Clik to log in"
        view.addSubview(userNameLabel)
        userNameLabel.adjustsFontSizeToFitWidth = true
        userNameLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(backBtn.snp.bottom).offset(40)
            $0.width.greaterThanOrEqualTo(1)
            $0.height.greaterThanOrEqualTo(1)
        }
    }
     

    @objc func loginBtnClick(sender: UIButton) {
        self.showLoginVC()
    }
    //
    func setupContentView() {
        view.addSubview(loginBtn)
        loginBtn.addTarget(self, action: #selector(loginBtnClick(sender:)), for: .touchUpInside)
        loginBtn.snp.makeConstraints {
            $0.center.equalTo(userNameLabel)
            $0.height.equalTo(44)
            $0.left.equalToSuperview()
        }
        
        let btnwidth: CGFloat = 100
        let btnheight: CGFloat = 160
        let leftPad: CGFloat = (UIScreen.width - (btnwidth * 2)) / 3
        
        // feedback
        view.addSubview(feedbackBtn)
        feedbackBtn.clickBlock = {
            [weak self] in
            guard let `self` = self else {return}
            self.feedback()
        }
        feedbackBtn.snp.makeConstraints {
            $0.left.equalTo(leftPad)
            $0.height.equalTo(btnheight)
            $0.width.equalTo(btnwidth)
            $0.top.equalTo(userNameLabel.snp.bottom).offset(20)
            
        }
        
//        if Device.current.diagonal == 4.7 || Device.current.diagonal > 7 {
//            feedbackBtn.snp.makeConstraints {
//                $0.width.equalTo(357)
//                $0.height.equalTo(64)
//                $0.top.equalTo(userNameLabel.snp.bottom).offset(27)
//                $0.centerX.equalToSuperview()
//            }
//        } else {
//            feedbackBtn.snp.makeConstraints {
//                $0.width.equalTo(357)
//                $0.height.equalTo(64)
//                $0.top.equalTo(userNameLabel.snp.bottom).offset(37)
//                $0.centerX.equalToSuperview()
//            }
//        }
        
        // privacy link
        view.addSubview(privacyLinkBtn)
        privacyLinkBtn.clickBlock = {
            [weak self] in
            guard let `self` = self else {return}
            UIApplication.shared.openURL(url: PrivacyPolicyURLStr)
        }
        privacyLinkBtn.snp.makeConstraints {
            $0.right.equalTo(-leftPad)
            $0.height.equalTo(btnheight)
            $0.width.equalTo(btnwidth)
            $0.top.equalTo(feedbackBtn.snp.top)
            
        }
        // terms
        
        view.addSubview(termsBtn)
        termsBtn.clickBlock = {
            [weak self] in
            guard let `self` = self else {return}
            UIApplication.shared.openURL(url: TermsofuseURLStr)
        }
        termsBtn.snp.makeConstraints {
            $0.left.equalTo(leftPad)
            $0.height.equalTo(btnheight)
            $0.width.equalTo(btnwidth)
            $0.top.equalTo(feedbackBtn.snp.bottom).offset(40)
            
        }
        
        // logout
        view.addSubview(logoutBtn)
        logoutBtn.clickBlock = {
            [weak self] in
            guard let `self` = self else {return}
            LoginMNG.shared.logout()
            self.updateUserAccountStatus()
        }
        logoutBtn.snp.makeConstraints {
            $0.right.equalTo(-leftPad)
            $0.height.equalTo(btnheight)
            $0.width.equalTo(btnwidth)
            $0.top.equalTo(termsBtn.snp.top)
        }
        
    }
    
}


extension SLymSettingTTVC {
     
    
    func showLoginVC() {
        if LoginMNG.currentLoginUser() == nil {
            let loginVC = LoginMNG.shared.obtainVC()
            loginVC.modalTransitionStyle = .crossDissolve
            loginVC.modalPresentationStyle = .fullScreen
            
            self.present(loginVC, animated: true) {
            }
        }
    }
    func updateUserAccountStatus() {
        if let userModel = LoginMNG.currentLoginUser() {
            let userName  = userModel.userName
            userNameLabel.text = (userName?.count ?? 0) > 0 ? userName : "Sign in With Apple succeeded"
            logoutBtn.isHidden = false
            loginBtn.isHidden = true
            userPlaceIcon.isHidden = false
//            loginBtn.isUserInteractionEnabled = false
            
        } else {
            userNameLabel.text = "Clik to log in"
            logoutBtn.isHidden = true
            loginBtn.isHidden = false
            userPlaceIcon.isHidden = true
//            loginBtn.isUserInteractionEnabled = true
            
        }
    }
}

extension SLymSettingTTVC: MFMailComposeViewControllerDelegate {
    func feedback() {
        //首先要判断设备具不具备发送邮件功能
        if MFMailComposeViewController.canSendMail(){
            //获取系统版本号
            let systemVersion = UIDevice.current.systemVersion
            let modelName = UIDevice.current.modelName
            
            let infoDic = Bundle.main.infoDictionary
            // 获取App的版本号
            let appVersion = infoDic?["CFBundleShortVersionString"] ?? "8.8.8"
            // 获取App的名称
            let appName = "\(AppName)"

            
            let controller = MFMailComposeViewController()
            //设置代理
            controller.mailComposeDelegate = self
            //设置主题
            controller.setSubject("\(appName) Feedback")
            //设置收件人
            // FIXME: feed back email
            controller.setToRecipients([feedbackEmail])
            //设置邮件正文内容（支持html）
         controller.setMessageBody("\n\n\nSystem Version：\(systemVersion)\n Device Name：\(modelName)\n App Name：\(appName)\n App Version：\(appVersion )", isHTML: false)
            
            //打开界面
            self.present(controller, animated: true, completion: nil)
        }else{
            HUD.error("The device doesn't support email")
        }
    }
    
    //发送邮件代理方法
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
        
    }
 }



class SettingContentBtn: UIButton {
    var clickBlock: (()->Void)?
    var nameTitle: String
    var iconImage: UIImage?
    init(frame: CGRect, name: String, iconImage: UIImage?) {
        self.nameTitle = name
        self.iconImage = iconImage
        super.init(frame: frame)
        setupView()
        addTarget(self, action: #selector(clickAction(sender:)), for: .touchUpInside)
    }
    
    @objc func clickAction(sender: UIButton) {
        clickBlock?()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView() {
        self.backgroundColor = .clear
//        self.layer.cornerRadius = 17
//        self.layer.borderWidth = 4
//        self.layer.borderColor = UIColor.black.cgColor
        
        
        //
        let iconImgV = UIImageView(image: iconImage)
        iconImgV.contentMode = .scaleAspectFit
        addSubview(iconImgV)
        iconImgV.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.centerX.equalToSuperview()
            $0.width.height.equalTo(100)
        }
        //
        let nameLabel = UILabel()
        addSubview(nameLabel)
        nameLabel.text = nameTitle
        nameLabel.numberOfLines(2)
        nameLabel.textColor = UIColor(hexString: "#000000")
        nameLabel.font = UIFont(name: "Quicksand-Bold", size: 18)
        nameLabel.textAlignment = .center
        nameLabel.numberOfLines(0)
        nameLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(iconImgV.snp.bottom).offset(11)
            $0.height.greaterThanOrEqualTo(1)
            $0.left.equalTo(0)
        }
        
         
        
    }
    
}

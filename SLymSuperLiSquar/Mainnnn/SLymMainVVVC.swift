//
//  SLymMainVVVC.swift
//  SLymSuperLiSquar
//
//  Created by JOJO on 2021/7/28.
//

import UIKit
import Photos
import YPImagePicker


class SLymMainVVVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        showLoginVC()
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2) {
            AFlyerLibManage.event_LaunchApp()
        }
    }
    func showLoginVC() {
        if LoginMNG.currentLoginUser() == nil {
            let loginVC = LoginMNG.shared.obtainVC()
            loginVC.modalTransitionStyle = .crossDissolve
            loginVC.modalPresentationStyle = .fullScreen
            
            self.present(loginVC, animated: true) {
            }
        }
    }
    func setupView() {
        let topOverImagV = UIImageView()
        topOverImagV
            .image("dmitriy")
            .contentMode(.scaleAspectFill)
            .adhere(toSuperview: self.view)
        topOverImagV.snp.makeConstraints {
            $0.left.right.top.equalToSuperview()
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-210)
        }
        //
        let bottomBgView = UIView()
        bottomBgView
            .backgroundColor(.white)
            .adhere(toSuperview: self.view)
        bottomBgView.snp.makeConstraints {
            $0.left.right.bottom.equalToSuperview()
            $0.top.equalTo(topOverImagV.snp.bottom)
        }
        //
        let centerImgV = UIImageView()
        centerImgV
            .image("home_hello_backgro")
            .adhere(toSuperview: self.view)
        centerImgV.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.centerY.equalTo(bottomBgView.snp.top).offset(2)
            $0.width.equalTo(690 / 2)
            $0.height.equalTo(654 / 2)
        }
        //
        let infoLabel1 = UILabel()
        infoLabel1
            .text(AppName)
            .color(UIColor(hexString: "#007D89")!)
            .fontName(30, "Quicksand-Bold")
            .textAlignment(.center)
            .adhere(toSuperview: self.view)
        infoLabel1.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalTo(bottomBgView.snp.top).offset(-72)
            $0.width.height.greaterThanOrEqualTo(1)
        }
        //
        let infoLabel2 = UILabel()
        infoLabel2
            .text("Likes Blur Effect")
            .color(UIColor(hexString: "#007D89")!)
            .fontName(16, "Quicksand-Bold")
            .textAlignment(.center)
            .adhere(toSuperview: self.view)
        infoLabel2.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(infoLabel1.snp.bottom).offset(4)
            $0.width.height.greaterThanOrEqualTo(1)
        }
        
        //
        let enterBtn = UIButton(type: .custom)
        enterBtn
            .image(UIImage(named: "home_create"))
            .adhere(toSuperview: self.view)
        enterBtn.snp.makeConstraints {
            $0.right.equalTo(centerImgV.snp.right).offset(-17)
            $0.centerY.equalTo(bottomBgView.snp.top).offset(3)
            $0.width.equalTo(172/2)
            $0.height.equalTo(178/2)
        }
        enterBtn.addTarget(self, action: #selector(enterBtnClick(sender:)), for: .touchUpInside)
        //
        let settingBtn = SLymMainToolBtn(frame: .zero, iconStr: "home_ic_setting", name: "Setting")
        view.addSubview(settingBtn)
        settingBtn.snp.makeConstraints {
            $0.right.equalTo(view.snp.centerX).offset(-25)
            $0.top.equalTo(bottomBgView.snp.top).offset(25)
            $0.width.equalTo(80)
            $0.height.equalTo(80)
        }
        settingBtn.addTarget(self, action: #selector(settingBtnClick(sender:)), for: .touchUpInside)
        //
        let storeBtn = SLymMainToolBtn(frame: .zero, iconStr: "home_ic_store", name: "Store")
        view.addSubview(storeBtn)
        storeBtn.snp.makeConstraints {
            $0.left.equalTo(view.snp.centerX).offset(25)
            $0.top.equalTo(bottomBgView.snp.top).offset(25)
            $0.width.equalTo(80)
            $0.height.equalTo(80)
        }
        storeBtn.addTarget(self, action: #selector(storeBtnClick(sender:)), for: .touchUpInside)
        
    }

    
    
    @objc func enterBtnClick(sender: UIButton) {
        checkAlbumAuthorization()
    }
    
    @objc func settingBtnClick(sender: UIButton) {
        self.navigationController?.pushViewController(SLymSettingTTVC())
    }
    
    @objc func storeBtnClick(sender: UIButton) {
        self.navigationController?.pushViewController(SLymStorereVC())
    }
    
    func presntEditViewController(image: UIImage) {
        let editVC = SLymEdittttVC()
        editVC.image = image
        self.navigationController?.pushViewController(editVC)

    }
}


class SLymMainToolBtn: UIButton {
    
    init(frame: CGRect, iconStr: String, name: String) {
        super.init(frame: frame)
        let iconImgV = UIImageView()
        iconImgV
            .image(iconStr)
            .contentMode(.center)
            .adhere(toSuperview: self)
        iconImgV.snp.makeConstraints {
            $0.width.height.equalTo(24)
            $0.bottom.equalTo(snp.centerY)
            $0.centerX.equalToSuperview()
        }
        //
        let nameLabel = UILabel()
        nameLabel
            .text(name)
            .textAlignment(.center)
            .fontName(18, "Quicksand-Bold")
            .color(UIColor(hexString: "#010101")!)
            .adhere(toSuperview: self)
        nameLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(iconImgV.snp.bottom).offset(7)
            $0.left.equalTo(2)
            $0.height.greaterThanOrEqualTo(1)
        }
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}

extension SLymMainVVVC: UIImagePickerControllerDelegate {
    
    func checkAlbumAuthorization() {
        
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            PHPhotoLibrary.requestAuthorization(for: .readWrite) { status in
                switch status {
                case .authorized:
                    DispatchQueue.main.async {
                        self.presentPhotoPickerController()
                    }
                case .limited:
                    DispatchQueue.main.async {
                        self.presentLimitedPhotoPickerController()
                    }
                case .notDetermined:
                    if status == PHAuthorizationStatus.authorized {
                        DispatchQueue.main.async {
                            self.presentPhotoPickerController()
                        }
                    } else if status == PHAuthorizationStatus.limited {
                        DispatchQueue.main.async {
                            self.presentLimitedPhotoPickerController()
                        }
                    }
                case .denied:
                    DispatchQueue.main.async {
                        [weak self] in
                        guard let `self` = self else {return}
                        let alert = UIAlertController(title: "Oops", message: "You have declined access to photos, please active it in Settings>Privacy>Photos.", preferredStyle: .alert)
                        let confirmAction = UIAlertAction(title: "Ok", style: .default, handler: { (goSettingAction) in
                            DispatchQueue.main.async {
                                let url = URL(string: UIApplication.openSettingsURLString)!
                                UIApplication.shared.open(url, options: [:])
                            }
                        })
                        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
                        alert.addAction(confirmAction)
                        alert.addAction(cancelAction)
                        
                        self.present(alert, animated: true)
                    }
                    
                case .restricted:
                    DispatchQueue.main.async {
                        [weak self] in
                        guard let `self` = self else {return}
                        let alert = UIAlertController(title: "Oops", message: "You have declined access to photos, please active it in Settings>Privacy>Photos.", preferredStyle: .alert)
                        let confirmAction = UIAlertAction(title: "Ok", style: .default, handler: { (goSettingAction) in
                            DispatchQueue.main.async {
                                let url = URL(string: UIApplication.openSettingsURLString)!
                                UIApplication.shared.open(url, options: [:])
                            }
                        })
                        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
                        alert.addAction(confirmAction)
                        alert.addAction(cancelAction)
                        
                        self.present(alert, animated: true)
                    }
                default: break
                }
            }
        }
    }
    
    func presentLimitedPhotoPickerController() {
        var config = YPImagePickerConfiguration()
        config.library.maxNumberOfItems = 1
        config.screens = [.library]
        config.library.defaultMultipleSelection = false
        config.library.skipSelectionsGallery = true
        config.showsPhotoFilters = false
        config.library.preselectedItems = nil
        let picker = YPImagePicker(configuration: config)
        picker.didFinishPicking { [unowned picker] items, cancelled in
            var imgs: [UIImage] = []
            for item in items {
                switch item {
                case .photo(let photo):
                    if let img = photo.image.scaled(toWidth: 1200) {
                        imgs.append(img)
                    }
                    print(photo)
                case .video(let video):
                    print(video)
                }
            }
            picker.dismiss(animated: true, completion: nil)
            if !cancelled {
                if let image = imgs.first {
                    self.showEditVC(image: image)
                }
            }
        }
        
        present(picker, animated: true, completion: nil)
    }
    
    
    
//    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
//        picker.dismiss(animated: true, completion: nil)
//        var imgList: [UIImage] = []
//
//        for result in results {
//            result.itemProvider.loadObject(ofClass: UIImage.self, completionHandler: { (object, error) in
//                if let image = object as? UIImage {
//                    DispatchQueue.main.async {
//                        // Use UIImage
//                        print("Selected image: \(image)")
//                        imgList.append(image)
//                    }
//                }
//            })
//        }
//        if let image = imgList.first {
//            self.showEditVC(image: image)
//        }
//    }
    
 
    func presentPhotoPickerController() {
        let myPickerController = UIImagePickerController()
        myPickerController.allowsEditing = false
        myPickerController.delegate = self
        myPickerController.sourceType = .photoLibrary
        self.present(myPickerController, animated: true, completion: nil)

    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        dismiss(animated: true, completion: nil)
        if let image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            self.showEditVC(image: image)
        } else if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            self.showEditVC(image: image)
        }

    }
//
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func showEditVC(image: UIImage) {
        DispatchQueue.main.async {
            [weak self] in
            guard let `self` = self else {return}
            self.openImageClipping(image: image)
//            let vc = LMyMirrorEffectEditVC(originalImg: image)
//            self.navigationController?.pushViewController(vc)
        }
    }
}

extension SLymMainVVVC:  UINavigationControllerDelegate, ImageClippingViewControllerDelegate {
    
     
   
    
    func openImageClipping(image: UIImage) {
        var contentInsets = UIEdgeInsets(top: 50, left: 0, bottom: (40 + 30 + 30 + 10), right: 0)
        let isX = UIScreen.main.bounds.size.height > 736.0
        if isX {
            contentInsets.top += 24
            contentInsets.bottom += 34
        }
        
        let configure = JPImageresizerConfigure.defaultConfigure(withResize: image) { (configure) in
            configure?.jp_resizeWHScale(1.0)
            configure?.jp_contentInsets(contentInsets)
        }
        let vc = ImageClippingViewController.init()
        vc.modalTransitionStyle = .crossDissolve
        vc.modalPresentationStyle = .fullScreen
        vc.delegate = self
        vc.configure = configure
        self.present(vc, animated: true) {
        }
    }
    
    func clippingImage(image: UIImage) {
        self.presntEditViewController(image: image)
    }
    
    func clippingDismiss() {
    }
    
}

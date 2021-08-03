//
//  SLymEdittttVC.swift
//  SLymSuperLiSquar
//
//  Created by JOJO on 2021/7/29.
//

import UIKit
import Photos
import YPImagePicker

class SLymEdittttVC: UIViewController {

    var image: UIImage?
    let editView = EditView()
    let fillCancelBtn = UIButton(type: .custom)
    let fillOkBtn = UIButton(type: .custom)
    let blurSlider = UISlider()
    let coinAlertView = SLymRemoveAlertView()
    
    var isProVip: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(hexString: "#FFFFFF")
        setupCanvasView()
        setupView()
        setupCoinAlertProView()
        fillCancelBtnClick(sender: fillCancelBtn)
    }
    
    @objc func backBtnClick(sender: UIButton) {
        if self.navigationController != nil {
            self.navigationController?.popViewController()
        } else {
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    @objc func saveBtnClick(sender: UIButton) {
        if isProVip == true {
            showCoinAlertView(title: "Paid items will be deducted \(LMymBCartCoinManager.default.coinCostCount) coins.", okBtnStr: "Save") {
                DispatchQueue.main.async {
                    [weak self] in
                    guard let `self` = self else {return}
                    self.saveImage()
                }
            }
        } else {
            saveImage()
        }
        
    }
    
    func setupView() {
        let bottombar = UIView()
        bottombar
            .adhere(toSuperview: self.view)
        bottombar.snp.makeConstraints {
            $0.left.right.bottom.equalToSuperview()
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-54)
        }
        //
        let backBtn = UIButton(type: .custom)
        backBtn
            .backgroundColor(UIColor(hexString: "#1C1C1E")!)
            .adhere(toSuperview: bottombar)
        backBtn.snp.makeConstraints {
            $0.top.left.bottom.equalToSuperview()
            $0.right.equalTo(bottombar.snp.centerX)
        }
        backBtn.addTarget(self, action: #selector(backBtnClick(sender:)), for: .touchUpInside)
        let backBtnTitleLabel = UILabel()
        backBtnTitleLabel
            .text("Back")
            .fontName(20, "Quicksand-Bold")
            .color(UIColor.white)
            .adhere(toSuperview: bottombar)
        backBtnTitleLabel.snp.makeConstraints {
            $0.centerX.equalTo(backBtn)
            $0.height.equalTo(54)
            $0.top.equalTo(backBtn.snp.top)
            
        }
        //
        //
        let saveBtn = UIButton(type: .custom)
        saveBtn
            .backgroundImage(UIImage(named: "button_save"))
            .adhere(toSuperview: bottombar)
        saveBtn.addTarget(self, action: #selector(saveBtnClick(sender:)), for: .touchUpInside)
        saveBtn.snp.makeConstraints {
            $0.top.right.bottom.equalToSuperview()
            $0.left.equalTo(bottombar.snp.centerX)
        }
        let saveBtnTitleLabel = UILabel()
        saveBtnTitleLabel
            .text("Save")
            .fontName(20, "Quicksand-Bold")
            .color(UIColor.white)
            .adhere(toSuperview: bottombar)
        saveBtnTitleLabel.snp.makeConstraints {
            $0.centerX.equalTo(saveBtn)
            $0.height.equalTo(54)
            $0.top.equalTo(saveBtn.snp.top)
        }
        //
        //
        let bgListView = SLymBgImgView()
        bgListView
            .adhere(toSuperview: view)
        bgListView.snp.makeConstraints {
            $0.left.right.equalToSuperview()
            $0.bottom.equalTo(bottombar.snp.top)
            $0.height.equalTo(120)
        }
        bgListView.clickSelectBlock = {
            [weak self] item in
            guard let `self` = self else {return}
            DispatchQueue.main.async {
                self.updateBgImgAction(item: item)
            }
        }
        //
        let toolBgView = UIView()
        toolBgView
            .backgroundColor(.white)
            .adhere(toSuperview: view)
        toolBgView.snp.makeConstraints {
            $0.left.right.equalToSuperview()
            $0.bottom.equalTo(bgListView.snp.top)
            $0.top.equalTo(editView.snp.bottom)
        }
        //
        let toolContentView = UIView()
        toolContentView
            .backgroundColor(.white)
            .adhere(toSuperview: toolBgView)
        toolContentView.snp.makeConstraints {
            $0.left.right.equalToSuperview()
            $0.centerY.equalToSuperview()
            $0.height.equalTo(100)
        }
        //
        let picblurLabel = UILabel()
        picblurLabel
            .fontName(18, "Quicksand-Bold")
            .color(UIColor.black)
            .text("PicBlur")
            .textAlignment(.left)
            .adhere(toSuperview: toolContentView)
        picblurLabel.snp.makeConstraints {
            $0.left.equalTo(25)
            $0.bottom.equalTo(toolContentView.snp.centerY).offset(-10)
            $0.width.lessThanOrEqualTo(80)
            $0.height.greaterThanOrEqualTo(1)
        }
        //
        let fillEnLabel = UILabel()
        fillEnLabel
            .fontName(18, "Quicksand-Bold")
            .color(UIColor.black)
            .text("Fill Entire Photo")
            .textAlignment(.left)
            .adhere(toSuperview: toolContentView)
        fillEnLabel.snp.makeConstraints {
            $0.left.equalTo(25)
            $0.top.equalTo(toolContentView.snp.centerY).offset(10)
            $0.width.greaterThanOrEqualTo(1)
            $0.height.greaterThanOrEqualTo(1)
        }
        
        //
        
        blurSlider.setThumbImage(UIImage(named: "edit_slider_ball"), for: .normal)
        blurSlider.setMinimumTrackImage(UIImage(named: "edit_slider"), for: .normal)
        blurSlider.setMaximumTrackImage(UIImage.init(color: UIColor(hexString: "#F7F7F7")!, size: CGSize(width: 236, height: 4)), for: .normal)
        blurSlider.minimumValue = 0
        blurSlider.maximumValue = 25
        blurSlider.value = 0
        toolContentView.addSubview(blurSlider)
        blurSlider.snp.makeConstraints {
            $0.centerY.equalTo(picblurLabel.snp.centerY)
            $0.left.equalTo(picblurLabel.snp.right).offset(14)
            $0.right.equalTo(-25)
            $0.height.equalTo(30)
        }
        blurSlider.addTarget(self, action: #selector(blurSliderValueChange(slider:)), for: .valueChanged)
          
        //

        fillCancelBtn
            .image(UIImage(named: "edit_space_no"))
            .adhere(toSuperview: toolContentView)
        fillCancelBtn.layer.cornerRadius = 22
        fillCancelBtn.layer.borderWidth = 2
        fillCancelBtn.layer.borderColor = UIColor(hexString: "#0EB1C8")?.cgColor
        fillCancelBtn.snp.makeConstraints {
            $0.centerY.equalTo(fillEnLabel.snp.centerY)
            $0.right.equalTo(-25)
            $0.width.height.equalTo(44)
        }
        fillCancelBtn.addTarget(self, action: #selector(fillCancelBtnClick(sender:)), for: .touchUpInside)
        //
        
        fillOkBtn
            .image(UIImage(named: "edit_space_yes"))
            .adhere(toSuperview: toolContentView)
        fillOkBtn.layer.cornerRadius = 22
        fillOkBtn.layer.borderWidth = 2
        fillOkBtn.layer.borderColor = UIColor(hexString: "#0EB1C8")?.cgColor
        fillOkBtn.snp.makeConstraints {
            $0.centerY.equalTo(fillEnLabel.snp.centerY)
            $0.right.equalTo(fillCancelBtn.snp.left).offset(-12)
            $0.width.height.equalTo(44)
        }
        fillOkBtn.addTarget(self, action: #selector(fillOkBtnClick(sender:)), for: .touchUpInside)
        
        
        
    }
    
    func setupCoinAlertProView() {
        coinAlertView.alpha = 0
        view.addSubview(coinAlertView)
        coinAlertView.snp.makeConstraints {
            $0.left.right.bottom.top.equalToSuperview()
        }

    }
    
    
    
    func setupCanvasView() {
        editView.backgroundColor = UIColor.init(hexString: "#17181F")
        self.editView.assignmentImage(image: self.image ?? UIImage())
        self.view.addSubview(editView)
        
        //
        let left: CGFloat = 0
        
        //
        editView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            $0.left.equalTo(left)
            $0.centerX.equalToSuperview()
            $0.height.equalTo(editView.snp.width).multipliedBy(1)
        }
        
        editView.removeWatermarkBlock = {
            [weak self] in
            guard let `self` = self else {return}
            DispatchQueue.main.async {
                
                self.showCoinAlertView(title: "It costs \(LMymBCartCoinManager.default.coinCostCount) coins to remove the watermark.", okBtnStr: "OK") {
                    DispatchQueue.main.async {
                        [weak self] in
                        guard let `self` = self else {return}
                        self.editView.removeWaterMark()
                    }
                }

            }
        }
    }
    
    @objc func fillOkBtnClick(sender: UIButton) {
        updateFillEntirStatus(isFill: true)
        fillOkBtn.layer.borderWidth = 2
        fillCancelBtn.layer.borderWidth = 0
    }
    
    @objc func fillCancelBtnClick(sender: UIButton) {
        updateFillEntirStatus(isFill: false)
        fillOkBtn.layer.borderWidth = 0
        fillCancelBtn.layer.borderWidth = 2
    }
    
    func showCoinAlertView(title: String?, okBtnStr: String?, okBlock: (()->Void)?) {
        // show coin alert
        UIView.animate(withDuration: 0.35) {
            self.coinAlertView.alpha = 1
        }
        if let title_m = title {
            coinAlertView.infoLabel.text = title_m
            coinAlertView.saveButton.setTitle(okBtnStr, for: .normal)
        }
        
        coinAlertView.okBtnClickBlock = {
            [weak self] in
            guard let `self` = self else {return}
            
            if LMymBCartCoinManager.default.coinCount >= LMymBCartCoinManager.default.coinCostCount {
                DispatchQueue.main.async {
                    LMymBCartCoinManager.default.costCoin(coin: LMymBCartCoinManager.default.coinCostCount)
                    okBlock?()
                }
            } else {
                DispatchQueue.main.async {
                    self.showAlert(title: "", message: "Insufficient coins, please buy at the store first !", buttonTitles: ["OK"], highlightedButtonIndex: 0) { i in
                        DispatchQueue.main.async {
                            [weak self] in
                            guard let `self` = self else {return}
                            self.navigationController?.pushViewController(SLymStorereVC())
                        }
                    }
                }
            }

            UIView.animate(withDuration: 0.25) {
                self.coinAlertView.alpha = 0
            } completion: { finished in
                if finished {
                    
                }
            }
        }
        
        
        coinAlertView.backBtnClickBlock = {
            [weak self] in
            guard let `self` = self else {return}
            UIView.animate(withDuration: 0.25) {
                self.coinAlertView.alpha = 0
            } completion: { finished in
                if finished {
                    
                }
            }
        }
        
    }
    
}

extension SLymEdittttVC {
    func updateBgImgAction(item: SLymEditToolItem) {
        
        if item.thumb == "background_1" {
            //
            checkAlbumAuthorization()
        } else {
            isProVip = item.pro
            //
            updateBgColorImg(img: UIImage(named: item.big))
        }
    }
    
    func updateBgColorImg(img: UIImage?) {
        self.editView.bgImageView.image = img
    }
    
    func presntEditViewController(image: UIImage) {
        isProVip = false
        updateBgColorImg(img: image)
    }
    
    func updateFillEntirStatus(isFill: Bool) {
        self.editView.topImageView.isHidden = !isFill
    }
    
    func updateSharpeChangeValue(value: Float) {
        self.editView.changevisualEffect(blurRadius: CGFloat(25 - value))
    }
    
    func saveImage() {
        editView.controlIsHidden(hidden: true)
        
        self.view.layoutIfNeeded()
        let image = UIImage.createImage(view: self.editView)
        let  bigImage = image.scaleImage(scaleSize: 6)
        saveToAlbumPhotoAction(images: [bigImage])
        debugPrint(bigImage)
        editView.controlIsHidden(hidden: false)
        
        
    }
    
    @objc func blurSliderValueChange(slider: UISlider) {
        self.updateSharpeChangeValue(value: slider.value)
    }
    
    
    
    
}

extension SLymEdittttVC {
    func saveToAlbumPhotoAction(images: [UIImage]) {
        DispatchQueue.main.async(execute: {
            PHPhotoLibrary.shared().performChanges({
                [weak self] in
                guard let `self` = self else {return}
                for img in images {
                    PHAssetChangeRequest.creationRequestForAsset(from: img)
                }
            }) { (finish, error) in
                if finish {
                    DispatchQueue.main.async {
                        [weak self] in
                        guard let `self` = self else {return}
                        self.showSaveSuccessAlert()
//                        if self.shouldCostCoin {
//                            LMymBCartCoinManager.default.costCoin(coin: LMymBCartCoinManager.default.coinCostCount)
//                        }
                    }
                } else {
                    DispatchQueue.main.async {
                        [weak self] in
                        guard let `self` = self else {return}
                        if error != nil {
                            let auth = PHPhotoLibrary.authorizationStatus()
                            if auth != .authorized {
                                self.showDenideAlert()
                            }
                        }
                    }
                }
            }
        })
    }
    
    func showSaveSuccessAlert() {
        HUD.success("Photo save successful.")
    }
    
    func showDenideAlert() {
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
    }
    
}



extension SLymEdittttVC: UIImagePickerControllerDelegate {
    
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

extension SLymEdittttVC:  UINavigationControllerDelegate, ImageClippingViewControllerDelegate {
    
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


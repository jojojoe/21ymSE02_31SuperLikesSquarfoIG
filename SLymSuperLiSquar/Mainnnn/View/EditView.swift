//
//  EditView.swift
//  SuperLike
//
//  Created by 薛忱 on 2021/6/21.
//

import UIKit
import VisualEffectView

typealias REMOVEWATERMARKBLOCK = () -> Void
class EditView: UIView {
    
    var orignImage = UIImage()
    let visualEffectView = VisualEffectView()
    
    let bgImageView = UIImageView()
    let topImageView = UIImageView()
    
    var watermarkContentView = UIView()
    var stickerView: GYStickerView?
    
    let removeButton = UIButton()
    var removeWatermarkBlock: REMOVEWATERMARKBLOCK?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.addSubview(bgImageView)
        bgImageView.snp.makeConstraints { make in
            make.top.left.bottom.right.equalTo(0)
        }
        
        visualEffectView.tintColor = .clear
        visualEffectView.blurRadius = 25
        visualEffectView.scale = 1
        self.addSubview(visualEffectView)
        visualEffectView.snp.makeConstraints { make in
            make.top.left.bottom.right.equalTo(0)
        }
        
        watermarkContentView.backgroundColor = .clear
        
        let view = UIView()
        view.backgroundColor = UIColor.init(hexString: "#FFFFFF")?.withAlphaComponent(0.22)
        watermarkContentView.addSubview(view)
        view.snp.makeConstraints { make in
            make.right.bottom.equalTo(0)
            make.left.top.equalTo(10)
        }
        
        let label = UILabel()
        label.text = AppName
        label.textColor = .white
        label.textAlignment = .center
        label.font = UIFont(name: "Quicksand-Bold", size: 14)
        view.addSubview(label)
        label.snp.makeConstraints { make in
            make.top.left.bottom.right.equalTo(0)
        }
        
        removeButton.setImage(UIImage(named: "edit_ic_delete"), for: .normal)
        removeButton.addTarget(self, action: #selector(removeButtonClick(button:)), for: .touchUpInside)
        watermarkContentView.addSubview(removeButton)
        removeButton.snp.makeConstraints { make in
            make.top.left.equalTo(0)
            make.width.equalTo(20)
            make.height.equalTo(20)
        }
        
    }
    
    func changevisualEffect(blurRadius: CGFloat) {
        self.visualEffectView.blurRadius = blurRadius
    }
    
    func changeBgImage(image: UIImage) {
        self.bgImageView.image = image
    }
    
    func removeWaterMark() {
        self.watermarkContentView.isHidden = true
    }
    
    @objc func removeButtonClick(button: UIButton) {
        
        removeWatermarkBlock?()
    }
    
    func assignmentImage(image: UIImage) {
        self.orignImage = image
        self.bgImageView.image = self.orignImage
        self.topImageView.image = self.orignImage
        
        let contentView = UIImageView(image: self.orignImage)
        stickerView = GYStickerView(contentView: contentView)
        stickerView?.ctrlType = GYStickerViewCtrlType.two
        stickerView?.scaleMode = GYStickerViewScaleMode.transform
        stickerView?.originalPoint = CGPoint(x: 0.5, y: 0.5)
        stickerView?.isScaleFit = false
        stickerView?.isText = true
        stickerView?.isEdit = true
        stickerView?.showOriginalPoint(false)
        stickerView?.showReversalCtrl(false)
        stickerView?.showRemoveCtrl(false)
        stickerView?.rotateCtrlImage(UIImage(named: "edit_ic_rotate"))
        stickerView?.layer.masksToBounds = false
        self.addSubview(stickerView ?? GYStickerView())
        stickerView?.snp.makeConstraints({ make in
            make.top.left.equalTo(45)
            make.bottom.right.equalTo(-45)
        })
        
        topImageView.image = self.orignImage
        topImageView.isHidden = true
        self.addSubview(topImageView)
        topImageView.snp.makeConstraints { make in
            make.top.left.bottom.right.equalTo(0)
        }
        
        self.addSubview(watermarkContentView)
        watermarkContentView.snp.makeConstraints { make in
            make.right.bottom.equalTo(0)
            make.height.equalTo(42)
            make.width.equalTo(150)
        }
    }
    
    func controlIsHidden(hidden: Bool) {
        if hidden {
            stickerView?.hiddenCtrls()
        } else {
            stickerView?.showCtrls()
        }
        
        removeButton.isHidden = hidden
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}

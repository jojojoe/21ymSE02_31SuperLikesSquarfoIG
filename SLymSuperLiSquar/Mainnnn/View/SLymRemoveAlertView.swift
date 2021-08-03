//
//  SLymRemoveAlertView.swift
//  SLymSuperLiSquar
//
//  Created by JOJO on 2021/7/29.
//

import UIKit

class SLymRemoveAlertView: UIView {
    
    let contentView = UIView()
    var okBtnClickBlock: (()->Void)?
    var backBtnClickBlock: (()->Void)?
    
    let saveButton = UIButton()
    
    let infoLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.init(hexString: "#17181F", transparency: 0.8)
        
        contentView.backgroundColor = UIColor.clear
        self.addSubview(contentView)
        contentView.snp.makeConstraints {
            $0.width.equalTo(320)
            $0.height.equalTo(250)
            $0.centerX.equalToSuperview()
            $0.centerY.equalToSuperview().offset(20)
        }
        //
        let coverImgV = UIImageView()
        coverImgV
            .image("costcoin_background")
            .adhere(toSuperview: contentView)
        coverImgV.snp.makeConstraints {
            $0.left.right.top.bottom.equalToSuperview()
        }
        //
        
        infoLabel
            .fontName(16, "Quicksand-Bold")
            .color(UIColor.white)
            .textAlignment(.center)
            .numberOfLines(2)
            .text("\(LMymBCartCoinManager.default.coinCostCount) coins will be deducted for using paid items.")
            .adhere(toSuperview: contentView)
        infoLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalTo(contentView.snp.bottom).offset(-48)
            $0.width.equalTo(280)
            $0.height.greaterThanOrEqualTo(1)
        }
        
        
        
        //
        let closeButton = UIButton()
        closeButton.setImage(UIImage(named: "ic_close-1"), for: .normal)
        closeButton.addTarget(self, action: #selector(closeButtonClick(button:)), for: .touchUpInside)
        addSubview(closeButton)
        closeButton.snp.makeConstraints { make in
            make.width.height.equalTo(48)
            make.top.equalTo(safeAreaLayoutGuide.snp.top).offset(10)
            make.right.equalTo(-10)
        }
         
        //
        saveButton.setBackgroundImage(UIImage(named: "costcoin_button"), for: .normal)
        saveButton.setTitle("Save", for: .normal)
        saveButton.setTitleColor(UIColor.init(hexString: "#FFFFFF"), for: .normal)
        saveButton.titleLabel?.font = UIFont(name: "Quicksand-Bold", size: 18)
        saveButton.addTarget(self, action: #selector(saveButtonClick(button:)), for: .touchUpInside)
        addSubview(saveButton)
        saveButton.snp.makeConstraints {
            $0.top.equalTo(contentView.snp.bottom).offset(16)
            $0.width.equalTo(130)
            $0.height.equalTo(48)
            $0.centerX.equalToSuperview()
        }
        
    }
    
    @objc func saveButtonClick(button: UIButton) {
        self.okBtnClickBlock?()
        
    }
    
    @objc func closeButtonClick(button: UIButton) {
        backBtnClickBlock?()
    }
    
    
    
     
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}

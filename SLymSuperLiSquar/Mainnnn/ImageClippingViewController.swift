//
//  ImageClippingViewController.swift
//  ProfileMakeup
//
//  Created by 薛忱 on 2019/6/24.
//  Copyright © 2019 薛忱. All rights reserved.
//

import UIKit

protocol ImageClippingViewControllerDelegate: class {
    func clippingImage(image: UIImage)
    func clippingDismiss()
}

class ImageClippingViewController: UIViewController {

    var configure: JPImageresizerConfigure?
    var imageresizerView: JPImageresizerView?
    weak var delegate: ImageClippingViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        imageresizerView = JPImageresizerView.init(configure: self.configure, imageresizerIsCanRecovery: { (isCanRecovery) in
            
        }) { (isPrepareToScale) in
            
        }
//        imageresizerView?.resizeWHScale = 
        imageresizerView?.frameType = JPImageresizerFrameType.classicFrameType
        self.view.insertSubview(imageresizerView!, at: 0)
        
        let topView = UIView()
        topView.backgroundColor = UIColor.clear
        self.view.addSubview(topView)
        topView.snp.makeConstraints {
            $0.top.left.right.equalTo(0)
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.top).offset(44)
        }
        
        let remakebutton = UIButton()
        remakebutton.backgroundColor = .clear
        remakebutton.addTarget(self, action: #selector(remakeButtonClick(button:)), for: .touchUpInside)
        remakebutton.setImage(UIImage(named: "remakes"), for: .normal)
        self.view.addSubview(remakebutton)
        
        remakebutton.snp.makeConstraints { (make) in
            make.width.height.equalTo(40)
            make.right.equalTo(-20)
            make.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom).offset(-40)
        }
        
        let backButton = UIButton()
        backButton.addTarget(self, action: #selector(backButtonClick(button:)), for: .touchUpInside)
        backButton.setImage(UIImage(named: "close_w"), for: .normal)
        topView.addSubview(backButton)
        backButton.snp.makeConstraints { (make) in
            make.width.height.equalTo(44)
            make.left.equalTo(10)
            make.bottom.equalTo(0)
        }
        
        let clippingButton = UIButton()
        clippingButton.addTarget(self, action: #selector(saveButtonClick(button:)), for: .touchUpInside)
        clippingButton.setImage(UIImage(named: "done_w"), for: .normal)
        topView.addSubview(clippingButton)
        clippingButton.snp.makeConstraints { (make) in
            make.width.height.equalTo(44)
            make.right.equalTo(-15)
            make.bottom.equalTo(0)
        }
    }
    
    @objc func backButtonClick(button: UIButton) {
        self.delegate?.clippingDismiss()
        self.dismiss(animated: true) {
        }
    }
    
    @objc func saveButtonClick(button: UIButton) {
        self.imageresizerView?.imageresizer(complete: { (image) in
            if image == nil {
                return
            }
            
            DispatchQueue.main.async {
                self.dismiss(animated: true, completion: {
                    self.delegate?.clippingImage(image: image ?? UIImage())
                })
            }
        })

    }
    
    @objc func remakeButtonClick(button: UIButton) {
        self.imageresizerView?.recovery()
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

//
//  SLymStorereVC.swift
//  SLymSuperLiSquar
//
//  Created by JOJO on 2021/7/29.
//

import UIKit
import NoticeObserveKit
import StoreKit
import Adjust
import SwiftyStoreKit

class SLymStorereVC: UIViewController {
     
    private var pool = Notice.ObserverPool()
    
    let backBtn = UIButton(type: .custom)
    let topCoinLabel = UILabel()
    var collection: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        setupView()
        setupCollection()
        addNotificationObserver()
        
    }
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    func addNotificationObserver() {
        
        NotificationCenter.default.nok.observe(name: .pi_noti_coinChange) {[weak self] _ in
            guard let `self` = self else {return}
            DispatchQueue.main.async {
                self.topCoinLabel.text = "\(LMymBCartCoinManager.default.coinCount)"
            }
        }
        .invalidated(by: pool)
        
        NotificationCenter.default.nok.observe(name: .pi_noti_priseFetch) { [weak self] _ in
            guard let `self` = self else {return}
            DispatchQueue.main.async {
                self.collection.reloadData()
            }
        }
        .invalidated(by: pool)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.topCoinLabel.text = "\(LMymBCartCoinManager.default.coinCount)"
    }
    
}

extension SLymStorereVC {
    
    @objc func backBtnClick(sender: UIButton) {
        if self.navigationController != nil {
            self.navigationController?.popViewController()
        } else {
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    func setupView() {
        
        backBtn
            .title("Back")
            .titleColor(UIColor.black)
            .font(20, "Quicksand-Bold")
        backBtn.addTarget(self, action: #selector(backBtnClick(sender:)), for: .touchUpInside)
            
        
        view.addSubview(backBtn)
        backBtn.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(24)
            $0.left.equalTo(10)
            $0.width.greaterThanOrEqualTo(1)
            $0.height.equalTo(44)
        }
        
        let topTitleLabel = UILabel()
            .fontName(20, "Quicksand-Bold")
            .color(UIColor.black)
            .text("store")
        view.addSubview(topTitleLabel)
        topTitleLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.centerY.equalTo(backBtn)
            $0.width.height.greaterThanOrEqualTo(1)
        }
        
        //
        topCoinLabel.textAlignment = .right
        topCoinLabel.text = "\(LMymBCartCoinManager.default.coinCount)"
        topCoinLabel.textColor = UIColor.black
        topCoinLabel.font = UIFont(name: "Quicksand-Bold", size: 20)
        view.addSubview(topCoinLabel)
        topCoinLabel.snp.makeConstraints {
            $0.centerY.equalTo(backBtn)
            $0.right.equalTo(-24)
            $0.height.greaterThanOrEqualTo(35)
            $0.width.greaterThanOrEqualTo(25)
        }
        //
//        let topCoinImgV = UIImageView(image: UIImage(named: "store_coin300"))
//        view.addSubview(topCoinImgV)
//        topCoinImgV.snp.makeConstraints {
//            $0.centerY.equalTo(topCoinLabel)
//            $0.right.equalTo(topCoinLabel.snp.left).offset(-5)
//            $0.width.height.equalTo(25)
//        }
        
        
    }
    
    func setupCollection() {
        
        // collection
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        collection = UICollectionView.init(frame: CGRect.zero, collectionViewLayout: layout)
        collection.showsHorizontalScrollIndicator = false
        collection.showsVerticalScrollIndicator = false
        collection.backgroundColor = .clear
//        collection.layer.cornerRadius = 35
        collection.layer.masksToBounds = true
        collection.delegate = self
        collection.dataSource = self
        view.addSubview(collection)
        collection.snp.makeConstraints {
            $0.left.equalToSuperview()
            $0.top.equalTo(topCoinLabel.snp.bottom).offset(5)
            $0.right.equalToSuperview()
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }
        collection.register(cellWithClass: LMymStoreCell.self)
        
    }
    
    func selectCoinItem(item: StoreItem) {
        LMymBCartCoinManager.default.purchaseIapId(item: item) { (success, errorString) in
            
            if success {
                self.showAlert(title: "Purchase successful.", message: "")
            } else {
                self.showAlert(title: "Purchase failed.", message: errorString)
            }
        }
    }
    
    
}

extension SLymStorereVC: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withClass: LMymStoreCell.self, for: indexPath)
        let item = LMymBCartCoinManager.default.coinIpaItemList[indexPath.item]
        cell.coinCountLabel.text = "\(item.coin)"
        cell.priceLabel.text = item.price
//
//
//        cell.bgImageV.image = UIImage(named: topImgName)
//        cell.priceBgImgV.image = UIImage(named: priceImgName)
        
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return LMymBCartCoinManager.default.coinIpaItemList.count
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
}

extension SLymStorereVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellwidth: CGFloat = 150
        let cellHeight: CGFloat = 150
        
        
        return CGSize(width: cellwidth, height: cellHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        let left: CGFloat = ((UIScreen.main.bounds.width - 150 * 2 - 1) / 3)
        return UIEdgeInsets(top: 20, left: left, bottom: 20, right: left)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        let left: CGFloat = ((UIScreen.main.bounds.width - 150 * 2 - 1) / 3)
        return left
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        let left: CGFloat = ((UIScreen.main.bounds.width - 150 * 2 - 1) / 3)
        return left
    }
    
}

extension SLymStorereVC: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let item = LMymBCartCoinManager.default.coinIpaItemList[safe: indexPath.item] {
            selectCoinItem(item: item)
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        
    }
}





class LMymStoreCell: UICollectionViewCell {
    
    var bgView: UIView = UIView()
    
    var bgImageV: UIImageView = UIImageView()
    var coverImageV: UIImageView = UIImageView()
    var coinCountLabel: UILabel = UILabel()
    var priceLabel: UILabel = UILabel()
    var priceBgImgV: UIImageView = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView() {
        
        backgroundColor = UIColor.clear
        bgView.backgroundColor = .clear
        contentView.addSubview(bgView)
        bgView.snp.makeConstraints {
            $0.top.bottom.left.right.equalToSuperview()
        }
        //
        bgImageV.backgroundColor = .clear
        bgImageV.contentMode = .scaleAspectFit
        bgImageV.image = UIImage(named: "store_background")
//        bgImageV.layer.masksToBounds = true
//        bgImageV.layer.cornerRadius = 27
//        bgImageV.layer.borderColor = UIColor.black.cgColor
//        bgImageV.layer.borderWidth = 4
        bgView.addSubview(bgImageV)
        bgImageV.snp.makeConstraints {
            $0.left.right.bottom.top.equalToSuperview()
        }
        
        //
//        let iconImgV = UIImageView(image: UIImage(named: "store_ic_heart"))
//        iconImgV.contentMode = .scaleAspectFit
//        bgView.addSubview(iconImgV)
//        iconImgV.snp.makeConstraints {
//            $0.centerY.equalToSuperview()
//            $0.left.equalTo(35)
//            $0.width.height.equalTo(38)
//        }
        
        //
        coinCountLabel.adjustsFontSizeToFitWidth = true
        coinCountLabel.textColor = UIColor.white
//        coinCountLabel.layer.shadowColor = UIColor(hexString: "#FFE7A8")?.cgColor
//        coinCountLabel.layer.shadowOffset = CGSize(width: 0, height: 0)
//        coinCountLabel.layer.shadowRadius = 3
//        coinCountLabel.layer.shadowOpacity = 0.8
        
        coinCountLabel.numberOfLines = 1
        coinCountLabel.textAlignment = .center
        coinCountLabel.font = UIFont(name: "Quicksand-Bold", size: 20)
        coinCountLabel.adjustsFontSizeToFitWidth = true
        bgView.addSubview(coinCountLabel)
        coinCountLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.centerY.equalToSuperview().offset(4)
            $0.left.equalTo(5)
            $0.height.greaterThanOrEqualTo(1)
        }
        
        //
//        coverImageV.image = UIImage(named: "home_button")
//        coverImageV.contentMode = .center
//        bgView.addSubview(coverImageV)
//
        
        //
        bgView.addSubview(priceBgImgV)
        priceBgImgV.snp.makeConstraints {
            $0.left.right.equalToSuperview()
            $0.bottom.equalToSuperview()
            $0.height.equalTo(40)
        }
        priceBgImgV.contentMode = .scaleAspectFill
        //
        priceLabel.textColor = UIColor(hexString: "#FFFFFF")
        priceLabel.font = UIFont(name: "Quicksand-Bold", size: 18)
        priceLabel.textAlignment = .center
        bgView.addSubview(priceLabel)
//        priceLabel.layer.shadowColor = UIColor(hexString: "#FF12D2")?.cgColor
//        priceLabel.layer.shadowOffset = CGSize(width: 0, height: 0)
//        priceLabel.layer.shadowRadius = 3
//        priceLabel.layer.shadowOpacity = 0.8
        
        
//        priceLabel.backgroundColor = UIColor(hexString: "#4AD0EF")
//        priceLabel.cornerRadius = 30
        priceLabel.adjustsFontSizeToFitWidth = true
//        priceLabel.layer.borderWidth = 2
//        priceLabel.layer.borderColor = UIColor.white.cgColor
        priceLabel.snp.makeConstraints {
            $0.left.right.equalToSuperview()
            $0.height.greaterThanOrEqualTo(40)
            $0.bottom.equalToSuperview()
        }
        
        
        
//        coverImageV.snp.makeConstraints {
//            $0.center.equalTo(priceLabel.snp.center)
//            $0.width.equalTo(135)
//            $0.height.equalTo(54)
//        }
    }
     
}





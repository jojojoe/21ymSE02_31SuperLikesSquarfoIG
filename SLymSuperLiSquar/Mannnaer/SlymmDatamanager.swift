//
//  SlymmDatamanager.swift
//  SLymSuperLiSquar
//
//  Created by JOJO on 2021/7/29.
//

import Foundation
import UIKit


//

class SlymmDatamanager {
    var layoutTypeList: [SLymEditToolItem] = []
    
    var bgColorList: [SLymEditToolItem] = []
    var bgColorImgList: [SLymEditToolItem] = []
    var stickerItemList: [SLymEditToolItem] = []
     

    static let `default` = SlymmDatamanager()
    
    init() {
        loadData()
        
    }
    
    func loadData() {
        
        bgColorList = loadJson([SLymEditToolItem].self, name: "bgcolorList") ?? []
         
        
    }
    
    
}


extension SlymmDatamanager {
    func loadJson<T: Codable>(_:T.Type, name: String, type: String = "json") -> T? {
        if let path = Bundle.main.path(forResource: name, ofType: type) {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path))
                return try! JSONDecoder().decode(T.self, from: data)
            } catch let error as NSError {
                debugPrint(error)
            }
        }
        return nil
    }
    
    func loadJson<T: Codable>(_:T.Type, path:String) -> T? {
        do {
            let data = try Data(contentsOf: URL(fileURLWithPath: path))
            do {
                return try PropertyListDecoder().decode(T.self, from: data)
            } catch let error as NSError {
                print(error)
            }
        } catch let error as NSError {
            print(error)
        }
        return nil
    }
    
    func loadPlist<T: Codable>(_:T.Type, name:String, type:String = "plist") -> T? {
        if let path = Bundle.main.path(forResource: name, ofType: type) {
            return loadJson(T.self, path: path)
        }
        return nil
    }
    
}



struct SLymEditToolItem: Codable, Hashable {
    static func == (lhs: SLymEditToolItem, rhs: SLymEditToolItem) -> Bool {
        return lhs.thumb == rhs.thumb
    }
    var thumb: String = ""
    var big: String = ""
    var pro: Bool = false
     
}
 
//
//
//struct ShapeItem: Codable, Identifiable, Hashable {
//    static func == (lhs: ShapeItem, rhs: ShapeItem) -> Bool {
//        return lhs.id == rhs.id
//    }
//    var id: Int = 0
//    var thumbName: String = ""
//    var bigName: String = ""
//    var isPro: Bool = false
//
//}
//
//struct StickerItem: Codable, Identifiable, Hashable {
//    static func == (lhs: StickerItem, rhs: StickerItem) -> Bool {
//        return lhs.id == rhs.id
//    }
//    var id: Int = 0
//    var thumbName: String = ""
//    var bigName: String = ""
//    var isPro: Bool = false
//
//}
//
//struct BackgroundItem: Codable, Identifiable, Hashable {
//    static func == (lhs: BackgroundItem, rhs: BackgroundItem) -> Bool {
//        return lhs.id == rhs.id
//    }
//    var id: Int = 0
//    var thumbName: String = ""
//    var bigName: String = ""
//    var isPro: Bool = false
//
//}
//
//

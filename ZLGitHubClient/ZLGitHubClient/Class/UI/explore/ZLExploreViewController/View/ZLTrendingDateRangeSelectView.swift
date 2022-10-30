//
//  ZLTrendingDateRangeSelectView.swift
//  ZLGitHubClient
//
//  Created by 朱猛 on 2020/5/25.
//  Copyright © 2020 ZM. All rights reserved.
//

import UIKit
import FFPopup
import ZLGitRemoteService
import ZLUIUtilities
import ZLBaseExtension

extension ZLDateRange {
    var title: String {
        switch self {
        case ZLDateRangeDaily:
            return ZLLocalizedString(string: "Today", comment: "")
        case ZLDateRangeWeakly:
            return ZLLocalizedString(string: "This Week", comment: "")
        case ZLDateRangeMonthly:
            return ZLLocalizedString(string: "This Month", comment: "")
        default:
            return ZLLocalizedString(string: "Today", comment: "")
        }
    }
}

class ZLTrendingFilterManager {
    
    /// 时间范围列表
    let dateRangeArray: [ZLDateRange] = [ZLDateRangeDaily,
                                         ZLDateRangeWeakly,
                                         ZLDateRangeMonthly]
    /// 开发语言列表
    var developLanguageArray: [String] = []
    
    /// 交流语言列表
    let spokenLanguageArray: [String] = ["Any"] + Array(ZLTrendingFilterManager.spokenLanguagueDic.keys).sorted()
    
    /// 选择时间范围
    lazy var dateRangeSelectView: ZMSingleSelectTitlePopView = {
        let dateRangeSelectView = ZMSingleSelectTitlePopView()
        dateRangeSelectView.frame = UIScreen.main.bounds
        dateRangeSelectView.textFieldBackView.isHidden = true
        dateRangeSelectView.contentWidth = 280
        dateRangeSelectView.contentHeight = 195
        dateRangeSelectView.collectionView.lineSpacing = .leastNonzeroMagnitude
        dateRangeSelectView.collectionView.interitemSpacing = .leastNonzeroMagnitude
        dateRangeSelectView.collectionView.itemSize = CGSize(width: 280, height: 50)
        dateRangeSelectView.popDelegate = self
        return dateRangeSelectView
    }()
    
    /// 开发语言选择
    lazy var developLanguageSelectView: ZMSingleSelectTitlePopView = {
        let dateRangeSelectView = ZMSingleSelectTitlePopView()
        dateRangeSelectView.frame = UIScreen.main.bounds
        dateRangeSelectView.contentWidth = 280
        dateRangeSelectView.contentHeight = 500
        dateRangeSelectView.collectionView.lineSpacing = .leastNonzeroMagnitude
        dateRangeSelectView.collectionView.interitemSpacing = .leastNonzeroMagnitude
        dateRangeSelectView.collectionView.itemSize = CGSize(width: 280, height: 50)
        dateRangeSelectView.popDelegate = self
        return dateRangeSelectView
    }()
    
    /// 交流语言
    lazy var spokenLanguageSelectView: ZMSingleSelectTitlePopView = {
        let dateRangeSelectView = ZMSingleSelectTitlePopView()
        dateRangeSelectView.frame = UIScreen.main.bounds
        dateRangeSelectView.contentWidth = 280
        dateRangeSelectView.contentHeight = 500
        dateRangeSelectView.collectionView.lineSpacing = .leastNonzeroMagnitude
        dateRangeSelectView.collectionView.interitemSpacing = .leastNonzeroMagnitude
        dateRangeSelectView.collectionView.itemSize = CGSize(width: 280, height: 50)
        dateRangeSelectView.popDelegate = self
        return dateRangeSelectView
    }()

}

/// show/dismiss
extension ZLTrendingFilterManager {
   
    /// 弹出时间范围弹出选择框
    func showTrendingDateRangeSelectView(to: UIView,
                                         initDateRange: ZLDateRange,
                                         resultBlock : @escaping ((ZLDateRange) -> Void)) {
        let titles = dateRangeArray.map({ $0.title })
        let selectedIndex = dateRangeArray.firstIndex(of: initDateRange) ?? 0
        dateRangeSelectView.titleLabel.text = ZLLocalizedString(string: "DateRange", comment: "")
        dateRangeSelectView.frame = UIScreen.main.bounds
        dateRangeSelectView.showSingleSelectTitleBox(to,
                                                     contentPoition: .center,
                                                     animationDuration: 0.1,
                                                     titles: titles,
                                                     selectedIndex: selectedIndex,
                                                     cellType: ZMInputCollectionViewSelectTickCell.self)
        { [weak self] index, title in
            guard let self = self else { return }
            resultBlock(self.dateRangeArray[index])
        }
    }
    
    /// 弹出开发语言选择框
    func showDevelopLanguageSelectView(to: UIView,
                                       developeLanguage: String?,
                                       resultBlock : @escaping ((String?) -> Void)) {
        let showBlock = { [weak self] in
            guard let self = self else { return }
            self.developLanguageSelectView.frame = UIScreen.main.bounds
            var selectedIndex = 0
            if let language = developeLanguage {
                selectedIndex = self.developLanguageArray.firstIndex(of: language) ?? 0
            }
            
            self.developLanguageSelectView.titleLabel.text = ZLLocalizedString(string: "Select a language", comment: "选择一种语言")
            let placeHolder = ZLLocalizedString(string: "Filter languages", comment: "筛选语言")
                .asMutableAttributedString()
                .font(.zlRegularFont(withSize: 12))
                .foregroundColor(ZLRGBValue_H(colorValue: 0xCED1D6))
            self.developLanguageSelectView
                .textField
                .attributedPlaceholder = placeHolder
            
            self.developLanguageSelectView
                .showSingleSelectTitleBox(to,
                                          contentPoition: .center,
                                          animationDuration: 0.1,
                                          titles: self.developLanguageArray,
                                          selectedIndex: selectedIndex,
                                          cellType: ZMInputCollectionViewSelectTickCell.self)
            { index, title in
                if title == "Any" {
                    resultBlock(nil)
                } else {
                    resultBlock(title)
                }
            }

        }
        
        if !developLanguageArray.isEmpty {
            showBlock()
        } else {
            requestDevelopLanguage{
                showBlock()
            }
        }
    }
    
    /// 弹出交流语言选择框
    func showSpokenLanguageSelectView(to: UIView,
                                      spokenLanguage: String?,
                                      resultBlock : @escaping ((String?) -> Void)) {
        var selectedIndex = 0
        if let language = spokenLanguage {
            selectedIndex = spokenLanguageArray.firstIndex(of: language) ?? 0
        }

        self.spokenLanguageSelectView.frame = UIScreen.main.bounds
        self.spokenLanguageSelectView.titleLabel.text = ZLLocalizedString(string: "Select a language", comment: "选择一种语言")
        let placeHolder = ZLLocalizedString(string: "Filter languages", comment: "筛选语言")
            .asMutableAttributedString()
            .font(.zlRegularFont(withSize: 12))
            .foregroundColor(ZLRGBValue_H(colorValue: 0xCED1D6))
        self.spokenLanguageSelectView
            .textField
            .attributedPlaceholder = placeHolder
        self.spokenLanguageSelectView
            .showSingleSelectTitleBox(to,
                                      contentPoition: .center,
                                      animationDuration: 0.1,
                                      titles: spokenLanguageArray,
                                      selectedIndex: selectedIndex,
                                      cellType: ZMInputCollectionViewSelectTickCell.self)
        { index, title in
            if title == "Any" {
                resultBlock(nil)
            } else {
                resultBlock(title)
            }
        }
    }
    
    
    ///
    func dismissAllFilterView() {
        dateRangeSelectView.dismissForce()
    }
}

// MARK: Request
extension ZLTrendingFilterManager {
    
    func requestDevelopLanguage(callBack: @escaping () -> Void) {
    
        let languageArray = ZLServiceManager.sharedInstance.additionServiceModel?.getLanguagesWithSerialNumber(NSString.generateSerialNumber())
        { [weak self](resultModel: ZLOperationResultModel) in
            guard let self = self else { return }
            ZLProgressHUD.dismiss()
            if !self.developLanguageArray.isEmpty {
                return
            }
            
            if resultModel.result == true {
                guard let languageArray = resultModel.data as? [String] else {
                    ZLToastView.showMessage("language list transfer failed", duration: 3.0)
                    return
                }
                var newLanguageArray = ["Any"]
                newLanguageArray.append(contentsOf: languageArray)
                self.developLanguageArray = newLanguageArray
                callBack()
            } else {
                guard let errorModel: ZLGithubRequestErrorModel = resultModel.data as? ZLGithubRequestErrorModel else {
                    ZLToastView.showMessage("query language list failed", duration: 3.0)
                    return
                }
                ZLToastView.showMessage("query language list failed statusCode[\(errorModel.statusCode) message[\(errorModel.message)]]", duration: 3.0)
            }
        }
        guard let realLanguageArray = languageArray else {
            ZLProgressHUD.show()
            return
        }
    
        var newLanguageArray = ["Any"]
        newLanguageArray.append(contentsOf: realLanguageArray)
        self.developLanguageArray = newLanguageArray
        callBack()
    }
    
}


// MARK: ZLPopContainerViewDelegate
extension ZLTrendingFilterManager: ZMPopContainerViewDelegate {
    
    func popContainerViewShouldChangeFrameWhenDeviceOrientationDidChange(_ view:ZMPopContainerView) -> Bool {
        true
    }
    
    func popContainerViewShouldChangeContentViewFrameWhenDeviceOrientationDidChange(_ view:ZMPopContainerView) -> Bool {
        true
    }
    
    func popContainerViewChangeFrameWhenDeviceOrientationDidChange(_ view:ZMPopContainerView) -> CGRect {
        return ZLScreenBoundsAdjustWithScreenOrientation
    }
    
    func popContainerViewChangeContentViewTargetFrameWhenDeviceOrientationDidChange(_ view:ZMPopContainerView) -> CGRect {
        if view == self.dateRangeSelectView {
            let origin = CGPoint(x: ( view.frame.width - 280 ) / 2 , y: ( view.frame.height - 195 ) / 2 )
            return CGRect(origin: origin, size: CGSize(width: 280, height: 195))
        } else if  view == self.developLanguageSelectView ||
                   view == self.spokenLanguageSelectView {
            let origin = CGPoint(x: ( view.frame.width - 280 ) / 2 , y: ( view.frame.height - 500 ) / 2 )
            return CGRect(origin: origin, size: CGSize(width: 280, height: 500))
        }
        return .zero
    }
    
    func popContainerViewChangeContentViewInitFrameWhenDeviceOrientationDidChange(_ view:ZMPopContainerView) -> CGRect {
        let origin = CGPoint(x: view.frame.width / 2 , y: view.frame.height / 2 )
        return CGRect(origin: origin, size: .zero)
    }
    
}

/// 交流语言
extension ZLTrendingFilterManager {
    static let spokenLanguagueDic: [String: String?] = [
        "Any":nil,
        "Abkhazian":"ab",
        "Afar":"aa",
        "Afrikaans":"af",
        "Akan":"ak",
        "Albanian":"sq",
        "Amharic":"am",
        "Arabic":"ar",
        "Aragonese":"an",
        "Armenian":"hy",
        "Assamese":"as",
        "Avaric":"av",
        "Avestan":"ae",
        "Aymara":"ay",
        "Azerbaijani":"az",
        "Bambara":"bm",
        "Bashkir":"ba",
        "Basque":"eu",
        "Belarusian":"be",
        "Bengali":"bn",
        "Bihari languages":"bh",
        "Bislama":"bi",
        "Bosnian":"bs",
        "Breton":"br",
        "Bulgarian":"bg",
        "Burmese":"my",
        "Catalan, Valencian":"ca",
        "Chamorro":"ch",
        "Chechen":"ce",
        "Chichewa, Chewa, Nyanja":"ny",
        "Chinese":"zh",
        "Chuvash":"cv",
        "Cornish":"kw",
        "Corsican":"co",
        "Cree":"cr",
        "Croatian":"hr",
        "Czech":"cs",
        "Danish":"da",
        "Divehi, Dhivehi, Maldivian":"dv",
        "Dutch, Flemish":"nl",
        "Dzongkha":"dz",
        "English":"en",
        "Esperanto":"eo",
        "Estonian":"et",
        "Ewe":"ee",
        "Faroese":"fo",
        "Fijian":"fj",
        "Finnish":"fi",
        "French":"fr",
        "Fulah":"ff",
        "Galician":"gl",
        "Georgian":"ka",
        "German":"de",
        "Greek, Modern":"el",
        "Guarani":"gn",
        "Gujarati":"gu",
        "Haitian, Haitian Creole":"ht",
        "Hausa":"ha",
        "Hebrew":"he",
        "Herero":"hz",
        "Hindi":"hi",
        "Hiri Motu":"ho",
        "Hungarian":"hu",
        "Interlingua (International Auxil...":"ia",
        "Indonesian":"id",
        "Interlingue, Occidental":"ie",
        "Irish":"ga",
        "Igbo":"ig",
        "Inupiaq":"ik",
        "Ido":"io",
        "Icelandic":"is",
        "Italian":"it",
        "Inuktitut":"iu",
        "Japanese":"ja",
        "Javanese":"jv",
        "Kalaallisut, Greenlandic":"kl",
        "Kannada":"kn",
        "Kanuri":"kr",
        "Kashmiri":"ks",
        "Kazakh":"kk",
        "Central Khmer":"km",
        "Kikuyu, Gikuyu":"ki",
        "Kinyarwanda":"rw",
        "Kirghiz, Kyrgyz":"ky",
        "Komi":"kv",
        "Kongo":"kg",
        "Korean":"ko",
        "Kurdish":"ku",
        "Kuanyama, Kwanyama":"kj",
        "Latin":"la",
        "Luxembourgish, Letzeburgesch":"lb",
        "Ganda":"lg",
        "Limburgan, Limburger, Limburgish":"li",
        "Lingala":"ln",
        "Lao":"lo",
        "Lithuanian":"lt",
        "Luba-Katanga":"lu",
        "Latvian":"lv",
        "Manx":"gv",
        "Macedonian":"mk",
        "Malagasy":"mg",
        "Malay":"ms",
        "Malayalam":"ml",
        "Maltese":"mt",
        "Maori":"mi",
        "Marathi":"mr",
        "Marshallese":"mh",
        "Mongolian":"mn",
        "Nauru":"na",
        "Navajo, Navaho":"nv",
        "North Ndebele":"nd",
        "Nepali":"ne",
        "Ndonga":"ng",
        "Norwegian Bokmål":"nb",
        "Norwegian Nynorsk":"nn",
        "Norwegian":"no",
        "Sichuan Yi, Nuosu":"ii",
        "South Ndebele":"nr",
        "Occitan":"oc",
        "Ojibwa":"oj",
        "Church Slavic, Old Slavonic, Chu...":"cu",
        "Oromo":"om",
        "Oriya":"or",
        "Ossetian, Ossetic":"os",
        "Punjabi, Panjabi":"pa",
        "Pali":"pi",
        "Persian":"fa",
        "Polish":"pl",
        "Pashto, Pushto":"ps",
        "Portuguese":"pt",
        "Quechua":"qu",
        "Romansh":"rm",
        "Rundi":"rn",
        "Romanian, Moldavian, Moldovan":"ro",
        "Russian":"ru",
        "Sanskrit":"sa",
        "Sardinian":"sc",
        "Sindhi":"sd",
        "Northern Sami":"se",
        "Samoan":"sm",
        "Sango":"sg",
        "Serbian":"sr",
        "Gaelic, Scottish Gaelic":"gd",
        "Shona":"sn",
        "Sinhala, Sinhalese":"si",
        "Slovak":"sk",
        "Slovenian":"sl",
        "Somali":"so",
        "Southern Sotho":"st",
        "Spanish, Castilian":"es",
        "Sundanese":"su",
        "Swahili":"sw",
        "Swati":"ss",
        "Swedish":"sv",
        "Tamil":"ta",
        "Telugu":"te",
        "Tajik":"tg",
        "Thai":"th",
        "Tigrinya":"ti",
        "Tibetan":"bo",
        "Turkmen":"tk",
        "Tagalog":"tl",
        "Tswana":"tn",
        "Tonga (Tonga Islands)":"to",
        "Turkish":"tr",
        "Tsonga":"ts",
        "Tatar":"tt",
        "Twi":"tw",
        "Tahitian":"ty",
        "Uighur, Uyghur":"ug",
        "Ukrainian":"uk",
        "Urdu":"ur",
        "Uzbek":"uz",
        "Venda":"ve",
        "Vietnamese":"vi",
        "Volapük":"vo",
        "Walloon":"wa",
        "Welsh":"cy",
        "Wolof":"wo",
        "Western Frisian":"fy",
        "Xhosa":"xh",
        "Yiddish":"yi",
        "Yoruba":"yo",
        "Zhuang, Chuang":"za",
        "Zulu":"zu"
     ]
}



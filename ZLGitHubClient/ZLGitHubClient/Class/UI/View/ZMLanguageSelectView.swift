//
//  ZMLanguageSelectView.swift
//  ZLGitHubClient
//
//  Created by 朱猛 on 2023/2/22.
//  Copyright © 2023 ZM. All rights reserved.
//

import Foundation
import UIKit
import ZLBaseExtension
import ZLGitRemoteService
import ZLUIUtilities

class ZMLanguageSelectView {
    
    static var popDelegate: ZMPopContainerViewDelegate_Center = ZMPopContainerViewDelegate_Center()
    
    static func getLanguageSelectView() -> ZMSingleSelectTitlePopView {
        /// 开发语言选择
        let dateRangeSelectView = ZMSingleSelectTitlePopView()
        dateRangeSelectView.frame = UIScreen.main.bounds
        let title = ZLLocalizedString(string: "Select a language", comment: "选择一种语言")
        dateRangeSelectView.titleLabel.text = title
        let placeHolder = ZLLocalizedString(string: "Filter languages", comment: "筛选语言")
            .asMutableAttributedString()
            .font(.zlRegularFont(withSize: 12))
            .foregroundColor(ZLRGBValue_H(colorValue: 0xCED1D6))
        dateRangeSelectView.textField.attributedPlaceholder = placeHolder
        dateRangeSelectView.contentWidth = 280
        dateRangeSelectView.contentHeight = 500
        dateRangeSelectView.collectionView.lineSpacing = .leastNonzeroMagnitude
        dateRangeSelectView.collectionView.interitemSpacing = .leastNonzeroMagnitude
        dateRangeSelectView.collectionView.itemSize = CGSize(width: 280, height: 50)
        dateRangeSelectView.popDelegate = ZMLanguageSelectView.popDelegate
        return dateRangeSelectView
    }
    
    /// 弹出开发语言选择框
    static func showDevelopLanguageSelectView(to: UIView,
                                              developeLanguage: String?,
                                              resultBlock : @escaping ((String?) -> Void)) {
        let showBlock = { (developLanguageArray: [String]) in
            
            let developLanguageSelectView = ZMLanguageSelectView.getLanguageSelectView()
            var selectedIndex = 0
            if let language = developeLanguage {
                selectedIndex = developLanguageArray.firstIndex(of: language) ?? 0
            }
            
            developLanguageSelectView
                .showSingleSelectTitleBox(to,
                                          contentPoition: .center,
                                          animationDuration: 0.1,
                                          titles: developLanguageArray,
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
    
        ZMLanguageSelectView.requestDevelopLanguage{ languages in
            showBlock(languages)
        }
        
    }
    
    
    /// 弹出交流语言选择框
    static func showSpokenLanguageSelectView(to: UIView,
                                             spokenLanguage: String?,
                                             resultBlock : @escaping ((String?) -> Void)) {
        let showBlock = { (languages: [String]) in
            
            let spokenLanguageSelectView = ZMLanguageSelectView.getLanguageSelectView()
            var selectedIndex = 0
            if let language = spokenLanguage {
                selectedIndex = languages.firstIndex(of: language) ?? 0
            }
            
            spokenLanguageSelectView
                .showSingleSelectTitleBox(to,
                                          contentPoition: .center,
                                          animationDuration: 0.1,
                                          titles: languages,
                                          selectedIndex: selectedIndex,
                                          cellType: ZMInputCollectionViewSelectTickCell.self)
            { index, title in
                resultBlock(title)
            }
            
        }
    
        var newLanguageArray = ["Any"]
        newLanguageArray.append(contentsOf: ZMLanguageSelectView.spokenLanguagueDic.keys.sorted())
        showBlock(newLanguageArray)
    }

}


extension ZMLanguageSelectView {
    
    /// 请求开发语言列表
    static func requestDevelopLanguage(callBack: @escaping ([String]) -> Void) {
    
        var hasPoped = false
        let languageArray = ZLServiceManager
            .sharedInstance
            .additionServiceModel?
            .getLanguagesWithSerialNumber(NSString.generateSerialNumber())
        { (resultModel: ZLOperationResultModel) in
            ZLProgressHUD.dismiss()
            if hasPoped {
                /// 已经弹出过选择浮层，则不再弹出
                return
            }
            
            if resultModel.result == true {
                guard let languageArray = resultModel.data as? [String] else {
                    ZLToastView.showMessage("language list transfer failed", duration: 3.0)
                    return
                }
                var newLanguageArray = ["Any"]
                newLanguageArray.append(contentsOf: languageArray)
                callBack(newLanguageArray)
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
    
        hasPoped = true
        var newLanguageArray = ["Any"]
        newLanguageArray.append(contentsOf: realLanguageArray)
        callBack(newLanguageArray)
    }
    
    /// 交流语言列表
    static let spokenLanguagueDic: [String: String] = [
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

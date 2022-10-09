//
//  ZLSpokenLanguageSelectView.swift
//  ZLGitHubClient
//
//  Created by 朱猛 on 2022/5/23.
//  Copyright © 2022 ZM. All rights reserved.
//

import UIKit
import FFPopup
import ZLBaseExtension

class ZLSpokenLanguageSelectView: UIView {
    
    static func showSpokenLanguageSelectView(resultBlock : @escaping ((String?, String?) -> Void)) {

        let view = ZLSpokenLanguageSelectView()
        view.resultBlock = resultBlock

        view.frame = CGRect.init(x: 0, y: 0, width: 280, height: 500)
        let popup = FFPopup(contentView: view, showType: .bounceIn, dismissType: .bounceOut, maskType: FFPopup.MaskType.dimmed, dismissOnBackgroundTouch: true, dismissOnContentTouch: false)
        view.popup = popup
        popup.show(layout: .Center)

    }
    
    weak var popup: FFPopup?
    var resultBlock: ((String?,String?) -> Void)?
    
    var filterLanguagesArray: [String] = []
    var allLanguagesArray: [String] = []

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        
        filterLanguagesArray = ["Any"] + Array(ZLSpokenLanguageSelectView.spokenLanguagueDic.keys).sorted()
        allLanguagesArray = filterLanguagesArray
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupUI() {
        
        cornerRadius = 5
        
        addSubview(headerView)
        addSubview(tableView)
        headerView.addSubview(titleLabel)
        headerView.addSubview(seperateLine)
        headerView.addSubview(textField)
        
        headerView.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview()
            make.height.equalTo(100)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.left.equalTo(10)
            make.top.equalTo(10)
        }
        
        seperateLine.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(10)
            make.height.equalTo(1.0 / UIScreen.main.scale)
            make.left.right.equalToSuperview()
        }
        
        textField.snp.makeConstraints { make in
            make.top.equalTo(seperateLine.snp.bottom).offset(10)
            make.left.equalTo(10)
            make.right.equalTo(-10)
            make.height.equalTo(40)
            make.bottom.equalTo(-10)
        }
        
        tableView.snp.makeConstraints { make in
            make.bottom.left.right.equalToSuperview()
            make.top.equalTo(headerView.snp.bottom)
        }
    }
    
    
    lazy var headerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(named:"ZLPopUpTitleBackView")
        return view
    }()
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = .zlMediumFont(withSize: 15)
        label.textColor = UIColor(named: "ZLPopupTitleColor")
        label.text = ZLLocalizedString(string: "Select a language", comment: "选择一种语言")
        return label
    }()
    
    lazy var seperateLine: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(named:"ZLSeperatorLineColor")
        return view
    }()
    
    lazy var textField: UITextField = {
       let textField = UITextField()
        textField.delegate = self
        let attributedPlaceHolder = NSAttributedString.init(string: ZLLocalizedString(string: "Filter languages", comment: "筛选语言"), attributes: [NSAttributedString.Key.foregroundColor: ZLRGBValue_H(colorValue: 0xCED1D6), NSAttributedString.Key.font: UIFont.init(name: Font_PingFangSCRegular, size: 12) ?? UIFont.systemFont(ofSize: 12)])
        textField.attributedPlaceholder = attributedPlaceHolder
        textField.font = .zlRegularFont(withSize: 14)
        textField.borderStyle = .roundedRect
        textField.backgroundColor = UIColor(named: "ZLPopUpTextFieldBackColor")
        return textField
    }()
    
    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: CGRect.zero)
        tableView.register(ZLSpokenLanguageSelectViewCell.self, forCellReuseIdentifier: "ZLSpokenLanguageSelectViewCell")
        tableView.delegate = self
        tableView.dataSource = self
        tableView.contentInset = UIEdgeInsets.zero
        if #available(iOS 15.0, *) {
            tableView.sectionHeaderTopPadding = 0
        }
        return tableView
    }()

}

extension ZLSpokenLanguageSelectView: UITableViewDelegate,UITableViewDataSource {
   
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ZLSpokenLanguageSelectViewCell", for: indexPath) as? ZLSpokenLanguageSelectViewCell else {
            return UITableViewCell.init()
        }

        cell.languageLabel.text = filterLanguagesArray[indexPath.row]
        return cell
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filterLanguagesArray.count
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let languague = filterLanguagesArray[indexPath.row]
        if languague == "Any" {
            resultBlock?(nil,nil)
        } else {
            resultBlock?(languague,ZLSpokenLanguageSelectView.spokenLanguagueDic[languague])
        }
        
        self.popup?.dismiss(animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return CGFloat.leastNonzeroMagnitude
    }

    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        self.endEditing(true)
    }
}

extension ZLSpokenLanguageSelectView: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if string == "\n" {
            textField.resignFirstResponder()
            return false
        }
        
        let textStr: NSString? = self.textField.text as NSString?
        let text: String = textStr?.replacingCharacters(in: range, with: string) ?? ""
        let array = self.allLanguagesArray.filter({ str in
            return str.lowercased().contains(find: text.lowercased())
        })
        self.filterLanguagesArray = array
        self.tableView.reloadData()
        
        return true
    }
}


class ZLSpokenLanguageSelectViewCell: UITableViewCell {
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupUI() {
        contentView.backgroundColor = UIColor(named: "ZLPopUpCellBack")
        
        contentView.addSubview(languageLabel)
        contentView.addSubview(separateLine)
        
        languageLabel.snp.makeConstraints { make in
            make.left.equalTo(20)
            make.centerY.equalToSuperview()
        }
        
        separateLine.snp.makeConstraints { make in
            make.left.equalTo(20)
            make.bottom.right.equalToSuperview()
            make.height.equalTo(1.0/UIScreen.main.scale)
        }
    }
    
    lazy var languageLabel: UILabel = {
        let label = UILabel()
        label.font = .zlRegularFont(withSize: 14)
        label.textColor = UIColor(named: "ZLLabelColor4")
        return label
    }()
    
    lazy var separateLine: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(named:"ZLSeperatorLineColor")
        return view
    }()
    
    
}


extension ZLSpokenLanguageSelectView {
    static let spokenLanguagueDic = [
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

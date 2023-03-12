//
//  ZLDatePickerPopView.swift
//  ZLGitHubClient
//
//  Created by 朱猛 on 2023/2/17.
//  Copyright © 2023 ZM. All rights reserved.
//

import Foundation
import ZLBaseExtension
import ZLBaseUI

@objc public enum ZMDateComponentType: Int {
  case year = 0
  case month
  case day
}

public class ZMDatePickerViewModel: NSObject {
    public dynamic var currentDate: Date
    public dynamic let startDate: Date
    public dynamic let endDate: Date
    
    var currentYear: Int = 0
    var currentMonth: Int = 0
    var currentDay: Int = 0
    
    var years: [Int] = []
    var months: [Int] = []
    var days: [Int] = []
    
    init(startDate: Date,
         endDate: Date,
         currentDate: Date? = nil) {
        self.currentDate = currentDate ?? endDate
        self.endDate = endDate
        self.startDate = startDate.timeIntervalSince(endDate) > 0 ? endDate : startDate /// 矫正 startDate > endDate 的情况
        super.init()
        initDatePickerItems()
    }
    
    func initDatePickerItems() {
        /// 矫正currentDate
        if currentDate.timeIntervalSince(endDate) > 0 {
            currentDate = endDate
        } else if currentDate.timeIntervalSince(startDate) < 0 {
            currentDate = startDate
        }
        currentYear = currentDate.year
        currentMonth = currentDate.month
        currentDay = currentDate.day
        
        years = Array(startDate.year...endDate.year)
        
        if currentYear == startDate.year {
            months = Array(startDate.month...12)
            if currentMonth == startDate.month {
                days = Array(startDate.day...currentDate.daysInMonth)
            } else {
                days = Array(1...currentDate.daysInMonth)
            }
        } else if currentYear == endDate.year {
            months = Array(1...endDate.month)
            if currentMonth == endDate.month {
                days = Array(1...endDate.day)
            } else {
                days = Array(1...currentDate.daysInMonth)
            }
        } else {
            months = Array(1...12)
            days = Array(1...currentDate.daysInMonth)
        }
    }
    
    public func changeDateItem(item: Int, itemType: ZMDateComponentType) {
        
        switch itemType {
        case .year:
            if case .year = itemType {
                currentYear = item
            }
            /// 修正year
            currentYear = corretDateItem(item: currentYear, itemRange: years)
            
            /// 更新month
            if currentYear == startDate.year {
                months = Array(startDate.month...12)
            } else if currentYear == endDate.year {
                months = Array(1...endDate.month)
            } else {
                months = Array(1...12)
            }
            fallthrough
            
        case .month:
            if case .month = itemType {
                currentMonth = item
            }
            /// 修正month
            currentMonth = corretDateItem(item: currentMonth, itemRange: months)
            
            /// 更新month
            let date = Date(year: currentYear, month: currentMonth, day: 1)
            if currentYear == startDate.year,
               currentMonth == startDate.month {
                days = Array(startDate.day...date.daysInMonth)
            } else if currentYear == endDate.year,
                      currentMonth == endDate.month {
                days = Array(1...endDate.day)
            } else {
                days = Array(1...date.daysInMonth)
            }
            
            fallthrough
        case .day:
            if case .day = itemType {
                currentDay = item
            }
            /// 修正month
            currentDay = corretDateItem(item: currentDay, itemRange: days)
        }
        
        currentDate = Date(year: currentYear, month: currentMonth, day: currentDay)
    }
    
    /// 修正year, month, day
    func corretDateItem(item: Int, itemRange: [Int]) -> Int {
        var item = item
        if let start = itemRange.first, item < start {
            item = start
        } else if let end = itemRange.last, item >= end {
            item = end
        }
        return item
    }
}


public protocol ZMDatePickerPopViewDelegate: NSObjectProtocol {
    func zmDatePickerPopViewDidConfirm(date: Date)
    
    func zmDatePickerPopViewDidSelect(date: Date)
}


public class ZMDatePickerPopView: ZMPopContainerView {
    
    public weak var delegate: ZMDatePickerPopViewDelegate?
    
    public var confirmBlock: ((Date) -> Void)?

    private let title: String
    private let viewModel: ZMDatePickerViewModel
    private let dateComponentTypes: [ZMDateComponentType] = [.year,.month,.day]
    private let contentSize: CGSize
    
    public init(title: String,
                contentSize: CGSize,
                startDate: Date,
                endDate: Date,
                currentDate: Date? = nil) {
        self.title = title
        self.contentSize = contentSize
        self.viewModel = ZMDatePickerViewModel(startDate: startDate,
                                               endDate: endDate,
                                               currentDate: currentDate)
        super.init(frame: .zero)
        setupContentUI()
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupContentUI() {
        titleLabel.text = title
        
        contentView.addSubview(verticalStackView)
        verticalStackView.addArrangedSubview(titleBackView)
        verticalStackView.addArrangedSubview(pickerView)
        verticalStackView.addArrangedSubview(bottomView)
        titleBackView.addSubview(titleLabel)
        bottomView.addSubview(confirmButton)
        
        verticalStackView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        titleBackView.snp.makeConstraints { make in
            make.height.equalTo(45)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalTo(10)
        }
        
        bottomView.snp.makeConstraints { make in
            make.height.equalTo(80)
        }
        
        confirmButton.snp.makeConstraints { make in
            make.top.equalTo(10)
            make.left.equalTo(30)
            make.right.equalTo(-30)
            make.height.equalTo(40)
        }
        
        if let selectedIndedx = viewModel.days.firstIndex(of: viewModel.currentDay),
           let componentIndex = dateComponentTypes.firstIndex(of: .day) {
            pickerView.selectRow(selectedIndedx, inComponent: componentIndex, animated: false)
        }
        
        if let selectedIndedx = viewModel.months.firstIndex(of: viewModel.currentMonth),
           let componentIndex = dateComponentTypes.firstIndex(of: .month) {
            pickerView.selectRow(selectedIndedx, inComponent: componentIndex, animated: false)
        }
        
        if let selectedIndedx = viewModel.years.firstIndex(of: viewModel.currentYear),
           let componentIndex = dateComponentTypes.firstIndex(of: .year) {
            pickerView.selectRow(selectedIndedx, inComponent: componentIndex, animated: false)
        }
        
    }
    
    // MARK: Lazy View
    public lazy var contentView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(named: "ZLPopUpBackColor")
        view.layer.masksToBounds = true
        view.layer.cornerRadius = 5.0
        return view
    }()
    
    @objc public lazy var verticalStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 0
        stackView.alignment = .fill
        stackView.distribution = .fill
        return stackView
    }()
    
    public lazy var pickerView: UIPickerView = {
        let pickerView = UIPickerView()
        pickerView.delegate = self
        pickerView.dataSource = self
        return pickerView 
    }()
    
    public lazy var titleBackView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(named:"ZLPopUpTitleBackView")
        return view
    }()
    
    public lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = .zlMediumFont(withSize: 15)
        label.textColor = UIColor(named: "ZLPopupTitleColor")
        return label
    }()
    
    public lazy var bottomView: UIView = {
        let view = UIView()
        return view
    }()
    
    public lazy var confirmButton: UIButton = {
        let button = ZLBaseButton()
        button.setTitle(ZLLocalizedString(string: "Confirm", comment: ""), for: .normal)
        button.titleLabel?.font = .zlMediumFont(withSize: 16)
        button.addTarget(self, action: #selector(onConfirmButtonClicked), for: .touchUpInside)
        return button
    }()
}

// MARK: - Action
public extension ZMDatePickerPopView {
    
    @objc func onConfirmButtonClicked() {
        delegate?.zmDatePickerPopViewDidConfirm(date: viewModel.currentDate)
        confirmBlock?(viewModel.currentDate)
        self.dismiss()
    }
}

// MARK: - UIPickerViewDataSource,UIPickerViewDelegate
extension ZMDatePickerPopView: UIPickerViewDataSource,UIPickerViewDelegate  {
    
    public func numberOfComponents(in pickerView: UIPickerView) -> Int {
        dateComponentTypes.count
    }

    public func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        let componentType = dateComponentTypes[component]
        switch componentType {
        case .year:
            return viewModel.years.count
        case .month:
            return viewModel.months.count
        case .day:
            return viewModel.days.count
        }
    }
    
    public func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        let componentType = dateComponentTypes[component]
        switch componentType {
        case .year:
            let year = viewModel.years[row]
            return String(year)
        case .month:
            let month = viewModel.months[row]
            return String(format: "%02d", month)
        case .day:
            let day = viewModel.days[row]
            return String(format: "%02d", day)
        }
    }
    
    public func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let componentType = dateComponentTypes[component]
        var componentValue = 0
        switch componentType {
        case .year:
            componentValue = viewModel.years[row]
        case .month:
            componentValue = viewModel.months[row]
        case .day:
            componentValue = viewModel.days[row]
        }
        viewModel.changeDateItem(item: componentValue, itemType: componentType)
        pickerView.reloadAllComponents()
        
        if let selectedIndedx = viewModel.days.firstIndex(of: viewModel.currentDay),
           let componentIndex = dateComponentTypes.firstIndex(of: .day) {
            pickerView.selectRow(selectedIndedx, inComponent: componentIndex, animated: false)
        }
        
        if let selectedIndedx = viewModel.months.firstIndex(of: viewModel.currentMonth),
           let componentIndex = dateComponentTypes.firstIndex(of: .month) {
            pickerView.selectRow(selectedIndedx, inComponent: componentIndex, animated: false)
        }
        
        if let selectedIndedx = viewModel.years.firstIndex(of: viewModel.currentYear),
           let componentIndex = dateComponentTypes.firstIndex(of: .year) {
            pickerView.selectRow(selectedIndedx, inComponent: componentIndex, animated: false)
        }
        
        delegate?.zmDatePickerPopViewDidSelect(date: viewModel.currentDate)
    }
}

// MARK: -
public extension ZMDatePickerPopView {
    
    static func showDatePickerPopView(to: UIView,
                                      title: String,
                                      startDate: Date,
                                      endDate: Date,
                                      currentDate: Date? = nil,
                                      delegate: ZMDatePickerPopViewDelegate? = nil,
                                      confirmBlock: ((Date) -> Void)? = nil) {

        let view = ZMDatePickerPopView(title: title,
                                       contentSize: CGSize(width: 280, height: 400),
                                       startDate: startDate,
                                       endDate: endDate,
                                       currentDate: currentDate)
        view.delegate = delegate
        view.confirmBlock = confirmBlock
        view.frame = to.bounds
        view.inline_show(to,
                         contentView: view.contentView,
                         contentSize: view.contentSize,
                         contentPoition: .center,
                         animationDuration: 0.25)
    }
    
}



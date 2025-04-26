//
//  ContributionWidget.swift
//  Fixed RepoExtension
//
//  Created by 朱猛 on 2021/1/23.
//  Copyright © 2021 ZM. All rights reserved.
//

import Foundation
import WidgetKit
import SwiftUI

extension ZLSimpleContributionModel {
    static func getSampleContributionData() -> ZLViewersContributionModel {
        let contributionsModel = ZLViewersContributionModel()
        contributionsModel.login = "ExistOrLive"
        let calendarModel = ZLContributionCalendarModel()
        calendarModel.totalContributions = 101
        calendarModel.weeks = Array(0...19).map({ _  in
            let weekModel = ZLContributionWeekModel()
            weekModel.contributionDays = Array(0...6).map({ _ in
                let data = ZLSimpleContributionModel()
                data.contributionsLevel = Int.random(in: 0...4)
                return data
            })
            return weekModel
        })
        contributionsModel.contributionsModel = calendarModel
        return contributionsModel
    }
    static func getPlaceHolderContributionData() -> ZLViewersContributionModel {
        let contributionsModel = ZLViewersContributionModel()
        contributionsModel.login = "--"
        let calendarModel = ZLContributionCalendarModel()
        calendarModel.totalContributions = 0
        calendarModel.weeks = Array(0...19).map({ _  in
            let weekModel = ZLContributionWeekModel()
            weekModel.contributionDays = Array(0...6).map({ _ in
                let data = ZLSimpleContributionModel()
                data.contributionsLevel = 0
                return data
            })
            return weekModel
        })
        contributionsModel.contributionsModel = calendarModel
        return contributionsModel
    }
}

struct ContributionEntry : TimelineEntry {
    var date: Date
    var model: ZLViewersContributionModel?
    var isPlaceHolder : Bool = false
}

struct ContributionProvider : IntentTimelineProvider {
    
    typealias Entry = ContributionEntry
    
    typealias Intent = ContributionConfigurationIntent
    
    func placeholder(in context: Self.Context) -> Self.Entry {
        ContributionEntry(date:Date(),model:ZLSimpleContributionModel.getPlaceHolderContributionData(),isPlaceHolder:true)
    }
    
    func getSnapshot(for configuration: Self.Intent, in context: Self.Context, completion: @escaping (Self.Entry) -> Void) {
        if context.isPreview {
            completion(ContributionEntry(date:Date(),model:ZLSimpleContributionModel.getSampleContributionData(), isPlaceHolder: false))
        } else {
            completion(ContributionEntry(date:Date(),model:ZLSimpleContributionModel.getPlaceHolderContributionData(),isPlaceHolder:true))
        }
        
    }
    
    func getTimeline(for configuration: Self.Intent, in context: Self.Context, completion: @escaping (Timeline<Self.Entry>) -> Void){
        
        ZLWidgetService.contributions() { (result, data) in
            
            
            
            let currentDate  = Date()
            let entry = ContributionEntry(date:currentDate,model: data, isPlaceHolder: false)
            let entryDate = Calendar.current.date(byAdding: .hour, value: 2, to: currentDate)!
            let timeLine = Timeline(entries: [entry], policy: .after(entryDate))
            
            completion(timeLine)
        }
        
      
    }
}


struct ContributionMeidumView : View {
    
    let entry : ContributionProvider.Entry
    
    var body : some View {
        let view: some View = VStack{
            if entry.isPlaceHolder {
                
                HStack{
                    Text("      ")
                        .foregroundColor(Color("ZLTitleColor1"))
                    
                    Text("      ")
                        .foregroundColor(Color("ZLDescColor"))
                    
                    Spacer()
                }
                
                Spacer()
                
                HStack(alignment: .top, spacing: 3){
                    ForEach(Array(0...19),id: \.self) { column in
                        VStack(alignment: .leading, spacing: 3){
                            ForEach(Array(0...6),id: \.self) { row in
                                
                                RoundedRectangle(cornerRadius: 2, style: .circular)
                                    .fill(getColor(contribution:0))
                                    .frame(width: 13, height: 13, alignment: .center)
                                
                            }
                        }
                    }
                    Spacer()
                }
                
            } else {
                
                if let model = entry.model,
                   let contributionsModel = model.contributionsModel {
                    
                    HStack{
                        Text(model.login)
                            .font(.title3)
                            .foregroundColor(Color("ZLTitleColor1"))
                        
                        if contributionsModel.totalContributions > 0 {
                            Text("\(contributionsModel.totalContributions) contribution")
                                .foregroundColor(Color("ZLDescColor"))
                                .font(.caption)
                        }
                       
                        Spacer()
                    }
                    
                    Spacer()
                    
                    HStack(alignment: .top, spacing: 3){
                        ForEach(contributionsModel.weeks.suffix(20), id: \.self.firstDay) { week in
                            VStack(alignment: .leading, spacing: 3){
                                ForEach(week.contributionDays,id: \.self.contributionsDate) { day in
                                    RoundedRectangle(cornerRadius: 2, style: .circular)
                                        .fill(getColor(contribution: day.contributionsLevel))
                                        .frame(width: 13, height: 13, alignment: .center)
                                    
                                }
                            }
                        }
                        Spacer()
                    }
                    
                   
                } else {
                    Text("No Data")
                        .font(.footnote)
                        .foregroundColor(Color("ZLDescColor"))
                }
            }
            
        }
        .widgetURL(URL(string: "https://github.com/\(entry.model?.login ?? "")"))
  
        if #available(iOS 17.0, *) {
            return view.containerBackground(.background, for: .widget)
        } else {
            return view
        }
    }
    
    func getColor(contribution : Int) -> Color {
        switch(contribution) {
        case 0:
            return Color("ZLContributionColor1")
        case 1:
            return Color("ZLContributionColor2")
        case 2:
            return Color("ZLContributionColor3")
        case 3:
            return Color("ZLContributionColor4")
        case 4:
            return Color("ZLContributionColor5")
        default:
            return Color("ZLContributionColor1")
        }
    }
    
}


struct ContributionView : View {
    
    var entry: ContributionProvider.Entry
    @Environment(\.widgetFamily) var family: WidgetFamily
    
    var body: some View {
        return ContributionMeidumView(entry: entry)
    }
}




struct ContributionWidget : Widget {

    let kind = "ContributionWidget"
    
    var body : some WidgetConfiguration {
        
        IntentConfiguration(kind: kind, intent: ContributionConfigurationIntent.self, provider: ContributionProvider()) { entry in
            ContributionView(entry: entry)
        }
        .configurationDisplayName("Contributions")
        .description("Recent Contributions")
        .supportedFamilies([.systemMedium])
        
    }
}

struct ContributionWidget_Previews : PreviewProvider {
    static var previews: some View {
        ContributionView(entry:ContributionEntry(date:Date(),model:ZLSimpleContributionModel.getSampleContributionData())).previewContext(WidgetPreviewContext(family: .systemMedium))
    }
}

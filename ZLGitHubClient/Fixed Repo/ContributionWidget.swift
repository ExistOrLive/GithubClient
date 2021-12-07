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
    static func getSampleContributionData() -> [ZLSimpleContributionModel] {
        var datas = [ZLSimpleContributionModel]()
        for i in 1...154 {
            var data = ZLSimpleContributionModel()
            data.contributionsNumber = i % 30
            datas.append(data)
        }
        return datas
    }
    static func getPlaceHolderContributionData() -> [ZLSimpleContributionModel] {
        var datas = [ZLSimpleContributionModel]()
        for _ in 1...154 {
            var data = ZLSimpleContributionModel()
            data.contributionsNumber = 0
            datas.append(data)
        }
        return datas
    }
}

struct ContributionEntry : TimelineEntry {
    var date: Date
    var data: [ZLSimpleContributionModel]
    var totalContributions : Int = 0
    var loginName : String?
    var isPlaceHolder : Bool = false
}

struct ContributionProvider : IntentTimelineProvider {
    
    typealias Entry = ContributionEntry
    
    typealias Intent = ContributionConfigurationIntent
    
    func placeholder(in context: Self.Context) -> Self.Entry {
        ContributionEntry(date:Date(),data:ZLSimpleContributionModel.getPlaceHolderContributionData(),loginName:nil,isPlaceHolder:true)
    }
    
    func getSnapshot(for configuration: Self.Intent, in context: Self.Context, completion: @escaping (Self.Entry) -> Void) {
        if context.isPreview {
            completion(ContributionEntry(date:Date(),data:ZLSimpleContributionModel.getSampleContributionData(),loginName:"ExistOrLive"))
        } else {
            completion(ContributionEntry(date:Date(),data:ZLSimpleContributionModel.getPlaceHolderContributionData(),loginName:nil,isPlaceHolder:true))
        }
        
    }
    
    func getTimeline(for configuration: Self.Intent, in context: Self.Context, completion: @escaping (Timeline<Self.Entry>) -> Void){
        
        ZLWidgetService.contributions(loginName: configuration.loginName ?? "") { (result, data, count) in
            
            let currentDate  = Date()
            let entry = ContributionEntry(date:currentDate,data:data,totalContributions:count,loginName:configuration.loginName ?? "")
            let entryDate = Calendar.current.date(byAdding: .hour, value: 2, to: currentDate)!
            let timeLine = Timeline(entries: [entry], policy: .after(entryDate))
            
            completion(timeLine)
        }
        
      
    }
}


struct ContributionMeidumView : View {
    
    let entry : ContributionProvider.Entry
    
    var body : some View {
        VStack{
            if entry.isPlaceHolder {
                
                HStack{
                    Text("      ")
                        .foregroundColor(Color("ZLTitleColor1"))
                        .padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 10))
                    
                    Text("      ")
                        .foregroundColor(Color("ZLDescColor"))
                    
                    Spacer()
                }
                
                Spacer()
                
                HStack(alignment: .top, spacing: 3){
                    ForEach(Range(0...21)) { column in
                        VStack(alignment: .leading, spacing: 3){
                            ForEach(Range(0...6)) { row in
                                let index = column * 7 + row
                                if index < entry.data.count {
                                    RoundedRectangle(cornerRadius: 2, style: .circular)
                                        .fill(getColor(contribution: entry.data[index].contributionsLevel))
                                        .frame(width: 10, height: 10, alignment: .center)
                                }
                            }
                        }
                    }
                    Spacer()
                }
                
            } else {
                
                HStack{
                    Text(entry.loginName ?? "")
                        .font(.title2)
                        .foregroundColor(Color("ZLTitleColor1"))
                        .padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 10))
                    
                    if entry.totalContributions != 0{
                        Text("\(entry.totalContributions) contribution")
                            .foregroundColor(Color("ZLDescColor"))
                            .font(.caption)
                    }
                   
                    Spacer()
                }
                
                Spacer()
                
                if entry.data.count == 0 {
                    
                    Text("No Data")
                        .font(.footnote)
                        .foregroundColor(Color("ZLDescColor"))
                    Spacer()
                    
                } else {
                    
                    HStack(alignment: .top, spacing: 3){
                        ForEach(Range(0...21)) { column in
                            VStack(alignment: .leading, spacing: 3){
                                ForEach(Range(0...6)) { row in
                                    let index = column * 7 + row
                                    if index < entry.data.count {
                                        RoundedRectangle(cornerRadius: 2, style: .circular)
                                            .fill(getColor(contribution: entry.data[index].contributionsLevel))
                                            .frame(width: 10, height: 10, alignment: .center)
                                    }
                                }
                            }
                        }
                        Spacer()
                    }
                }
            }
            
        }
        .padding(EdgeInsets(top: 20, leading: 35, bottom: 20, trailing: 25))
        .widgetURL(URL(string: "https://github.com/\(entry.loginName ?? "")"))
        
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
        switch family{
        case .systemSmall:
            return ContributionMeidumView(entry: entry)
        case .systemMedium:
            return ContributionMeidumView(entry: entry)
        case .systemLarge:
            return ContributionMeidumView(entry: entry)
        case .systemExtraLarge:
            return ContributionMeidumView(entry: entry)
        @unknown default:
            return ContributionMeidumView(entry: entry)
        }
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
        ContributionView(entry:ContributionEntry(date:Date(),data:ZLSimpleContributionModel.getSampleContributionData(),loginName:"ExistOrLive")).previewContext(WidgetPreviewContext(family: .systemMedium))
    }
}

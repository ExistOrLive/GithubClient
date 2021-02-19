//
//  Fixed_Repo.swift
//  Fixed Repo
//
//  Created by 朱猛 on 2020/12/17.
//  Copyright © 2020 ZM. All rights reserved.
//

import WidgetKit
import SwiftUI
import Intents
import ZLServiceFramework


extension ZLGithubRepositoryModel{
    static func getSampleModel() -> ZLGithubRepositoryModel{
        let model = ZLGithubRepositoryModel()
        model.full_name = "ExistOrLive/GithubClient"
        model.desc_Repo = "Github iOS Client based on Github REST V3 API and GraphQL V4 API"
        model.language = "Swift"
        return model
    }
}

struct TrendingRepoProvider: IntentTimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        return SimpleEntry(date: Date(), model:nil,color:Color.blue)
    }
    
    func getSnapshot(for configuration: FixedRepoConfigurationIntent, in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = SimpleEntry(date: Date(),model: ZLGithubRepositoryModel.getSampleModel(), color:Color.blue)
        completion(entry)
    }
    
    func getTimeline(for configuration: FixedRepoConfigurationIntent, in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var entries: [SimpleEntry] = []
        
        let colors = [Color.blue,Color.red,Color.orange,Color.yellow,Color.green,Color.purple,Color.pink]
        
        ZLWidgetService.trendingRepo(dateRange: configuration.DateRange, language: configuration.Language) {(result, repos) in
            
            // Generate a timeline consisting of five entries an hour apart, starting from the current date.
            let currentDate = Date()
            for hourOffset in 0 ..< repos.count {
                let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
                let entry = SimpleEntry(date: entryDate,model: repos[hourOffset],color:colors[hourOffset % colors.count])
                entries.append(entry)
            }
            
            let timeline = Timeline(entries: entries, policy: .atEnd)
            completion(timeline)
            
        }
        
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let model : ZLGithubRepositoryModel?
    let color : Color
}


struct FixedRepoMediumView : View {
    
    var entry: TrendingRepoProvider.Entry
    
    var body: some View {
        HStack{
            VStack(alignment: .leading){
                
                if entry.model == nil {
                    
                    Text("             ")
                        .font(.title3)
                        .foregroundColor(Color("ZLTitleColor"))
                        .lineLimit(1)
                        .background(Color("ZLTitleColor"))
                    
                    Spacer()
                    
                    Text("                       ")
                        .font(.caption)
                        .foregroundColor(Color("ZLDescColor"))
                        .lineLimit(3)
                        .background(Color("ZLDescColor"))
                    
                    Spacer()
                    
                    
                    HStack{
                                                
                        Circle()
                            .fill(entry.color)
                            .frame(width: 15, height: 15, alignment: .leading)
                        Text("     ")
                            .font(.caption2)
                            .foregroundColor(Color("ZLLanguageColor"))
                            .background(Color("ZLLanguageColor"))
                    }
                    
                } else {
                    
                    Text(entry.model?.full_name ?? "")
                        .font(.title3)
                        .foregroundColor(Color("ZLTitleColor"))
                        .lineLimit(2)
                    
                    Spacer()
                    
                    Text(entry.model?.desc_Repo ?? "")
                        .font(.caption)
                        .foregroundColor(Color("ZLDescColor"))
                        .lineLimit(3)
                    
                    Spacer()
                    
                    
                    HStack{
                                            
                        if entry.model?.language?.count ?? 0 != 0 {
                            Circle()
                                .fill(entry.color)
                                .frame(width: 15, height: 15, alignment: .leading)
                            Text(entry.model?.language ?? "")
                                .font(.caption2)
                                .foregroundColor(Color("ZLLanguageColor"))
                        }
                        
                        Image("star")
                            .resizable()
                            .scaledToFit()
                            .frame(minWidth: 15, idealWidth: nil, maxWidth: 15, minHeight: nil, idealHeight: nil, maxHeight: nil, alignment:.center)
                            .padding(.leading, 20)
                        Text(String(entry.model?.stargazers_count ?? 0))
                            .font(.caption2)
                            .foregroundColor(Color("ZLLanguageColor"))
                        
                        Image("fork")
                            .resizable()
                            .scaledToFit()
                            .frame(minWidth: 15.5, idealWidth: nil, maxWidth: 15.5, minHeight: nil, idealHeight: nil, maxHeight: nil, alignment:.center)
                            .padding(.leading, 20)
                        Text(String(entry.model?.forks ?? 0))
                            .font(.caption2)
                            .foregroundColor(Color("ZLLanguageColor"))
                    }
                    
                    
                }
                
                
            }
            .padding(EdgeInsets(top: 20, leading: 25, bottom: 15, trailing: 25))
            Spacer()
        }
        .unredacted()
        .widgetURL(URL(string: "https://github.com/\(entry.model?.full_name ?? "")"))
        
    }
    
}



struct TrendingRepoEntryView : View {
    var entry: TrendingRepoProvider.Entry
    @Environment(\.widgetFamily) var family: WidgetFamily

    var body: some View {
        switch family{
        case .systemSmall:
            return FixedRepoMediumView(entry: entry)
        case .systemMedium:
            return FixedRepoMediumView(entry: entry)
        case .systemLarge:
            return FixedRepoMediumView(entry: entry)
        @unknown default:
            return FixedRepoMediumView(entry: entry)
        }
    }
}


struct TrendingRepoWidget: Widget {
    let kind: String = "Fixed_Repo"

    var body: some WidgetConfiguration {
        IntentConfiguration(kind: kind, intent: FixedRepoConfigurationIntent.self, provider: TrendingRepoProvider()) { entry in
            TrendingRepoEntryView(entry: entry)
        }
        .configurationDisplayName("Trending")
        .description("Trending Repositories")
        .supportedFamilies([.systemMedium])
    }
}

struct Fixed_Repo_Previews: PreviewProvider {
    static var previews: some View {
        TrendingRepoEntryView(entry: SimpleEntry(date: Date(), model: ZLGithubRepositoryModel.getSampleModel(),color:Color.blue))
            .previewContext(WidgetPreviewContext(family: .systemMedium))
    }
}





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

struct Provider: IntentTimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), configuration: ConfigurationIntent())
    }

    func getSnapshot(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = SimpleEntry(date: Date(), configuration: configuration)
        completion(entry)
    }

    func getTimeline(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var entries: [SimpleEntry] = []

        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
        let currentDate = Date()
        for hourOffset in 0 ..< 5 {
            let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
            let entry = SimpleEntry(date: entryDate, configuration: configuration)
            entries.append(entry)
        }

        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let configuration: ConfigurationIntent
}

struct Fixed_RepoEntryView : View {
    var entry: Provider.Entry

    var body: some View {
       
            VStack{
                HStack{
                    Image("default_avatar")
                        .resizable()
                        .scaledToFit()
                        .frame(minWidth: nil, idealWidth: nil, maxWidth: 50, minHeight: nil, idealHeight: nil, maxHeight: 50, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                        .padding(.trailing, /*@START_MENU_TOKEN@*/10/*@END_MENU_TOKEN@*/)
                       
                    Text("existorlive/githubclient")
                        .font(.title3)
                }
                .padding(EdgeInsets(top: 20, leading: 10, bottom: 10, trailing: 10))
                .foregroundColor(Color("ZLTitleColor"))
                
                Text("ddahsjkdhakjshdkjahskdjhakjshdkjahsdkjhaskjdhkjashdkjhaskjdhkajshdjkahskjdhkajshdkjashdkjahskjdhaksjhdkjsah")
                    .padding(EdgeInsets(top: 10, leading: 20, bottom: 20, trailing: 20))
                    .font(.body)
                    .foregroundColor(Color("ZLDescColor"))
                    .lineLimit(4)
                Spacer()
            }
        
    }
}

@main
struct Fixed_Repo: Widget {
    let kind: String = "Fixed_Repo"

    var body: some WidgetConfiguration {
        IntentConfiguration(kind: kind, intent: ConfigurationIntent.self, provider: Provider()) { entry in
            Fixed_RepoEntryView(entry: entry)
        }
        .configurationDisplayName("Trending")
        .description("First Trending Repository")
        .supportedFamilies([.systemLarge])
    }
}

struct Fixed_Repo_Previews: PreviewProvider {
    static var previews: some View {
        Fixed_RepoEntryView(entry: SimpleEntry(date: Date(), configuration: ConfigurationIntent()))
            .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}

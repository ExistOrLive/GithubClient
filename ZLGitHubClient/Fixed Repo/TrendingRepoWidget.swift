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


extension ZLSimpleRepositoryModel{
    static func getSampleModel() -> ZLSimpleRepositoryModel{
        var model = ZLSimpleRepositoryModel(fullName: "ExistOrLive/GithubClient")
        model.desc = "Github iOS Client based on Github REST V3 API and GraphQL V4 API"
        model.language = "Swift"
        return model
    }
}

struct TrendingRepoProvider: IntentTimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        return SimpleEntry(date: Date(), model:nil,color:Color.blue)
    }
    
    func getSnapshot(for configuration: FixedRepoConfigurationIntent, in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = SimpleEntry(date: Date(),model: ZLSimpleRepositoryModel.getSampleModel(), color:Color.blue)
        completion(entry)
    }
    
    func getTimeline(for configuration: FixedRepoConfigurationIntent, in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var entries: [SimpleEntry] = []
        
        ZLWidgetService.trendingRepo(dateRange: configuration.DateRange, language: configuration.Language) {(result, repos) in
            
            let currentDate = Date()
            
            for offset in 0 ..< repos.count {
                /// 每个repo展示时间相差15分钟
                let entryDate = Calendar.current.date(byAdding: .minute, value: offset * 15, to: currentDate)!
                let model = repos[offset]
                let entry = SimpleEntry(date: entryDate,model: model,color: colorForLanguage(language: model.language ?? ""))
                entries.append(entry)
            }
            
            ///repo列表都展示完，重新请求
            let timeline = Timeline(entries: entries, policy: .atEnd)
            
            completion(timeline)
            
        }
        
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date                          /// repo 显示的时间
    let model : ZLSimpleRepositoryModel?
    let color : Color
}


struct FixedRepoMediumView : View {
    var entry: TrendingRepoProvider.Entry
    
    var body: some View {
        let view: some View = HStack {
            VStack(alignment: .leading) {
                
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
                    
                    Text(entry.model?.fullName ?? "")
                        .font(.title3)
                        .foregroundColor(Color("ZLTitleColor"))
                        .lineLimit(2)
                    
                    Spacer()
                    
                    Text(entry.model?.desc ?? "")
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
                        Text(String(entry.model?.star ?? 0))
                            .font(.caption2)
                            .foregroundColor(Color("ZLLanguageColor"))
                        
                        Image("fork")
                            .resizable()
                            .scaledToFit()
                            .frame(minWidth: 15.5, idealWidth: nil, maxWidth: 15.5, minHeight: nil, idealHeight: nil, maxHeight: nil, alignment:.center)
                            .padding(.leading, 20)
                        Text(String(entry.model?.fork ?? 0))
                            .font(.caption2)
                            .foregroundColor(Color("ZLLanguageColor"))
                    }
                    
                    
                }
                
                
            }
            Spacer()
        }
        .unredacted()
        .widgetURL(URL(string: "https://github.com/\(entry.model?.fullName ?? "")"))
        
        if #available(iOS 17.0, *) {
            return view.containerBackground(for: .widget) {
                Color(.widgetBackground)
            }
        } else {
            return view.padding(EdgeInsets(top: 20, leading: 25, bottom: 15, trailing: 25))
        }
    }
}






struct TrendingRepoEntryView : View {
    var entry: TrendingRepoProvider.Entry
    @Environment(\.widgetFamily) var family: WidgetFamily

    var body: some View {
        return FixedRepoMediumView(entry: entry)
    }
}


struct TrendingRepoWidget: Widget {
    let kind: String = "Fixed_Repo"

    var body: some WidgetConfiguration {
        IntentConfiguration(kind: kind,
                            intent: FixedRepoConfigurationIntent.self,
                            provider: TrendingRepoProvider()) { entry in
            TrendingRepoEntryView(entry: entry)
        }
        .configurationDisplayName("Trending")
        .description("Trending Repositories")
        .supportedFamilies([.systemMedium])
    }
}

struct Fixed_Repo_Previews: PreviewProvider {
    static var previews: some View {
        TrendingRepoEntryView(entry: SimpleEntry(date: Date(),
                                                 model: ZLSimpleRepositoryModel.getSampleModel(),
                                                 color:Color.blue))
            .previewContext(WidgetPreviewContext(family: .systemMedium))
    }
}


func colorForLanguage(language: String) -> Color {
    var colorStr = languageToColor[language] ?? "#000000"
    colorStr = String(colorStr[colorStr.index(after: colorStr.startIndex)...])
        
    let rString = String(colorStr[colorStr.startIndex..<colorStr.index(colorStr.startIndex, offsetBy: 2)])
    
    let gString = String(colorStr[colorStr.index(colorStr.startIndex, offsetBy: 2)..<colorStr.index(colorStr.startIndex, offsetBy: 4)])
    
    let bString = String(colorStr[colorStr.index(colorStr.startIndex, offsetBy: 4)..<colorStr.index(colorStr.startIndex, offsetBy: 6)])

    let r = Int(rString,radix: 16) ?? 0
    let g = Int(gString,radix: 16) ?? 0
    let b = Int(bString,radix: 16) ?? 0
     
    return Color(red: Double(r) / 255.0,
                 green: Double(g) / 255.0,
                 blue: CGFloat(b) / 255.0)
}


let languageToColor = [
    "ASL": "#CCCCCC",
    "Adblock Filter List": "#800000",
    "Mercury": "#ff2b2b",
    "TypeScript": "#2b7489",
    "PureBasic": "#5a6986",
    "Objective-C++": "#6866fb",
    "Self": "#0579aa",
    "NewLisp": "#87AED7",
    "Fortran": "#4d41b1",
    "Ceylon": "#dfa535",
    "Rebol": "#358a5b",
    "Frege": "#00cafe",
    "AspectJ": "#a957b0",
    "Omgrofl": "#cabbff",
    "HolyC": "#ffefaf",
    "Shell": "#89e051",
    "HiveQL": "#dce200",
    "AppleScript": "#101F1F",
    "Eiffel": "#946d57",
    "XQuery": "#5232e7",
    "RUNOFF": "#665a4e",
    "RAML": "#77d9fb",
    "MTML": "#b7e1f4",
    "Elixir": "#6e4a7e",
    "SAS": "#B34936",
    "MQL4": "#62A8D6",
    "MQL5": "#4A76B8",
    "Agda": "#315665",
    "wisp": "#7582D1",
    "Dockerfile": "#384d54",
    "SRecode Template": "#348a34",
    "D": "#ba595e",
    "PowerBuilder": "#8f0f8d",
    "Kotlin": "#F18E33",
    "Opal": "#f7ede0",
    "TI Program": "#A0AA87",
    "Crystal": "#000100",
    "Objective-C": "#438eff",
    "Batchfile": "#C1F12E",
    "Oz": "#fab738",
    "Mirah": "#c7a938",
    "ZIL": "#dc75e5",
    "Objective-J": "#ff0c5a",
    "ANTLR": "#9DC3FF",
    "Roff": "#ecdebe",
    "Ragel": "#9d5200",
    "FreeMarker": "#0050b2",
    "Gosu": "#82937f",
    "Zig": "#ec915c",
    "Ruby": "#701516",
    "Nemerle": "#3d3c6e",
    "Jupyter Notebook": "#DA5B0B",
    "Component Pascal": "#B0CE4E",
    "Nextflow": "#3ac486",
    "Brainfuck": "#2F2530",
    "SystemVerilog": "#DAE1C2",
    "APL": "#5A8164",
    "Hack": "#878787",
    "Go": "#00ADD8",
    "Ring": "#2D54CB",
    "PHP": "#4F5D95",
    "Cirru": "#ccccff",
    "SQF": "#3F3F3F",
    "ZAP": "#0d665e",
    "Glyph": "#c1ac7f",
    "1C Enterprise": "#814CCC",
    "WebAssembly": "#04133b",
    "Java": "#b07219",
    "MAXScript": "#00a6a6",
    "Scala": "#c22d40",
    "Makefile": "#427819",
    "Perl": "#0298c3",
    "Jsonnet": "#0064bd",
    "Arc": "#aa2afe",
    "LLVM": "#185619",
    "GDScript": "#355570",
    "Verilog": "#b2b7f8",
    "Factor": "#636746",
    "Haxe": "#df7900",
    "Forth": "#341708",
    "Red": "#f50000",
    "YARA": "#220000",
    "Hy": "#7790B2",
    "mcfunction": "#E22837",
    "Volt": "#1F1F1F",
    "AngelScript": "#C7D7DC",
    "LSL": "#3d9970",
    "eC": "#913960",
    "Terra": "#00004c",
    "CoffeeScript": "#244776",
    "HTML": "#e34c26",
    "Lex": "#DBCA00",
    "UnrealScript": "#a54c4d",
    "Idris": "#b30000",
    "Swift": "#ffac45",
    "Modula-3": "#223388",
    "C": "#555555",
    "AutoHotkey": "#6594b9",
    "P4": "#7055b5",
    "Isabelle": "#FEFE00",
    "G-code": "#D08CF2",
    "Metal": "#8f14e9",
    "Clarion": "#db901e",
    "Vue": "#2c3e50",
    "JSONiq": "#40d47e",
    "Boo": "#d4bec1",
    "AutoIt": "#1C3552",
    "Genie": "#fb855d",
    "Clojure": "#db5855",
    "EQ": "#a78649",
    "Visual Basic": "#945db7",
    "CSS": "#563d7c",
    "Prolog": "#74283c",
    "SourcePawn": "#5c7611",
    "AMPL": "#E6EFBB",
    "Shen": "#120F14",
    "wdl": "#42f1f4",
    "Harbour": "#0e60e3",
    "Yacc": "#4B6C4B",
    "Tcl": "#e4cc98",
    "Quake": "#882233",
    "BlitzMax": "#cd6400",
    "PigLatin": "#fcd7de",
    "xBase": "#403a40",
    "Lasso": "#999999",
    "Processing": "#0096D8",
    "VHDL": "#adb2cb",
    "Elm": "#60B5CC",
    "Dhall": "#dfafff",
    "Propeller Spin": "#7fa2a7",
    "Rascal": "#fffaa0",
    "Alloy": "#64C800",
    "IDL": "#a3522f",
    "Slice": "#003fa2",
    "YASnippet": "#32AB90",
    "ATS": "#1ac620",
    "Ada": "#02f88c",
    "Nu": "#c9df40",
    "LFE": "#4C3023",
    "SuperCollider": "#46390b",
    "Oxygene": "#cdd0e3",
    "ASP": "#6a40fd",
    "Assembly": "#6E4C13",
    "Gnuplot": "#f0a9f0",
    "FLUX": "#88ccff",
    "C#": "#178600",
    "Turing": "#cf142b",
    "Vala": "#fbe5cd",
    "ECL": "#8a1267",
    "ObjectScript": "#424893",
    "NetLinx": "#0aa0ff",
    "Perl 6": "#0000fb",
    "MATLAB": "#e16737",
    "Emacs Lisp": "#c065db",
    "Stan": "#b2011d",
    "SaltStack": "#646464",
    "Gherkin": "#5B2063",
    "QML": "#44a51c",
    "Pike": "#005390",
    "DataWeave": "#003a52",
    "LOLCODE": "#cc9900",
    "ooc": "#b0b77e",
    "XSLT": "#EB8CEB",
    "XC": "#99DA07",
    "J": "#9EEDFF",
    "Mask": "#f97732",
    "EmberScript": "#FFF4F3",
    "TeX": "#3D6117",
    "Pep8": "#C76F5B",
    "R": "#198CE7",
    "Cuda": "#3A4E3A",
    "KRL": "#28430A",
    "Vim script": "#199f4b",
    "Lua": "#000080",
    "Asymptote": "#4a0c0c",
    "Ren'Py": "#ff7f7f",
    "Golo": "#88562A",
    "PostScript": "#da291c",
    "Fancy": "#7b9db4",
    "OCaml": "#3be133",
    "ColdFusion": "#ed2cd6",
    "Pascal": "#E3F171",
    "F#": "#b845fc",
    "API Blueprint": "#2ACCA8",
    "ActionScript": "#882B0F",
    "F*": "#572e30",
    "Fantom": "#14253c",
    "Zephir": "#118f9e",
    "Click": "#E4E6F3",
    "Smalltalk": "#596706",
    "Ballerina": "#FF5000",
    "DM": "#447265",
    "Ioke": "#078193",
    "PogoScript": "#d80074",
    "LiveScript": "#499886",
    "JavaScript": "#f1e05a",
    "Wollok": "#a23738",
    "Rust": "#dea584",
    "ABAP": "#E8274B",
    "ZenScript": "#00BCD1",
    "Slash": "#007eff",
    "Erlang": "#B83998",
    "Pan": "#cc0000",
    "LookML": "#652B81",
    "Scheme": "#1e4aec",
    "Squirrel": "#800000",
    "Nim": "#37775b",
    "Python": "#3572A5",
    "Max": "#c4a79c",
    "Solidity": "#AA6746",
    "Common Lisp": "#3fb68b",
    "Dart": "#00B4AB",
    "Nix": "#7e7eff",
    "Nearley": "#990000",
    "Nit": "#009917",
    "Chapel": "#8dc63f",
    "Groovy": "#e69f56",
    "Dylan": "#6c616e",
    "E": "#ccce35",
    "Parrot": "#f3ca0a",
    "Grammatical Framework": "#79aa7a",
    "Game Maker Language": "#71b417",
    "VCL": "#148AA8",
    "Papyrus": "#6600cc",
    "C++": "#f34b7d",
    "NetLinx+ERB": "#747faa",
    "Common Workflow Language": "#B5314C",
    "Clean": "#3F85AF",
    "X10": "#4B6BEF",
    "Puppet": "#302B6D",
    "Jolie": "#843179",
    "PLSQL": "#dad8d8",
    "sed": "#64b970",
    "Pawn": "#dbb284",
    "Standard ML": "#dc566d",
    "PureScript": "#1D222D",
    "Julia": "#a270ba",
    "nesC": "#94B0C7",
    "q": "#0040cd",
    "Haskell": "#5e5086",
    "NCL": "#28431f",
    "Io": "#a9188d",
    "Rouge": "#cc0088",
    "Racket": "#3c5caa",
    "NetLogo": "#ff6375",
    "AGS Script": "#B9D9FF",
    "Meson": "#007800",
    "Dogescript": "#cca760",
    "PowerShell": "#012456"
]




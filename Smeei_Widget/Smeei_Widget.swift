//
//  Smeei_Widget.swift
//  Smeei_Widget
//
//  Created by Mac18 on 23/01/21.
//

import WidgetKit
import SwiftUI
import Intents

struct Provider: IntentTimelineProvider {

    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), status: "-" ,max: "-", min: "-", average: "-",configuration: ConfigurationIntent())
        
    }
    
    func loadData () -> [String]{
        var data = Array<String>()
        if UserDefaults.standard.object(forKey: "max_value") != nil {
            data.append("Datos recopilados")
            data.append(UserDefaults.standard.string(forKey: "max_value") ?? "No data")
            data.append(UserDefaults.standard.string(forKey: "min_value") ?? "No data")
            data.append(UserDefaults.standard.string(forKey: "average") ?? "No data")
        }else{
            data = ["Sin datos", "no data", "no data", "no data "]
        }
        return data
        
    }

    func getSnapshot(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = SimpleEntry(date: Date(), status: "-",max: "-", min: "-", average: "-",configuration: configuration)
        completion(entry)
    }

    func getTimeline(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var entries: [SimpleEntry] = []

        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
        let currentDate = Date()
        let result = loadData()
        for hourOffset in 0 ..< 5 {
            let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
            let entry = SimpleEntry(date: entryDate, status: result[0], max: result[1], min: result[2], average: result[3], configuration: configuration)
            entries.append(entry)
        }

        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let status : String
    let max: String
    let min: String
    let average: String
    let configuration: ConfigurationIntent
    
}



struct Smeei_WidgetEntryView : View {
    var entry: Provider.Entry

    var body: some View {
        VStack(alignment: .leading){
            HStack{
                Image("measurer_blue")
                    .resizable()
                    .frame(width: 125, height: 125)
                    .padding(5)
                
                VStack(alignment: .leading){
                    Text(entry.status)
                    .font(.title)
                    Text("Consumo").font(.headline)
                    Text("Máximo: \(entry.max)")
                        .font(.body)
                    Text("Mínimo: \(entry.min)")
                        .font(.body)
                    Text("Promedio: \(entry.average)")
                        .font(.body)
                }
            }

        }.padding()

    }
}

@main
struct Smeei_Widget: Widget {
    let kind: String = "Smeei_Widget"

    var body: some WidgetConfiguration {
        IntentConfiguration(kind: kind, intent: ConfigurationIntent.self, provider: Provider()) { entry in
            Smeei_WidgetEntryView(entry: entry)
        }
        .configurationDisplayName("SMEEI Widget")
        .description("Widget for SMEEI App")
    }
}

struct Smeei_Widget_Previews: PreviewProvider {
    static var previews: some View {
        Smeei_WidgetEntryView(entry: SimpleEntry(date: Date(), status: "-", max: "-", min: "-", average: "-", configuration: ConfigurationIntent()))
            .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}

//
//  ContentView.swift
//  x016WeatherApp
//
//  Created by Тагир Аюпов on 2021-02-01.
//
import SDWebImageSwiftUI
import SwiftUI

struct WeatherListView: View {
    @StateObject var store = Store.instance
    
    var body: some View {
        NavigationView {
            VStack {
                if store.cities.count == store.locations.count {
                    List {
                        ForEach(store.cities, id: \.id) { city in
                            NavigationLink(
                                destination: DetailView(city: city),
                                label: {
                                    CityRow(city: city)
                                })
                        }
                        .onDelete(perform: store.delete)
                        .onMove(perform: store.move)
                    }
                    .toolbar {
                        EditButton()
                    }
                    .listStyle(PlainListStyle())
                    
                } else {
                    ProgressView()
                }
            }
            .navigationTitle("My Cities ☀️")
            
        }
    }
}

struct CityRow: View {
    @ObservedObject var city: ForecastListVM
    var body: some View {
        if city.forecasts.count > 0 {
            HStack {
                VStack(alignment: .leading) {
                    Text(city.location)
                        .font(.largeTitle)
                    Text(city.current?.description ?? "")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                Spacer()
                WebImage(url: city.current!.weatherIconURL)
                    .resizable()
                    .placeholder {
                        Image(systemName: "hourglass")
                    }
                    .scaledToFit()
                    .frame(width: 50, height: 50)
                Text("\(city.current!.temp)")
                    .font(.largeTitle)

            }
            .padding(5)
        }
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        WeatherListView()
    }
}




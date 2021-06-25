//
//  DetailView.swift
//  x016WeatherApp
//
//  Created by Tagir Aiupov on 2021-05-10.
//


import SDWebImageSwiftUI
import SwiftUI
import CoreLocation

struct DetailView: View {
    @StateObject var store = Store.instance
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var city: ForecastListVM
    var showButton: Bool = false
    var cityName: String = ""
    
    var body: some View {
        ZStack {
            
            if city.current != nil {
                VStack(spacing: 5) {
                    if showButton {
                        
                        HStack {
                            Text(cityName)
                                .scaledToFill()
                                .minimumScaleFactor(0.5)
                                .lineLimit(1)
                            Spacer()
                        }
                        .padding(.top, 30)
                        .padding(.leading, 15)
                    }
                    
                    HStack(alignment: .top) {
                        VStack(alignment: .leading) {
                            Text(city.current!.temp)
                                .font(.system(size: 70.0))
                            Text(city.current!.description)
                                .foregroundColor(.secondary)
                        }
                        .padding([.leading, .trailing], 10)
                        
                        Spacer()
                        WebImage(url: city.current!.weatherIconURL)
                            .scaledToFit()
                            .frame(width: 125)
                    } // topView
                    
                    
                    HStack {
                        Label(
                            title: { Text(city.current!.pressure) },
                            icon: { Image(systemName: "thermometer") })
                        Spacer()
                        Label(
                            title: { Text(city.current!.humidity) },
                            icon: { Image(systemName: "drop") })
                        Spacer()
                        Label(
                            title: { Text(city.current!.wind) },
                            icon: { Image(systemName: "wind") })
                    }
                    .padding([.leading, .bottom, .trailing], 15)
                    
                    List(city.forecasts, id: \.day) { day in
                        HStack {
                            Text(day.day)
                            Spacer()
                            
                            WebImage(url: day.weatherIconURL)
                                .resizable()
                                .placeholder {
                                    Image(systemName: "hourglass")
                                }
                                .scaledToFit()
                                .frame(width: 35)
                                
                            
                            Text(day.high)
                            Text(day.low)
                                
                                
                                
                        }
                    }
                    
                    VStack {
//                        Spacer()
                        Button(action: {
                            self.presentationMode.wrappedValue.dismiss()
                            store.addCity(location: cityName, city: city)
                            
                        }, label: {
                            Text("Add to Cities")
                                .foregroundColor(.white)
                                .frame(width: UIScreen.main.bounds.width * 2 / 3, height: 55)
                                .background(Color.blue.cornerRadius(10))
                                .padding()
                        })
                    }
                    
                } // daily forecast
            } else {
                ProgressView()
            }
        }
        .navigationTitle(city.location)
    }
}

struct DetailView_Previews: PreviewProvider {
    static var previews: some View {
        DetailView(city: ForecastListVM(location: "Moscow"))
    }
}

//
//  ContentView.swift
//  Raincoat
//
//  Created by Тагир Аюпов on 2021-04-13.
//

import SwiftUI
import MapKit
import CoreLocation

struct HomeView: View {
    @StateObject var store = Store.instance
    @StateObject var vm = MapViewVM.instance
    

    @State private var centerCoordinate = CLLocationCoordinate2D()
    @State var selection: Int = 0
    var isShowingButton: Bool { vm.city != "" }
    @State var isShowingDetails = false
    
    
    var body: some View {
        
        VStack(spacing: 0) {
            switch selection {
            case 0:
                ZStack(alignment: .top) {
                    MapView(centerCoordinate: $centerCoordinate, annotations: vm.locations)
                    
                    if isShowingButton {
                        VStack {
                            Spacer()
                            Button(action: {
//                                    selection = 1
//                                weatherVM.getWeatherForecast(coordinate: centerCoordinate)
                                isShowingDetails.toggle()
                            }, label: {
                                Text("Show weather for: \(vm.city)")
                                    .foregroundColor(.white)
                                    .frame(height: 40)
                                    .frame(maxWidth: .infinity)
                                    .padding()
                                    .background(Color.gray)
                                    .opacity(1.0)
                                    .transition(.opacity)
                                
                            })
                        }.transition(AnyTransition.opacity.animation(.easeInOut(duration: 0.5)))
                    }
                }
                .sheet(isPresented: $isShowingDetails, content: {
                    DetailView(city: ForecastListVM(location: vm.city), showButton: true, cityName: vm.city).environmentObject(store)
                })
                
                
                
            default:
                WeatherListView()
                    .transition(AnyTransition.opacity.animation(.easeInOut(duration: 0.5)))
            }
            TabBarView(selection: $selection)
        }
        .edgesIgnoringSafeArea(.all)
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}

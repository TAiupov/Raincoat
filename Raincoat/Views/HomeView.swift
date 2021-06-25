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
                ZStack(alignment: .bottom) {
                    MapView(centerCoordinate: $centerCoordinate, annotations: vm.locations)
                    
                    if isShowingButton {
                        detailsButton
                            
                    }
                }
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

extension HomeView {
    
    private var detailsButton: some View {
            Button(action: {
                isShowingDetails.toggle()
            }, label: {
                Text("Show weather for: \(vm.city)")
                    .foregroundColor(.white)
                    .frame(height: 40)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.gray)
                    .opacity(0.7)
                    .transition(.opacity)
            })
            .sheet(isPresented: $isShowingDetails, content: {
                DetailView(city: ForecastListVM(location: vm.city), showButton: true, cityName: vm.city).environmentObject(store)
            })
            .transition(AnyTransition.opacity.animation(.easeInOut(duration: 0.5)))
            
                                
        
    }
}

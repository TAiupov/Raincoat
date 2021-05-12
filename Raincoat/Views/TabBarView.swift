//
//  TabBar.swift
//  Raincoat
//
//  Created by Тагир Аюпов on 2021-04-26.
//

import SwiftUI

struct TabBarView: View {
    let tabBarIcon: [String] = ["mappin.and.ellipse", "cloud.sun"]
    let tabBarName: [String] = ["Map", "Weather"]
    
    @Binding var selection: Int
    
    var body: some View {
        VStack(spacing: 0) {
            
            Divider()
                .background(Color.red)
            
            HStack {
                ForEach(0 ..< tabBarIcon.count) { index in
                        
                        Button(action: {
                            withAnimation {
                                selection = index
                            }
                        }, label: {
                            Spacer()
                            VStack {
                                Image(systemName: "\(tabBarIcon[index])")
                                Text(tabBarName[index])
                            }
                            .foregroundColor(selection == index ? Color.red : Color.gray)
                            Spacer()
                        })
                        
                        
                    }
                }
            .frame(height: 70)
            .frame(maxWidth: .infinity)
        .background(Color.gray.opacity(0.2))
        }
        
    }
}

struct TabBar_Previews: PreviewProvider {
    
    static var previews: some View {
        TabBarView(selection: .constant(0)).previewLayout(.sizeThatFits)
    }
}

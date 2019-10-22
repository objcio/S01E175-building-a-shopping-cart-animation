//
//  ContentView.swift
//  ShoppingCart
//
//  Created by Chris Eidhof on 22.10.19.
//  Copyright © 2019 Chris Eidhof. All rights reserved.
//

import SwiftUI

let colors = (0..<5).map { ix in
    Color(hue: Double(ix)/5, saturation: 1, brightness: 0.8)
}
let icons = ["airplane", "studentdesk", "hourglass", "headphones", "lightbulb"]

struct ShoppingItem: View {
    let index: Int
    var body: some View {
        RoundedRectangle(cornerRadius: 5)
           .fill(colors[index])
           .frame(width: 50, height: 50)
            .overlay(
                Image(systemName: icons[index])
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .foregroundColor(.white)
                    .padding(10)
            )
    }
}

struct AnchorKey: PreferenceKey {
    typealias Value = Anchor<CGPoint>?
    static var defaultValue: Value { nil }
    
    static func reduce(value: inout Value, nextValue: () -> Value) {
        value = nextValue()
    }
}

struct ContentView: View {
    @State var cartItems: [(index: Int, anchor: Anchor<CGPoint>)] = []
    
    var body: some View {
        VStack {
            HStack {
                ForEach(0..<colors.count) { index in
                    ShoppingItem(index: index)
                        .anchorPreference(key: AnchorKey.self, value: .topLeading, transform: { $0 })
                        .overlayPreferenceValue(AnchorKey.self, { anchor in
                            Button(action: {
                                self.cartItems.append((index: index, anchor: anchor!))
                            }, label: { Color.clear })
                        })
                    
                }
            }
            Spacer()
                .frame(height: 150)
            RoundedRectangle(cornerRadius: 5)
                .fill(Color.gray)
                .frame(width: 80, height: 80)
                .overlay(Text("\(cartItems.count)"))
            .background(
                GeometryReader { proxy in
                    ZStack {
                        ForEach(Array(self.cartItems.enumerated()), id: \.offset) { (_, item) in
                                ShoppingItem(index: item.index)
                                    .animation(.default)
                                    .transition(.offset(x: proxy[item.anchor].x, y: proxy[item.anchor].y))
                        }
                    }
                }.frame(width: 50, height: 50)
            )
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

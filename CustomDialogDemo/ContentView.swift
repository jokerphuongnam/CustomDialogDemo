//
//  ContentView.swift
//  CustomDialogDemo
//
//  Created by gannha on 10/05/2022.
//

import SwiftUI

struct ContentView: View {
    @State private var isPresented: Bool = false
    var body: some View {
        Button(action: onShowDialog) {
            VStack {
                Text("This demo for dialog")
                    .font(.largeTitle)
                Text("Tap to show dialog")
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.blue)
                    .cornerRadius(20)
            }
        }
        .background(Color.white)
        .cornerRadius(16)
        .dialog(isPresented: $isPresented, isEnableCancel: false, onDismiss: onDismiss) {
            VStack {
                Text("Dialog")
                    .font(.largeTitle)
                    .padding()
                
                Text("Show dialog success!")
                    .padding()
            }
            .padding()
//            .background(Color.white)
            .cornerRadius(20)
        }
    }
    
    func onShowDialog() {
        isPresented = true
    }
    
    func onDismiss() {
        print("Dismiss")
    }
}

#if DEBUG
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
#endif

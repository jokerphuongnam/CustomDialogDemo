//
//  ContentView.swift
//  CustomDialogDemo
//
//  Created by gannha on 10/05/2022.
//

import SwiftUI

struct ContentView: View {
    @State private var isPresentedCanCancel: Bool = false
    @State private var isEnableCancel: Bool = false
    @State private var timeInterval: String = ""
    @State private var isPresentedTimeInterval: Bool = false
    var body: some View {
        VStack {
            VStack {
                Toggle("Is Enable Cancel: ", isOn: $isEnableCancel)
                    .padding()
                
                Button(action: onShowDialogIsCanCancel) {
                    Text("Tap to show dialog \(isEnableCancel ? "can" : "can't") cancel")
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.blue)
                        .cornerRadius(20)
                }
            }
            .padding()
            
            VStack {
                VStack {
                    Text("Input time interval: ")
                    HStack {
                        Spacer()
                        TextField("200", text: $timeInterval)
                            .keyboardType(.numberPad)
                        Text("ms")
                        Spacer()
                    }
                }
                
                if !timeInterval.isEmpty {
                    Button(action: onShowDialogTimeInterval) {
                        Text("Show dialog in \(String(format: "%g", Float(Int(timeInterval) ?? 0) / 1000))s")
                            .foregroundColor(.white)
                            .padding()
                            .background(Color.blue)
                            .cornerRadius(20)
                    }
                }
            }
            .padding()
        }
        .navigationBarTitle("This demo for dialog")
        .dialog(isPresented: $isPresentedCanCancel, isEnableCancel: isEnableCancel, onDismiss: onDismiss) {
            dialog
        }
        .dialog(isPresented: $isPresentedTimeInterval, timeInterval: Int(timeInterval) ?? 0) {
            dialog
        }
    }
    
    func onShowDialogIsCanCancel() {
        isPresentedCanCancel = true
    }
    
    func onCancelDialog() {
        isPresentedCanCancel = false
    }
    
    func onShowDialogTimeInterval() {
        isPresentedTimeInterval = true
    }
    
    func onDismiss() {
        print("Dismiss")
    }
    
    private var dialog: some View {
        VStack {
            Text("Dialog")
                .font(.largeTitle)
                .padding()
            
            Text("Show dialog success!")
                .padding()
            
            if !isEnableCancel && isPresentedCanCancel {
                Button(action: onCancelDialog) {
                    Text("Cancel")
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.blue)
                        .cornerRadius(20)
                }
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(20)
    }
}

#if DEBUG
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
#endif

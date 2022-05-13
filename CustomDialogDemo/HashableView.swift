//
//  HashableView.swift
//  CustomDialogDemo
//
//  Created by gannha on 13/05/2022.
//

import SwiftUI

struct HashableView: View {
    @State private var selection: SelectionDialog? = nil
    @State private var isEnableCancel: Bool = false
    @State private var timeInterval: String = ""
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
        .toolbar {
            NavigationLink("Hashable Test") {
                HashableView()
            }
        }
        .dialog(selection: $selection, tag: .isPresented, isEnableCancel: isEnableCancel, onDismiss: onDismiss) {
            dialog
        }
        .dialog(selection: $selection, tag: .timeInterval, timeInterval: Int(timeInterval) ?? 0) {
            dialog
        }
    }
    
    func onShowDialogIsCanCancel() {
        selection = .isPresented
    }
    
    func onCancelDialog() {
        selection = nil
    }
    
    func onShowDialogTimeInterval() {
        selection = .timeInterval
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
            
            if !isEnableCancel && selection == .isPresented {
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
    
    private enum SelectionDialog {
        case isPresented
        case timeInterval
    }
}

#if DEBUG
struct HashableView_Previews: PreviewProvider {
    static var previews: some View {
        HashableView()
    }
}
#endif

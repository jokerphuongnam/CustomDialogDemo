//
//  ContentView.swift
//  CustomDialogDemo
//
//  Created by gannha on 10/05/2022.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationView {
            IsPresentedView()
        }
    }
}

#if DEBUG
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
#endif

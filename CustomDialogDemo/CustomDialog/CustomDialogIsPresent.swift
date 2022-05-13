//
//  CustomDialogIsPresent.swift
//  gannha
//
//  Created by gannha on 10/05/2022.
//

import SwiftUI

private struct CustomDialogModifier<Body>: ViewModifier where Body: View {
    @Binding private var isPresented: Bool
    fileprivate typealias OnDismiss = (() -> ())
    private let onDismiss: OnDismiss?
    private let body: Body
    private let cancellable: Cancellable
    init(
        isPresented: Binding<Bool>,
        isEnableCancel: Bool,
        onDismiss: OnDismiss?,
        @ViewBuilder body: @escaping () -> Body) {
            self._isPresented = isPresented
            self.cancellable = .enable(isEnable: isEnableCancel)
            self.onDismiss = onDismiss
            self.body = body()
        }
    
    init(
        isPresented: Binding<Bool>,
        timeInterval: Int,
        onDismiss: OnDismiss?,
        @ViewBuilder body: @escaping () -> Body) {
            self._isPresented = isPresented
            self.cancellable = .timeIntervel(timeInterval: timeInterval)
            self.onDismiss = onDismiss
            self.body = body()
        }
    
    func body(content: Content) -> some View {
        content
            .overlay(contentOverlay, alignment: .center)
            .fullScreenCover(
                isPresented: $isPresented,
                onDismiss: onDismiss) {
                    body
                        .background(
                            background
                                .onAppear {
                                    switch cancellable {
                                    case .enable(_): break
                                    case .timeIntervel(let timeInterval):
                                        DispatchQueue.main.asyncAfter(deadline: .now() + DispatchTimeInterval.milliseconds(timeInterval)) {
                                            isPresented = false
                                        }
                                    }
                                })
                }
    }
    
    @ViewBuilder private var contentOverlay: some View {
        if isPresented {
            let size = UIScreen.main.bounds
            Color.black
                .opacity(0.4)
                .edgesIgnoringSafeArea(.all)
                .frame(width: size.width, height: size.height)
        } else {
            EmptyView()
        }
    }
}

private extension CustomDialogModifier {
    @ViewBuilder
    var background: some View {
        switch cancellable {
        case .enable(let isEnableCancel):
            BackgroundDialog(isPresented: $isPresented, isEnableCancel: isEnableCancel)
        case .timeIntervel(_):
            BackgroundDialog(isPresented: $isPresented, isEnableCancel: false)
        }
    }
}

private extension CustomDialogModifier {
    enum Cancellable {
        case enable(isEnable: Bool)
        case timeIntervel(timeInterval: Int)
    }
}

private struct BackgroundDialog: UIViewRepresentable {
    @Binding fileprivate var isPresented: Bool
    private let isEnableCancel: Bool
    init(isPresented: Binding<Bool>, isEnableCancel: Bool) {
        self._isPresented = isPresented
        self.isEnableCancel = isEnableCancel
    }
    func makeUIView(context: Context) -> UIView {
        let view = UIView()
        DispatchQueue.main.async {
            guard let parentView = view.superview?.superview else {
                return
            }
            
            parentView.backgroundColor = .clear
            
            if isEnableCancel {
                parentView.addGestureRecognizer(context.coordinator.dismissTap)
            }
        }
        return view
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {
        
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    fileprivate class Coordinator {
        private let parent: BackgroundDialog
        lazy var dismissTap = UITapGestureRecognizer(target: self, action: #selector(dismiss))
        
        init(_ parent: BackgroundDialog) {
            self.parent = parent
        }
        
        @objc private func dismiss(_ sender: UITapGestureRecognizer) {
            guard let parentView = sender.view,
                  let view = parentView.subviews.first?.subviews.first else {
                      return
                  }
            let touchPoint = sender.location(in: view)
            let frame = view.frame
            if !(0...frame.width).contains(touchPoint.x) ||
                !(0...frame.height).contains(touchPoint.y) {
                parent.isPresented = false
            }
        }
    }
}

public extension View {
    func dialog<Content>(
        isPresented: Binding<Bool>,
        isEnableCancel: Bool = true,
        onDismiss: (() -> ())? = nil,
        @ViewBuilder content: @escaping () -> Content) -> some View
    where Content: View {
        modifier(CustomDialogModifier(isPresented: isPresented, isEnableCancel: isEnableCancel, onDismiss: onDismiss, body: content))
    }
    
    func dialog<Content>(
        isPresented: Binding<Bool>,
        timeInterval: Int,
        onDismiss: (() -> ())? = nil,
        @ViewBuilder content: @escaping () -> Content) -> some View
    where Content: View {
        modifier(CustomDialogModifier(isPresented: isPresented, timeInterval: timeInterval, onDismiss: onDismiss, body: content))
    }
}

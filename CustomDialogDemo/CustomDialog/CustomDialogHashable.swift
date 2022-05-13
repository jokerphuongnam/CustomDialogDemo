//
//  CustomDialogHashable.swift
//  CustomDialogDemo
//
//  Created by gannha on 13/05/2022.
//

import SwiftUI

private struct CustomDialogModifier<Body, V>: ViewModifier where Body: View, V: Hashable {
    @Binding private var selection: V?
    private let tag: V
    fileprivate typealias OnDismiss = (() -> ())
    private let onDismiss: OnDismiss?
    private let body: Body
    private let cancellable: Cancellable
    init(
        selection: Binding<V?>,
        tag: V,
        isEnableCancel: Bool,
        onDismiss: OnDismiss?,
        @ViewBuilder body: @escaping () -> Body) {
            self._selection = selection
            self.tag = tag
            self.cancellable = .enable(isEnable: isEnableCancel)
            self.onDismiss = onDismiss
            self.body = body()
        }
    
    init(
        selection: Binding<V?>,
        tag: V,
        timeInterval: Int,
        onDismiss: OnDismiss?,
        @ViewBuilder body: @escaping () -> Body) {
            self._selection = selection
            self.tag = tag
            self.cancellable = .timeIntervel(timeInterval: timeInterval)
            self.onDismiss = onDismiss
            self.body = body()
        }
    
    func body(content: Content) -> some View {
        content
            .overlay(contentOverlay, alignment: .center)
            .fullScreenCover(
                isPresented: Binding(get: {
                    selection == tag
                }, set: { newValue in
                    if newValue {
                        
                    } else {
                        selection = nil
                    }
                }),
                onDismiss: onDismiss) {
                    body
                        .background(
                            background
                                .onAppear {
                                    switch cancellable {
                                    case .enable(_): break
                                    case .timeIntervel(let timeInterval):
                                        DispatchQueue.main.asyncAfter(deadline: .now() + DispatchTimeInterval.milliseconds(timeInterval)) {
                                            selection = nil
                                        }
                                    }
                                })
                }
    }
    
    @ViewBuilder private var contentOverlay: some View {
        if selection != nil {
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
            BackgroundDialog(selection: $selection, isEnableCancel: isEnableCancel)
        case .timeIntervel(_):
            BackgroundDialog(selection: $selection, isEnableCancel: false)
        }
    }
}

private extension CustomDialogModifier {
    enum Cancellable {
        case enable(isEnable: Bool)
        case timeIntervel(timeInterval: Int)
    }
}

private struct BackgroundDialog<V>: UIViewRepresentable where V: Hashable {
    @Binding fileprivate var selection: V?
    private let isEnableCancel: Bool
    init(selection: Binding<V?>, isEnableCancel: Bool) {
        self._selection = selection
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
                parent.selection = nil
            }
        }
    }
}

public extension View {
    func dialog<Content, V>(
        selection: Binding<V?>,
        tag: V,
        isEnableCancel: Bool = true,
        onDismiss: (() -> ())? = nil,
        @ViewBuilder content: @escaping () -> Content) -> some View
    where Content: View, V: Hashable {
        modifier(CustomDialogModifier(selection: selection, tag: tag, isEnableCancel: isEnableCancel, onDismiss: onDismiss, body: content))
    }
    
    func dialog<Content, V>(
        selection: Binding<V?>,
        tag: V,
        timeInterval: Int,
        onDismiss: (() -> ())? = nil,
        @ViewBuilder content: @escaping () -> Content) -> some View
    where Content: View, V: Hashable {
        modifier(CustomDialogModifier(selection: selection, tag: tag, timeInterval: timeInterval, onDismiss: onDismiss, body: content))
    }
}

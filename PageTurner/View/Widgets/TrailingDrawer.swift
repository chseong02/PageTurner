//
//  TrailingDrawer.swift
//  PageTurner
//
//  Created by chseong on 7/10/25.
//

import SwiftUI

// 재사용 가능한 TrailingDrawer 모디파이어 (스크림 제거 버전)
struct TrailingDrawer<DrawerContent: View>: ViewModifier {
    @Binding var isOpen: Bool
    let width: CGFloat
    let drawer: () -> DrawerContent
    // 추가: 메인 뷰가 밀리는 거리 비율 (0…1)
    var mainShiftRatio: CGFloat = 0.7

    func body(content: Content) -> some View {
        ZStack {
            // 1) 메인 콘텐츠: 사이드바 열리면 왼쪽으로 이동
            content
                .offset(x: isOpen ? -width * mainShiftRatio : 0)
                .animation(.easeInOut, value: isOpen)

            // 2) 사이드바
            if isOpen {
                HStack(spacing: 0) {
                    Spacer()
                    drawer()
                        .frame(width: width)
                        .background(Color(UIColor.secondarySystemBackground)) // 필요 없으면 제거
                        .transition(.move(edge: .trailing))
                }
                .animation(.easeInOut, value: isOpen)
            }
        }
    }
}

extension View {
    func trailingDrawer<Content: View>(
        isOpen: Binding<Bool>,
        width: CGFloat = UIScreen.main.bounds.width * 0.7,
        mainShiftRatio: CGFloat = 0.7,
        @ViewBuilder content: @escaping () -> Content
    ) -> some View {
        modifier(
            TrailingDrawer(
                isOpen: isOpen,
                width: width,
                drawer: content,
                mainShiftRatio: mainShiftRatio
            )
        )
    }
}
//
//// 사용 예시
//struct ContentView: View {
//    @State private var showRight = false
//
//    var body: some View {
//        ZStack {
//            VStack {
//                Button("사이드바 토글") {
//                    withAnimation { showRight.toggle() }
//                }
//                Spacer()
//                Text("메인 콘텐츠")
//                Spacer()
//            }
//        }
//        .trailingDrawer(isOpen: $showRight, width: 280) {
//            VStack(alignment: .leading) {
//                HStack {
//                    Spacer()
//                    Button {
//                        withAnimation { showRight = false }
//                    } label: {
//                        Image(systemName: "xmark.circle.fill")
//                            .font(.title2)
//                    }
//                }
//                .padding(.horizontal)
//
//                Divider()
//                // 여기부터 사이드바 내부 콘텐츠
//                VStack(spacing: 16) {
//                    Text("옵션 A")
//                    Toggle("", isOn: .constant(true))
//                    Text("옵션 B")
//                    Toggle("", isOn: .constant(false))
//                }
//                .padding()
//                Spacer()
//            }
//        }
//    }
//}

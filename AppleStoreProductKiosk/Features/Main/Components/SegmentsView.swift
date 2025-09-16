//
//  SegmentsView.swift
//  AppleStoreProductKiosk
//
//  Created by 홍석현 on 9/16/25.
//

import SwiftUI

public struct SegmentData: Identifiable {
  public let id: String
  public let title: String
  public let icon: String?
}

public struct SegmentsView<Content: View>: View {
  private let items: [SegmentData]
  @Binding private var selectedID: String
  private let content: (SegmentData, Bool) -> Content

  public init(
    items: [SegmentData],
    selectedID: Binding<String>,
    content: @escaping (SegmentData, Bool) -> Content
  ) {
    self.items = items
    self._selectedID = selectedID
    self.content = content
  }

  public var body: some View {
    ScrollView(.horizontal) {
      HStack(spacing: 6) {
        ForEach(items) { item in
          Button(action: {
            withAnimation(.interactiveSpring) {
              selectedID = item.id
            }
          }) {
            content(item, selectedID == item.id)
              .padding(.horizontal, 12)
              .padding(.vertical, 12)
              .background(
                selectedID == item.id ? Color.blue : Color.white
              )
              .foregroundColor(
                selectedID == item.id ? .white : .primary
              )
              .overlay(
                Capsule()
                  .stroke(
                    selectedID == item.id
                      ? Color.blue : Color.gray.opacity(0.5),
                    lineWidth: 1
                  )
              )
              .clipShape(Capsule())
          }
        }
      }
      .padding(.horizontal, 8)
    }
    .scrollIndicators(.hidden)
  }
}

private struct PreviewSegment: View {
  @State var selectedSegment = "iPhone"

  var body: some View {
    SegmentsView(
      items: [
        SegmentData(id: "iPhone", title: "iPhone", icon: "iphone"),
        SegmentData(id: "iPad", title: "iPad", icon: "ipad"),
        SegmentData(id: "Mac", title: "Mac", icon: "macbook"),
        SegmentData(
          id: "Apple Watch",
          title: "Apple Watch",
          icon: "applewatch"
        ),
      ],
      selectedID: $selectedSegment
    ) { item, isSelected in
      HStack {
        if let icon = item.icon {
          Image(systemName: icon)
        }
        Text(item.title)
          .lineLimit(1)
      }
      .font(.system(size: 12))
    }
  }
}

#Preview {
  PreviewSegment()
}

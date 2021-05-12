//
//  RatingView.swift
//  Compliments-Beta
//
//  Created by Derik Flanary on 5/12/21.
//

import SwiftUI

struct RatingView: View {

    @Binding var rating: Double
    
    @State private var starSize: CGSize = .zero
    @State private var controlSize: CGSize = .zero
    @State private var shouldScale: Bool = false
    
    @GestureState private var dragging: Bool = false

    let maxRating: Int
    var scale: CGFloat {
        1 + (CGFloat(rating) / 100)
    }

    init(_ rating: Binding<Double>, maxRating: Int = 5) {
        _rating = rating
        self.maxRating = maxRating
    }

    var body: some View {
        ZStack {
            HStack {
                ForEach(0..<Int(maxRating), id: \.self) { starValue in
                    image(starValue: starValue)
                        .star(size: starSize)
                }
            }
            .scaleEffect(scale)
            .animation(Animation.easeInOut.repeatCount(1, autoreverses: false))
            .background(
                GeometryReader { proxy in
                    Color.clear.preference(key: ControlSizeKey.self, value: proxy.size)
                }
            )
            .onPreferenceChange(StarSizeKey.self) { size in
                starSize = size
            }
            .onPreferenceChange(ControlSizeKey.self) { size in
                controlSize = size
            }

            Color.clear
                .frame(width: controlSize.width, height: controlSize.height)
                .contentShape(Rectangle())
                .gesture(
                    DragGesture(minimumDistance: 0, coordinateSpace: .local)
                        .onChanged { value in
                            rating = rating(at: value.location)
                        }
                )
        }
    }
    
    func image(starValue: Int) -> Image {
        let actualStarValue = Double(starValue + 1)
        if rating == actualStarValue || rating > actualStarValue && rating - actualStarValue > 0 {
            return Image(systemName: "star.fill")
        } else if actualStarValue - rating == 0.5 {
            return Image(systemName: "star.leadinghalf.fill")
        } else {
            return Image(systemName: "star")
        }
    }

    private func rating(at position: CGPoint) -> Double {
        let singleStarWidth = starSize.width
        let totalPaddingWidth = controlSize.width - CGFloat(maxRating)*singleStarWidth
        let singlePaddingWidth = totalPaddingWidth / (CGFloat(maxRating) - 1)
        let starWithSpaceWidth = Double(singleStarWidth + singlePaddingWidth)
        let x = Double(position.x)

        let starIdx = Int(x / starWithSpaceWidth)
        let starPercent = x.truncatingRemainder(dividingBy: starWithSpaceWidth) / Double(singleStarWidth) * 100

        let rating: Double
        if starPercent < 25 {
            rating = Double(starIdx)
        } else if starPercent <= 75 {
            rating = Double(starIdx) + 0.5
        } else {
            rating = Double(starIdx) + 1
        }

        return min(Double(maxRating), max(0, rating))
    }
    
}

fileprivate extension Image {
    
    func star(size: CGSize) -> some View {
        return self
            .font(.system(size: 48, weight: .light, design: .default))
            .foregroundColor(.white)
            .background(
                GeometryReader { proxy in
                    Color.clear.preference(key: StarSizeKey.self, value: proxy.size)
                }
            )
            .frame(width: size.width, height: size.height)
    }
    
}


fileprivate protocol SizeKey: PreferenceKey { }

fileprivate extension SizeKey {
    static var defaultValue: CGSize { .zero }
    static func reduce(value: inout CGSize, nextValue: () -> CGSize) {
        let next = nextValue()
        value = CGSize(width: max(value.width, next.width), height: max(value.height, next.height))
    }
}

fileprivate struct StarSizeKey: SizeKey { }
fileprivate struct ControlSizeKey: SizeKey { }

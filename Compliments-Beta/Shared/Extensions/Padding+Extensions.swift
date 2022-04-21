//
//  Padding+Extensions.swift
//  Compliments-Beta
//
//  Created by Derik Flanary on 4/21/22.
//

import SwiftUI

extension View {
    
    /// Pads this view along all edge insets by the amount you specify.
    /// - Parameters:
    ///     - edge: The set of edges along which to inset this view.
    ///     - constant: A `Constant.Padding` case which is the amount to inset this view on each edge.
    /// - Returns: A view that pads this view using edge the insets you specify.
    func padding(_ edge: Edge.Set, _ constant: Constants.Padding) -> some View {
        padding(edge, constant.rawValue)
    }
    
    /// Pads this view along all edge insets by the amount you specify.
    /// - Parameter constant: A `Constant.Padding` case which is the amount to inset this view on each edge.
    /// - Returns: A view that pads this view by the amount you specify.
    func padding(_ constant: Constants.Padding) -> some View {
        padding(constant.rawValue)
    }
    
    /// Add padding to the view along multiple edges in one call
    /// - Parameters:
    ///   - leading: `Constant.Padding` to be used for the leading edge
    ///   - trailing: `Constant.Padding` to be used for the trailing edge
    ///   - top: `Constant.Padding` to be used for the top edge
    ///   - bottom: `Constant.Padding` to be used for the bottom edge
    /// - Returns: A view that pads this view by the amounts you specify.
    func padding(leading: Constants.Padding = .none, trailing: Constants.Padding = .none, top: Constants.Padding = .none, bottom: Constants.Padding = .none) -> some View {
        padding(.leading, leading)
            .padding(.trailing, trailing)
            .padding(.top, top)
            .padding(.bottom, bottom)
    }
    
}

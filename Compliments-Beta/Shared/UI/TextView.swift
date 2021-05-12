import SwiftUI

public struct TextView: View {
    
    
    // MARK: - Typealiases
    
    public typealias TextAlignment = NSTextAlignment
    public typealias ContentType = UITextContentType
    public typealias Autocorrection = UITextAutocorrectionType
    public typealias Autocapitalization = UITextAutocapitalizationType
    
    
    // MARK: - Bindings
    
    @Binding private var text: String
    @Binding private var isEditing: Bool
    
    
    // MARK: - Properties
    
    private let placeholder: String?
    private let textAlignment: TextAlignment
    private let placeholderAlignment: Alignment
    private let placeholderHorizontalPadding: CGFloat
    private let placeholderVerticalPadding: CGFloat
    private let textColor: UIColor
    private let placeholderColor: Color
    private let backgroundColor: UIColor
    private let contentType: ContentType?
    private let autocorrection: Autocorrection
    private let autocapitalization: Autocapitalization
    private let isSecure: Bool
    private let isEditable: Bool
    private let isSelectable: Bool
    private let isScrollingEnabled: Bool
    private let isUserInteractionEnabled: Bool
    private var contentSizeDidChange: ((CGSize) -> Void)?
    
    static let placeholderPadding: CGFloat = 4.5
    
    
    // MARK: - Init
    
    public init(text: Binding<String>, isEditing: Binding<Bool>, placeholder: String? = nil, textAlignment: TextAlignment = .left, placeholderAlignment: Alignment = .topLeading, placeholderVerticalPadding: CGFloat = 8, textColor: UIColor = .label, placeholderColor: Color = .gray, backgroundColor: UIColor = .clear, contentType: ContentType? = nil, autocorrection: Autocorrection = .default, autocapitalization: Autocapitalization = .sentences, isSecure: Bool = false, isEditable: Bool = true, isSelectable: Bool = true, isScrollingEnabled: Bool = true, isUserInteractionEnabled: Bool = true, contentSizeDidChange: ((CGSize) -> Void)? = nil) {
        
        _text = text
        _isEditing = isEditing
        
        self.placeholder = placeholder
        self.textAlignment = textAlignment
        self.placeholderAlignment = placeholderAlignment
        self.placeholderHorizontalPadding = TextView.placeholderPadding
        self.placeholderVerticalPadding = placeholderVerticalPadding
        self.textColor = textColor
        self.placeholderColor = placeholderColor
        self.backgroundColor = backgroundColor
        self.contentType = contentType
        self.autocorrection = autocorrection
        self.autocapitalization = autocapitalization
        self.isSecure = isSecure
        self.isEditable = isEditable
        self.isSelectable = isSelectable
        self.isScrollingEnabled = isScrollingEnabled
        self.isUserInteractionEnabled = isUserInteractionEnabled
        self.contentSizeDidChange = contentSizeDidChange
    }
    
    private var _placeholder: String? {
        text.isEmpty ? placeholder : nil
    }
    
    private var textViewRepresentable: TextViewRepresentable {
        TextViewRepresentable(
            text: $text,
            isEditing: $isEditing,
            textAlignment: textAlignment,
            textColor: textColor,
            backgroundColor: backgroundColor,
            contentType: contentType,
            autocorrection: autocorrection,
            autocapitalization: autocapitalization,
            isSecure: isSecure,
            isEditable: isEditable,
            isSelectable: isSelectable,
            isScrollingEnabled: isScrollingEnabled,
            isUserInteractionEnabled: isUserInteractionEnabled,
            contentSizeDidChange: contentSizeDidChange
        )
    }
    
    public var body: some View {
        GeometryReader { geometry in
            ZStack {
                _placeholder.map { placeholder in
                    VStack {
                        Text(placeholder)
                            .font(.body)
                            .foregroundColor(placeholderColor)
                            .allowsHitTesting(false)
                            .padding(.horizontal, placeholderHorizontalPadding)
                            .padding(.top, placeholderVerticalPadding)
                        
                        Spacer()
                    }
                    .frame(width: geometry.size.width, height: geometry.size.height, alignment: placeholderAlignment)
                    .opacity(text.isEmpty ? 1 : 0)
                }
                textViewRepresentable
                    .accessibility(identifier: "TextView")
            }
        }
    }
    
}

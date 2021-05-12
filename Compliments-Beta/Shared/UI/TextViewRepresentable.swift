//   ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣴⣿⣿⣄⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
//   ⠀⠀⠀⠀⣿⣿⣷⣶⣶⣿⣿⣿⣿⣿⣿⣶⣶⣶⣿⣿⠀⠀⠀⠀
//   ⠀⠀⠀⠀⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⠀⠀⠀⠀
//   ⠀⠀⣀⣶⣿⣿⣿⣿⣿⣿⠟⠛⠛⠻⣿⣿⣿⣿⣿⣿⣦⣀⠀⠀
//   ⣾⣿⣿⣿⣿⣿⣿⣿⡟⠀⠀⠀⠀⠀⠀⢻⣿⣿⣿⣿⣿⣿⣿⡷
//   ⠀⠙⣿⣿⣿⡟⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠉⣿⣿⣿⣿⠋⠀
//   ⠀⠀⣼⣿⣿⣷⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣿⣿⣿⡆⠀⠀
//   ⠀⢠⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡀⠀
//   ⠀⠈⠉⠛⠛⠿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⠿⠛⠛⠉⠁⠀
//   ⠀⠀⠀⠀⠀⠀⠙⣿⣿⣿⣿⡿⣿⣿⣿⣿⣿⠁⠀⠀⠀⠀⠀⠀
//   ⠀⠀⠀⠀⠀⠀⠀⠙⠛⠉⠀⠀⠀⠀⠉⠛⠋

import SwiftUI

struct TextViewRepresentable: UIViewRepresentable {

    // MARK: - Typealiases
    
    public typealias TextAlignment = NSTextAlignment
    public typealias ContentType = UITextContentType
    public typealias Autocorrection = UITextAutocorrectionType
    public typealias Autocapitalization = UITextAutocapitalizationType
    
    
    // MARK: - Bindings
    
    @Binding private var text: String
    @Binding private var isEditing: Bool
    
    
    // MARK: - Properties
    
    private let textAlignment: TextAlignment
    private let textColor: UIColor
    private let backgroundColor: UIColor
    private let contentType: ContentType?
    private let autocorrection: Autocorrection
    private let autocapitalization: Autocapitalization
    private let isSecure: Bool
    private let isEditable: Bool
    private let isSelectable: Bool
    private let isScrollingEnabled: Bool
    private let isUserInteractionEnabled: Bool
    private let keyboardDismissMode: UIScrollView.KeyboardDismissMode
    private var contentSizeDidChange: ((CGSize) -> Void)?
    
    
    // MARK: - Init
    
    public init(text: Binding<String>, isEditing: Binding<Bool>, textAlignment: TextAlignment, textColor: UIColor, backgroundColor: UIColor, contentType: ContentType?, autocorrection: Autocorrection, autocapitalization: Autocapitalization, isSecure: Bool, isEditable: Bool, isSelectable: Bool, isScrollingEnabled: Bool, isUserInteractionEnabled: Bool, keyboardDismissMode: UIScrollView.KeyboardDismissMode = .none, contentSizeDidChange: ((CGSize) -> Void)? = nil) {
        
        _text = text
        _isEditing = isEditing
        
        self.textAlignment = textAlignment
        self.textColor = textColor
        self.backgroundColor = backgroundColor
        self.contentType = contentType
        self.autocorrection = autocorrection
        self.autocapitalization = autocapitalization
        self.isSecure = isSecure
        self.isEditable = isEditable
        self.isSelectable = isSelectable
        self.isScrollingEnabled = isScrollingEnabled
        self.isUserInteractionEnabled = isUserInteractionEnabled
        self.keyboardDismissMode = keyboardDismissMode
        self.contentSizeDidChange = contentSizeDidChange
    }
    
    
    // MARK: - Functions
    

    public func makeCoordinator() -> TextViewRepresentable.Coordinator {
        Coordinator(self, contentSizeDidChange: contentSizeDidChange)
    }
    
    public func makeUIView(context: Context) -> UITextView {
        let textView = UITextView()
        textView.delegate = context.coordinator
        textView.textAlignment = textAlignment
        textView.textColor = textColor
        textView.backgroundColor = backgroundColor
        textView.textContentType = contentType
        textView.autocorrectionType = autocorrection
        textView.autocapitalizationType = autocapitalization
        textView.isSecureTextEntry = isSecure
        textView.isEditable = isEditable
        textView.dataDetectorTypes = .all
        textView.isSelectable = isSelectable
        textView.isScrollEnabled = isScrollingEnabled
        textView.isUserInteractionEnabled = isUserInteractionEnabled
        textView.keyboardDismissMode = keyboardDismissMode
        textView.font = .preferredFont(forTextStyle: .body)
        return textView
    }
    
    public func updateUIView(_ textView: UITextView, context: Context) {
        context.coordinator.listenToChanges = false
        if isEditing != textView.isFirstResponder {
            if isEditing {
                textView.becomeFirstResponder() // this calls the delegate methods, which update the binding, which calls this method... infinitum. Hence the `listenToChanges` variable.
            } else {
                textView.resignFirstResponder() // this calls the delegate methods, which update the binding, which calls this method... infinitum. Hence the `listenToChanges` variable.
            }
        }
        textView.text = text
        context.coordinator.listenToChanges = true
        contentSizeDidChange?(textView.contentSize)
    }

    
    // MARK: Coordinator: UIKit -> SwiftUI
    
    class Coordinator: NSObject, UITextViewDelegate {
        
        private let parent: TextViewRepresentable
        private var contentSizeDidChange: ((CGSize) -> Void)?
        var listenToChanges: Bool = false // A Boolean to make sure we don't update Bindings when SwiftUI is updating UIKit (i.e. during the `updateUIView` execution)

        
        public init(_ parent: TextViewRepresentable, contentSizeDidChange: ((CGSize) -> Void)? = nil) {
            self.parent = parent
            self.contentSizeDidChange = contentSizeDidChange
        }
        
        private func setIsEditing(to value: Bool) {
            guard listenToChanges else { return }
            self.parent.isEditing = value
        }
        
        public func textViewDidChange(_ textView: UITextView) {
            guard listenToChanges else { return }
            parent.text = textView.text
            contentSizeDidChange?(textView.contentSize)
        }
        
        public func textViewDidBeginEditing(_: UITextView) {
            guard listenToChanges else { return }
            setIsEditing(to: true)
        }
        
        public func textViewDidEndEditing(_: UITextView) {
            guard listenToChanges else { return }
            setIsEditing(to: false)
        }
    }

}

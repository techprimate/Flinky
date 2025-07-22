import SFSafeSymbols
enum ListSymbolDocumentsReadingWriting {
    case bookmark
    case book
    case bookClosed
    case booksVertical
    case newspaper
    case folder
    case textDocument
    case document
    case giftCard
    case clipboard
    case paperPlane
    case present
    case birthdayCake
    case graduationCap
    case backpack
    case pen
    case pencil
    case pencilOutline
    case pencilScribble
    case pencilRuler
    case paper
    case creditcard
    case money

    var sfsymbol: SFSymbol {
        switch self {
        case .bookmark:
            return .bookmarkFill
        case .book:
            return .bookFill
        case .bookClosed:
            return .bookClosedFill
        case .booksVertical:
            return .booksVerticalFill
        case .newspaper:
            return .newspaperFill
        case .folder:
            return .folderFill
        case .textDocument:
            return .textDocumentFill
        case .document:
            return .documentFill
        case .giftCard:
            return .giftcardFill
        case .clipboard:
            return .listBulletClipboardFill
        case .paperPlane:
            return .paperplaneFill
        case .present:
            return .giftFill
        case .birthdayCake:
            return .birthdayCakeFill
        case .graduationCap:
            return .graduationcapFill
        case .backpack:
            return .backpackFill
        case .pen:
            return .pencilAndRulerFill
        case .pencil:
            return .pencil
        case .pencilOutline:
            return .pencilAndOutline
        case .pencilScribble:
            return .pencilAndScribble
        case .pencilRuler:
            return .pencilAndRulerFill
        case .paper:
            return .documentFill
        case .creditcard:
            return .creditcardFill
        case .money:
            return .banknoteFill
        }
    }
}

extension ListSymbolDocumentsReadingWriting: RawRepresentable {
    init?(rawValue: String) {
        switch rawValue {
        case "bookmark":
            self = .bookmark
        case "book":
            self = .book
        case "book-closed":
            self = .bookClosed
        case "books-vertical":
            self = .booksVertical
        case "newspaper":
            self = .newspaper
        case "folder":
            self = .folder
        case "text-document":
            self = .textDocument
        case "document":
            self = .document
        case "gift-card":
            self = .giftCard
        case "clipboard":
            self = .clipboard
        case "paper-plane":
            self = .paperPlane
        case "present":
            self = .present
        case "birthday-cake":
            self = .birthdayCake
        case "graduation-cap":
            self = .graduationCap
        case "backpack":
            self = .backpack
        case "pen":
            self = .pen
        case "pencil":
            self = .pencil
        case "pencil-outline":
            self = .pencilOutline
        case "pencil-scribble":
            self = .pencilScribble
        case "pencil-ruler":
            self = .pencilRuler
        case "paper":
            self = .paper
        case "creditcard":
            self = .creditcard
        case "money":
            self = .money
        default:
            return nil
        }
    }

    var rawValue: String {
        switch self {
        case .bookmark:
            return "bookmark"
        case .book:
            return "book"
        case .bookClosed:
            return "book-closed"
        case .booksVertical:
            return "books-vertical"
        case .newspaper:
            return "newspaper"
        case .folder:
            return "folder"
        case .textDocument:
            return "text-document"
        case .document:
            return "document"
        case .giftCard:
            return "gift-card"
        case .clipboard:
            return "clipboard"
        case .paperPlane:
            return "paper-plane"
        case .present:
            return "present"    
        case .birthdayCake:
            return "birthday-cake"
        case .graduationCap:
            return "graduation-cap"
        case .backpack:
            return "backpack"
        case .pen:
            return "pen"
        case .pencil:
            return "pencil"
        case .pencilOutline:
            return "pencil-outline"
        case .pencilScribble:
            return "pencil-scribble"
        case .pencilRuler:
            return "pencil-ruler"
        case .paper:
            return "paper"
        case .creditcard:
            return "creditcard"
        case .money:    
            return "money"
        }
    }
}   

extension ListSymbolDocumentsReadingWriting: CaseIterable {
    static var allCases: [ListSymbolDocumentsReadingWriting] {
        return [
            .bookmark, .book, .bookClosed, .booksVertical, .newspaper, .folder, .textDocument, .document, .giftCard, .clipboard, .paperPlane, .present, .birthdayCake, .graduationCap, .backpack, .pen, .pencil, .pencilOutline, .pencilScribble, .pencilRuler, .paper, .creditcard, .money,
        ]
    }
}
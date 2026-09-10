import SwiftUI

enum Hill {
    static let turf = Color(red: 0.435, green: 0.502, blue: 0.337)
    static let turfDark = Color(red: 0.298, green: 0.369, blue: 0.247)
    static let turfDeep = Color(red: 0.196, green: 0.251, blue: 0.176)
    static let turfPale = Color(red: 0.596, green: 0.639, blue: 0.443)

    static let canvas = Color(red: 0.898, green: 0.867, blue: 0.792)
    static let canvasWarm = Color(red: 0.937, green: 0.910, blue: 0.843)
    static let canvasSunk = Color(red: 0.827, green: 0.796, blue: 0.718)

    static let ink = Color(red: 0.106, green: 0.110, blue: 0.102)
    static let inkSoft = Color(red: 0.239, green: 0.247, blue: 0.231)
    static let inkPale = Color(red: 0.427, green: 0.435, blue: 0.412)

    static let stone = Color(red: 0.612, green: 0.600, blue: 0.569)
    static let stoneDark = Color(red: 0.392, green: 0.384, blue: 0.365)
    static let slate = Color(red: 0.302, green: 0.333, blue: 0.357)
    static let slateDeep = Color(red: 0.161, green: 0.184, blue: 0.204)
    static let bracken = Color(red: 0.647, green: 0.478, blue: 0.263)
    static let heather = Color(red: 0.529, green: 0.404, blue: 0.478)
    static let fleece = Color(red: 0.886, green: 0.875, blue: 0.839)
    static let fleeceDark = Color(red: 0.694, green: 0.678, blue: 0.639)
    static let collie = Color(red: 0.145, green: 0.141, blue: 0.133)
    static let sepia = Color(red: 0.353, green: 0.271, blue: 0.184)
    static let oat = Color(red: 0.847, green: 0.792, blue: 0.663)
    static let brass = Color(red: 0.769, green: 0.612, blue: 0.294)
    static let rosetteRed = Color(red: 0.667, green: 0.184, blue: 0.176)
    static let rosetteBlue = Color(red: 0.220, green: 0.373, blue: 0.529)
    static let sky = Color(red: 0.729, green: 0.784, blue: 0.816)
    static let moss = Color(red: 0.376, green: 0.478, blue: 0.325)

    static let hairline = Color.black.opacity(0.16)
    static let hairlineLight = Color.white.opacity(0.12)
}

enum Slate {
    static func title(_ size: CGFloat) -> Font { .custom("Georgia-Bold", size: size) }
    static func body(_ size: CGFloat) -> Font { .custom("Georgia", size: size) }
    static func italic(_ size: CGFloat) -> Font { .custom("Georgia-Italic", size: size) }
    static func figure(_ size: CGFloat) -> Font { .system(size: size, weight: .semibold, design: .monospaced) }
}

enum Pitch {
    static var isPad: Bool { UIScreen.main.bounds.width >= 700 }
    static var contentWidth: CGFloat { isPad ? 660 : UIScreen.main.bounds.width }
    static var gutter: CGFloat { isPad ? 32 : 18 }
    static var screenW: CGFloat { UIScreen.main.bounds.width }
    static var screenH: CGFloat { UIScreen.main.bounds.height }
}

func hillPlate(_ name: String) -> UIImage? {
    if let path = Bundle.main.path(forResource: name, ofType: "jpg", inDirectory: "Art"),
       let img = UIImage(contentsOfFile: path) {
        return img
    }
    if let path = Bundle.main.path(forResource: name, ofType: "jpg") {
        return UIImage(contentsOfFile: path)
    }
    return nil
}

struct HillLayer: View {
    let name: String
    var fallback: Color
    var opacity: Double = 1.0

    var body: some View {
        GeometryReader { geo in
            ZStack {
                fallback
                if let ui = hillPlate(name) {
                    Color.clear
                        .overlay(Image(uiImage: ui).resizable().aspectRatio(contentMode: .fill))
                        .frame(width: geo.size.width, height: geo.size.height)
                        .clipped()
                        .opacity(opacity)
                }
            }
        }
    }
}

extension View {
    func hillPage() -> some View {
        self.background(HillLayer(name: "bg_turf", fallback: Hill.turfDeep, opacity: 0.55)
            .ignoresSafeArea())
    }

    func centreColumn() -> some View {
        HStack(spacing: 0) {
            Spacer(minLength: 0)
            self.frame(maxWidth: Pitch.contentWidth)
            Spacer(minLength: 0)
        }
    }
}

enum Nudge {
    static func light() { UIImpactFeedbackGenerator(style: .light).impactOccurred() }
    static func firm() { UIImpactFeedbackGenerator(style: .medium).impactOccurred() }
    static func heavy() { UIImpactFeedbackGenerator(style: .heavy).impactOccurred() }
    static func soft() { UIImpactFeedbackGenerator(style: .soft).impactOccurred() }
}

struct Roll {
    var s: UInt64
    init(_ seed: UInt64) { s = seed == 0 ? 0x9E3779B97F4A7C15 : seed }
    mutating func next() -> UInt64 { s ^= s << 13; s ^= s >> 7; s ^= s << 17; return s }
    mutating func unit() -> Double { Double(next() % 1_000_000) / 1_000_000.0 }
    mutating func range(_ a: Double, _ b: Double) -> Double { a + unit() * (b - a) }
    mutating func index(_ n: Int) -> Int { n <= 0 ? 0 : Int(next() % UInt64(n)) }
    mutating func chance(_ p: Double) -> Bool { unit() < p }
    mutating func signed() -> Double { unit() * 2 - 1 }
}

func hillSeed(_ text: String) -> UInt64 {
    var h: UInt64 = 14695981039346656037
    for b in text.utf8 { h = (h ^ UInt64(b)) &* 1099511628211 }
    return h
}

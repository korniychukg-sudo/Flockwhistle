import SwiftUI

struct CanvasCard<Content: View>: View {
    var padding: CGFloat = 14
    var tint: Color = Hill.canvas
    @ViewBuilder var content: Content

    var body: some View {
        content
            .padding(padding)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(
                ZStack {
                    RoundedRectangle(cornerRadius: 9, style: .continuous).fill(tint)
                    HillLayer(name: "bg_card", fallback: tint, opacity: 0.5)
                        .clipShape(RoundedRectangle(cornerRadius: 9, style: .continuous))
                }
                .overlay(RoundedRectangle(cornerRadius: 9, style: .continuous)
                    .stroke(Hill.hairline, lineWidth: 1))
                .shadow(color: Color.black.opacity(0.32), radius: 7, x: 0, y: 4)
            )
    }
}

struct SlateCard<Content: View>: View {
    var padding: CGFloat = 14
    @ViewBuilder var content: Content

    var body: some View {
        content
            .padding(padding)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(
                RoundedRectangle(cornerRadius: 9, style: .continuous)
                    .fill(Hill.slate)
                    .overlay(RoundedRectangle(cornerRadius: 9, style: .continuous)
                        .stroke(Hill.hairlineLight, lineWidth: 1))
                    .shadow(color: Color.black.opacity(0.34), radius: 7, x: 0, y: 4)
            )
    }
}

struct FieldHead: View {
    let title: String
    var note: String? = nil
    var tint: Color = Hill.bracken
    var body: some View {
        VStack(alignment: .leading, spacing: 2) {
            Text(title.uppercased()).font(Slate.title(11)).tracking(2.6).foregroundColor(tint)
            if let note = note {
                Text(note).font(Slate.italic(13)).foregroundColor(Hill.inkPale)
            }
        }
    }
}

struct CountChip: View {
    let value: String
    let label: String
    var tint: Color = Hill.sepia
    var onCanvas: Bool = true
    var body: some View {
        VStack(spacing: 1) {
            Text(value).font(Slate.figure(15)).foregroundColor(tint)
            Text(label.uppercased()).font(Slate.body(9)).tracking(1.2)
                .foregroundColor(onCanvas ? Hill.inkPale : Hill.canvas.opacity(0.7))
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 7)
        .background(
            RoundedRectangle(cornerRadius: 6, style: .continuous)
                .fill(onCanvas ? Hill.canvasSunk.opacity(0.7) : Color.black.opacity(0.22))
        )
    }
}

struct GateButton: View {
    let title: String
    var subtitle: String? = nil
    var tint: Color = Hill.bracken
    var enabled: Bool = true
    let action: () -> Void

    var body: some View {
        Button(action: { if enabled { Nudge.firm(); action() } }) {
            VStack(spacing: 2) {
                Text(title).font(Slate.title(17)).foregroundColor(Hill.canvas)
                if let subtitle = subtitle {
                    Text(subtitle).font(Slate.italic(12)).foregroundColor(Hill.canvas.opacity(0.85))
                        .multilineTextAlignment(.center)
                }
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 13)
            .background(RoundedRectangle(cornerRadius: 8, style: .continuous)
                .fill(enabled ? tint : Hill.stone.opacity(0.6)))
        }
        .buttonStyle(.plain)
        .opacity(enabled ? 1 : 0.72)
    }
}

struct SmallGateButton: View {
    let title: String
    var tint: Color = Hill.inkSoft
    let action: () -> Void
    var body: some View {
        Button(action: { Nudge.light(); action() }) {
            Text(title).font(Slate.title(14)).foregroundColor(tint)
                .padding(.horizontal, 14).padding(.vertical, 9)
                .background(RoundedRectangle(cornerRadius: 7, style: .continuous)
                    .fill(Hill.canvasSunk.opacity(0.75)))
        }
        .buttonStyle(.plain)
    }
}

struct RiseIn<Content: View>: View {
    let index: Int
    @ViewBuilder var content: Content
    @State private var shown = false

    var body: some View {
        content
            .opacity(shown ? 1 : 0)
            .offset(y: shown ? 0 : 16)
            .onAppear {
                withAnimation(.easeOut(duration: 0.42).delay(Double(index) * 0.06)) { shown = true }
            }
    }
}

struct CallBanner: View {
    let title: String
    let detail: String
    var tint: Color = Hill.bracken
    var body: some View {
        HStack(alignment: .top, spacing: 10) {
            RoundedRectangle(cornerRadius: 2).fill(tint).frame(width: 3)
            VStack(alignment: .leading, spacing: 3) {
                Text(title).font(Slate.title(14)).foregroundColor(Hill.ink)
                Text(detail).font(Slate.body(13)).foregroundColor(Hill.inkSoft)
                    .fixedSize(horizontal: false, vertical: true)
            }
        }
        .padding(11)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(RoundedRectangle(cornerRadius: 7, style: .continuous).fill(tint.opacity(0.12)))
    }
}

struct FieldPlate: View {
    let name: String
    var height: CGFloat = 200
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 7, style: .continuous).fill(Hill.canvasSunk)
            if let ui = hillPlate(name) {
                GeometryReader { geo in
                    Image(uiImage: ui)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: geo.size.width,
                               height: geo.size.width * ui.size.height / max(1, ui.size.width),
                               alignment: .top)
                        .clipped()
                }
                .clipped()
            }
        }
        .frame(height: height)
        .clipShape(RoundedRectangle(cornerRadius: 7, style: .continuous))
        .overlay(RoundedRectangle(cornerRadius: 7, style: .continuous)
            .stroke(Hill.hairline, lineWidth: 1))
    }
}

struct PlateSheetView: View {
    let name: String
    let title: String
    let onClose: () -> Void
    @State private var scale: CGFloat = 1

    var body: some View {
        ZStack {
            Hill.turfDeep.ignoresSafeArea()
            VStack(spacing: 0) {
                HStack {
                    Text(title).font(Slate.title(16)).foregroundColor(Hill.canvas)
                    Spacer()
                    Button(action: { Nudge.light(); onClose() }) {
                        ShutMark(size: 18, color: Hill.canvas)
                            .padding(10).background(Circle().fill(Color.white.opacity(0.14)))
                    }
                    .buttonStyle(.plain)
                }
                .padding(.horizontal, 16).padding(.vertical, 12)
                ScrollView([.vertical, .horizontal], showsIndicators: false) {
                    if let ui = hillPlate(name) {
                        Image(uiImage: ui)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: Pitch.screenW * scale)
                    } else {
                        Text("Plate unavailable").font(Slate.italic(15))
                            .foregroundColor(Hill.canvas.opacity(0.7)).padding(40)
                    }
                }
                HStack(spacing: 12) {
                    SmallGateButton(title: "Fit", tint: Hill.canvas) { scale = 1 }
                    SmallGateButton(title: "Closer", tint: Hill.canvas) {
                        scale = min(2.8, scale + 0.4)
                    }
                }
                .padding(.bottom, 14)
            }
        }
    }
}

struct Rosette: View {
    let grade: String
    var tint: Color
    var body: some View {
        ZStack {
            RosetteGlyph(size: 34, color: tint)
            Text(grade).font(Slate.title(12)).foregroundColor(Hill.canvas)
                .offset(y: -3)
        }
        .frame(width: 34, height: 34)
    }
}

struct PointRow: View {
    let label: String
    let value: Double
    let maxPoints: Int
    var tint: Color
    var body: some View {
        HStack(spacing: 10) {
            Text(label).font(Slate.body(13)).foregroundColor(Hill.inkSoft)
                .frame(width: 92, alignment: .leading)
            GeometryReader { geo in
                ZStack(alignment: .leading) {
                    Capsule().fill(Hill.canvasSunk)
                    Capsule().fill(tint).frame(width: max(0, min(1, value)) * geo.size.width)
                }
            }
            .frame(height: 8)
            Text("\(Int((value * Double(maxPoints)).rounded()))/\(maxPoints)")
                .font(Slate.figure(11)).foregroundColor(Hill.inkPale)
                .frame(width: 46, alignment: .trailing)
        }
    }
}

struct WhistleRail: View {
    let shape: String
    var tint: Color = Hill.bracken
    var height: CGFloat = 26

    var body: some View {
        Canvas { ctx, size in
            var path = Path()
            let pts = whistleContour(shape)
            for (i, p) in pts.enumerated() {
                let point = CGPoint(x: p.x * size.width, y: p.y * size.height)
                if i == 0 { path.move(to: point) } else { path.addLine(to: point) }
            }
            ctx.stroke(path, with: .color(tint),
                       style: StrokeStyle(lineWidth: 2.4, lineCap: .round, lineJoin: .round))
        }
        .frame(height: height)
    }
}

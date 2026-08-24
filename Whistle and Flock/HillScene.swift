import SwiftUI

struct HillHue {
    var sky: Color
    var skyLow: Color
    var fell: Color
    var grass: Color
    var mist: Double
    var warm: Double
    var label: String
}

enum HillLight {
    static let keys: [(Int, HillHue)] = [
        (0, HillHue(sky: Color(red: 0.086, green: 0.106, blue: 0.137),
                    skyLow: Color(red: 0.129, green: 0.153, blue: 0.184),
                    fell: Color(red: 0.129, green: 0.153, blue: 0.137),
                    grass: Color(red: 0.145, green: 0.180, blue: 0.145),
                    mist: 0.10, warm: 0, label: "Dark, and the flock is settled")),
        (5, HillHue(sky: Color(red: 0.310, green: 0.325, blue: 0.376),
                    skyLow: Color(red: 0.639, green: 0.545, blue: 0.478),
                    fell: Color(red: 0.286, green: 0.310, blue: 0.286),
                    grass: Color(red: 0.325, green: 0.384, blue: 0.290),
                    mist: 0.55, warm: 0.35, label: "First light, mist in the bottoms")),
        (8, HillHue(sky: Color(red: 0.639, green: 0.702, blue: 0.741),
                    skyLow: Color(red: 0.831, green: 0.851, blue: 0.855),
                    fell: Color(red: 0.404, green: 0.435, blue: 0.376),
                    grass: Color(red: 0.435, green: 0.502, blue: 0.337),
                    mist: 0.28, warm: 0.15, label: "Morning, and the gather starts")),
        (13, HillHue(sky: Color(red: 0.678, green: 0.749, blue: 0.792),
                     skyLow: Color(red: 0.867, green: 0.886, blue: 0.878),
                     fell: Color(red: 0.451, green: 0.475, blue: 0.404),
                     grass: Color(red: 0.478, green: 0.545, blue: 0.365),
                     mist: 0.06, warm: 0.10, label: "Midday on the fell")),
        (18, HillHue(sky: Color(red: 0.639, green: 0.639, blue: 0.667),
                     skyLow: Color(red: 0.867, green: 0.741, blue: 0.588),
                     fell: Color(red: 0.396, green: 0.384, blue: 0.333),
                     grass: Color(red: 0.463, green: 0.502, blue: 0.325),
                     mist: 0.12, warm: 0.55, label: "Evening light along the wall")),
        (21, HillHue(sky: Color(red: 0.239, green: 0.251, blue: 0.302),
                     skyLow: Color(red: 0.463, green: 0.373, blue: 0.361),
                     fell: Color(red: 0.216, green: 0.235, blue: 0.220),
                     grass: Color(red: 0.251, green: 0.298, blue: 0.220),
                     mist: 0.20, warm: 0.25, label: "Dusk, and the dogs are fed")),
        (24, HillHue(sky: Color(red: 0.086, green: 0.106, blue: 0.137),
                     skyLow: Color(red: 0.129, green: 0.153, blue: 0.184),
                     fell: Color(red: 0.129, green: 0.153, blue: 0.137),
                     grass: Color(red: 0.145, green: 0.180, blue: 0.145),
                     mist: 0.10, warm: 0, label: "Dark, and the flock is settled")),
    ]

    static func mix(_ a: Color, _ b: Color, _ t: Double) -> Color {
        let ua = UIColor(a), ub = UIColor(b)
        var r1: CGFloat = 0, g1: CGFloat = 0, b1: CGFloat = 0, a1: CGFloat = 0
        var r2: CGFloat = 0, g2: CGFloat = 0, b2: CGFloat = 0, a2: CGFloat = 0
        ua.getRed(&r1, green: &g1, blue: &b1, alpha: &a1)
        ub.getRed(&r2, green: &g2, blue: &b2, alpha: &a2)
        let f = CGFloat(max(0, min(1, t)))
        return Color(red: Double(r1 + (r2 - r1) * f), green: Double(g1 + (g2 - g1) * f),
                     blue: Double(b1 + (b2 - b1) * f))
    }

    static func hue(for hour: Double) -> HillHue {
        var lower = keys[0], upper = keys[keys.count - 1]
        for i in 0..<(keys.count - 1) {
            if hour >= Double(keys[i].0) && hour <= Double(keys[i + 1].0) {
                lower = keys[i]; upper = keys[i + 1]
                break
            }
        }
        let span = max(0.001, Double(upper.0 - lower.0))
        let t = max(0, min(1, (hour - Double(lower.0)) / span))
        return HillHue(sky: mix(lower.1.sky, upper.1.sky, t),
                       skyLow: mix(lower.1.skyLow, upper.1.skyLow, t),
                       fell: mix(lower.1.fell, upper.1.fell, t),
                       grass: mix(lower.1.grass, upper.1.grass, t),
                       mist: lower.1.mist + (upper.1.mist - lower.1.mist) * t,
                       warm: lower.1.warm + (upper.1.warm - lower.1.warm) * t,
                       label: t < 0.5 ? lower.1.label : upper.1.label)
    }

    static var nowHour: Double {
        let c = Calendar.current.dateComponents([.hour, .minute], from: Date())
        return Double(c.hour ?? 12) + Double(c.minute ?? 0) / 60
    }
}

struct HillScene: View {
    let field: TrialField
    var height: CGFloat = 220

    var body: some View {
        let hue = HillLight.hue(for: HillLight.nowHour)
        TimelineView(.animation(minimumInterval: 1.0 / 12.0)) { timeline in
            Canvas { ctx, size in
                draw(&ctx, size, hue: hue, time: timeline.date.timeIntervalSinceReferenceDate)
            }
        }
        .frame(height: height)
        .clipShape(RoundedRectangle(cornerRadius: 11, style: .continuous))
        .overlay(RoundedRectangle(cornerRadius: 11, style: .continuous)
            .stroke(Hill.hairlineLight, lineWidth: 1))
    }

    private func draw(_ ctx: inout GraphicsContext, _ size: CGSize, hue: HillHue, time: Double) {
        let w = size.width, h = size.height
        var sky = Path()
        sky.addRect(CGRect(origin: .zero, size: size))
        ctx.fill(sky, with: .linearGradient(Gradient(colors: [hue.sky, hue.skyLow]),
                                            startPoint: .zero, endPoint: CGPoint(x: 0, y: h * 0.5)))

        if hue.warm > 0.2 {
            var glow = Path()
            glow.addEllipse(in: CGRect(x: w * 0.66, y: h * 0.10, width: w * 0.5, height: h * 0.5))
            ctx.fill(glow, with: .radialGradient(
                Gradient(colors: [Color(red: 0.98, green: 0.86, blue: 0.66).opacity(0.34 * hue.warm),
                                  Color.clear]),
                center: CGPoint(x: w * 0.86, y: h * 0.28), startRadius: 0, endRadius: w * 0.3))
        }

        for layer in 0..<3 {
            var ridge = Path()
            let base = h * (0.34 + CGFloat(layer) * 0.10)
            ridge.move(to: CGPoint(x: 0, y: h))
            var x = 0.0
            while x <= Double(w) {
                let y = base - CGFloat(sin(x / (110 + Double(layer) * 60) + Double(layer) * 1.4)
                                       * (26 - Double(layer) * 6))
                ridge.addLine(to: CGPoint(x: x, y: y))
                x += 6
            }
            ridge.addLine(to: CGPoint(x: w, y: h))
            ridge.closeSubpath()
            ctx.fill(ridge, with: .color(HillLight.mix(hue.fell, hue.grass,
                                                       Double(layer) * 0.35).opacity(0.95)))
        }

        var meadow = Path()
        meadow.addRect(CGRect(x: 0, y: h * 0.60, width: w, height: h * 0.40))
        ctx.fill(meadow, with: .linearGradient(
            Gradient(colors: [hue.grass, HillLight.mix(hue.grass, Hill.turfDeep, 0.5)]),
            startPoint: CGPoint(x: 0, y: h * 0.60), endPoint: CGPoint(x: 0, y: h)))

        var rng = Roll(hillSeed(field.id))
        for _ in 0..<200 {
            let x = CGFloat(rng.unit()) * w
            let y = h * 0.58 + CGFloat(rng.unit()) * h * 0.42
            let scale = (y - h * 0.58) / (h * 0.42)
            var blade = Path()
            blade.move(to: CGPoint(x: x, y: y))
            blade.addLine(to: CGPoint(x: x + CGFloat(rng.range(-3, 3)), y: y - 3 - scale * 8))
            ctx.stroke(blade, with: .color((rng.chance(0.5) ? Hill.turfPale : Hill.turfDeep)
                                            .opacity(0.14 + Double(scale) * 0.2)),
                       lineWidth: 0.7 + scale)
        }

        var wall = Path()
        wall.move(to: CGPoint(x: -10, y: h * 0.74))
        wall.addLine(to: CGPoint(x: w * 0.62, y: h * 0.62))
        ctx.stroke(wall, with: .color(Hill.stone.opacity(0.9)), lineWidth: 9)
        ctx.stroke(wall, with: .color(Hill.stoneDark.opacity(0.8)), lineWidth: 3)
        var stones = Roll(4409)
        var sx = -10.0
        while sx < Double(w) * 0.62 {
            let t = sx / (Double(w) * 0.62 + 10)
            let sy = Double(h) * (0.74 - t * 0.12)
            var stone = Path()
            stone.addRect(CGRect(x: sx, y: sy - 6, width: CGFloat(stones.range(6, 12)), height: 7))
            ctx.stroke(stone, with: .color(Hill.stoneDark.opacity(0.5)), lineWidth: 0.8)
            sx += stones.range(8, 15)
        }

        let drift = sin(time * 0.35) * 6
        for k in 0..<field.sheepCount {
            let base = CGPoint(x: w * CGFloat(0.34 + Double(k % 4) * 0.13),
                               y: h * CGFloat(0.80 + Double(k / 4) * 0.07))
            let x = base.x + CGFloat(drift * (k % 2 == 0 ? 1 : -0.6))
            var wool = Path()
            wool.addEllipse(in: CGRect(x: x - 12, y: base.y - 8, width: 24, height: 16))
            ctx.fill(wool, with: .color(Hill.fleece))
            ctx.stroke(wool, with: .color(Hill.inkSoft.opacity(0.7)), lineWidth: 1.4)
            var head = Path()
            head.addEllipse(in: CGRect(x: x + 8, y: base.y - 3, width: 9, height: 8))
            ctx.fill(head, with: .color(Hill.inkSoft))
            for leg in 0..<2 {
                var l = Path()
                l.move(to: CGPoint(x: x - 6 + CGFloat(leg) * 12, y: base.y + 6))
                l.addLine(to: CGPoint(x: x - 6 + CGFloat(leg) * 12, y: base.y + 13))
                ctx.stroke(l, with: .color(Hill.inkSoft), lineWidth: 2)
            }
        }

        let dogX = w * 0.16 + CGFloat(sin(time * 0.22) * 8)
        let dogY = h * 0.86
        var dog = Path()
        dog.addEllipse(in: CGRect(x: dogX - 16, y: dogY - 7, width: 32, height: 14))
        ctx.fill(dog, with: .color(Hill.collie))
        var ruff = Path()
        ruff.addEllipse(in: CGRect(x: dogX - 2, y: dogY - 9, width: 14, height: 12))
        ctx.fill(ruff, with: .color(Hill.fleece.opacity(0.9)))
        var dogHead = Path()
        dogHead.addEllipse(in: CGRect(x: dogX + 11, y: dogY - 16, width: 14, height: 12))
        ctx.fill(dogHead, with: .color(Hill.collie))
        var muzzle = Path()
        muzzle.addEllipse(in: CGRect(x: dogX + 21, y: dogY - 11, width: 9, height: 6))
        ctx.fill(muzzle, with: .color(Hill.collie))
        var blaze = Path()
        blaze.addEllipse(in: CGRect(x: dogX + 16, y: dogY - 15, width: 4, height: 9))
        ctx.fill(blaze, with: .color(Hill.fleece))
        var ear = Path()
        ear.move(to: CGPoint(x: dogX + 12, y: dogY - 14))
        ear.addLine(to: CGPoint(x: dogX + 11, y: dogY - 22))
        ear.addLine(to: CGPoint(x: dogX + 18, y: dogY - 16))
        ear.closeSubpath()
        ctx.fill(ear, with: .color(Hill.collie))
        for leg in 0..<2 {
            var l = Path()
            l.move(to: CGPoint(x: dogX - 8 + CGFloat(leg) * 16, y: dogY + 5))
            l.addLine(to: CGPoint(x: dogX - 9 + CGFloat(leg) * 16, y: dogY + 13))
            ctx.stroke(l, with: .color(Hill.collie), lineWidth: 3)
        }
        var tail = Path()
        tail.move(to: CGPoint(x: dogX - 16, y: dogY))
        tail.addQuadCurve(to: CGPoint(x: dogX - 30, y: dogY + 8),
                          control: CGPoint(x: dogX - 26, y: dogY - 6))
        ctx.stroke(tail, with: .color(Hill.collie), lineWidth: 4)

        if hue.mist > 0.1 {
            for k in 0..<4 {
                var band = Path()
                let y = h * CGFloat(0.52 + Double(k) * 0.07)
                band.addRect(CGRect(x: 0, y: y, width: w, height: h * 0.05))
                ctx.fill(band, with: .color(Color.white.opacity(hue.mist * 0.18)))
            }
        }
    }
}

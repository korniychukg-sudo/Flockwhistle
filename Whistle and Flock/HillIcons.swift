import SwiftUI

struct SheepGlyph: View {
    var size: CGFloat
    var color: Color
    var body: some View {
        Canvas { ctx, s in
            let w = s.width, h = s.height
            var wool = Path()
            wool.addEllipse(in: CGRect(x: w * 0.16, y: h * 0.30, width: w * 0.60, height: h * 0.40))
            ctx.stroke(wool, with: .color(color), lineWidth: max(1.2, w * 0.06))
            var head = Path()
            head.addEllipse(in: CGRect(x: w * 0.68, y: h * 0.30, width: w * 0.20, height: h * 0.18))
            ctx.fill(head, with: .color(color))
            for k in 0..<3 {
                var leg = Path()
                let lx = w * (0.28 + Double(k) * 0.18)
                leg.move(to: CGPoint(x: lx, y: h * 0.68))
                leg.addLine(to: CGPoint(x: lx, y: h * 0.88))
                ctx.stroke(leg, with: .color(color), lineWidth: max(1.0, w * 0.05))
            }
        }
        .frame(width: size, height: size)
    }
}

struct DogGlyph: View {
    var size: CGFloat
    var color: Color
    var body: some View {
        Canvas { ctx, s in
            let w = s.width, h = s.height
            var body = Path()
            body.move(to: CGPoint(x: w * 0.16, y: h * 0.56))
            body.addQuadCurve(to: CGPoint(x: w * 0.70, y: h * 0.52),
                              control: CGPoint(x: w * 0.44, y: h * 0.40))
            ctx.stroke(body, with: .color(color), lineWidth: max(1.4, w * 0.09))
            var head = Path()
            head.move(to: CGPoint(x: w * 0.70, y: h * 0.52))
            head.addLine(to: CGPoint(x: w * 0.90, y: h * 0.44))
            ctx.stroke(head, with: .color(color), lineWidth: max(1.2, w * 0.07))
            var ear = Path()
            ear.move(to: CGPoint(x: w * 0.74, y: h * 0.46))
            ear.addLine(to: CGPoint(x: w * 0.72, y: h * 0.32))
            ear.addLine(to: CGPoint(x: w * 0.82, y: h * 0.42))
            ctx.fill(ear, with: .color(color))
            for k in 0..<2 {
                var leg = Path()
                let lx = w * (0.28 + Double(k) * 0.30)
                leg.move(to: CGPoint(x: lx, y: h * 0.56))
                leg.addLine(to: CGPoint(x: lx - w * 0.02, y: h * 0.84))
                ctx.stroke(leg, with: .color(color), lineWidth: max(1.0, w * 0.05))
            }
            var tail = Path()
            tail.move(to: CGPoint(x: w * 0.16, y: h * 0.56))
            tail.addQuadCurve(to: CGPoint(x: w * 0.06, y: h * 0.74),
                              control: CGPoint(x: w * 0.04, y: h * 0.58))
            ctx.stroke(tail, with: .color(color), lineWidth: max(1.0, w * 0.05))
        }
        .frame(width: size, height: size)
    }
}

struct WhistleGlyph: View {
    var size: CGFloat
    var color: Color
    var body: some View {
        Canvas { ctx, s in
            let w = s.width, h = s.height
            var plate = Path()
            plate.move(to: CGPoint(x: w * 0.16, y: h * 0.34))
            plate.addLine(to: CGPoint(x: w * 0.80, y: h * 0.28))
            plate.addLine(to: CGPoint(x: w * 0.86, y: h * 0.56))
            plate.addLine(to: CGPoint(x: w * 0.20, y: h * 0.64))
            plate.closeSubpath()
            ctx.stroke(plate, with: .color(color), lineWidth: max(1.2, w * 0.06))
            var slot = Path()
            slot.addRect(CGRect(x: w * 0.34, y: h * 0.40, width: w * 0.34, height: h * 0.10))
            ctx.fill(slot, with: .color(color))
            var wave = Path()
            wave.move(to: CGPoint(x: w * 0.10, y: h * 0.80))
            wave.addQuadCurve(to: CGPoint(x: w * 0.50, y: h * 0.80),
                              control: CGPoint(x: w * 0.30, y: h * 0.66))
            wave.addQuadCurve(to: CGPoint(x: w * 0.90, y: h * 0.80),
                              control: CGPoint(x: w * 0.70, y: h * 0.94))
            ctx.stroke(wave, with: .color(color.opacity(0.75)), lineWidth: max(1.0, w * 0.05))
        }
        .frame(width: size, height: size)
    }
}

struct CrookGlyph: View {
    var size: CGFloat
    var color: Color
    var body: some View {
        Canvas { ctx, s in
            let w = s.width, h = s.height
            var shank = Path()
            shank.move(to: CGPoint(x: w * 0.36, y: h * 0.94))
            shank.addLine(to: CGPoint(x: w * 0.48, y: h * 0.36))
            ctx.stroke(shank, with: .color(color), lineWidth: max(1.4, w * 0.08))
            var head = Path()
            head.addArc(center: CGPoint(x: w * 0.60, y: h * 0.32), radius: w * 0.18,
                        startAngle: .degrees(150), endAngle: .degrees(400), clockwise: false)
            ctx.stroke(head, with: .color(color), lineWidth: max(1.4, w * 0.08))
        }
        .frame(width: size, height: size)
    }
}

struct RosetteGlyph: View {
    var size: CGFloat
    var color: Color
    var body: some View {
        Canvas { ctx, s in
            let w = s.width, h = s.height
            let cx = w * 0.5, cy = h * 0.40
            for k in 0..<10 {
                let a = Double(k) / 10 * 2 * Double.pi
                var petal = Path()
                petal.addEllipse(in: CGRect(x: cx + CGFloat(cos(a)) * w * 0.20 - w * 0.09,
                                            y: cy + CGFloat(sin(a)) * w * 0.20 - w * 0.06,
                                            width: w * 0.18, height: w * 0.12))
                ctx.stroke(petal, with: .color(color.opacity(0.8)), lineWidth: max(0.9, w * 0.035))
            }
            var centre = Path()
            centre.addEllipse(in: CGRect(x: cx - w * 0.11, y: cy - w * 0.11,
                                         width: w * 0.22, height: w * 0.22))
            ctx.fill(centre, with: .color(color))
            for k in 0..<2 {
                var tail = Path()
                tail.move(to: CGPoint(x: cx + CGFloat(k == 0 ? -0.06 : 0.06) * w, y: cy + w * 0.18))
                tail.addLine(to: CGPoint(x: cx + CGFloat(k == 0 ? -0.16 : 0.16) * w, y: h * 0.92))
                ctx.stroke(tail, with: .color(color), lineWidth: max(1.2, w * 0.07))
            }
        }
        .frame(width: size, height: size)
    }
}

struct GateGlyph: View {
    var size: CGFloat
    var color: Color
    var body: some View {
        Canvas { ctx, s in
            let w = s.width, h = s.height
            for side in 0..<2 {
                let px = w * (side == 0 ? 0.22 : 0.78)
                var post = Path()
                post.move(to: CGPoint(x: px, y: h * 0.26))
                post.addLine(to: CGPoint(x: px, y: h * 0.80))
                ctx.stroke(post, with: .color(color), lineWidth: max(1.3, w * 0.07))
                for k in 0..<2 {
                    var rail = Path()
                    let ry = h * (0.42 + Double(k) * 0.20)
                    rail.move(to: CGPoint(x: px, y: ry))
                    rail.addLine(to: CGPoint(x: px + CGFloat(side == 0 ? -0.14 : 0.14) * w, y: ry))
                    ctx.stroke(rail, with: .color(color.opacity(0.8)), lineWidth: max(1.0, w * 0.05))
                }
            }
        }
        .frame(width: size, height: size)
    }
}

struct MarkGlyph: View {
    var size: CGFloat
    var color: Color
    var facing: Double = 0
    var body: some View {
        Canvas { ctx, s in
            var p = Path()
            p.move(to: CGPoint(x: s.width * 0.36, y: s.height * 0.16))
            p.addLine(to: CGPoint(x: s.width * 0.72, y: s.height * 0.5))
            p.addLine(to: CGPoint(x: s.width * 0.36, y: s.height * 0.84))
            ctx.stroke(p, with: .color(color), style: StrokeStyle(lineWidth: max(1.4, s.width * 0.10),
                                                                  lineCap: .round, lineJoin: .round))
        }
        .frame(width: size, height: size)
        .rotationEffect(.radians(facing))
    }
}

struct ShutMark: View {
    var size: CGFloat
    var color: Color
    var body: some View {
        Canvas { ctx, s in
            var p = Path()
            p.move(to: CGPoint(x: s.width * 0.24, y: s.height * 0.24))
            p.addLine(to: CGPoint(x: s.width * 0.76, y: s.height * 0.76))
            p.move(to: CGPoint(x: s.width * 0.76, y: s.height * 0.24))
            p.addLine(to: CGPoint(x: s.width * 0.24, y: s.height * 0.76))
            ctx.stroke(p, with: .color(color), style: StrokeStyle(lineWidth: max(1.4, s.width * 0.10),
                                                                  lineCap: .round))
        }
        .frame(width: size, height: size)
    }
}

struct DoneMark: View {
    var size: CGFloat
    var color: Color
    var body: some View {
        Canvas { ctx, s in
            var p = Path()
            p.move(to: CGPoint(x: s.width * 0.20, y: s.height * 0.54))
            p.addLine(to: CGPoint(x: s.width * 0.42, y: s.height * 0.76))
            p.addLine(to: CGPoint(x: s.width * 0.80, y: s.height * 0.26))
            ctx.stroke(p, with: .color(color), style: StrokeStyle(lineWidth: max(1.5, s.width * 0.11),
                                                                  lineCap: .round, lineJoin: .round))
        }
        .frame(width: size, height: size)
    }
}

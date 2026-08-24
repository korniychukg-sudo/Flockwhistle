import Foundation
import CoreGraphics

func makeIcon(dir: String) {
    let p = Sheet(1024, 1024)
    p.fillAll(Field.night)
    p.topDown()
    var rng = Dice(90211)

    if let g = CGGradient(colorsSpace: rgbSpace,
                          colors: [cg(Tone(r: 0.216, g: 0.243, b: 0.196)),
                                   cg(Tone(r: 0.063, g: 0.078, b: 0.067))] as CFArray,
                          locations: [0, 1]) {
        p.ctx.drawRadialGradient(g, startCenter: CGPoint(x: 320, y: 260), startRadius: 0,
                                 endCenter: CGPoint(x: 320, y: 260), endRadius: 1150,
                                 options: [.drawsAfterEndLocation])
    }
    for _ in 0..<3000 {
        p.disc(rng.d() * 1024, rng.d() * 1024, rng.r(0.5, 2.0),
               (rng.chance(0.5) ? Field.turfPale : Field.night).al(rng.r(0.02, 0.09)))
    }
    for _ in 0..<160 {
        let gx = rng.d() * 1024, gy = 700 + rng.d() * 340
        pen(p, [pnt(gx, gy), pnt(gx + rng.signed() * 8, gy - rng.r(10, 34))],
            weight: rng.r(1.0, 2.6), colour: Field.turfDark.al(rng.r(0.10, 0.30)),
            wobble: 0.5, taper: true, seed: bits(Int(gx)))
    }

    let shankTop = pnt(628, 342)
    let shankEnd = pnt(1210, 1110)
    let dx = Double(shankEnd.x - shankTop.x), dy = Double(shankEnd.y - shankTop.y)
    let len = (dx * dx + dy * dy).squareRoot()
    let nx = -dy / len, ny = dx / len
    let halfW = 58.0

    for k in 0..<7 {
        let f = Double(k) * 9.0
        p.poly([pnt(Double(shankTop.x) + nx * halfW + 30 + f, Double(shankTop.y) + ny * halfW + 40 + f),
                pnt(Double(shankEnd.x) + nx * halfW + 30 + f, Double(shankEnd.y) + ny * halfW + 40 + f),
                pnt(Double(shankEnd.x) - nx * halfW + 30 + f, Double(shankEnd.y) - ny * halfW + 40 + f),
                pnt(Double(shankTop.x) - nx * halfW + 30 + f, Double(shankTop.y) - ny * halfW + 40 + f)],
               Field.night.al(0.10))
    }

    let shank: [CGPoint] = [pnt(Double(shankTop.x) + nx * halfW, Double(shankTop.y) + ny * halfW),
                            pnt(Double(shankEnd.x) + nx * halfW, Double(shankEnd.y) + ny * halfW),
                            pnt(Double(shankEnd.x) - nx * halfW, Double(shankEnd.y) - ny * halfW),
                            pnt(Double(shankTop.x) - nx * halfW, Double(shankTop.y) - ny * halfW)]
    p.poly(shank, Field.sepia)
    p.clip(pathOf(shank)) {
        if let g = CGGradient(colorsSpace: rgbSpace,
                              colors: [cg(Field.sepia.lt(0.42)), cg(Field.sepia),
                                       cg(Field.sepia.dk(0.44))] as CFArray,
                              locations: [0, 0.40, 1]) {
            p.ctx.drawLinearGradient(g,
                start: CGPoint(x: Double(shankTop.x) + nx * halfW, y: Double(shankTop.y) + ny * halfW),
                end: CGPoint(x: Double(shankTop.x) - nx * halfW, y: Double(shankTop.y) - ny * halfW),
                options: [.drawsBeforeStartLocation, .drawsAfterEndLocation])
        }
        var rb = Dice(4409)
        for _ in 0..<900 {
            let t = rb.d()
            let s = rb.r(-halfW, halfW)
            let x = Double(shankTop.x) + dx * t + nx * s
            let y = Double(shankTop.y) + dy * t + ny * s
            pen(p, [pnt(x, y), pnt(x + dx / len * rb.r(10, 60), y + dy / len * rb.r(10, 60))],
                weight: rb.r(0.7, 2.4),
                colour: (rb.chance(0.5) ? Field.sepia.lt(0.24) : Field.night).al(rb.r(0.10, 0.34)),
                wobble: 0.4, taper: true, seed: bits(Int(x)))
        }
        for k in 0..<9 {
            let t = 0.06 + Double(k) * 0.11
            let x = Double(shankTop.x) + dx * t
            let y = Double(shankTop.y) + dy * t
            p.ellipse(x, y, 14, 9, Field.sepia.dk(0.30).al(0.6))
            p.ellipse(x - 3, y - 3, 7, 5, Field.sepia.lt(0.22).al(0.5))
        }
    }

    var horn: [CGPoint] = []
    var inner: [CGPoint] = []
    let cx = 330.0, cy = 246.0
    let aStart = 0.30, aEnd = 4.42
    func hornRadius(_ t: Double) -> (Double, Double) {
        let u = (t - aStart) / (aEnd - aStart)
        let mid = 292.0 - u * 40
        let wide = 142.0 - u * 104
        return (mid + wide / 2, mid - wide / 2)
    }
    var a = aStart
    while a <= aEnd {
        let (outer, _) = hornRadius(a)
        horn.append(pnt(cx + cos(a) * outer, cy + sin(a) * outer * 0.94))
        a += 0.06
    }
    a = aEnd
    while a >= aStart {
        let (_, innerR) = hornRadius(a)
        inner.append(pnt(cx + cos(a) * innerR, cy + sin(a) * innerR * 0.94))
        a -= 0.06
    }
    let hornBody = horn + inner
    p.poly(hornBody.map { pnt(Double($0.x) + 30, Double($0.y) + 40) }, Field.night.al(0.46))
    p.poly(hornBody, Field.oat)
    p.clip(pathOf(hornBody)) {
        if let g = CGGradient(colorsSpace: rgbSpace,
                              colors: [cg(Tone(r: 0.988, g: 0.965, b: 0.898)),
                                       cg(Tone(r: 0.902, g: 0.827, b: 0.647)),
                                       cg(Tone(r: 0.639, g: 0.518, b: 0.337)),
                                       cg(Field.sepia.dk(0.44))] as CFArray,
                              locations: [0, 0.34, 0.72, 1]) {
            p.ctx.drawLinearGradient(g, start: CGPoint(x: cx - 250, y: cy - 250),
                                     end: CGPoint(x: cx + 250, y: cy + 300),
                                     options: [.drawsBeforeStartLocation, .drawsAfterEndLocation])
        }
        var rh = Dice(6607)
        var t = aStart
        while t <= aEnd {
            let (outer, innerR) = hornRadius(t)
            let f = rh.r(0.06, 0.94)
            let r0 = innerR + (outer - innerR) * f
            let r1 = innerR + (outer - innerR) * min(1, f + rh.r(0.10, 0.42))
            pen(p, [pnt(cx + cos(t) * r0, cy + sin(t) * r0 * 0.94),
                    pnt(cx + cos(t + rh.r(0.10, 0.34)) * r1,
                        cy + sin(t + rh.r(0.10, 0.34)) * r1 * 0.94)],
                weight: rh.r(1.6, 6.0),
                colour: (rh.chance(0.55) ? Tone(r: 0.451, g: 0.353, b: 0.220)
                         : Tone(r: 0.976, g: 0.949, b: 0.878)).al(rh.r(0.05, 0.22)),
                wobble: 0.5, taper: true, seed: bits(Int(t * 1000)))
            t += 0.02
        }
        var ridge = aStart
        while ridge <= aEnd {
            let (outer, innerR) = hornRadius(ridge)
            let r = innerR + (outer - innerR) * 0.30
            pen(p, [pnt(cx + cos(ridge) * r, cy + sin(ridge) * r * 0.94),
                    pnt(cx + cos(ridge + 0.06) * r, cy + sin(ridge + 0.06) * r * 0.94)],
                weight: 9, colour: Field.night.al(0.16), wobble: 0.3, taper: false,
                seed: bits(Int(ridge * 700)))
            ridge += 0.30
        }
        if let g = CGGradient(colorsSpace: rgbSpace,
                              colors: [cg(Tone(r: 1, g: 0.988, b: 0.945).al(0.55)),
                                       cg(Field.oat.al(0))] as CFArray,
                              locations: [0, 1]) {
            p.ctx.drawRadialGradient(g, startCenter: CGPoint(x: cx - 150, y: cy - 160),
                                     startRadius: 0,
                                     endCenter: CGPoint(x: cx - 150, y: cy - 160),
                                     endRadius: 300, options: [])
        }
    }

    var litRuns: [[Int]] = []
    var current: [Int] = []
    for i in 0..<hornBody.count {
        let p0 = hornBody[i], p1 = hornBody[(i + 1) % hornBody.count]
        let ang = atan2(Double(p1.y - p0.y), Double(p1.x - p0.x))
        if cos(ang - .pi / 2 - 2.30) > 0 { current.append(i) }
        else if !current.isEmpty { litRuns.append(current); current = [] }
    }
    if !current.isEmpty { litRuns.append(current) }
    for run in litRuns where run.count > 1 {
        var pts: [CGPoint] = [hornBody[run[0]]]
        for i in run { pts.append(hornBody[(i + 1) % hornBody.count]) }
        pen(p, pts, weight: 6.0, colour: Field.bone.lt(0.55).al(0.80), wobble: 0.3,
            taper: false, seed: bits(run[0] * 71))
    }
    penContour(p, hornBody, weight: 3.4, colour: Field.night.al(0.72), seed: 5501)

    let collar: [CGPoint] = [pnt(Double(shankTop.x) + nx * (halfW + 10) - 6,
                                 Double(shankTop.y) + ny * (halfW + 10) + 40),
                             pnt(Double(shankTop.x) + nx * (halfW + 10) + 34,
                                 Double(shankTop.y) + ny * (halfW + 10) + 82),
                             pnt(Double(shankTop.x) - nx * (halfW + 10) + 34,
                                 Double(shankTop.y) - ny * (halfW + 10) + 82),
                             pnt(Double(shankTop.x) - nx * (halfW + 10) - 6,
                                 Double(shankTop.y) - ny * (halfW + 10) + 40)]
    p.poly(collar, Field.brass)
    p.clip(pathOf(collar)) {
        if let g = CGGradient(colorsSpace: rgbSpace,
                              colors: [cg(Field.brass.lt(0.45)), cg(Field.brass.dk(0.34))] as CFArray,
                              locations: [0, 1]) {
            p.ctx.drawLinearGradient(g, start: CGPoint(x: Double(shankTop.x) - 60, y: 0),
                                     end: CGPoint(x: Double(shankTop.x) + 60, y: 0), options: [])
        }
    }
    penContour(p, collar, weight: 2.6, colour: Field.night.al(0.8), seed: 5507)

    for i in 0..<shank.count {
        let p0 = shank[i], p1 = shank[(i + 1) % shank.count]
        let ang = atan2(Double(p1.y - p0.y), Double(p1.x - p0.x))
        let lit = cos(ang - .pi / 2 - 2.30) > 0
        pen(p, [p0, p1], weight: lit ? 6.0 : 7.0,
            colour: lit ? Field.bone.lt(0.20).al(0.62) : Field.night.al(0.80),
            wobble: 0.3, taper: false, seed: bits(i * 91))
    }

    if let g = CGGradient(colorsSpace: rgbSpace,
                          colors: [cg(Field.bone.al(0.10)), cg(Field.night.al(0)),
                                   cg(Field.night.al(0.52))] as CFArray,
                          locations: [0, 0.40, 1]) {
        p.ctx.drawRadialGradient(g, startCenter: CGPoint(x: 330, y: 290), startRadius: 0,
                                 endCenter: CGPoint(x: 330, y: 290), endRadius: 950,
                                 options: [.drawsAfterEndLocation])
    }

    p.writePNG(dir, "AppIcon-1024")
}

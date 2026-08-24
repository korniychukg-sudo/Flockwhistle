import Foundation
import CoreGraphics

struct FieldSpec {
    let id: String
    let name: String
    let place: String
    let terrain: String
    let breed: String
    let sheepCount: Int
    let kicker: String
    let notes: [(String, String)]
}

func pnt(_ x: Double, _ y: Double) -> CGPoint { CGPoint(x: CGFloat(x), y: CGFloat(y)) }

func drawSheep(_ p: Sheet, at c: CGPoint, size: Double, facing: Double, seed: UInt64) {
    var rng = Dice(seed)
    let x = Double(c.x), y = Double(c.y)
    let bodyW = size, bodyH = size * 0.62
    var wool: [CGPoint] = []
    var a = 0.0
    while a < 6.283 {
        let bump = 1.0 + 0.14 * sin(a * 7 + rng.d())
        wool.append(pnt(x + cos(a) * bodyW * bump, y + sin(a) * bodyH * bump))
        a += 0.22
    }
    p.poly(wool, Field.fleece)
    penContour(p, wool, weight: size * 0.10, colour: Field.inkSoft, seed: seed &+ 3)
    for _ in 0..<Int(size * 0.9) {
        let wx = x + rng.r(-bodyW * 0.8, bodyW * 0.8)
        let wy = y + rng.r(-bodyH * 0.6, bodyH * 0.6)
        p.ring(wx, wy, rng.r(size * 0.10, size * 0.22), size * 0.05,
               Field.fleeceDark.al(rng.r(0.30, 0.65)))
    }
    let hx = x + cos(facing) * bodyW * 1.05
    let hy = y + sin(facing) * bodyH * 0.9
    p.ellipse(hx, hy, size * 0.30, size * 0.24, Field.inkSoft)
    p.ellipse(hx + cos(facing) * size * 0.22, hy + sin(facing) * size * 0.18,
              size * 0.16, size * 0.13, Field.ink)
    for k in 0..<4 {
        let lx = x + (k < 2 ? -bodyW * 0.5 : bodyW * 0.45) + (k % 2 == 0 ? -size * 0.14 : size * 0.14)
        pen(p, [pnt(lx, y + bodyH * 0.6), pnt(lx + rng.r(-1, 1) * size * 0.1, y + bodyH * 1.5)],
            weight: size * 0.11, colour: Field.inkSoft, wobble: 0.2, taper: false,
            seed: seed &+ bits(k))
    }
}

func drawDog(_ p: Sheet, at c: CGPoint, size: Double, facing: Double, seed: UInt64) {
    let x = Double(c.x), y = Double(c.y)
    let dir = cos(facing) >= 0 ? 1.0 : -1.0
    var body: [CGPoint] = []
    var t = 0.0
    while t <= 1.0 {
        body.append(pnt(x - dir * size * 1.2 + dir * t * size * 2.4,
                        y - sin(t * 3.14) * size * 0.42))
        t += 0.1
    }
    t = 1.0
    while t >= 0 {
        body.append(pnt(x - dir * size * 1.2 + dir * t * size * 2.4,
                        y + size * 0.30 + sin(t * 3.14) * size * 0.10))
        t -= 0.1
    }
    p.poly(body, Field.collie)
    p.poly([pnt(x + dir * size * 1.1, y - size * 0.2), pnt(x + dir * size * 1.9, y - size * 0.5),
            pnt(x + dir * size * 2.0, y + size * 0.1), pnt(x + dir * size * 1.1, y + size * 0.2)],
           Field.collie)
    p.ellipse(x + dir * size * 1.9, y - size * 0.3, size * 0.28, size * 0.22, Field.fleece)
    for k in 0..<4 {
        let lx = x - dir * size * 0.9 + dir * Double(k) * size * 0.6
        pen(p, [pnt(lx, y + size * 0.22), pnt(lx + dir * size * 0.1, y + size * 0.95)],
            weight: size * 0.16, colour: Field.collie, wobble: 0.2, taper: false,
            seed: seed &+ bits(k))
    }
    pen(p, [pnt(x - dir * size * 1.2, y - size * 0.1), pnt(x - dir * size * 2.1, y + size * 0.3)],
        weight: size * 0.26, colour: Field.collie, wobble: 0.4, taper: true, seed: seed &+ 9)
    p.poly([pnt(x + dir * size * 0.4, y - size * 0.35), pnt(x + dir * size * 1.3, y - size * 0.35),
            pnt(x + dir * size * 0.9, y + size * 0.2)], Field.fleece.al(0.9))
}

func drawShepherd(_ p: Sheet, at c: CGPoint, size: Double, seed: UInt64) {
    let x = Double(c.x), y = Double(c.y)
    p.ellipse(x, y - size * 1.55, size * 0.26, size * 0.30, Field.inkSoft)
    p.poly([pnt(x - size * 0.34, y - size * 1.25), pnt(x + size * 0.34, y - size * 1.25),
            pnt(x + size * 0.26, y - size * 0.2), pnt(x - size * 0.26, y - size * 0.2)],
           Field.slate)
    pen(p, [pnt(x - size * 0.16, y - size * 0.2), pnt(x - size * 0.2, y + size * 0.6)],
        weight: size * 0.2, colour: Field.inkSoft, wobble: 0.2, taper: false, seed: seed)
    pen(p, [pnt(x + size * 0.16, y - size * 0.2), pnt(x + size * 0.2, y + size * 0.6)],
        weight: size * 0.2, colour: Field.inkSoft, wobble: 0.2, taper: false, seed: seed &+ 1)
    pen(p, [pnt(x + size * 0.36, y - size * 1.9), pnt(x + size * 0.44, y + size * 0.6)],
        weight: size * 0.12, colour: Field.sepia, wobble: 0.2, taper: false, seed: seed &+ 3)
    var crook: [CGPoint] = []
    var a = 3.4
    while a < 6.0 {
        crook.append(pnt(x + size * 0.36 + cos(a) * size * 0.26,
                         y - size * 1.9 + sin(a) * size * 0.26))
        a += 0.2
    }
    pen(p, crook, weight: size * 0.12, colour: Field.sepia, wobble: 0.2, taper: false,
        seed: seed &+ 5)
}

func drawWall(_ p: Sheet, _ pts: [CGPoint], height: Double, seed: UInt64) {
    var rng = Dice(seed)
    for i in 0..<(pts.count - 1) {
        let a = pts[i], b = pts[i + 1]
        let steps = max(2, Int(hypot(Double(b.x - a.x), Double(b.y - a.y)) / 9))
        for k in 0..<steps {
            let t = Double(k) / Double(steps)
            let x = Double(a.x) + (Double(b.x) - Double(a.x)) * t
            let y = Double(a.y) + (Double(b.y) - Double(a.y)) * t
            let sw = rng.r(6, 11)
            let sh = rng.r(height * 0.28, height * 0.42)
            p.rect(x, y - sh, sw, sh, rng.chance(0.5) ? Field.stone : Field.stone.dk(0.10))
            penContour(p, [pnt(x, y - sh), pnt(x + sw, y - sh), pnt(x + sw, y), pnt(x, y)],
                       weight: 0.8, colour: Field.stoneDark, seed: seed &+ bits(k))
            if rng.chance(0.6) {
                let sh2 = rng.r(height * 0.24, height * 0.36)
                p.rect(x + rng.r(-2, 2), y - sh - sh2, sw * rng.r(0.7, 1.0), sh2,
                       rng.chance(0.5) ? Field.stone.lt(0.06) : Field.stone.dk(0.14))
            }
        }
    }
}

func drawGate(_ p: Sheet, at c: CGPoint, width: Double, seed: UInt64) {
    let x = Double(c.x), y = Double(c.y)
    let h = width * 0.62
    for side in 0..<2 {
        let px = x + (side == 0 ? -width : width)
        pen(p, [pnt(px, y), pnt(px, y - h)], weight: 6.0, colour: Field.sepia,
            wobble: 0.3, taper: false, seed: seed &+ bits(side))
        for k in 0..<3 {
            let ry = y - h * (0.30 + Double(k) * 0.28)
            pen(p, [pnt(px - width * 0.55, ry), pnt(px, ry)], weight: 3.4,
                colour: Field.sepia.lt(0.10), wobble: 0.3, taper: false,
                seed: seed &+ bits(k &+ side * 10))
        }
        pen(p, [pnt(px - width * 0.55, y), pnt(px - width * 0.55, y - h * 0.9)], weight: 4.4,
            colour: Field.sepia.dk(0.06), wobble: 0.3, taper: false, seed: seed &+ bits(side &+ 20))
    }
    pen(p, [pnt(x - width, y + 3), pnt(x + width, y + 3)], weight: 2.0,
        colour: Field.inkSoft.al(0.4), wobble: 0.5, taper: false, seed: seed &+ 31)
}

func drawPen(_ p: Sheet, at c: CGPoint, size: Double, seed: UInt64) {
    let x = Double(c.x), y = Double(c.y)
    let corners: [CGPoint] = [pnt(x - size, y), pnt(x - size * 0.5, y - size * 0.5),
                              pnt(x + size * 0.5, y - size * 0.5), pnt(x + size, y)]
    for i in 0..<(corners.count - 1) {
        pen(p, [corners[i], corners[i + 1]], weight: 3.4, colour: Field.sepia,
            wobble: 0.4, taper: false, seed: seed &+ bits(i))
        pen(p, [pnt(Double(corners[i].x), Double(corners[i].y) - size * 0.22),
                pnt(Double(corners[i + 1].x), Double(corners[i + 1].y) - size * 0.22)],
            weight: 2.6, colour: Field.sepia.lt(0.08), wobble: 0.4, taper: false,
            seed: seed &+ bits(i &+ 20))
        pen(p, [corners[i], pnt(Double(corners[i].x), Double(corners[i].y) - size * 0.34)],
            weight: 3.0, colour: Field.sepia.dk(0.08), wobble: 0.3, taper: false,
            seed: seed &+ bits(i &+ 40))
    }
    pen(p, [corners[corners.count - 1], pnt(x + size * 1.4, y + size * 0.2)], weight: 3.0,
        colour: Field.sepia, wobble: 0.4, taper: false, seed: seed &+ 61)
}

func makeFieldPlate(_ spec: FieldSpec, dir: String) {
    let p = Sheet(1350, 1620)
    let seed = hashOf(spec.id)
    layPaper(p, seed: seed, tone: Field.canvas)
    p.topDown()
    p.light = 2.30
    var rng = Dice(seed &+ 7)

    let scene = CGRect(x: 96, y: 96, width: 1158, height: 900)
    let horizon = Double(scene.minY) + Double(scene.height) * 0.30

    p.clipRect(scene) {
        washBand(p, from: Double(scene.minY), to: horizon, Field.sky, strength: 0.42, seed: seed &+ 3)
        for _ in 0..<rng.i(3, 6) {
            let cx = Double(scene.minX) + rng.d() * Double(scene.width)
            let cy = Double(scene.minY) + rng.d() * (horizon - Double(scene.minY)) * 0.8
            let cloud = blob(cx: cx, cy: cy, rx: rng.r(120, 260), ry: rng.r(28, 54),
                             rough: 0.30, steps: 24, seed: seed &+ bits(Int(cx)))
            wash(p, cloud, Field.bone.lt(0.2), strength: rng.r(0.20, 0.40), bleed: 10,
                 seed: seed &+ bits(Int(cy)))
        }

        var fell: [CGPoint] = []
        var x = Double(scene.minX) - 20
        while x < Double(scene.maxX) + 20 {
            fell.append(pnt(x, horizon - 60 - sin((x - Double(scene.minX)) / 260) * 54
                            - sin((x - Double(scene.minX)) / 90) * 16 + rng.signed() * 6))
            x += 40
        }
        fell.append(pnt(Double(scene.maxX) + 20, horizon + 10))
        fell.append(pnt(Double(scene.minX) - 20, horizon + 10))
        p.poly(fell, Field.moor.al(0.7))
        hatch(p, pathOf(fell), angle: 1.2, spacing: 10, weight: 0.9,
              colour: Field.inkSoft.al(0.34), coverage: 0.6, seed: seed &+ 11)
        for i in 0..<(fell.count - 3) {
            pen(p, [fell[i], fell[i + 1]], weight: 1.6, colour: Field.inkSoft.al(0.7),
                wobble: 0.6, taper: false, seed: seed &+ bits(i))
        }

        washBand(p, from: horizon, to: Double(scene.maxY), Field.turf, strength: 0.46,
                 seed: seed &+ 13)
        washBand(p, from: horizon + Double(scene.height) * 0.35, to: Double(scene.maxY),
                 Field.turfDark, strength: 0.20, seed: seed &+ 17)

        for _ in 0..<Int(Double(scene.width) * 0.9) {
            let gx = Double(scene.minX) + rng.d() * Double(scene.width)
            let gy = horizon + rng.d() * (Double(scene.maxY) - horizon)
            let scale = (gy - horizon) / (Double(scene.maxY) - horizon)
            pen(p, [pnt(gx, gy), pnt(gx + rng.signed() * 4, gy - 4 - scale * 9)],
                weight: 0.6 + scale * 1.0,
                colour: (rng.chance(0.5) ? Field.turfDark : Field.turfPale).al(rng.r(0.2, 0.55)),
                wobble: 0.4, taper: true, seed: seed &+ bits(Int(gx + gy)))
        }

        for _ in 0..<rng.i(8, 16) {
            let bx = Double(scene.minX) + rng.d() * Double(scene.width)
            let by = horizon + rng.d() * (Double(scene.maxY) - horizon) * 0.6
            let scale = 0.4 + (by - horizon) / (Double(scene.maxY) - horizon)
            for k in 0..<5 {
                let a = 1.0 + Double(k) * 0.35
                pen(p, [pnt(bx, by), pnt(bx + cos(a) * 16 * scale, by - sin(a) * 20 * scale)],
                    weight: 1.0 * scale, colour: Field.bracken.al(0.7), wobble: 0.6, taper: true,
                    seed: seed &+ bits(k &+ Int(bx)))
            }
        }

        drawWall(p, [pnt(Double(scene.minX) - 10, horizon + 40),
                     pnt(Double(scene.midX) - 120, horizon + 26),
                     pnt(Double(scene.maxX) + 10, horizon + 54)], height: 40, seed: seed &+ 21)
        drawWall(p, [pnt(Double(scene.minX) - 20, Double(scene.maxY) - 30),
                     pnt(Double(scene.minX) + 300, horizon + 120)], height: 46, seed: seed &+ 23)

        let postX = Double(scene.minX) + Double(scene.width) * 0.06
        let postY = Double(scene.maxY) - 60
        pen(p, [pnt(postX, postY), pnt(postX, postY - 90)], weight: 6.0, colour: Field.sepia,
            wobble: 0.3, taper: false, seed: seed &+ 31)
        drawShepherd(p, at: pnt(postX + 34, postY), size: 30, seed: seed &+ 33)

        let gateY = horizon + (Double(scene.maxY) - horizon) * 0.46
        drawGate(p, at: pnt(Double(scene.midX) + 90, gateY + 40), width: 62, seed: seed &+ 41)
        drawGate(p, at: pnt(Double(scene.maxX) - 250, gateY - 40), width: 46, seed: seed &+ 43)

        drawPen(p, at: pnt(Double(scene.minX) + 300, Double(scene.maxY) - 70), size: 84,
                seed: seed &+ 51)

        let flockX = Double(scene.midX) + 40
        let flockY = horizon + (Double(scene.maxY) - horizon) * 0.62
        for k in 0..<spec.sheepCount {
            let a = Double(k) / Double(spec.sheepCount) * 6.283
            let sx = flockX + cos(a) * rng.r(20, 90)
            let sy = flockY + sin(a) * rng.r(12, 46)
            let scale = 0.7 + (sy - horizon) / (Double(scene.maxY) - horizon) * 0.9
            drawSheep(p, at: pnt(sx, sy), size: 15 * scale, facing: 3.14 + rng.r(-0.6, 0.6),
                      seed: seed &+ bits(k))
        }

        drawDog(p, at: pnt(flockX + 180, flockY + 40), size: 13, facing: 3.14, seed: seed &+ 61)

        var track: [CGPoint] = []
        var t = 0.0
        while t <= 1.0 {
            track.append(pnt(flockX + 120 - t * (flockX + 120 - postX - 40),
                             flockY + 60 + sin(t * 3.4) * 40 + t * 60))
            t += 0.06
        }
        for i in 0..<(track.count - 1) where i % 3 != 2 {
            pen(p, [track[i], track[i + 1]], weight: 1.6, colour: Field.oxblood.al(0.55),
                wobble: 0.4, taper: false, seed: seed &+ bits(i))
        }
    }

    penContour(p, [pnt(Double(scene.minX), Double(scene.minY)), pnt(Double(scene.maxX), Double(scene.minY)),
                   pnt(Double(scene.maxX), Double(scene.maxY)), pnt(Double(scene.minX), Double(scene.maxY))],
               weight: 3.0, colour: Field.ink, seed: seed &+ 71)

    caption(p, spec.kicker.uppercased(), at: 96, 72, size: 20, colour: Field.oxblood,
            face: "Georgia-Bold", align: .left, tracking: 3.4)
    caption(p, spec.name, at: 96, 1066, size: 50, colour: Field.ink, face: "Georgia-Bold", align: .left)
    caption(p, spec.place + "  ·  " + spec.terrain, at: 96, 1104, size: 24, colour: Field.inkPale,
            face: "Georgia-Italic", align: .left)
    caption(p, spec.breed + "  ·  " + String(spec.sheepCount) + " head", at: 96, 1140, size: 22,
            colour: Field.sepia, face: "Georgia", align: .left)

    var y = 1200.0
    for note in spec.notes {
        caption(p, note.0.uppercased(), at: 96, y, size: 18, colour: Field.sepia,
                face: "Georgia-Bold", align: .left, tracking: 2.4)
        y += 30
        for line in wrapText(note.1, width: 1150, size: 23) {
            caption(p, line, at: 96, y, size: 23, colour: Field.inkSoft, face: "Georgia", align: .left)
            y += 30
        }
        y += 14
    }

    plateFrame(p, inset: 44, seed: seed &+ 91)
    p.write(dir, "field_" + spec.id, quality: 0.94)
}

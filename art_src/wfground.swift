import Foundation
import CoreGraphics

func makeGrounds(dir: String) {
    let paper = Sheet(1100, 1900)
    layPaper(paper, seed: 4409, tone: Field.canvas)
    paper.write(dir, "bg_paper", quality: 0.82)

    let card = Sheet(900, 1200)
    layPaper(card, seed: 5507, tone: Field.paperWarm, laid: false)
    card.write(dir, "bg_card", quality: 0.82)

    let turf = Sheet(1100, 1900)
    var rng = Dice(7703)
    turf.fillAll(Field.turf)
    turf.topDown()
    for _ in 0..<40 {
        let cx = rng.d() * turf.w, cy = rng.d() * turf.h
        turf.poly(blob(cx: cx, cy: cy, rx: rng.r(80, 260), ry: rng.r(60, 200), rough: 0.28,
                       steps: 24, seed: bits(Int(cx))),
                  (rng.chance(0.5) ? Field.turfDark : Field.turfPale).al(rng.r(0.10, 0.30)))
    }
    for _ in 0..<9000 {
        let gx = rng.d() * turf.w, gy = rng.d() * turf.h
        pen(turf, [pnt(gx, gy), pnt(gx + rng.signed() * 4, gy - rng.r(4, 12))],
            weight: rng.r(0.6, 1.6),
            colour: (rng.chance(0.5) ? Field.turfDark : Field.turfPale).al(rng.r(0.14, 0.42)),
            wobble: 0.4, taper: true, seed: bits(Int(gx + gy)))
    }
    for _ in 0..<70 {
        let bx = rng.d() * turf.w, by = rng.d() * turf.h
        for k in 0..<5 {
            let a = 1.0 + Double(k) * 0.35
            pen(turf, [pnt(bx, by), pnt(bx + cos(a) * 22, by - sin(a) * 26)], weight: 1.2,
                colour: Field.bracken.al(0.55), wobble: 0.6, taper: true, seed: bits(k &+ Int(bx)))
        }
    }
    if let g = CGGradient(colorsSpace: rgbSpace,
                          colors: [cg(Field.turfDark.al(0)), cg(Field.turfDark.al(0.55))] as CFArray,
                          locations: [0.4, 1]) {
        turf.ctx.drawRadialGradient(g, startCenter: CGPoint(x: turf.w * 0.4, y: turf.h * 0.3),
                                    startRadius: 0,
                                    endCenter: CGPoint(x: turf.w * 0.4, y: turf.h * 0.3),
                                    endRadius: CGFloat(turf.h * 0.9),
                                    options: [.drawsAfterEndLocation])
    }
    turf.write(dir, "bg_turf", quality: 0.84)

    let slateBoard = Sheet(1100, 1900)
    var rs = Dice(9901)
    slateBoard.fillAll(Field.slate)
    for _ in 0..<14000 {
        let x = rs.d() * slateBoard.w, y = rs.d() * slateBoard.h
        slateBoard.disc(x, y, rs.r(0.6, 2.2),
                        (rs.chance(0.5) ? Field.slate.lt(0.10) : Field.night).al(rs.r(0.08, 0.26)))
    }
    for _ in 0..<220 {
        let x = rs.d() * slateBoard.w, y = rs.d() * slateBoard.h
        pen(slateBoard, [pnt(x, y), pnt(x + rs.r(-90, 90), y + rs.r(-16, 16))],
            weight: rs.r(0.6, 1.8), colour: Field.slate.lt(0.16).al(rs.r(0.10, 0.28)),
            wobble: 0.8, taper: true, seed: bits(Int(x)))
    }
    slateBoard.write(dir, "bg_slate", quality: 0.84)

    let hill = Sheet(1400, 900)
    var rh = Dice(1213)
    hill.fillAll(Field.sky)
    hill.topDown()
    washBand(hill, from: 0, to: 420, Field.sky, strength: 0.45, seed: 3301)
    for k in 0..<5 {
        var ridge: [CGPoint] = []
        var x = -40.0
        let base = 430.0 + Double(k) * 42
        while x < hill.w + 40 {
            ridge.append(pnt(x, base - sin(x / (150 + Double(k) * 40) + Double(k)) * (44 - Double(k) * 6)
                             + rh.signed() * 5))
            x += 40
        }
        ridge.append(pnt(hill.w + 40, hill.h))
        ridge.append(pnt(-40, hill.h))
        hill.poly(ridge, (k % 2 == 0 ? Field.moor : Field.turfDark).al(0.35 + Double(k) * 0.10))
    }
    hill.write(dir, "bg_hill", quality: 0.84)
}

struct KitSpec {
    let id: String
    let name: String
    let note: String
    let kind: String
}

let kitBook: [KitSpec] = [
    KitSpec(id: "whistle", name: "The shepherd's whistle",
            note: "A folded plate of tin or brass held between the teeth and the tongue. It takes weeks to make a note at all and years to make six different ones at will.",
            kind: "whistle"),
    KitSpec(id: "crook", name: "The crook",
            note: "A hazel or blackthorn shank with a horn head. The neck crook catches a ewe by the neck, the leg crook by the hind leg, and both are used far more as a third leg on a wet hill.",
            kind: "crook"),
    KitSpec(id: "collar", name: "Collar and lead",
            note: "A dog that will not walk quietly on a lead past sheep is not ready to work them off one. The lead is training equipment long before it is restraint.",
            kind: "collar"),
    KitSpec(id: "hurdle", name: "Hurdles and the pen",
            note: "Six light hurdles make a pen anywhere in a field. At a trial the mouth is nine feet wide, the gate swings on a rope, and the handler may not let go of it.",
            kind: "hurdle"),
    KitSpec(id: "tally", name: "The tally stick",
            note: "Sheep were counted in scores in a dialect older than English: yan, tan, tethera, methera, pimp. A notch on the stick for every score, and the notches settle arguments.",
            kind: "tally"),
    KitSpec(id: "card", name: "The judge's card and pencil",
            note: "A printed card, a stub of pencil and fifteen minutes. Deductions are written as they happen, because nobody can reconstruct a run from memory afterwards.",
            kind: "card"),
]

func makeKitPlate(_ spec: KitSpec, dir: String) {
    let p = Sheet(1100, 760)
    let seed = hashOf("kit" + spec.id)
    layPaper(p, seed: seed, tone: Field.paperWarm)
    p.topDown()
    p.light = 2.30
    var rng = Dice(seed &+ 3)

    switch spec.kind {
    case "whistle":
        let body: [CGPoint] = [pnt(300, 300), pnt(700, 260), pnt(760, 360), pnt(720, 460),
                               pnt(320, 430)]
        p.poly(body, Field.stone.lt(0.10))
        formShade(p, body, inset: 50, depth: 3, spacing: 7, colour: Field.inkSoft, seed: seed)
        penContour(p, body, weight: 3.0, colour: Field.ink, seed: seed &+ 5)
        p.poly([pnt(420, 330), pnt(620, 312), pnt(620, 356), pnt(420, 372)], Field.night.al(0.8))
        pen(p, [pnt(300, 300), pnt(320, 430)], weight: 5.0, colour: Field.stoneDark,
            wobble: 0.3, taper: false, seed: seed &+ 7)
        for k in 0..<12 {
            pen(p, [pnt(340 + Double(k) * 34, 300 + rng.r(-4, 4)),
                    pnt(346 + Double(k) * 34, 430 + rng.r(-4, 4))], weight: 0.8,
                colour: Field.bone.lt(0.3).al(0.30), wobble: 0.5, taper: true, seed: seed &+ bits(k))
        }
        caption(p, "held against the tongue", at: 300, 520, size: 22, colour: Field.oxblood,
                face: "Georgia-Italic", align: .left)
    case "crook":
        pen(p, [pnt(260, 640), pnt(560, 180)], weight: 14, colour: Field.sepia,
            wobble: 0.6, taper: false, seed: seed)
        var head: [CGPoint] = []
        var a = 3.2
        while a < 6.6 {
            head.append(pnt(600 + cos(a) * 70, 180 + sin(a) * 62))
            a += 0.16
        }
        pen(p, head, weight: 15, colour: Field.bone.dk(0.06), wobble: 0.4, taper: false,
            seed: seed &+ 5)
        pen(p, head.map { pnt(Double($0.x) - 3, Double($0.y) - 3) }, weight: 4,
            colour: Field.bone.lt(0.3).al(0.6), wobble: 0.3, taper: false, seed: seed &+ 7)
        for k in 0..<26 {
            let t = Double(k) / 26
            pen(p, [pnt(260 + t * 300 + rng.r(-6, 6), 640 - t * 460),
                    pnt(266 + t * 300 + rng.r(-6, 6), 620 - t * 460)], weight: 1.2,
                colour: Field.sepia.dk(0.16).al(0.6), wobble: 0.6, taper: true, seed: seed &+ bits(k))
        }
        caption(p, "hazel shank, horn head", at: 260, 700, size: 22, colour: Field.oxblood,
                face: "Georgia-Italic", align: .left)
    case "collar":
        var band: [CGPoint] = []
        var a = 0.0
        while a < 6.283 {
            band.append(pnt(520 + cos(a) * 180, 380 + sin(a) * 150))
            a += 0.12
        }
        pen(p, band, weight: 26, colour: Field.sepia, wobble: 0.5, taper: false, seed: seed)
        pen(p, band.map { pnt(Double($0.x), Double($0.y) - 4) }, weight: 6,
            colour: Field.sepia.lt(0.20).al(0.6), wobble: 0.4, taper: false, seed: seed &+ 3)
        p.disc(700, 380, 26, Field.brass)
        p.ring(700, 380, 26, 4, Field.brass.dk(0.24))
        pen(p, [pnt(726, 380), pnt(980, 300)], weight: 10, colour: Field.oat.dk(0.10),
            wobble: 0.6, taper: false, seed: seed &+ 5)
        caption(p, "quiet on the lead first", at: 260, 620, size: 22, colour: Field.oxblood,
                face: "Georgia-Italic", align: .left)
    case "hurdle":
        for k in 0..<3 {
            let bx = 220.0 + Double(k) * 260
            for r in 0..<4 {
                pen(p, [pnt(bx, 300 + Double(r) * 50), pnt(bx + 220, 296 + Double(r) * 50)],
                    weight: 6, colour: Field.sepia, wobble: 0.4, taper: false,
                    seed: seed &+ bits(r &+ k * 10))
            }
            pen(p, [pnt(bx, 280), pnt(bx, 480)], weight: 8, colour: Field.sepia.dk(0.10),
                wobble: 0.3, taper: false, seed: seed &+ bits(k))
            pen(p, [pnt(bx + 220, 276), pnt(bx + 220, 476)], weight: 8, colour: Field.sepia.dk(0.10),
                wobble: 0.3, taper: false, seed: seed &+ bits(k &+ 20))
        }
        caption(p, "six hurdles make a pen anywhere", at: 220, 560, size: 22, colour: Field.oxblood,
                face: "Georgia-Italic", align: .left)
    case "tally":
        pen(p, [pnt(220, 400), pnt(880, 360)], weight: 30, colour: Field.sepia,
            wobble: 0.5, taper: false, seed: seed)
        for k in 0..<11 {
            let x = 280.0 + Double(k) * 56
            pen(p, [pnt(x, 372), pnt(x - 6, 410)], weight: 4, colour: Field.ink.al(0.8),
                wobble: 0.3, taper: false, seed: seed &+ bits(k))
        }
        let words = ["yan", "tan", "tethera", "methera", "pimp"]
        for (k, w) in words.enumerated() {
            caption(p, w, at: 250 + Double(k) * 150, 520, size: 26, colour: Field.inkSoft,
                    face: "Georgia-Italic", align: .left)
        }
        caption(p, "a notch for every score", at: 220, 600, size: 22, colour: Field.oxblood,
                face: "Georgia-Italic", align: .left)
    default:
        p.rect(280, 200, 520, 400, Field.paperCool.al(0.8))
        penContour(p, [pnt(280, 200), pnt(800, 200), pnt(800, 600), pnt(280, 600)],
                   weight: 2.4, colour: Field.ink, seed: seed &+ 5)
        var y = 260.0
        for name in ["Outrun", "Lift", "Fetch", "Drive", "Shed", "Pen"] {
            caption(p, name, at: 320, y, size: 22, colour: Field.inkSoft, face: "Georgia",
                    align: .left)
            pen(p, [pnt(300, y + 16), pnt(780, y + 16)], weight: 0.8, colour: Field.inkPale.al(0.5),
                wobble: 0.3, taper: false, seed: seed &+ bits(Int(y)))
            y += 56
        }
        pen(p, [pnt(840, 560), pnt(1000, 300)], weight: 10, colour: Field.oat.dk(0.14),
            wobble: 0.4, taper: false, seed: seed &+ 9)
        p.poly([pnt(1000, 300), pnt(1020, 264), pnt(1012, 296)], Field.ink)
        caption(p, "written as it happens", at: 280, 660, size: 22, colour: Field.oxblood,
                face: "Georgia-Italic", align: .left)
    }

    caption(p, spec.name, at: 90, 580, size: 38, colour: Field.ink, face: "Georgia-Bold", align: .left)
    var y = 624.0
    for line in wrapText(spec.note, width: 920, size: 23) {
        caption(p, line, at: 90, y, size: 23, colour: Field.inkSoft, face: "Georgia", align: .left)
        y += 30
    }
    plateFrame(p, inset: 36, seed: seed &+ 41)
    p.write(dir, "kit_" + spec.id, quality: 0.93)
}

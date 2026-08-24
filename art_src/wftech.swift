import Foundation
import CoreGraphics

struct CraftSpec {
    let id: String
    let kicker: String
    let title: String
    let sub: String
    let kind: String
    let notes: [(String, String)]
}

let craftBook: [CraftSpec] = craftBookA + craftBookB

let craftBookA: [CraftSpec] = [
    CraftSpec(id: "outrun", kicker: "Plate I", title: "The outrun",
              sub: "Wide enough that the sheep never see the dog coming",
              kind: "outrun",
              notes: [("Pear-shaped, not straight",
                       "The dog leaves the handler, opens out as it runs, and comes in behind the sheep at the top. Drawn on paper the path is a pear: narrow at the bottom, wide at the shoulder, closing again at the head."),
                      ("Crossing the course",
                       "A dog that starts one way and changes to the other has crossed, and at a trial that is the end of the run. It is judged from the handler's post, which is why the first fifty yards matter more than the last two hundred."),
                      ("Left or right",
                       "The handler chooses the side by the lie of the ground and the wind. A dog sent on the wrong side runs uphill into the sheep's view and lifts them before it is ready.")]),
    CraftSpec(id: "lift", kicker: "Plate II", title: "The lift",
              sub: "The ten seconds that decide everything after",
              kind: "lift",
              notes: [("Arrive and stop",
                       "At the top of the outrun the dog should stop, stand, and let the sheep notice it. Sheep that lift calmly walk; sheep that are startled run, and running sheep cannot be steered."),
                      ("The pear closes behind",
                       "The dog comes in at the point exactly opposite the direction of travel. That point is the balance, and holding it is the whole of the fetch.")]),
    CraftSpec(id: "fetch", kicker: "Plate III", title: "The fetch",
              sub: "A straight line, through the gates, round the post",
              kind: "fetch",
              notes: [("The judge watches the line",
                       "Not the speed and not the gates alone. Sheep drifting twenty yards off the line and coming back through the gates lose more than sheep that miss the gates on a straight line."),
                      ("Round the post, not over it",
                       "The sheep pass behind the handler at the post and turn for the drive. A handler who moves at this moment pulls the sheep off their line himself.")]),
    CraftSpec(id: "drive", kicker: "Plate IV", title: "Drive and cross-drive",
              sub: "Pushing sheep away from the one thing they want",
              kind: "drive",
              notes: [("Against the pull",
                       "Sheep want to come back to the handler, to the exhaust pen, to the rest of the flock. The drive asks the dog to hold a line directly against that wish for two hundred yards."),
                      ("Flanking little and often",
                       "The line is held by many small corrections, not by two big ones. A dog that flanks in short arcs keeps the sheep walking; one that swings wide turns them.")]),
    CraftSpec(id: "shed", kicker: "Plate V", title: "The shed",
              sub: "Splitting a flock in a marked ring",
              kind: "shed",
              notes: [("Make the gap first",
                       "The handler walks in and opens a space between the sheep. Only when there is a real gap is the dog called through it, and a dog called too early simply pushes them together again."),
                      ("Why it is hard",
                       "Everything a flock does is designed to prevent exactly this. Standing between two halves of a group of frightened animals is the least natural thing a dog is ever asked to do.")]),
    CraftSpec(id: "pen", kicker: "Plate VI", title: "The pen",
              sub: "Six feet of rope and no room for hurry",
              kind: "pen",
              notes: [("The handler is a post",
                       "He holds the rope on the gate and may not let go of it. Everything else is the dog, moving a step at a time behind sheep that can see the mouth of the pen and do not want it."),
                      ("Walk them in",
                       "The dog approaches straight, stops when the sheep stop, and never flanks close at the mouth. Most pens are lost in the last three feet.")]),
]

let craftBookB: [CraftSpec] = [
    CraftSpec(id: "whistles", kicker: "Plate VII", title: "The whistles",
              sub: "Six shapes that carry a mile",
              kind: "whistles",
              notes: [("Shape, not pitch",
                       "The dog learns the shape of the sound: rising, falling, two notes, a long steady tone. Every shepherd's whistles are different, and any dog can learn any set."),
                      ("Why not shout",
                       "A voice is lost at two hundred yards into wind. A whistle on a flat metal reed carries the better part of a mile, and carries the same shape at the far end."),
                      ("The six that matter",
                       "Away, come bye, walk up, steady, lie down, and that'll do. Everything else in shepherding is a variation on those.")]),
    CraftSpec(id: "flight", kicker: "Plate VIII", title: "Flight zone and balance",
              sub: "Why a dog standing still moves a flock",
              kind: "flight",
              notes: [("The flight zone",
                       "A circle of open ground round every animal. Step inside it and the animal moves away; stand on its edge and the animal watches. All stock handling is working that edge."),
                      ("The point of balance",
                       "At the shoulder. A dog behind it drives the sheep forward, a dog in front of it turns them back, and a dog on it holds them. Move a yard and the whole flock answers."),
                      ("What sheep see",
                       "Nearly three hundred degrees of vision, poor depth, and a blind spot straight behind. A dog working the blind spot pushes hardest and is most likely to panic them.")]),
    CraftSpec(id: "breeds", kicker: "Plate IX", title: "How different sheep move",
              sub: "Six breeds and six problems",
              kind: "breeds",
              notes: [("Hill breeds run",
                       "Blackface, Cheviot and Welsh Mountain lift at three hundred yards and keep going. They need a dog that stops early and works far off."),
                      ("Heavy breeds stand",
                       "Herdwicks and Lonks will look at a dog for a long time before moving at all. Pressure has to be held, and released the instant they turn."),
                      ("Horned sheep face up",
                       "A horned ewe with a lamb will stamp and come forward. A dog that gives ground once will be tested by every ewe on the hill afterwards.")]),
    CraftSpec(id: "young", kicker: "Plate X", title: "The young dog",
              sub: "Two years of doing almost nothing",
              kind: "young",
              notes: [("Stop first",
                       "Before a pup is allowed near sheep it must lie down on a whistle every time, anywhere. A dog that will not stop is a danger to the flock and to itself."),
                      ("Small numbers, quiet ground",
                       "Three or four dog-broken ewes in a small paddock. Everything a young dog learns badly there is learned badly for life."),
                      ("Nursery trials",
                       "Run in winter for dogs under three. They exist so that breeders can watch young stock work in public, which is why trials were invented in the first place.")]),
    CraftSpec(id: "card", kicker: "Plate XI", title: "The judge's card",
              sub: "A hundred points, and every one of them taken away",
              kind: "card",
              notes: [("The sections",
                       "Outrun twenty, lift ten, fetch twenty, drive thirty, shed ten, pen ten. Fifteen minutes, and the timekeeper's whistle stops the run where it stands."),
                      ("Deductions only",
                       "The judge begins at a hundred and takes off for every yard off the line, every ignored command and every sheep that breaks away. Nothing is ever added."),
                      ("Grip and retire",
                       "A dog that takes hold is out at once. A handler who sees the run is beyond saving may retire, and it is not thought a disgrace.")]),
    CraftSpec(id: "year", kicker: "Plate XII", title: "The shepherd's year",
              sub: "Twelve months on the same hill",
              kind: "year",
              notes: [("Tupping to lambing",
                       "Rams go out in November, lambs come in April, and everything between is counting, feeding and watching the weather."),
                      ("Marking, clipping, dipping",
                       "Late spring and summer: lambs marked, fleeces off in July, and the flock gathered through the autumn for sales and for winter ground."),
                      ("Gathering",
                       "Three or four full gathers a year, each one a day's work for two shepherds and four dogs across ground no vehicle can reach.")]),
]

func courseFrame(_ p: Sheet, _ box: CGRect, seed: UInt64) {
    p.clipRect(box) {
        p.ctx.setFillColor(cg(Field.turfPale.al(0.30)))
        p.ctx.fill(box)
        var rng = Dice(seed)
        for _ in 0..<Int(Double(box.width) * 0.5) {
            let gx = Double(box.minX) + rng.d() * Double(box.width)
            let gy = Double(box.minY) + rng.d() * Double(box.height)
            pen(p, [pnt(gx, gy), pnt(gx + rng.signed() * 3, gy - rng.r(3, 8))], weight: 0.7,
                colour: Field.turfDark.al(rng.r(0.15, 0.40)), wobble: 0.3, taper: true,
                seed: seed &+ bits(Int(gx)))
        }
    }
    penContour(p, [pnt(Double(box.minX), Double(box.minY)), pnt(Double(box.maxX), Double(box.minY)),
                   pnt(Double(box.maxX), Double(box.maxY)), pnt(Double(box.minX), Double(box.maxY))],
               weight: 2.4, colour: Field.inkSoft, seed: seed &+ 5)
}

func courseGate(_ p: Sheet, at c: CGPoint, width: Double, seed: UInt64) {
    pen(p, [pnt(Double(c.x) - width / 2 - 22, Double(c.y)), pnt(Double(c.x) - width / 2, Double(c.y))],
        weight: 4.0, colour: Field.sepia, wobble: 0.3, taper: false, seed: seed)
    pen(p, [pnt(Double(c.x) + width / 2, Double(c.y)), pnt(Double(c.x) + width / 2 + 22, Double(c.y))],
        weight: 4.0, colour: Field.sepia, wobble: 0.3, taper: false, seed: seed &+ 1)
}

func makeCraftPlate(_ spec: CraftSpec, dir: String) {
    let p = Sheet(1350, 1200)
    let seed = hashOf(spec.id)
    layPaper(p, seed: seed, tone: Field.paperWarm)
    p.topDown()
    p.light = 2.30
    var rng = Dice(seed &+ 3)

    let field = CGRect(x: 150, y: 130, width: 1050, height: 620)

    switch spec.kind {
    case "outrun":
        courseFrame(p, field, seed: seed)
        let post = pnt(Double(field.midX), Double(field.maxY) - 40)
        let sheepAt = pnt(Double(field.midX) + 40, Double(field.minY) + 90)
        p.disc(Double(post.x), Double(post.y), 8, Field.ink)
        caption(p, "post", at: Double(post.x), Double(post.y) + 34, size: 20, colour: Field.inkSoft,
                face: "Georgia-Italic", align: .centre)
        for k in 0..<5 {
            drawSheep(p, at: pnt(Double(sheepAt.x) + Double(k % 3) * 26 - 26,
                                 Double(sheepAt.y) + Double(k / 3) * 22),
                      size: 11, facing: 1.6, seed: seed &+ bits(k))
        }
        for side in 0..<2 {
            let dir = side == 0 ? -1.0 : 1.0
            var path: [CGPoint] = []
            var t = 0.0
            while t <= 1.0 {
                let x = Double(post.x) + dir * sin(t * 3.14) * 380
                let y = Double(post.y) - t * (Double(post.y) - Double(sheepAt.y) - 60)
                path.append(pnt(x, y))
                t += 0.04
            }
            for i in 0..<(path.count - 1) where i % 3 != 2 {
                pen(p, [path[i], path[i + 1]], weight: side == 0 ? 2.6 : 1.6,
                    colour: side == 0 ? Field.oxblood : Field.inkPale.al(0.7),
                    wobble: 0.3, taper: false, seed: seed &+ bits(i &+ side * 50))
            }
            if side == 0 {
                drawDog(p, at: pnt(Double(path[path.count / 2].x), Double(path[path.count / 2].y)),
                        size: 10, facing: 0, seed: seed &+ 41)
            }
        }
        caption(p, "come bye", at: Double(post.x) - 330, Double(post.y) - 240, size: 22,
                colour: Field.oxblood, face: "Georgia-Italic", align: .centre)
        caption(p, "away to me", at: Double(post.x) + 330, Double(post.y) - 240, size: 22,
                colour: Field.inkPale, face: "Georgia-Italic", align: .centre)
    case "lift":
        courseFrame(p, field, seed: seed)
        let flock = pnt(Double(field.midX), Double(field.midY) + 40)
        for k in 0..<5 {
            drawSheep(p, at: pnt(Double(flock.x) + Double(k % 3) * 34 - 34,
                                 Double(flock.y) + Double(k / 3) * 28),
                      size: 15, facing: 1.6, seed: seed &+ bits(k))
        }
        drawDog(p, at: pnt(Double(flock.x), Double(flock.y) - 150), size: 15, facing: 1.6,
                seed: seed &+ 11)
        p.ring(Double(flock.x), Double(flock.y), 190, 1.6, Field.oxblood.al(0.6))
        caption(p, "flight zone", at: Double(flock.x) + 200, Double(flock.y) - 170, size: 21,
                colour: Field.oxblood, face: "Georgia-Italic", align: .left)
        rayArrowWF(p, from: pnt(Double(flock.x), Double(flock.y) + 90),
                   to: pnt(Double(flock.x), Double(flock.y) + 200), colour: Field.inkSoft,
                   seed: seed &+ 13)
        caption(p, "and they walk", at: Double(flock.x) + 20, Double(flock.y) + 190, size: 21,
                colour: Field.inkSoft, face: "Georgia-Italic", align: .left)
        caption(p, "the balance point", at: Double(flock.x), Double(flock.y) - 190, size: 21,
                colour: Field.sepia, face: "Georgia-Italic", align: .centre)
    case "fetch", "drive":
        courseFrame(p, field, seed: seed)
        let post = pnt(Double(field.midX), Double(field.maxY) - 50)
        p.disc(Double(post.x), Double(post.y), 8, Field.ink)
        if spec.kind == "fetch" {
            let top = pnt(Double(field.midX), Double(field.minY) + 60)
            pen(p, [top, post], weight: 2.4, colour: Field.oxblood, wobble: 0.3, taper: false,
                seed: seed &+ 5)
            courseGate(p, at: pnt(Double(field.midX), Double(field.minY) + 220), width: 90,
                       seed: seed &+ 7)
            for k in 0..<5 {
                drawSheep(p, at: pnt(Double(field.midX) + rng.r(-30, 30),
                                     Double(field.minY) + 130 + rng.r(-16, 16)),
                          size: 13, facing: 1.6, seed: seed &+ bits(k))
            }
            drawDog(p, at: pnt(Double(field.midX) + 20, Double(field.minY) + 80), size: 12,
                    facing: 1.6, seed: seed &+ 21)
            caption(p, "fetch gates", at: Double(field.midX) + 130, Double(field.minY) + 214,
                    size: 21, colour: Field.sepia, face: "Georgia-Italic", align: .left)
            caption(p, "round the post", at: Double(post.x) + 30, Double(post.y) - 10, size: 21,
                    colour: Field.inkSoft, face: "Georgia-Italic", align: .left)
        } else {
            let a = pnt(Double(post.x), Double(post.y) - 40)
            let b = pnt(Double(field.maxX) - 160, Double(field.minY) + 200)
            let c = pnt(Double(field.minX) + 160, Double(field.minY) + 200)
            pen(p, [a, b], weight: 2.4, colour: Field.oxblood, wobble: 0.3, taper: false,
                seed: seed &+ 5)
            pen(p, [b, c], weight: 2.4, colour: Field.oxblood, wobble: 0.3, taper: false,
                seed: seed &+ 7)
            pen(p, [c, pnt(Double(post.x) - 40, Double(post.y) - 90)], weight: 2.4,
                colour: Field.oxblood, wobble: 0.3, taper: false, seed: seed &+ 9)
            courseGate(p, at: pnt(Double(b.x) - 40, Double(b.y) + 100), width: 80, seed: seed &+ 11)
            courseGate(p, at: pnt(Double(c.x) + 60, Double(c.y) + 6), width: 80, seed: seed &+ 13)
            caption(p, "drive away", at: Double(b.x) - 210, Double(b.y) + 120, size: 21,
                    colour: Field.sepia, face: "Georgia-Italic", align: .left)
            caption(p, "cross-drive", at: Double(field.midX), Double(field.minY) + 176, size: 21,
                    colour: Field.sepia, face: "Georgia-Italic", align: .centre)
            for k in 0..<4 {
                drawSheep(p, at: pnt(Double(field.midX) + 120 + rng.r(-24, 24),
                                     Double(field.minY) + 240 + rng.r(-16, 16)),
                          size: 12, facing: 3.14, seed: seed &+ bits(k))
            }
            drawDog(p, at: pnt(Double(field.midX) + 210, Double(field.minY) + 250), size: 11,
                    facing: 3.14, seed: seed &+ 31)
        }
    case "shed":
        courseFrame(p, field, seed: seed)
        let cx = Double(field.midX), cy = Double(field.midY)
        var ring: [CGPoint] = []
        var a = 0.0
        while a < 6.283 {
            ring.append(pnt(cx + cos(a) * 240, cy + sin(a) * 150))
            a += 0.16
        }
        for i in 0..<ring.count where i % 2 == 0 {
            pen(p, [ring[i], ring[(i + 1) % ring.count]], weight: 2.0, colour: Field.oat.dk(0.16),
                wobble: 0.4, taper: false, seed: seed &+ bits(i))
        }
        for k in 0..<3 {
            drawSheep(p, at: pnt(cx - 120 + Double(k) * 34, cy + rng.r(-18, 18)), size: 15,
                      facing: 3.14, seed: seed &+ bits(k))
        }
        for k in 0..<2 {
            drawSheep(p, at: pnt(cx + 120 + Double(k) * 34, cy + rng.r(-18, 18)), size: 15,
                      facing: 0, seed: seed &+ bits(k &+ 10))
        }
        drawDog(p, at: pnt(cx, cy - 20), size: 15, facing: 0, seed: seed &+ 21)
        drawShepherd(p, at: pnt(cx - 30, cy + 130), size: 34, seed: seed &+ 23)
        caption(p, "the gap, then the dog", at: cx, cy - 90, size: 22, colour: Field.oxblood,
                face: "Georgia-Italic", align: .centre)
    case "pen":
        courseFrame(p, field, seed: seed)
        let cx = Double(field.midX) + 60, cy = Double(field.midY) + 60
        drawPen(p, at: pnt(cx, cy), size: 150, seed: seed &+ 5)
        drawShepherd(p, at: pnt(cx + 190, cy + 30), size: 40, seed: seed &+ 7)
        pen(p, [pnt(cx + 170, cy - 20), pnt(cx + 210, cy + 10)], weight: 2.0, colour: Field.oat,
            wobble: 0.6, taper: false, seed: seed &+ 9)
        for k in 0..<5 {
            drawSheep(p, at: pnt(cx - 120 + Double(k % 3) * 40, cy + 90 + Double(k / 3) * 34),
                      size: 15, facing: 0, seed: seed &+ bits(k))
        }
        drawDog(p, at: pnt(cx - 240, cy + 120), size: 15, facing: 0, seed: seed &+ 31)
        caption(p, "the rope is never let go", at: cx + 120, cy + 150, size: 21,
                colour: Field.sepia, face: "Georgia-Italic", align: .left)
    case "whistles":
        let names = ["Come bye", "Away to me", "Walk up", "Steady", "Lie down", "That'll do"]
        let shapes = ["rise", "fall", "riseflat", "flat", "fallflat", "risefall"]
        for k in 0..<6 {
            let col = k % 2, row = k / 2
            let bx = 230.0 + Double(col) * 560
            let by = 200.0 + Double(row) * 190
            p.rect(bx - 130, by - 70, 420, 140, Field.paperCool.al(0.5))
            penContour(p, [pnt(bx - 130, by - 70), pnt(bx + 290, by - 70),
                           pnt(bx + 290, by + 70), pnt(bx - 130, by + 70)],
                       weight: 1.2, colour: Field.inkPale, seed: seed &+ bits(k))
            var contour: [CGPoint] = []
            var t = 0.0
            while t <= 1.0 {
                var y = 0.0
                switch shapes[k] {
                case "rise": y = -t * 46
                case "fall": y = -46 + t * 46
                case "riseflat": y = t < 0.5 ? -t * 2 * 46 : -46
                case "flat": y = -22
                case "fallflat": y = t < 0.5 ? -46 + t * 2 * 46 : 0
                default: y = -sin(t * 3.14) * 46
                }
                contour.append(pnt(bx - 100 + t * 300, by + 24 + y))
                t += 0.04
            }
            pen(p, contour, weight: 5.0, colour: Field.oxblood, wobble: 0.3, taper: false,
                seed: seed &+ bits(k &+ 30))
            caption(p, names[k], at: bx - 100, by - 34, size: 26, colour: Field.ink,
                    face: "Georgia-Bold", align: .left)
        }
    case "flight":
        courseFrame(p, field, seed: seed)
        let cx = Double(field.midX), cy = Double(field.midY)
        p.ring(cx, cy, 250, 1.6, Field.oxblood.al(0.7))
        p.ring(cx, cy, 150, 1.2, Field.oxblood.al(0.4))
        drawSheep(p, at: pnt(cx, cy), size: 34, facing: 0, seed: seed &+ 5)
        var blind: [CGPoint] = [pnt(cx, cy)]
        var a = 2.9
        while a < 3.4 {
            blind.append(pnt(cx + cos(a) * 250, cy + sin(a) * 250))
            a += 0.06
        }
        p.poly(blind, Field.inkPale.al(0.22))
        caption(p, "blind spot", at: cx - 300, cy + 10, size: 21, colour: Field.inkSoft,
                face: "Georgia-Italic", align: .centre)
        pen(p, [pnt(cx - 60, cy - 260), pnt(cx - 60, cy + 260)], weight: 1.4,
            colour: Field.sepia.al(0.8), wobble: 0.3, taper: false, seed: seed &+ 7)
        caption(p, "point of balance", at: cx - 60, cy - 280, size: 21, colour: Field.sepia,
                face: "Georgia-Italic", align: .centre)
        drawDog(p, at: pnt(cx + 200, cy + 120), size: 16, facing: 3.14, seed: seed &+ 9)
        caption(p, "behind it: they walk on", at: cx + 200, cy + 190, size: 20,
                colour: Field.inkSoft, face: "Georgia-Italic", align: .centre)
    case "breeds":
        let names = ["Swaledale", "Herdwick", "Cheviot", "Welsh Mountain", "Blackface", "Lonk"]
        for k in 0..<6 {
            let col = k % 3, row = k / 3
            let bx = 300.0 + Double(col) * 380
            let by = 260.0 + Double(row) * 280
            drawSheep(p, at: pnt(bx, by), size: 46, facing: 0, seed: seed &+ bits(k))
            if k == 0 || k == 4 {
                for side in 0..<2 {
                    let dir = side == 0 ? -1.0 : 1.0
                    var horn: [CGPoint] = []
                    var a = 0.0
                    while a < 4.4 {
                        horn.append(pnt(bx + 50 + dir * 10 + cos(a + 1.2) * (14 + a * 4),
                                        by - 16 + sin(a + 1.2) * (12 + a * 3)))
                        a += 0.3
                    }
                    pen(p, horn, weight: 4.0, colour: Field.bone.dk(0.10), wobble: 0.3,
                        taper: true, seed: seed &+ bits(k &+ side * 9))
                }
            }
            caption(p, names[k], at: bx, by + 96, size: 23, colour: Field.inkSoft,
                    face: "Georgia", align: .centre)
        }
    case "young":
        courseFrame(p, field, seed: seed)
        drawShepherd(p, at: pnt(Double(field.minX) + 220, Double(field.maxY) - 90), size: 48,
                     seed: seed &+ 5)
        drawDog(p, at: pnt(Double(field.minX) + 340, Double(field.maxY) - 110), size: 18,
                facing: 0, seed: seed &+ 7)
        for k in 0..<3 {
            drawSheep(p, at: pnt(Double(field.midX) + 160 + Double(k) * 44,
                                 Double(field.midY) + rng.r(-30, 30)),
                      size: 18, facing: 3.14, seed: seed &+ bits(k))
        }
        pen(p, [pnt(Double(field.minX) + 360, Double(field.maxY) - 120),
                pnt(Double(field.midX) + 120, Double(field.midY) + 20)], weight: 2.0,
            colour: Field.oxblood.al(0.6), wobble: 0.4, taper: false, seed: seed &+ 9)
        caption(p, "three quiet ewes and a small field", at: Double(field.minX) + 60,
                Double(field.maxY) + 40, size: 22, colour: Field.sepia,
                face: "Georgia-Italic", align: .left)
    case "card":
        p.rect(300, 150, 750, 620, Field.paperCool.al(0.7))
        penContour(p, [pnt(300, 150), pnt(1050, 150), pnt(1050, 770), pnt(300, 770)],
                   weight: 2.4, colour: Field.ink, seed: seed &+ 5)
        caption(p, "JUDGE'S CARD", at: 675, 200, size: 26, colour: Field.ink,
                face: "Georgia-Bold", align: .centre, tracking: 3)
        let rows = [("Outrun", "20"), ("Lift", "10"), ("Fetch", "20"), ("Drive", "30"),
                    ("Shed", "10"), ("Pen", "10")]
        var y = 270.0
        for (name, points) in rows {
            caption(p, name, at: 350, y, size: 24, colour: Field.inkSoft, face: "Georgia",
                    align: .left)
            caption(p, points, at: 700, y, size: 24, colour: Field.inkSoft, face: "Georgia",
                    align: .centre)
            var dashes = 0.0
            while dashes < 200 {
                pen(p, [pnt(760 + dashes, y + 6), pnt(770 + dashes, y + 6)], weight: 1.0,
                    colour: Field.inkPale, wobble: 0.2, taper: false, seed: seed &+ bits(Int(dashes)))
                dashes += 20
            }
            pen(p, [pnt(340, y + 20), pnt(1010, y + 20)], weight: 0.8, colour: Field.inkPale.al(0.5),
                wobble: 0.3, taper: false, seed: seed &+ bits(Int(y)))
            y += 76
        }
        caption(p, "100", at: 700, y + 10, size: 26, colour: Field.oxblood, face: "Georgia-Bold",
                align: .centre)
        caption(p, "Total", at: 350, y + 10, size: 26, colour: Field.ink, face: "Georgia-Bold",
                align: .left)
    default:
        let cx = Double(field.midX), cy = Double(field.midY)
        p.ring(cx, cy, 250, 2.4, Field.ink)
        p.ring(cx, cy, 196, 1.2, Field.inkPale)
        let months = ["Tupping", "", "Winter feed", "", "Lambing", "", "Marking", "",
                      "Clipping", "", "Gathering", "Sales"]
        for k in 0..<12 {
            let a = Double(k) / 12 * 6.283 - 1.5708
            pen(p, [pnt(cx + cos(a) * 196, cy + sin(a) * 196),
                    pnt(cx + cos(a) * 250, cy + sin(a) * 250)], weight: 1.4,
                colour: Field.inkPale, wobble: 0.2, taper: false, seed: seed &+ bits(k))
            if !months[k].isEmpty {
                let mid = a + 6.283 / 24
                caption(p, months[k], at: cx + cos(mid) * 300, cy + sin(mid) * 300, size: 22,
                        colour: Field.inkSoft, face: "Georgia", align: .centre)
            }
        }
        drawSheep(p, at: pnt(cx, cy), size: 40, facing: 0, seed: seed &+ 11)
    }

    caption(p, spec.kicker.uppercased(), at: 120, 88, size: 20, colour: Field.oxblood,
            face: "Georgia-Bold", align: .left, tracking: 3.4)
    caption(p, spec.title, at: 120, 830, size: 50, colour: Field.ink, face: "Georgia-Bold", align: .left)
    caption(p, spec.sub, at: 120, 868, size: 25, colour: Field.inkPale, face: "Georgia-Italic",
            align: .left)

    var ty = 920.0
    for note in spec.notes {
        caption(p, note.0.uppercased(), at: 120, ty, size: 18, colour: Field.sepia,
                face: "Georgia-Bold", align: .left, tracking: 2.4)
        ty += 28
        for line in wrapText(note.1, width: 1110, size: 22) {
            caption(p, line, at: 120, ty, size: 22, colour: Field.inkSoft, face: "Georgia",
                    align: .left)
            ty += 28
        }
        ty += 10
    }

    plateFrame(p, inset: 44, seed: seed &+ 99)
    p.write(dir, "craft_" + spec.id, quality: 0.93)
}

func rayArrowWF(_ p: Sheet, from a: CGPoint, to b: CGPoint, colour: Tone, seed: UInt64) {
    pen(p, [a, b], weight: 2.0, colour: colour, wobble: 0.4, taper: false, seed: seed)
    let ang = atan2(Double(b.y - a.y), Double(b.x - a.x))
    let h = 13.0
    p.poly([b, pnt(Double(b.x) - cos(ang - 0.4) * h, Double(b.y) - sin(ang - 0.4) * h),
            pnt(Double(b.x) - cos(ang + 0.4) * h, Double(b.y) - sin(ang + 0.4) * h)], colour)
}

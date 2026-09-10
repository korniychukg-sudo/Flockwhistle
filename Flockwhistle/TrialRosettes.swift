import SwiftUI

struct TrialHonour: Identifiable {
    let id: String
    let title: String
    let note: String
    let emblem: String
    let test: (TrialStore) -> Bool
}

enum HonourBoard {
    static let all: [TrialHonour] = setA + setB

    private static let setA: [TrialHonour] = [
        TrialHonour(id: "first_run", title: "First Run Out",
                    note: "Take one dog to the post and bring the sheep round the course. Nobody's first run is quiet.",
                    emblem: "post") { $0.runs >= 1 },
        TrialHonour(id: "clean_outrun", title: "A Clean Outrun",
                    note: "Ninety for the outrun. Wide enough that the sheep never lifted their heads until the dog was behind them.",
                    emblem: "outrun") { store in store.cards.values.contains { $0.outrun >= 0.90 } },
        TrialHonour(id: "quiet_lift", title: "A Quiet Lift",
                    note: "Ninety for the lift. The dog came onto them slowly and they walked off the top on their own.",
                    emblem: "lift") { store in store.cards.values.contains { $0.lift >= 0.90 } },
        TrialHonour(id: "straight_fetch", title: "Straight Down the Fetch",
                    note: "Ninety for the fetch. A line drawn from the top of the field to the handler's feet.",
                    emblem: "fetch") { store in store.cards.values.contains { $0.fetch >= 0.90 } },
        TrialHonour(id: "good_drive", title: "The Drive Held",
                    note: "Ninety for the drive. Away from the handler and through the gates, which is the hardest thing a young dog learns.",
                    emblem: "gate") { store in store.cards.values.contains { $0.drive >= 0.90 } },
        TrialHonour(id: "cross_drive", title: "Across the Field",
                    note: "Ninety for the cross drive. The line stayed square all the way to the far gates.",
                    emblem: "cross") { store in store.cards.values.contains { $0.crossDrive >= 0.90 } },
        TrialHonour(id: "clean_shed", title: "A Clean Shed",
                    note: "Ninety for the shed. Into the ring, the gap opened, and the dog came through it without a wasted step.",
                    emblem: "shed") { store in store.cards.values.contains { $0.shed >= 0.90 } },
        TrialHonour(id: "first_pen", title: "The Gate Shut",
                    note: "Ninety for the pen. Rope in hand, gate swung, and all of them inside without a break.",
                    emblem: "pen") { store in store.cards.values.contains { $0.pen >= 0.90 } },
    ]

    private static let setB: [TrialHonour] = [
        TrialHonour(id: "first_a", title: "Graded A",
                    note: "One card graded A by the judge. He watches the sheep, not the dog, and he does not flatter.",
                    emblem: "card") { store in store.cards.values.contains { $0.grade == "A" } },
        TrialHonour(id: "ninety", title: "Ninety of a Hundred",
                    note: "Ninety points on one card. There are open handlers who wait years for that number.",
                    emblem: "rosette") { $0.bestTotal >= 90 },
        TrialHonour(id: "three_days", title: "Three Mornings Running",
                    note: "Three days out on the hill in a row. The dog settles when the routine does.",
                    emblem: "streak") { $0.bestStreak >= 3 },
        TrialHonour(id: "fortnight", title: "A Fortnight on the Hill",
                    note: "Fourteen days in a row. This is the part of the work nobody photographs.",
                    emblem: "calendar") { $0.bestStreak >= 14 },
        TrialHonour(id: "thousand_whistles", title: "A Thousand Whistles",
                    note: "A thousand commands blown. Somewhere in there the whistle stopped being a thing you thought about.",
                    emblem: "whistle") { $0.whistles >= 1000 },
        TrialHonour(id: "twenty_pens", title: "Twenty Penned",
                    note: "Twenty flocks put in the pen. The gate is where a good run is usually lost.",
                    emblem: "hurdle") { $0.pens >= 20 },
        TrialHonour(id: "shelf_read", title: "The Shelf Read",
                    note: "All twelve plates opened. Commands, flanks, the shed ring and the balance point.",
                    emblem: "book") { $0.plateRead.count >= 12 },
        TrialHonour(id: "every_field", title: "Every Field Run",
                    note: "A card at every field in the book, from a bare park to the open hill.",
                    emblem: "hills") { $0.cardCount >= FieldBook.all.count },
    ]
}

struct HonourEmblem: View {
    let kind: String
    let earned: Bool
    var size: CGFloat = 74

    private var ink: Color { earned ? Hill.ink : Hill.inkPale.opacity(0.38) }
    private var red: Color { earned ? Hill.rosetteRed : Hill.inkPale.opacity(0.30) }
    private var blue: Color { earned ? Hill.rosetteBlue : Hill.inkPale.opacity(0.28) }
    private var wool: Color { earned ? Hill.fleece : Hill.inkPale.opacity(0.24) }
    private var green: Color { earned ? Hill.moss : Hill.inkPale.opacity(0.26) }

    var body: some View {
        Canvas { ctx, s in
            draw(&ctx, s)
        }
        .frame(width: size, height: size)
    }

    private func draw(_ ctx: inout GraphicsContext, _ s: CGSize) {
        let w = s.width, h = s.height
        var field = Path()
        field.addRoundedRect(in: CGRect(origin: .zero, size: s),
                             cornerSize: CGSize(width: w * 0.14, height: w * 0.14))
        ctx.fill(field, with: .linearGradient(
            Gradient(colors: earned
                     ? [Hill.canvasWarm, Hill.canvasSunk]
                     : [Hill.canvasSunk.opacity(0.5), Hill.canvasSunk.opacity(0.28)]),
            startPoint: .zero, endPoint: CGPoint(x: w, y: h)))
        ctx.stroke(field, with: .color(earned ? Hill.rosetteRed.opacity(0.62) : Hill.hairline),
                   lineWidth: earned ? 2 : 1)

        switch kind {
        case "post":
            var post = Path()
            post.move(to: CGPoint(x: w * 0.32, y: h * 0.18))
            post.addLine(to: CGPoint(x: w * 0.32, y: h * 0.84))
            ctx.stroke(post, with: .color(ink), lineWidth: w * 0.06)
            var flag = Path()
            flag.move(to: CGPoint(x: w * 0.35, y: h * 0.20))
            flag.addLine(to: CGPoint(x: w * 0.82, y: h * 0.30))
            flag.addLine(to: CGPoint(x: w * 0.35, y: h * 0.44))
            flag.closeSubpath()
            ctx.fill(flag, with: .color(red))
            var ground = Path()
            ground.move(to: CGPoint(x: w * 0.14, y: h * 0.84))
            ground.addQuadCurve(to: CGPoint(x: w * 0.86, y: h * 0.80),
                                control: CGPoint(x: w * 0.50, y: h * 0.90))
            ctx.stroke(ground, with: .color(green), lineWidth: w * 0.045)
        case "outrun":
            var path = Path()
            path.move(to: CGPoint(x: w * 0.50, y: h * 0.84))
            path.addCurve(to: CGPoint(x: w * 0.52, y: h * 0.20),
                          control1: CGPoint(x: w * 0.06, y: h * 0.72),
                          control2: CGPoint(x: w * 0.10, y: h * 0.20))
            ctx.stroke(path, with: .color(ink), style: StrokeStyle(lineWidth: w * 0.045,
                                                                   dash: [w * 0.09, w * 0.06]))
            var sheepPath = Path()
            sheepPath.addEllipse(in: CGRect(x: w * 0.60, y: h * 0.14, width: w * 0.24, height: h * 0.16))
            ctx.fill(sheepPath, with: .color(wool))
            ctx.stroke(sheepPath, with: .color(ink), lineWidth: w * 0.022)
            var dog = Path()
            dog.addEllipse(in: CGRect(x: w * 0.42, y: h * 0.74, width: w * 0.18, height: h * 0.12))
            ctx.fill(dog, with: .color(ink))
        case "lift":
            var sheepPath = Path()
            for i in 0..<3 {
                sheepPath.addEllipse(in: CGRect(x: w * (0.22 + Double(i) * 0.20), y: h * 0.30,
                                                width: w * 0.20, height: h * 0.15))
            }
            ctx.fill(sheepPath, with: .color(wool))
            ctx.stroke(sheepPath, with: .color(ink), lineWidth: w * 0.022)
            var dog = Path()
            dog.move(to: CGPoint(x: w * 0.50, y: h * 0.86))
            dog.addLine(to: CGPoint(x: w * 0.62, y: h * 0.72))
            dog.addLine(to: CGPoint(x: w * 0.38, y: h * 0.72))
            dog.closeSubpath()
            ctx.fill(dog, with: .color(ink))
            var eye = Path()
            eye.move(to: CGPoint(x: w * 0.50, y: h * 0.70))
            eye.addLine(to: CGPoint(x: w * 0.50, y: h * 0.50))
            ctx.stroke(eye, with: .color(red.opacity(0.8)),
                       style: StrokeStyle(lineWidth: w * 0.028, dash: [w * 0.05, w * 0.04]))
        case "fetch":
            var line = Path()
            line.move(to: CGPoint(x: w * 0.50, y: h * 0.14))
            line.addLine(to: CGPoint(x: w * 0.50, y: h * 0.86))
            ctx.stroke(line, with: .color(ink), lineWidth: w * 0.05)
            for i in 0..<3 {
                var sheepPath = Path()
                sheepPath.addEllipse(in: CGRect(x: w * 0.38, y: h * (0.24 + Double(i) * 0.22),
                                                width: w * 0.24, height: h * 0.14))
                ctx.fill(sheepPath, with: .color(wool))
                ctx.stroke(sheepPath, with: .color(ink), lineWidth: w * 0.02)
            }
        case "gate":
            for x in [0.22, 0.72] {
                var postPath = Path()
                postPath.addRect(CGRect(x: w * x, y: h * 0.26, width: w * 0.07, height: h * 0.56))
                ctx.fill(postPath, with: .color(earned ? Hill.sepia : Hill.inkPale.opacity(0.3)))
            }
            var arrow = Path()
            arrow.move(to: CGPoint(x: w * 0.34, y: h * 0.54))
            arrow.addLine(to: CGPoint(x: w * 0.66, y: h * 0.54))
            ctx.stroke(arrow, with: .color(ink), lineWidth: w * 0.05)
            var headPath = Path()
            headPath.move(to: CGPoint(x: w * 0.72, y: h * 0.54))
            headPath.addLine(to: CGPoint(x: w * 0.56, y: h * 0.44))
            headPath.addLine(to: CGPoint(x: w * 0.56, y: h * 0.64))
            headPath.closeSubpath()
            ctx.fill(headPath, with: .color(ink))
        case "cross":
            var line = Path()
            line.move(to: CGPoint(x: w * 0.14, y: h * 0.62))
            line.addLine(to: CGPoint(x: w * 0.86, y: h * 0.38))
            ctx.stroke(line, with: .color(ink), lineWidth: w * 0.045)
            for x in [0.16, 0.80] {
                var postPath = Path()
                postPath.addRect(CGRect(x: w * x, y: h * (x < 0.5 ? 0.52 : 0.28),
                                        width: w * 0.06, height: h * 0.22))
                ctx.fill(postPath, with: .color(earned ? Hill.sepia : Hill.inkPale.opacity(0.3)))
            }
            var sheepPath = Path()
            sheepPath.addEllipse(in: CGRect(x: w * 0.44, y: h * 0.42, width: w * 0.22, height: h * 0.14))
            ctx.fill(sheepPath, with: .color(wool))
            ctx.stroke(sheepPath, with: .color(ink), lineWidth: w * 0.02)
        case "shed":
            var ringPath = Path()
            ringPath.addEllipse(in: CGRect(x: w * 0.12, y: h * 0.26, width: w * 0.76, height: h * 0.52))
            ctx.stroke(ringPath, with: .color(earned ? Hill.oat : Hill.inkPale.opacity(0.26)),
                       style: StrokeStyle(lineWidth: w * 0.035, dash: [w * 0.07, w * 0.05]))
            for x in [0.24, 0.38] {
                var sheepPath = Path()
                sheepPath.addEllipse(in: CGRect(x: w * x, y: h * 0.44, width: w * 0.16, height: h * 0.12))
                ctx.fill(sheepPath, with: .color(wool))
                ctx.stroke(sheepPath, with: .color(ink), lineWidth: w * 0.02)
            }
            for x in [0.60, 0.74] {
                var sheepPath = Path()
                sheepPath.addEllipse(in: CGRect(x: w * x, y: h * 0.44, width: w * 0.16, height: h * 0.12))
                ctx.fill(sheepPath, with: .color(wool))
                ctx.stroke(sheepPath, with: .color(ink), lineWidth: w * 0.02)
            }
            var gap = Path()
            gap.move(to: CGPoint(x: w * 0.53, y: h * 0.28))
            gap.addLine(to: CGPoint(x: w * 0.53, y: h * 0.76))
            ctx.stroke(gap, with: .color(red), lineWidth: w * 0.035)
        case "pen":
            var hurdle = Path()
            hurdle.addRect(CGRect(x: w * 0.22, y: h * 0.36, width: w * 0.56, height: h * 0.42))
            ctx.stroke(hurdle, with: .color(earned ? Hill.sepia : Hill.inkPale.opacity(0.3)),
                       lineWidth: w * 0.05)
            for i in 1..<3 {
                var bar = Path()
                bar.move(to: CGPoint(x: w * 0.22, y: h * (0.36 + Double(i) * 0.14)))
                bar.addLine(to: CGPoint(x: w * 0.78, y: h * (0.36 + Double(i) * 0.14)))
                ctx.stroke(bar, with: .color(earned ? Hill.sepia.opacity(0.7)
                                             : Hill.inkPale.opacity(0.22)), lineWidth: w * 0.03)
            }
            var gatePath = Path()
            gatePath.move(to: CGPoint(x: w * 0.22, y: h * 0.36))
            gatePath.addLine(to: CGPoint(x: w * 0.06, y: h * 0.22))
            ctx.stroke(gatePath, with: .color(ink), lineWidth: w * 0.045)
        case "card":
            var sheet = Path()
            sheet.addRect(CGRect(x: w * 0.22, y: h * 0.16, width: w * 0.56, height: h * 0.68))
            ctx.fill(sheet, with: .color(earned ? Hill.canvasWarm : Hill.canvasSunk.opacity(0.4)))
            ctx.stroke(sheet, with: .color(ink), lineWidth: w * 0.03)
            for i in 0..<4 {
                var rule = Path()
                rule.move(to: CGPoint(x: w * 0.28, y: h * (0.34 + Double(i) * 0.12)))
                rule.addLine(to: CGPoint(x: w * 0.72, y: h * (0.34 + Double(i) * 0.12)))
                ctx.stroke(rule, with: .color(ink.opacity(0.4)), lineWidth: w * 0.02)
            }
            var mark = Path()
            mark.move(to: CGPoint(x: w * 0.34, y: h * 0.26))
            mark.addLine(to: CGPoint(x: w * 0.66, y: h * 0.26))
            ctx.stroke(mark, with: .color(red), lineWidth: w * 0.035)
        case "rosette":
            for i in 0..<9 {
                let a = Double(i) * Double.pi * 2 / 9
                var petal = Path()
                let px: CGFloat = w * 0.50 + CGFloat(cos(a)) * w * 0.24
                let py: CGFloat = h * 0.44 + CGFloat(sin(a)) * w * 0.24
                petal.move(to: CGPoint(x: w * 0.50, y: h * 0.44))
                petal.addLine(to: CGPoint(x: px, y: py))
                ctx.stroke(petal, with: .color(i % 2 == 0 ? red : blue), lineWidth: w * 0.09)
            }
            var tailA = Path()
            tailA.move(to: CGPoint(x: w * 0.42, y: h * 0.60))
            tailA.addLine(to: CGPoint(x: w * 0.34, y: h * 0.90))
            tailA.addLine(to: CGPoint(x: w * 0.50, y: h * 0.82))
            tailA.closeSubpath()
            var tailB = Path()
            tailB.move(to: CGPoint(x: w * 0.58, y: h * 0.60))
            tailB.addLine(to: CGPoint(x: w * 0.66, y: h * 0.90))
            tailB.addLine(to: CGPoint(x: w * 0.50, y: h * 0.82))
            tailB.closeSubpath()
            ctx.fill(tailA, with: .color(red))
            ctx.fill(tailB, with: .color(blue))
        case "streak":
            for i in 0..<3 {
                var bar = Path()
                let x = w * (0.22 + Double(i) * 0.22)
                bar.addRect(CGRect(x: x, y: h * (0.62 - Double(i) * 0.14),
                                   width: w * 0.14, height: h * (0.24 + Double(i) * 0.14)))
                ctx.fill(bar, with: .color(i == 2 ? red : ink.opacity(0.65)))
            }
        case "calendar":
            var sheet = Path()
            sheet.addRect(CGRect(x: w * 0.18, y: h * 0.22, width: w * 0.64, height: h * 0.58))
            ctx.stroke(sheet, with: .color(ink), lineWidth: w * 0.04)
            for r in 0..<3 {
                for c in 0..<4 {
                    var cell = Path()
                    cell.addRect(CGRect(x: w * (0.24 + Double(c) * 0.14),
                                        y: h * (0.32 + Double(r) * 0.15),
                                        width: w * 0.09, height: h * 0.09))
                    ctx.fill(cell, with: .color((r * 4 + c) % 3 == 0 ? red : ink.opacity(0.3)))
                }
            }
        case "whistle":
            var bodyPath = Path()
            bodyPath.move(to: CGPoint(x: w * 0.18, y: h * 0.42))
            bodyPath.addLine(to: CGPoint(x: w * 0.70, y: h * 0.34))
            bodyPath.addLine(to: CGPoint(x: w * 0.70, y: h * 0.62))
            bodyPath.addLine(to: CGPoint(x: w * 0.18, y: h * 0.56))
            bodyPath.closeSubpath()
            ctx.fill(bodyPath, with: .linearGradient(
                Gradient(colors: [earned ? Hill.stone : Hill.inkPale.opacity(0.26),
                                  earned ? Hill.stoneDark : Hill.inkPale.opacity(0.18)]),
                startPoint: CGPoint(x: 0, y: h * 0.34), endPoint: CGPoint(x: 0, y: h * 0.62)))
            ctx.stroke(bodyPath, with: .color(ink), lineWidth: w * 0.025)
            var hole = Path()
            hole.addRect(CGRect(x: w * 0.34, y: h * 0.44, width: w * 0.14, height: h * 0.07))
            ctx.fill(hole, with: .color(ink))
            for i in 0..<3 {
                var arc = Path()
                let r = w * (0.14 + Double(i) * 0.09)
                arc.addArc(center: CGPoint(x: w * 0.72, y: h * 0.48), radius: r,
                           startAngle: .degrees(-48), endAngle: .degrees(48), clockwise: false)
                ctx.stroke(arc, with: .color(red.opacity(0.75 - Double(i) * 0.2)),
                           lineWidth: w * 0.03)
            }
        case "hurdle":
            for i in 0..<3 {
                var panel = Path()
                let x = w * (0.10 + Double(i) * 0.28)
                panel.addRect(CGRect(x: x, y: h * 0.36, width: w * 0.24, height: h * 0.42))
                ctx.stroke(panel, with: .color(earned ? Hill.sepia : Hill.inkPale.opacity(0.28)),
                           lineWidth: w * 0.035)
                var bar = Path()
                bar.move(to: CGPoint(x: x, y: h * 0.56))
                bar.addLine(to: CGPoint(x: x + w * 0.24, y: h * 0.56))
                ctx.stroke(bar, with: .color(earned ? Hill.sepia.opacity(0.7)
                                             : Hill.inkPale.opacity(0.2)), lineWidth: w * 0.025)
            }
        case "book":
            var left = Path()
            left.move(to: CGPoint(x: w * 0.12, y: h * 0.30))
            left.addQuadCurve(to: CGPoint(x: w * 0.50, y: h * 0.34),
                              control: CGPoint(x: w * 0.30, y: h * 0.24))
            left.addLine(to: CGPoint(x: w * 0.50, y: h * 0.78))
            left.addQuadCurve(to: CGPoint(x: w * 0.12, y: h * 0.72),
                              control: CGPoint(x: w * 0.30, y: h * 0.70))
            left.closeSubpath()
            var right = Path()
            right.move(to: CGPoint(x: w * 0.88, y: h * 0.30))
            right.addQuadCurve(to: CGPoint(x: w * 0.50, y: h * 0.34),
                               control: CGPoint(x: w * 0.70, y: h * 0.24))
            right.addLine(to: CGPoint(x: w * 0.50, y: h * 0.78))
            right.addQuadCurve(to: CGPoint(x: w * 0.88, y: h * 0.72),
                               control: CGPoint(x: w * 0.70, y: h * 0.70))
            right.closeSubpath()
            ctx.fill(left, with: .color(earned ? Hill.canvasWarm : Hill.canvasSunk.opacity(0.35)))
            ctx.fill(right, with: .color(earned ? Hill.canvas : Hill.canvasSunk.opacity(0.25)))
            ctx.stroke(left, with: .color(ink), lineWidth: w * 0.028)
            ctx.stroke(right, with: .color(ink), lineWidth: w * 0.028)
        case "hills":
            var far = Path()
            far.move(to: CGPoint(x: w * 0.06, y: h * 0.62))
            far.addLine(to: CGPoint(x: w * 0.34, y: h * 0.30))
            far.addLine(to: CGPoint(x: w * 0.58, y: h * 0.58))
            far.addLine(to: CGPoint(x: w * 0.78, y: h * 0.34))
            far.addLine(to: CGPoint(x: w * 0.94, y: h * 0.60))
            far.addLine(to: CGPoint(x: w * 0.94, y: h * 0.84))
            far.addLine(to: CGPoint(x: w * 0.06, y: h * 0.84))
            far.closeSubpath()
            ctx.fill(far, with: .color(green.opacity(0.75)))
            ctx.stroke(far, with: .color(ink), lineWidth: w * 0.028)
            var wall = Path()
            wall.move(to: CGPoint(x: w * 0.10, y: h * 0.78))
            wall.addQuadCurve(to: CGPoint(x: w * 0.90, y: h * 0.72),
                              control: CGPoint(x: w * 0.50, y: h * 0.86))
            ctx.stroke(wall, with: .color(earned ? Hill.stone : Hill.inkPale.opacity(0.28)),
                       lineWidth: w * 0.04)
        default:
            var ribbon = Path()
            ribbon.move(to: CGPoint(x: w * 0.34, y: h * 0.14))
            ribbon.addLine(to: CGPoint(x: w * 0.66, y: h * 0.14))
            ribbon.addLine(to: CGPoint(x: w * 0.62, y: h * 0.42))
            ribbon.addLine(to: CGPoint(x: w * 0.38, y: h * 0.42))
            ribbon.closeSubpath()
            ctx.fill(ribbon, with: .color(red))
            var plate = Path()
            plate.move(to: CGPoint(x: w * 0.50, y: h * 0.34))
            plate.addLine(to: CGPoint(x: w * 0.80, y: h * 0.58))
            plate.addLine(to: CGPoint(x: w * 0.50, y: h * 0.86))
            plate.addLine(to: CGPoint(x: w * 0.20, y: h * 0.58))
            plate.closeSubpath()
            ctx.fill(plate, with: .color(earned ? Hill.brass : Hill.inkPale.opacity(0.26)))
            ctx.stroke(plate, with: .color(ink), lineWidth: w * 0.024)
        }
    }
}

struct HonourCaseView: View {
    @EnvironmentObject var store: TrialStore
    @State private var selected: TrialHonour?

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            CanvasCard(padding: 12) {
                VStack(alignment: .leading, spacing: 8) {
                    FieldHead(title: "The honours board",
                              note: "\(store.earnedHonours.count) of \(HonourBoard.all.count) won")
                    Text("What the society has written against your name. Every line of it was run on a field with sheep that did not care.")
                        .font(Slate.body(13)).foregroundColor(Hill.inkSoft)
                        .fixedSize(horizontal: false, vertical: true)
                    PointRow(label: "Won", value: Double(store.earnedHonours.count)
                             / Double(HonourBoard.all.count),
                             maxPoints: HonourBoard.all.count, tint: Hill.rosetteRed)
                }
            }

            let columns = Pitch.isPad ? 5 : 4
            let rows = (HonourBoard.all.count + columns - 1) / columns
            VStack(spacing: 10) {
                ForEach(0..<rows, id: \.self) { r in
                    HStack(spacing: 10) {
                        ForEach(0..<columns, id: \.self) { c in
                            let index = r * columns + c
                            if index < HonourBoard.all.count {
                                let honour = HonourBoard.all[index]
                                Button(action: { Nudge.light(); selected = honour }) {
                                    HonourEmblem(kind: honour.emblem,
                                                 earned: store.earnedHonours.contains(honour.id),
                                                 size: Pitch.isPad ? 92 : 74)
                                }
                                .buttonStyle(.plain)
                            } else {
                                Color.clear.frame(width: 74, height: 74)
                            }
                        }
                    }
                }
            }
            .frame(maxWidth: .infinity)
        }
        .sheet(isPresented: Binding(get: { selected != nil },
                                    set: { if !$0 { selected = nil } })) {
            if let honour = selected {
                HonourSheet(honour: honour, earned: store.earnedHonours.contains(honour.id)) {
                    selected = nil
                }
            }
        }
    }
}

struct HonourSheet: View {
    let honour: TrialHonour
    let earned: Bool
    let onClose: () -> Void

    var body: some View {
        ZStack {
            HillLayer(name: "bg_turf", fallback: Hill.turfDark).ignoresSafeArea()
            Color.black.opacity(0.18).ignoresSafeArea()
            VStack(spacing: 18) {
                HStack {
                    Spacer()
                    Button(action: { Nudge.light(); onClose() }) {
                        ShutMark(size: 16, color: Hill.canvas)
                            .padding(9).background(Circle().fill(Color.black.opacity(0.24)))
                    }
                    .buttonStyle(.plain)
                }
                HonourEmblem(kind: honour.emblem, earned: earned, size: 148)
                Text(honour.title).font(Slate.title(24)).foregroundColor(Hill.canvas)
                    .multilineTextAlignment(.center)
                Text(honour.note).font(Slate.body(16)).foregroundColor(Hill.canvas.opacity(0.82))
                    .multilineTextAlignment(.center)
                    .fixedSize(horizontal: false, vertical: true)
                    .padding(.horizontal, 18)
                Text(earned ? "On the board" : "Not won yet")
                    .font(Slate.italic(13))
                    .foregroundColor(earned ? Hill.oat : Hill.canvas.opacity(0.55))
                Spacer()
                GateButton(title: "Close", tint: Hill.slate) { onClose() }
                    .padding(.bottom, 24)
            }
            .padding(.horizontal, Pitch.gutter)
            .padding(.top, 14)
            .centreColumn()
        }
    }
}

struct HonourToast: View {
    let honour: TrialHonour
    let onDismiss: () -> Void
    @State private var shown = false

    var body: some View {
        ZStack {
            Color.black.opacity(0.58).ignoresSafeArea()
                .onTapGesture { onDismiss() }
            VStack(spacing: 14) {
                HonourEmblem(kind: honour.emblem, earned: true, size: 120)
                    .scaleEffect(shown ? 1 : 0.7)
                    .rotationEffect(.degrees(shown ? 0 : -10))
                Text("Onto the board").font(Slate.title(12)).tracking(2.8)
                    .foregroundColor(Hill.oat)
                Text(honour.title).font(Slate.title(24)).foregroundColor(Hill.canvas)
                    .multilineTextAlignment(.center)
                Text(honour.note).font(Slate.body(15)).foregroundColor(Hill.canvas.opacity(0.84))
                    .multilineTextAlignment(.center)
                    .fixedSize(horizontal: false, vertical: true)
                    .padding(.horizontal, 26)
                SmallGateButton(title: "Good lad") { onDismiss() }
                    .padding(.top, 4)
            }
            .padding(.vertical, 26)
            .opacity(shown ? 1 : 0)
        }
        .onAppear {
            withAnimation(.spring(response: 0.5, dampingFraction: 0.62)) { shown = true }
            Nudge.heavy()
        }
    }
}

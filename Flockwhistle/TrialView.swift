import SwiftUI

struct TrialView: View {
    let field: TrialField
    let meet: DayCard?
    var drill: Bool = false
    let onClose: () -> Void

    @EnvironmentObject var store: TrialStore
    @StateObject private var sim = FlockSim()

    @State private var phase: TrialPhase = .waiting
    @State private var elapsed: Double = 0
    @State private var phaseSamples: [TrialPhase: [Double]] = [:]
    @State private var gatesTaken: [Bool] = [false, false, false]
    @State private var crossed = false
    @State private var drillPoints = 0
    @State private var drillQuality: Double = 0
    @State private var freshHonours: [TrialHonour] = []
    @State private var drillOutrun: Double = 0
    @State private var drillLift: Double = 0
    @State private var drillFetch: Double = 0
    @State private var outrunWidth: Double = 0
    @State private var sentSide: DogCommand = .comeBye
    @State private var strokePoints: [CGPoint] = []
    @State private var lastCommandName: String = ""
    @State private var commandCount = 0
    @State private var shedDone = false
    @State private var penned = false
    @State private var result: TrialResult?
    @State private var improved = false
    @State private var showLeave = false
    @State private var retired = false

    private let tick = Timer.publish(every: 1.0 / 30.0, on: .main, in: .common).autoconnect()
    private let course = TrialCourse()
    private let limit: Double = 240

    var body: some View {
        ZStack {
            HillLayer(name: "bg_turf", fallback: Hill.turfDeep).ignoresSafeArea()
            Color.black.opacity(0.22).ignoresSafeArea()
            VStack(spacing: 0) {
                header
                GeometryReader { geo in
                    fieldCanvas(geo.size)
                }
                .frame(maxHeight: .infinity)
                controls
            }
        }
        .onAppear(perform: begin)
        .onReceive(tick) { _ in step() }
        .overlay(finishOverlay)
    }

    private func begin() {
        guard sim.sheep.isEmpty else { return }
        sim.reset(count: field.sheepCount, config: field.config,
                  seed: hillSeed(field.id) &+ UInt64(Meets.dayIndex()))
        sim.handler = course.post
        sim.dog = CGPoint(x: Double(course.post.x) + 0.05, y: Double(course.post.y) - 0.02)
        sim.command = .lieDown
    }

    private var header: some View {
        VStack(spacing: 6) {
            HStack(alignment: .top) {
                VStack(alignment: .leading, spacing: 2) {
                    Text(field.name).font(Slate.title(17)).foregroundColor(Hill.canvas)
                    Text(phase.title).font(Slate.italic(12))
                        .foregroundColor(Hill.canvas.opacity(0.72))
                }
                Spacer()
                Button(action: { Nudge.light(); showLeave = true }) {
                    ShutMark(size: 16, color: Hill.canvas)
                        .padding(9).background(Circle().fill(Color.white.opacity(0.14)))
                }
                .buttonStyle(.plain)
            }
            HStack(spacing: 8) {
                Text(clockText).font(Slate.figure(12)).foregroundColor(Hill.brass)
                GeometryReader { geo in
                    ZStack(alignment: .leading) {
                        Capsule().fill(Color.black.opacity(0.3))
                        Capsule().fill(elapsed > limit * 0.8 ? Hill.rosetteRed : Hill.brass)
                            .frame(width: min(1, elapsed / limit) * geo.size.width)
                    }
                }
                .frame(height: 4)
                Text(lastCommandName).font(Slate.italic(11))
                    .foregroundColor(Hill.canvas.opacity(0.75))
                    .frame(width: 92, alignment: .trailing)
            }
        }
        .padding(.horizontal, 16).padding(.top, 10).padding(.bottom, 8)
        .background(Color.black.opacity(0.36).ignoresSafeArea(edges: .top))
        .alert(isPresented: $showLeave) {
            Alert(title: Text("Retire from the run?"),
                  message: Text("Nothing goes on the card, and the sheep go back to the exhaust."),
                  primaryButton: .destructive(Text("Retire")) { onClose() },
                  secondaryButton: .cancel(Text("Carry on")))
        }
    }

    private var clockText: String {
        let left = max(0, limit - elapsed)
        return String(format: "%d:%02d", Int(left) / 60, Int(left) % 60)
    }

    private func step() {
        guard phase != .waiting, phase != .finished else { return }
        let dt = 1.0 / 30.0
        elapsed += dt
        sim.step(dt: dt)
        sampleLine()
        advancePhase()
        if elapsed >= limit { finish() }
    }

    private func sampleLine() {
        let c = sim.centre
        let (a, b) = course.idealLine(for: phase)
        var list = phaseSamples[phase] ?? []
        switch phase {
        case .outrun:
            let width = abs(Double(sim.dog.x) - 0.5)
            outrunWidth = max(outrunWidth, width)
            let side = Double(sim.dog.x) - 0.5
            if sentSide == .comeBye && side < -0.06 { crossed = true }
            if sentSide == .awayToMe && side > 0.06 { crossed = true }
        case .lift:
            list.append(min(1, sim.spread * 4))
        case .fetch, .drive, .crossDrive:
            list.append(distanceToLine(c, a, b))
        case .shed:
            list.append(distance(c, course.shedRing))
        case .pen:
            list.append(distance(c, course.pen))
        default:
            break
        }
        phaseSamples[phase] = list
    }

    private func advancePhase() {
        let c = sim.centre
        switch phase {
        case .outrun:
            if Double(sim.dog.y) < Double(c.y) - 0.03 && distance(sim.dog, c) < 0.28 {
                phase = .lift
                sim.command = .steady
            }
        case .lift:
            if Double(c.y) > 0.20 { phase = .fetch }
        case .fetch:
            if abs(Double(c.x) - Double(course.fetchGate.x)) < course.gateWidth / 2
                && abs(Double(c.y) - Double(course.fetchGate.y)) < 0.03 {
                gatesTaken[0] = true
            }
            if distance(c, course.post) < 0.12 {
                if drill {
                    completeDrill()
                } else {
                    phase = .drive
                    Nudge.firm()
                }
            }
        case .drive:
            if abs(Double(c.x) - Double(course.driveGate.x)) < course.gateWidth
                && abs(Double(c.y) - Double(course.driveGate.y)) < 0.05 {
                gatesTaken[1] = true
            }
            if distance(c, course.driveGate) < 0.10 {
                phase = .crossDrive
                Nudge.firm()
            }
        case .crossDrive:
            if abs(Double(c.x) - Double(course.crossGate.x)) < course.gateWidth
                && abs(Double(c.y) - Double(course.crossGate.y)) < 0.05 {
                gatesTaken[2] = true
            }
            if distance(c, course.crossGate) < 0.10 {
                phase = .shed
                Nudge.firm()
            }
        case .shed:
            if shedDone { phase = .pen }
        case .pen:
            var inside = 0
            for s in sim.sheep where distance(s.p, course.pen) < 0.075 { inside += 1 }
            if inside == sim.sheep.count {
                penned = true
                finish()
            }
        default:
            break
        }
    }

    private func issue(_ command: DogCommand) {
        sim.command = command
        lastCommandName = command.title
        commandCount += 1
        store.countWhistle()
        Nudge.light()
        if phase == .waiting {
            if command == .comeBye || command == .awayToMe {
                sentSide = command
                phase = .outrun
                elapsed = 0
            }
        }
    }

    private func fieldCanvas(_ size: CGSize) -> some View {
        let side = min(size.width - 20, size.height - 20)
        let rect = CGRect(x: (size.width - side) / 2, y: (size.height - side) / 2,
                          width: side, height: side)
        return Canvas { ctx, _ in
            drawField(&ctx, rect)
        }
        .frame(width: size.width, height: size.height)
    }

    private func place(_ p: CGPoint, _ rect: CGRect) -> CGPoint {
        CGPoint(x: rect.minX + p.x * rect.width, y: rect.minY + p.y * rect.height)
    }

    private func drawField(_ ctx: inout GraphicsContext, _ rect: CGRect) {
        var turf = Path()
        turf.addRect(rect)
        ctx.fill(turf, with: .linearGradient(
            Gradient(colors: [Hill.turf.opacity(0.95), Hill.turfDark.opacity(0.95)]),
            startPoint: CGPoint(x: rect.minX, y: rect.minY),
            endPoint: CGPoint(x: rect.maxX, y: rect.maxY)))
        var rng = Roll(hillSeed(field.id))
        for _ in 0..<260 {
            let x = rect.minX + CGFloat(rng.unit()) * rect.width
            let y = rect.minY + CGFloat(rng.unit()) * rect.height
            var blade = Path()
            blade.move(to: CGPoint(x: x, y: y))
            blade.addLine(to: CGPoint(x: x + CGFloat(rng.range(-2, 2)), y: y - CGFloat(rng.range(3, 8))))
            ctx.stroke(blade, with: .color((rng.chance(0.5) ? Hill.turfPale : Hill.turfDeep)
                                            .opacity(rng.range(0.10, 0.30))),
                       lineWidth: 0.8)
        }
        ctx.stroke(turf, with: .color(Hill.turfDeep), lineWidth: 3)

        if !sim.track.isEmpty {
            var path = Path()
            let pts = sim.track.map { place($0, rect) }
            path.move(to: pts[0])
            for p in pts.dropFirst() { path.addLine(to: p) }
            ctx.stroke(path, with: .color(Hill.canvas.opacity(0.32)),
                       style: StrokeStyle(lineWidth: 2, lineCap: .round, dash: [4, 4]))
        }

        let (a, b) = course.idealLine(for: phase)
        if phase != .waiting && phase != .finished {
            var line = Path()
            line.move(to: place(a, rect))
            line.addLine(to: place(b, rect))
            ctx.stroke(line, with: .color(Hill.oat.opacity(0.5)),
                       style: StrokeStyle(lineWidth: 1.6, dash: [7, 6]))
        }

        drawGateMark(&ctx, course.fetchGate, rect, taken: gatesTaken[0], horizontal: true)
        drawGateMark(&ctx, course.driveGate, rect, taken: gatesTaken[1], horizontal: false)
        drawGateMark(&ctx, course.crossGate, rect, taken: gatesTaken[2], horizontal: false)

        var ring = Path()
        let ringCentre = place(course.shedRing, rect)
        ring.addEllipse(in: CGRect(x: ringCentre.x - CGFloat(course.ringRadius) * rect.width,
                                   y: ringCentre.y - CGFloat(course.ringRadius) * rect.height,
                                   width: CGFloat(course.ringRadius) * 2 * rect.width,
                                   height: CGFloat(course.ringRadius) * 2 * rect.height))
        ctx.stroke(ring, with: .color(phase == .shed ? Hill.oat : Hill.oat.opacity(0.30)),
                   style: StrokeStyle(lineWidth: 1.6, dash: [6, 8]))

        let penCentre = place(course.pen, rect)
        let penW = rect.width * 0.14
        var pen = Path()
        pen.move(to: CGPoint(x: penCentre.x - penW, y: penCentre.y + penW * 0.7))
        pen.addLine(to: CGPoint(x: penCentre.x - penW, y: penCentre.y - penW * 0.7))
        pen.addLine(to: CGPoint(x: penCentre.x + penW, y: penCentre.y - penW * 0.7))
        pen.addLine(to: CGPoint(x: penCentre.x + penW, y: penCentre.y + penW * 0.2))
        ctx.stroke(pen, with: .color(Hill.sepia), lineWidth: 4)
        var gate = Path()
        gate.move(to: CGPoint(x: penCentre.x + penW, y: penCentre.y + penW * 0.2))
        gate.addLine(to: CGPoint(x: penCentre.x + penW * 1.6, y: penCentre.y + penW * 0.9))
        ctx.stroke(gate, with: .color(Hill.sepia.opacity(0.8)), lineWidth: 3)

        let postAt = place(course.post, rect)
        var post = Path()
        post.move(to: CGPoint(x: postAt.x, y: postAt.y))
        post.addLine(to: CGPoint(x: postAt.x, y: postAt.y - 18))
        ctx.stroke(post, with: .color(Hill.sepia), lineWidth: 4)
        var handler = Path()
        handler.addEllipse(in: CGRect(x: postAt.x - 9, y: postAt.y - 30, width: 10, height: 10))
        ctx.fill(handler, with: .color(Hill.slateDeep))
        var coat = Path()
        coat.move(to: CGPoint(x: postAt.x - 12, y: postAt.y - 20))
        coat.addLine(to: CGPoint(x: postAt.x - 2, y: postAt.y - 20))
        coat.addLine(to: CGPoint(x: postAt.x - 3, y: postAt.y))
        coat.addLine(to: CGPoint(x: postAt.x - 11, y: postAt.y))
        coat.closeSubpath()
        ctx.fill(coat, with: .color(Hill.slate))

        for s in sim.sheep {
            let p = place(s.p, rect)
            var wool = Path()
            wool.addEllipse(in: CGRect(x: p.x - 8, y: p.y - 5, width: 16, height: 11))
            ctx.fill(wool, with: .color(Hill.fleece))
            ctx.stroke(wool, with: .color(Hill.inkSoft.opacity(0.8)), lineWidth: 1.2)
            let heading = atan2(Double(s.v.y), Double(s.v.x))
            var head = Path()
            head.addEllipse(in: CGRect(x: p.x + CGFloat(cos(heading)) * 8 - 3,
                                       y: p.y + CGFloat(sin(heading)) * 5 - 3,
                                       width: 6, height: 6))
            ctx.fill(head, with: .color(Hill.inkSoft))
        }

        let dogAt = place(sim.dog, rect)
        var dogBody = Path()
        dogBody.addEllipse(in: CGRect(x: dogAt.x - 9, y: dogAt.y - 4, width: 18, height: 9))
        ctx.fill(dogBody, with: .color(Hill.collie))
        var dogHead = Path()
        dogHead.addEllipse(in: CGRect(x: dogAt.x + 6, y: dogAt.y - 7, width: 8, height: 7))
        ctx.fill(dogHead, with: .color(Hill.collie))
        var blaze = Path()
        blaze.addEllipse(in: CGRect(x: dogAt.x + 8, y: dogAt.y - 6, width: 3, height: 5))
        ctx.fill(blaze, with: .color(Hill.fleece))
        if sim.command == .lieDown {
            var mark = Path()
            mark.addEllipse(in: CGRect(x: dogAt.x - 14, y: dogAt.y - 12, width: 28, height: 24))
            ctx.stroke(mark, with: .color(Hill.oat.opacity(0.55)),
                       style: StrokeStyle(lineWidth: 1.2, dash: [3, 3]))
        }
    }

    private func drawGateMark(_ ctx: inout GraphicsContext, _ at: CGPoint, _ rect: CGRect,
                              taken: Bool, horizontal: Bool) {
        let c = place(at, rect)
        let half = CGFloat(course.gateWidth / 2) * rect.width
        let tint = taken ? Hill.moss : Hill.sepia
        for side in 0..<2 {
            let offset = side == 0 ? -half : half
            var post = Path()
            if horizontal {
                post.move(to: CGPoint(x: c.x + offset, y: c.y - 7))
                post.addLine(to: CGPoint(x: c.x + offset, y: c.y + 7))
            } else {
                post.move(to: CGPoint(x: c.x - 7, y: c.y + offset))
                post.addLine(to: CGPoint(x: c.x + 7, y: c.y + offset))
            }
            ctx.stroke(post, with: .color(tint), lineWidth: 4)
        }
    }

    private var controls: some View {
        VStack(alignment: .leading, spacing: 8) {
            if phase == .waiting {
                Text("Send him out")
                    .font(Slate.title(18)).foregroundColor(Hill.ink)
                Text("Whistle come bye to send him clockwise, away to me for the other side. Draw the shape on the pad.")
                    .font(Slate.body(14)).foregroundColor(Hill.inkSoft)
                    .fixedSize(horizontal: false, vertical: true)
            } else if phase == .shed {
                Text("Shed them in the ring")
                    .font(Slate.title(18)).foregroundColor(Hill.ink)
                HStack(spacing: 10) {
                    Text("Open a gap, then take two off.")
                        .font(Slate.body(14)).foregroundColor(Hill.inkSoft)
                    Spacer()
                    SmallGateButton(title: "Shed", tint: Hill.bracken) {
                        if sim.spread > 0.10 && distance(sim.centre, course.shedRing) < course.ringRadius {
                            shedDone = true
                            Nudge.heavy()
                        }
                    }
                }
            } else {
                HStack(spacing: 10) {
                    CountChip(value: "\(gatesTaken.filter { $0 }.count)/3", label: "gates")
                    CountChip(value: String(format: "%.0f", sim.spread * 100), label: "spread",
                              tint: sim.spread > 0.18 ? Hill.rosetteRed : Hill.sepia)
                    CountChip(value: "\(commandCount)", label: "whistles")
                }
            }

            whistlePad
        }
        .padding(.horizontal, 14).padding(.top, 10).padding(.bottom, 14)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(HillLayer(name: "bg_card", fallback: Hill.canvasWarm)
            .ignoresSafeArea(edges: .bottom))
    }

    private var whistlePad: some View {
        VStack(spacing: 6) {
            HStack(spacing: 6) {
                ForEach(allCommands, id: \.rawValue) { command in
                    Button(action: { issue(command) }) {
                        VStack(spacing: 2) {
                            WhistleRail(shape: command.shape,
                                        tint: sim.command == command ? Hill.rosetteRed : Hill.inkSoft,
                                        height: 18)
                            Text(command.title).font(Slate.body(8))
                                .foregroundColor(Hill.inkSoft)
                                .lineLimit(1).minimumScaleFactor(0.7)
                        }
                        .padding(.vertical, 5)
                        .frame(maxWidth: .infinity)
                        .background(RoundedRectangle(cornerRadius: 6)
                            .fill(sim.command == command ? Hill.oat.opacity(0.7)
                                  : Hill.canvasSunk.opacity(0.55)))
                    }
                    .buttonStyle(.plain)
                }
            }
            ZStack {
                RoundedRectangle(cornerRadius: 8, style: .continuous)
                    .fill(Hill.canvasSunk.opacity(0.5))
                Canvas { ctx, size in
                    var rule = Path()
                    rule.move(to: CGPoint(x: 10, y: size.height / 2))
                    rule.addLine(to: CGPoint(x: size.width - 10, y: size.height / 2))
                    ctx.stroke(rule, with: .color(Hill.inkPale.opacity(0.3)),
                               style: StrokeStyle(lineWidth: 1, dash: [4, 5]))
                    if strokePoints.count > 1 {
                        var path = Path()
                        path.move(to: strokePoints[0])
                        for p in strokePoints.dropFirst() { path.addLine(to: p) }
                        ctx.stroke(path, with: .color(Hill.rosetteRed),
                                   style: StrokeStyle(lineWidth: 3, lineCap: .round, lineJoin: .round))
                    }
                }
                Text(strokePoints.isEmpty ? "draw the whistle here" : "")
                    .font(Slate.italic(12)).foregroundColor(Hill.inkPale.opacity(0.8))
            }
            .frame(height: 78)
            .contentShape(Rectangle())
            .gesture(
                DragGesture(minimumDistance: 0)
                    .onChanged { value in strokePoints.append(value.location) }
                    .onEnded { _ in
                        let normalised = strokePoints.map {
                            CGPoint(x: $0.x / max(1, Pitch.screenW - 28),
                                    y: $0.y / 78)
                        }
                        if let command = recogniseWhistle(normalised) {
                            issue(command)
                        } else {
                            lastCommandName = "he looks up, puzzled"
                            Nudge.heavy()
                        }
                        strokePoints = []
                    }
            )
        }
    }

    private func completeDrill() {
        guard phase != .finished else { return }
        phase = .finished

        var outrunScore = max(0, min(1, outrunWidth / 0.30))
        if crossed { outrunScore *= 0.35 }
        let liftScore = phaseSamples[.lift] == nil ? 0.4
            : max(0, min(1, 1 - (phaseSamples[.lift]!.reduce(0, +)
                                 / Double(max(1, phaseSamples[.lift]!.count)))))
        var fetchScore = 0.0
        if let list = phaseSamples[.fetch], !list.isEmpty {
            fetchScore = max(0, min(1, 1 - (list.reduce(0, +) / Double(list.count)) / 0.20))
        }
        if gatesTaken[0] { fetchScore = min(1, fetchScore + 0.18) }
        let quality = max(0, min(1, outrunScore * 0.40 + liftScore * 0.24 + fetchScore * 0.36))
        drillQuality = quality
        drillOutrun = outrunScore
        drillLift = liftScore
        drillFetch = fetchScore
        drillPoints = store.finishDrill(quality: quality, commands: commandCount)
        freshHonours = store.newlyEarnedHonours()
        Nudge.heavy()
    }

    private func finish() {
        guard phase != .finished else { return }
        phase = .finished

        func score(_ p: TrialPhase, tolerance: Double) -> Double {
            guard let list = phaseSamples[p], !list.isEmpty else { return 0 }
            let mean = list.reduce(0, +) / Double(list.count)
            return max(0, min(1, 1 - mean / tolerance))
        }

        var outrunScore = max(0, min(1, outrunWidth / 0.30))
        if crossed { outrunScore *= 0.35 }
        let liftScore = phaseSamples[.lift] == nil ? 0.4
            : max(0, min(1, 1 - (phaseSamples[.lift]!.reduce(0, +)
                                 / Double(max(1, phaseSamples[.lift]!.count)))))
        var fetchScore = score(.fetch, tolerance: 0.20)
        if gatesTaken[0] { fetchScore = min(1, fetchScore + 0.18) }
        var driveScore = score(.drive, tolerance: 0.22)
        if gatesTaken[1] { driveScore = min(1, driveScore + 0.18) }
        var crossScore = score(.crossDrive, tolerance: 0.22)
        if gatesTaken[2] { crossScore = min(1, crossScore + 0.18) }
        let shedScore = shedDone ? 0.9 : 0.0
        let penScore = penned ? 1.0 : 0.0

        let res = TrialResult(outrun: outrunScore, lift: liftScore, fetch: fetchScore,
                              drive: driveScore, crossDrive: crossScore, shed: shedScore,
                              pen: penScore, seconds: elapsed, commands: commandCount)
        result = res
        let card = TrialCard(fieldId: field.id, day: Meets.dayIndex(), grade: res.grade,
                             total: res.total, outrun: outrunScore, lift: liftScore,
                             fetch: fetchScore, drive: driveScore, crossDrive: crossScore,
                             shed: shedScore, pen: penScore, seconds: elapsed,
                             commands: commandCount, track: flattenTrack(sim.track))
        improved = store.finish(field: field, result: res, card: card, meet: meet)
        freshHonours = store.newlyEarnedHonours()
        Nudge.heavy()
    }

    @ViewBuilder private var finishOverlay: some View {
        if phase == .finished, drill {
            ZStack {
                Color.black.opacity(0.58).ignoresSafeArea()
                    .onTapGesture { onClose() }
                VStack {
                    Spacer(minLength: 0)
                    CanvasCard(padding: 16) {
                        VStack(alignment: .leading, spacing: 11) {
                            VStack(alignment: .leading, spacing: 2) {
                                Text("Gather at \(field.name)").font(Slate.title(19))
                                    .foregroundColor(Hill.ink)
                                Text("Out, lift and fetch. No drive, no shed, no pen.")
                                    .font(Slate.italic(13)).foregroundColor(Hill.inkSoft)
                            }
                            PointRow(label: "Outrun", value: drillOutrun, maxPoints: 20,
                                     tint: Hill.moss)
                            PointRow(label: "Lift", value: drillLift, maxPoints: 10,
                                     tint: Hill.turfPale)
                            PointRow(label: "Fetch", value: drillFetch, maxPoints: 20,
                                     tint: Hill.sepia)
                            HStack(spacing: 10) {
                                CountChip(value: "+\(drillPoints)", label: "points",
                                          tint: Hill.rosetteRed)
                                CountChip(value: "\(Int((drillQuality * 100).rounded()))",
                                          label: "gather")
                                CountChip(value: "\(store.liveStreak)", label: "streak")
                            }
                            CallBanner(title: "The morning counts",
                                       detail: "A gather keeps the run of days going. The full course is still there when you have the time for it.",
                                       tint: Hill.moss)
                            GateButton(title: "Back to the yard", tint: Hill.bracken) { onClose() }
                        }
                    }
                    .padding(.horizontal, 18)
                    Spacer(minLength: 0)
                }
                .centreColumn()
            }
            .overlay(honourOverlay)
        } else if phase == .finished, let r = result {
            ZStack {
                Color.black.opacity(0.58).ignoresSafeArea()
                    .onTapGesture { onClose() }
                VStack {
                    Spacer(minLength: 0)
                    CanvasCard(padding: 16) {
                        VStack(alignment: .leading, spacing: 11) {
                            HStack(alignment: .top) {
                                VStack(alignment: .leading, spacing: 2) {
                                    Text(field.name).font(Slate.title(19)).foregroundColor(Hill.ink)
                                    Text(improved ? "Your best card at this field"
                                         : "An earlier card still stands")
                                        .font(Slate.italic(13)).foregroundColor(Hill.inkSoft)
                                }
                                Spacer()
                                Rosette(grade: r.grade, tint: rosetteTint(r.grade))
                            }
                            PointRow(label: "Outrun", value: r.outrun, maxPoints: 20, tint: Hill.moss)
                            PointRow(label: "Lift", value: r.lift, maxPoints: 10, tint: Hill.turfPale)
                            PointRow(label: "Fetch", value: r.fetch, maxPoints: 20, tint: Hill.sepia)
                            PointRow(label: "Drive", value: r.drive, maxPoints: 15, tint: Hill.bracken)
                            PointRow(label: "Cross-drive", value: r.crossDrive, maxPoints: 15,
                                     tint: Hill.bracken)
                            PointRow(label: "Shed", value: r.shed, maxPoints: 10, tint: Hill.brass)
                            PointRow(label: "Pen", value: r.pen, maxPoints: 10, tint: Hill.rosetteBlue)
                            HStack(spacing: 10) {
                                CountChip(value: "\(r.total)", label: "of 100", tint: Hill.rosetteRed)
                                CountChip(value: String(format: "%.0fs", r.seconds), label: "time")
                                CountChip(value: "\(r.commands)", label: "whistles")
                            }
                            if let m = meet, m.field.id == field.id {
                                CallBanner(title: r.total >= m.target ? "In the placings"
                                            : "Not in the placings",
                                           detail: "The meet wanted \(m.target); this run scored \(r.total).",
                                           tint: r.total >= m.target ? Hill.moss : Hill.bracken)
                            }
                            GateButton(title: "Back to the yard", tint: Hill.bracken) { onClose() }
                        }
                    }
                    .padding(.horizontal, 18)
                    Spacer(minLength: 0)
                }
                .centreColumn()
            }
            .overlay(honourOverlay)
        }
    }

    @ViewBuilder private var honourOverlay: some View {
        if let honour = freshHonours.first {
            HonourToast(honour: honour) {
                if !freshHonours.isEmpty { freshHonours.removeFirst() }
            }
        }
    }
}

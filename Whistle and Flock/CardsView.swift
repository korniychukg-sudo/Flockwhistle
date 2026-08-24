import SwiftUI

struct CardsView: View {
    @EnvironmentObject var store: TrialStore
    @State private var selected: String?

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 14) {
                VStack(alignment: .leading, spacing: 3) {
                    Text("THE CARDS").font(Slate.title(11)).tracking(3.2).foregroundColor(Hill.brass)
                    Text("Your runs").font(Slate.title(24)).foregroundColor(Hill.canvas)
                    Text("Every card carries the judge's points and the line your sheep actually took across the field.")
                        .font(Slate.italic(14)).foregroundColor(Hill.canvas.opacity(0.72))
                        .fixedSize(horizontal: false, vertical: true)
                }

                HStack(spacing: 10) {
                    CountChip(value: "\(store.cardCount)/\(FieldBook.all.count)", label: "fields",
                              tint: Hill.moss, onCanvas: false)
                    CountChip(value: "\(store.topGrades)", label: "red tickets",
                              tint: Hill.rosetteRed, onCanvas: false)
                    CountChip(value: "\(store.bestTotal)", label: "best card",
                              tint: Hill.brass, onCanvas: false)
                }

                if store.cardCount == 0 {
                    CallBanner(title: "No cards yet",
                               detail: "Run any field from the list and the judge's card is written up and kept here with the sheep's track on it.",
                               tint: Hill.bracken)
                }

                ForEach(Array(sorted.enumerated()), id: \.element.fieldId) { pair in
                    RiseIn(index: min(6, pair.offset)) {
                        Button(action: { Nudge.light(); selected = pair.element.fieldId }) {
                            cardRow(pair.element)
                        }
                        .buttonStyle(.plain)
                    }
                }

                if !store.meets.isEmpty {
                    CanvasCard {
                        VStack(alignment: .leading, spacing: 8) {
                            FieldHead(title: "The season",
                                      note: "\(store.meets.filter { $0.met }.count) of \(store.meets.count) in the placings")
                            ForEach(store.meets.suffix(8).reversed(), id: \.day) { rec in
                                HStack(spacing: 10) {
                                    Text("Day \(rec.day)").font(Slate.figure(12))
                                        .foregroundColor(Hill.inkPale)
                                        .frame(width: 62, alignment: .leading)
                                    Text(FieldBook.field(rec.fieldId)?.name ?? rec.fieldId)
                                        .font(Slate.body(13)).foregroundColor(Hill.inkSoft)
                                        .lineLimit(1)
                                    Spacer(minLength: 0)
                                    Text("\(rec.total)/\(rec.target)").font(Slate.figure(12))
                                        .foregroundColor(rec.met ? Hill.moss : Hill.bracken)
                                }
                            }
                        }
                    }
                }
                Color.clear.frame(height: 12)
            }
            .padding(.horizontal, Pitch.gutter)
            .padding(.top, 8)
            .centreColumn()
        }
        .hillPage()
        .navigationBarHidden(true)
        .sheet(isPresented: Binding(get: { selected != nil },
                                    set: { if !$0 { selected = nil } })) {
            if let id = selected, let field = FieldBook.field(id), let card = store.card(for: id) {
                ZStack {
                    Hill.turfDeep.ignoresSafeArea()
                    ScrollView {
                        VStack(spacing: 14) {
                            HStack {
                                Text(field.name).font(Slate.title(19)).foregroundColor(Hill.canvas)
                                Spacer()
                                Button(action: { Nudge.light(); selected = nil }) {
                                    ShutMark(size: 16, color: Hill.canvas)
                                        .padding(9)
                                        .background(Circle().fill(Color.white.opacity(0.14)))
                                }
                                .buttonStyle(.plain)
                            }
                            cardRow(card, full: true)
                            Color.clear.frame(height: 20)
                        }
                        .padding(.horizontal, Pitch.gutter)
                        .padding(.top, 16)
                        .centreColumn()
                    }
                }
            }
        }
    }

    private var sorted: [TrialCard] {
        store.cards.values.sorted { $0.total > $1.total }
    }

    private func cardRow(_ card: TrialCard, full: Bool = false) -> some View {
        let field = FieldBook.field(card.fieldId)
        return CanvasCard(padding: 13) {
            VStack(alignment: .leading, spacing: 10) {
                HStack(alignment: .top) {
                    VStack(alignment: .leading, spacing: 2) {
                        Text(field?.name ?? card.fieldId).font(Slate.title(17))
                            .foregroundColor(Hill.ink)
                        Text("Day \(card.day) · \(field?.breed ?? "") · \(Int(card.seconds))s")
                            .font(Slate.italic(12)).foregroundColor(Hill.inkPale)
                    }
                    Spacer()
                    Rosette(grade: card.grade, tint: rosetteTint(card.grade))
                }
                Rectangle().fill(Hill.ink.opacity(0.18)).frame(height: 1)
                TrackPlan(card: card)
                    .frame(height: full ? 300 : 150)
                HStack(spacing: 10) {
                    CountChip(value: "\(card.total)", label: "of 100", tint: Hill.rosetteRed)
                    CountChip(value: "\(card.commands)", label: "whistles")
                    CountChip(value: card.pen > 0.8 ? "penned" : "no pen",
                              label: "finish",
                              tint: card.pen > 0.8 ? Hill.moss : Hill.bracken)
                }
                if full {
                    PointRow(label: "Outrun", value: card.outrun, maxPoints: 20, tint: Hill.moss)
                    PointRow(label: "Lift", value: card.lift, maxPoints: 10, tint: Hill.turfPale)
                    PointRow(label: "Fetch", value: card.fetch, maxPoints: 20, tint: Hill.sepia)
                    PointRow(label: "Drive", value: card.drive, maxPoints: 15, tint: Hill.bracken)
                    PointRow(label: "Cross-drive", value: card.crossDrive, maxPoints: 15,
                             tint: Hill.bracken)
                    PointRow(label: "Shed", value: card.shed, maxPoints: 10, tint: Hill.brass)
                    PointRow(label: "Pen", value: card.pen, maxPoints: 10, tint: Hill.rosetteBlue)
                    Text("The line on the plan is where your sheep actually walked. Run it again and the better card is the one that is kept.")
                        .font(Slate.italic(12)).foregroundColor(Hill.inkPale)
                        .fixedSize(horizontal: false, vertical: true)
                }
            }
        }
    }
}

struct TrackPlan: View {
    let card: TrialCard
    private let course = TrialCourse()

    var body: some View {
        Canvas { ctx, size in
            let side = min(size.width, size.height)
            let rect = CGRect(x: (size.width - side) / 2, y: 0, width: side, height: side)
            func place(_ p: CGPoint) -> CGPoint {
                CGPoint(x: rect.minX + p.x * rect.width, y: rect.minY + p.y * rect.height)
            }
            var field = Path()
            field.addRect(rect)
            ctx.fill(field, with: .color(Hill.turfPale.opacity(0.30)))
            ctx.stroke(field, with: .color(Hill.inkSoft.opacity(0.5)), lineWidth: 1.4)

            for gate in [course.fetchGate, course.driveGate, course.crossGate] {
                let c = place(gate)
                var mark = Path()
                mark.move(to: CGPoint(x: c.x - 9, y: c.y))
                mark.addLine(to: CGPoint(x: c.x + 9, y: c.y))
                ctx.stroke(mark, with: .color(Hill.sepia), lineWidth: 3)
            }
            var ring = Path()
            let ringCentre = place(course.shedRing)
            ring.addEllipse(in: CGRect(x: ringCentre.x - CGFloat(course.ringRadius) * rect.width,
                                       y: ringCentre.y - CGFloat(course.ringRadius) * rect.height,
                                       width: CGFloat(course.ringRadius) * 2 * rect.width,
                                       height: CGFloat(course.ringRadius) * 2 * rect.height))
            ctx.stroke(ring, with: .color(Hill.oat.opacity(0.5)),
                       style: StrokeStyle(lineWidth: 1, dash: [4, 5]))
            let penAt = place(course.pen)
            var pen = Path()
            pen.addRect(CGRect(x: penAt.x - 14, y: penAt.y - 10, width: 28, height: 20))
            ctx.stroke(pen, with: .color(Hill.sepia), lineWidth: 2)

            let pts = unflattenTrack(card.track).map(place)
            if pts.count > 1 {
                var path = Path()
                path.move(to: pts[0])
                for p in pts.dropFirst() { path.addLine(to: p) }
                ctx.stroke(path, with: .color(Hill.rosetteRed.opacity(0.85)),
                           style: StrokeStyle(lineWidth: 2, lineCap: .round, lineJoin: .round))
                var start = Path()
                start.addEllipse(in: CGRect(x: pts[0].x - 3, y: pts[0].y - 3, width: 6, height: 6))
                ctx.fill(start, with: .color(Hill.ink))
            }
            let postAt = place(course.post)
            var post = Path()
            post.addEllipse(in: CGRect(x: postAt.x - 3, y: postAt.y - 3, width: 6, height: 6))
            ctx.fill(post, with: .color(Hill.slateDeep))
        }
    }
}

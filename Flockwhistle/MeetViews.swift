import SwiftUI

struct MeetView: View {
    @EnvironmentObject var store: TrialStore
    @State private var chosen: TrialField?
    @State private var running = false

    private var day: Int { Meets.dayIndex() }
    private var meet: DayCard { Meets.forDay(day) }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 15) {
                VStack(alignment: .leading, spacing: 3) {
                    Text("THE FIELDS").font(Slate.title(11)).tracking(3.2).foregroundColor(Hill.brass)
                    Text("Choose a run").font(Slate.title(24)).foregroundColor(Hill.canvas)
                    Text("Twenty-four fields. The ground decides how far off the dog must work and how hard the sheep will argue.")
                        .font(Slate.italic(14)).foregroundColor(Hill.canvas.opacity(0.72))
                        .fixedSize(horizontal: false, vertical: true)
                }

                RiseIn(index: 0) {
                    SlateCard {
                        VStack(alignment: .leading, spacing: 8) {
                            FieldHead(title: "Today's trial", note: meet.title, tint: Hill.brass)
                            Text("\(meet.field.name) · \(meet.field.breed)")
                                .font(Slate.body(15)).foregroundColor(Hill.canvas)
                            GateButton(title: "Walk to the post", tint: Hill.bracken) {
                                chosen = meet.field
                                running = true
                            }
                        }
                    }
                }

                ForEach(Array(FieldBook.all.enumerated()), id: \.element.id) { pair in
                    RiseIn(index: min(6, pair.offset)) { fieldRow(pair.element) }
                }
                Color.clear.frame(height: 12)
            }
            .padding(.horizontal, Pitch.gutter)
            .padding(.top, 8)
            .centreColumn()
        }
        .hillPage()
        .navigationBarHidden(true)
        .fullScreenCover(isPresented: $running) {
            if let field = chosen {
                TrialView(field: field,
                          meet: field.id == meet.field.id ? meet : nil) { running = false }
                    .environmentObject(store)
            } else {
                VStack(spacing: 14) {
                    Text("No field chosen.").font(Slate.body(16)).foregroundColor(Hill.canvas)
                    SmallGateButton(title: "Back", tint: Hill.canvas) { running = false }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .hillPage()
            }
        }
    }

    private func fieldRow(_ field: TrialField) -> some View {
        Button(action: { Nudge.light(); chosen = field; running = true }) {
            CanvasCard(padding: 11) {
                HStack(spacing: 12) {
                    FieldPlate(name: field.plate, height: 84).frame(width: 74)
                    VStack(alignment: .leading, spacing: 3) {
                        Text(field.name).font(Slate.title(16)).foregroundColor(Hill.ink)
                        Text("\(field.place) · \(field.terrain)")
                            .font(Slate.italic(12)).foregroundColor(Hill.inkPale)
                        Text("\(field.breed) · \(field.sheepCount) head")
                            .font(Slate.body(12)).foregroundColor(Hill.inkSoft)
                        HStack(spacing: 4) {
                            ForEach(0..<5, id: \.self) { i in
                                Circle()
                                    .fill(i < field.difficulty ? Hill.bracken : Hill.canvasSunk)
                                    .frame(width: 6, height: 6)
                            }
                        }
                    }
                    Spacer(minLength: 0)
                    if let card = store.card(for: field.id) {
                        Rosette(grade: card.grade, tint: rosetteTint(card.grade))
                    } else {
                        MarkGlyph(size: 15, color: Hill.inkPale)
                    }
                }
            }
        }
        .buttonStyle(.plain)
    }
}

struct FieldsView: View {
    @EnvironmentObject var store: TrialStore

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 14) {
                VStack(alignment: .leading, spacing: 3) {
                    Text("THE HILLS").font(Slate.title(11)).tracking(3.2).foregroundColor(Hill.brass)
                    Text("Twenty-four grounds").font(Slate.title(24)).foregroundColor(Hill.canvas)
                    Text("Drawn from the fence, with the breed, the going and what it will do to your run.")
                        .font(Slate.italic(14)).foregroundColor(Hill.canvas.opacity(0.72))
                        .fixedSize(horizontal: false, vertical: true)
                }
                ForEach(Array(FieldBook.all.enumerated()), id: \.element.id) { pair in
                    RiseIn(index: min(6, pair.offset)) {
                        NavigationLink(destination: FieldDetail(field: pair.element)
                                        .environmentObject(store)) {
                            CanvasCard(padding: 11) {
                                VStack(alignment: .leading, spacing: 8) {
                                    FieldPlate(name: pair.element.plate, height: 236)
                                    HStack(alignment: .top) {
                                        VStack(alignment: .leading, spacing: 3) {
                                            Text(pair.element.kicker.uppercased())
                                                .font(Slate.title(10)).tracking(2)
                                                .foregroundColor(Hill.bracken)
                                            Text(pair.element.name).font(Slate.title(17))
                                                .foregroundColor(Hill.ink)
                                            Text("\(pair.element.place) · \(pair.element.breed)")
                                                .font(Slate.italic(12)).foregroundColor(Hill.inkPale)
                                        }
                                        Spacer(minLength: 0)
                                        MarkGlyph(size: 15, color: Hill.inkPale)
                                    }
                                }
                            }
                        }
                        .buttonStyle(.plain)
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
    }
}

struct FieldDetail: View {
    let field: TrialField
    @EnvironmentObject var store: TrialStore
    @State private var openPlate = false
    @State private var running = false

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 14) {
                VStack(alignment: .leading, spacing: 3) {
                    Text(field.kicker.uppercased()).font(Slate.title(11)).tracking(2.6)
                        .foregroundColor(Hill.brass)
                    Text(field.name).font(Slate.title(25)).foregroundColor(Hill.canvas)
                    Text("\(field.place) · \(field.terrain)")
                        .font(Slate.italic(14)).foregroundColor(Hill.canvas.opacity(0.72))
                }
                Button(action: { Nudge.light(); openPlate = true }) {
                    FieldPlate(name: field.plate, height: 360)
                }
                .buttonStyle(.plain)

                CanvasCard {
                    VStack(alignment: .leading, spacing: 9) {
                        FieldHead(title: "The sheep")
                        Text(field.blurb).font(Slate.body(15)).foregroundColor(Hill.inkSoft)
                            .fixedSize(horizontal: false, vertical: true)
                        HStack(spacing: 10) {
                            CountChip(value: field.breed, label: "breed")
                            CountChip(value: "\(field.sheepCount)", label: "head", tint: Hill.moss)
                            CountChip(value: "\(field.difficulty)/5", label: "ground",
                                      tint: Hill.bracken)
                        }
                    }
                }

                if let card = store.card(for: field.id) {
                    CanvasCard(tint: Hill.canvasWarm) {
                        VStack(alignment: .leading, spacing: 9) {
                            HStack {
                                FieldHead(title: "Your best card", note: "Day \(card.day)")
                                Spacer()
                                Rosette(grade: card.grade, tint: rosetteTint(card.grade))
                            }
                            PointRow(label: "Outrun", value: card.outrun, maxPoints: 20, tint: Hill.moss)
                            PointRow(label: "Lift", value: card.lift, maxPoints: 10, tint: Hill.turfPale)
                            PointRow(label: "Fetch", value: card.fetch, maxPoints: 20, tint: Hill.sepia)
                            PointRow(label: "Drive", value: card.drive, maxPoints: 15, tint: Hill.bracken)
                            PointRow(label: "Cross-drive", value: card.crossDrive, maxPoints: 15,
                                     tint: Hill.bracken)
                            PointRow(label: "Shed", value: card.shed, maxPoints: 10, tint: Hill.brass)
                            PointRow(label: "Pen", value: card.pen, maxPoints: 10, tint: Hill.rosetteBlue)
                        }
                    }
                } else {
                    CallBanner(title: "No card from this field yet",
                               detail: "Any field can be run from the list. Only your best card at each is kept.",
                               tint: Hill.stone)
                }

                GateButton(title: store.card(for: field.id) == nil ? "Run it" : "Run it again",
                           tint: Hill.bracken) { running = true }
                Color.clear.frame(height: 16)
            }
            .padding(.horizontal, Pitch.gutter)
            .padding(.top, 8)
            .centreColumn()
        }
        .hillPage()
        .navigationBarTitleDisplayMode(.inline)
        .sheet(isPresented: $openPlate) {
            PlateSheetView(name: field.plate, title: field.name) { openPlate = false }
        }
        .fullScreenCover(isPresented: $running) {
            TrialView(field: field, meet: nil) { running = false }
                .environmentObject(store)
        }
    }
}

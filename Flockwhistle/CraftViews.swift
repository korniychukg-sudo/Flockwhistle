import SwiftUI

struct CraftView: View {
    @EnvironmentObject var store: TrialStore
    @State private var section = 0
    @State private var openPlate: String?
    @State private var plateTitle = ""

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 14) {
                VStack(alignment: .leading, spacing: 3) {
                    Text("THE SHED").font(Slate.title(11)).tracking(3.2).foregroundColor(Hill.brass)
                    Text(section == 0 ? "Twelve plates" : "What hangs on the nail")
                        .font(Slate.title(24)).foregroundColor(Hill.canvas)
                    Text(section == 0
                         ? "Outrun, lift, fetch, drive, shed, pen, whistles, flight zone, breeds, young dogs, the card and the year."
                         : "Six things a shepherd carries, and what each is actually for.")
                        .font(Slate.italic(14)).foregroundColor(Hill.canvas.opacity(0.72))
                        .fixedSize(horizontal: false, vertical: true)
                }

                HStack(spacing: 8) {
                    segment("Plates", 0)
                    segment("Kit", 1)
                }

                if section == 0 {
                    ForEach(Array(CraftShelf.entries.enumerated()), id: \.element.id) { pair in
                        RiseIn(index: min(5, pair.offset)) { entryCard(pair.element) }
                    }
                } else {
                    ForEach(Array(CraftShelf.kit.enumerated()), id: \.element.id) { pair in
                        RiseIn(index: min(5, pair.offset)) { kitCard(pair.element) }
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
        .sheet(isPresented: Binding(get: { openPlate != nil },
                                    set: { if !$0 { openPlate = nil } })) {
            if let plate = openPlate {
                PlateSheetView(name: plate, title: plateTitle) { openPlate = nil }
            }
        }
    }

    private func segment(_ label: String, _ index: Int) -> some View {
        Button(action: { Nudge.light(); section = index }) {
            Text(label).font(Slate.title(13))
                .foregroundColor(section == index ? Hill.canvas : Hill.canvas.opacity(0.7))
                .padding(.horizontal, 14).padding(.vertical, 8)
                .background(Capsule().fill(section == index ? Hill.bracken : Hill.slate))
        }
        .buttonStyle(.plain)
    }

    private func entryCard(_ entry: CraftEntry) -> some View {
        Button(action: {
            Nudge.light()
            store.markPlate(entry.id)
            plateTitle = entry.title
            openPlate = entry.plate
        }) {
            CanvasCard(padding: 11) {
                VStack(alignment: .leading, spacing: 7) {
                    HStack {
                        FieldHead(title: entry.kicker)
                        Spacer()
                        if store.plateRead.contains(entry.id) {
                            DoneMark(size: 15, color: Hill.moss)
                        }
                    }
                    FieldPlate(name: entry.plate, height: 150)
                    Text(entry.title).font(Slate.title(17)).foregroundColor(Hill.ink)
                    Text(entry.sub).font(Slate.italic(12)).foregroundColor(Hill.inkPale)
                    Text(entry.summary).font(Slate.body(14)).foregroundColor(Hill.inkSoft)
                        .fixedSize(horizontal: false, vertical: true)
                }
            }
        }
        .buttonStyle(.plain)
    }

    private func kitCard(_ tool: ToolEntry) -> some View {
        Button(action: {
            Nudge.light()
            plateTitle = tool.name
            openPlate = tool.plate
        }) {
            CanvasCard(padding: 11) {
                VStack(alignment: .leading, spacing: 7) {
                    FieldPlate(name: tool.plate, height: 140)
                    Text(tool.name).font(Slate.title(16)).foregroundColor(Hill.ink)
                    Text(tool.note).font(Slate.body(13)).foregroundColor(Hill.inkSoft)
                        .fixedSize(horizontal: false, vertical: true)
                }
            }
        }
        .buttonStyle(.plain)
    }
}

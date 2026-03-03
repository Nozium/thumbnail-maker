import SwiftUI

struct TemplatePicker: View {
    @Binding var style: TemplateStyle

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Template").font(.headline)
            Picker("Template", selection: $style) {
                ForEach(TemplateStyle.allCases) { s in
                    Text(s.rawValue).tag(s)
                }
            }
            .pickerStyle(.segmented)
            Text(style.label)
                .font(.caption)
                .foregroundStyle(.secondary)
        }
    }
}

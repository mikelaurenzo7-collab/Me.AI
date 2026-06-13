import CarPlay
import UIKit

final class MeAICarScene: UIResponder, CPTemplateApplicationSceneDelegate {
    func templateApplicationScene(_ scene: CPTemplateApplicationScene, didConnect controller: CPInterfaceController) {
        let item = CPListItem(text: "Me.AI", detailText: "Ready")
        let section = CPListSection(items: [item])
        let template = CPListTemplate(title: "Me.AI", sections: [section])
        controller.setRootTemplate(template, animated: true)
    }

    func templateApplicationScene(_ scene: CPTemplateApplicationScene, didDisconnect controller: CPInterfaceController) {}
}

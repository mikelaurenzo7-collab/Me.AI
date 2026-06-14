import CarPlay
import UIKit

class MeAICarScene: UIResponder, CPTemplateApplicationSceneDelegate, CPTemplateApplicationDashboardSceneDelegate {
    
    // MARK: - Main CarPlay App Interface
    func templateApplicationScene(_ scene: CPTemplateApplicationScene, didConnect controller: CPInterfaceController) {
        // Build the primary List Interface for the CarPlay App
        let activeScreeningItem = CPListItem(text: "Live Call Screening", detailText: "Standby - Monitoring for inbound calls")
        activeScreeningItem.setImage(UIImage(systemName: "waveform.circle.fill"))
        activeScreeningItem.accessoryType = .none
        
        let pendingItem = CPListItem(text: "Pending Actions", detailText: "0 actions require your attention")
        pendingItem.setImage(UIImage(systemName: "checkmark.shield.fill"))
        
        let settingsItem = CPListItem(text: "Personal Mode", detailText: "Active")
        settingsItem.setImage(UIImage(systemName: "person.fill.checkmark"))
        
        let section = CPListSection(items: [activeScreeningItem, pendingItem, settingsItem])
        
        let listTemplate = CPListTemplate(title: "Me.AI Dashboard", sections: [section])
        listTemplate.tabSystemItem = .mostRecent
        
        let tabBarTemplate = CPTabBarTemplate(templates: [listTemplate])
        controller.setRootTemplate(tabBarTemplate, animated: true)
    }

    func templateApplicationScene(_ scene: CPTemplateApplicationScene, didDisconnect controller: CPInterfaceController) {}
    
    // MARK: - CarPlay Dashboard Widget Interface
    func templateApplicationDashboardScene(_ scene: CPTemplateApplicationDashboardScene, didConnect dashboardController: CPDashboardController) {
        // Create the CarPlay Dashboard Widget view
        
        let simulateButton = CPDashboardButton(titleVariants: ["Screen Call", "Simulate"], subtitleVariants: ["Trigger Test"], image: UIImage(systemName: "phone.badge.waveform")) { _ in
            // Action to handle when the dashboard button is pressed
            print("Dashboard button triggered Me.AI simulation")
        }
        
        let approveButton = CPDashboardButton(titleVariants: ["Approve Action"], subtitleVariants: ["Highest Priority"], image: UIImage(systemName: "checkmark.circle.fill")) { _ in
            // Action to approve pending tasks
            print("Dashboard button approved task")
        }
        
        dashboardController.shortcutButtons = [simulateButton, approveButton]
    }
    
    func templateApplicationDashboardScene(_ scene: CPTemplateApplicationDashboardScene, didDisconnect dashboardController: CPDashboardController) {}
}

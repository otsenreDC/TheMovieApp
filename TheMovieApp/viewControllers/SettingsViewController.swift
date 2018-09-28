//
//  SettingsViewController.swift
//  TheMovieApp
//
//  Created by Ernesto De los Santos Cordero on 9/28/18.
//  Copyright © 2018 BananaLabs. All rights reserved.
//

import UIKit

class SettingsViewController : UITableViewController {
    
    public var delegate: SettingsChangeDelegate?
    private var settingsHasChanged: Bool = false
    
    @IBOutlet var sortOptions: [UITableViewCell]!
    
    private let INDEX_SECTION_SORT = 0
    private let INDEX_SORT_BY_TITLE = 0
    private let INDEX_SORT_BY_RATING = 1
    private let INDEX_SORT_BY_YEAR = 2
    
    let currentSettings = Settings.getInsatance()
    
    override func viewWillDisappear(_ animated: Bool) {
        if settingsHasChanged {
            delegate?.sortSettingHasChanged()
        }
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Sorted by"
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        var sortOptionSelected : SortSetting? = nil
        switch indexPath.row {
        case INDEX_SORT_BY_RATING:
            sortOptionSelected = .rating
            break
        case INDEX_SORT_BY_YEAR:
            sortOptionSelected = .releaseDate
            break
        case INDEX_SORT_BY_TITLE:
            sortOptionSelected = .title
            break
        default:
            sortOptionSelected = .rating
        }
        selectSortOption(sort: sortOptionSelected!)
        currentSettings.sortSelected = sortOptionSelected!
        tableView.deselectRow(at: indexPath, animated: true)
        settingsHasChanged = true
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let positon = positionForSelectedSorted(sort: currentSettings.sortSelected)
        let row = indexPath.row
        if row == positon {
            cell.accessoryType = .checkmark
        } else {
            cell.accessoryType = .none
        }
    }
    
    private func selectSortOption(sortSetting: SortSetting) {
        currentSettings.sortSelected = sortSetting
        selectSortOption(sort: sortSetting)
    }
}

extension SettingsViewController {
    private func positionForSelectedSorted (sort: SortSetting) -> Int {
        switch sort {
        case .rating:
            return INDEX_SORT_BY_RATING
        case .title:
            return INDEX_SORT_BY_TITLE
        case .releaseDate:
            return INDEX_SORT_BY_YEAR
        }
    }
    
    private func selectSortOption(sort: SortSetting) {
        
        let positon = positionForSelectedSorted(sort: sort)
        for cell in sortOptions {
            let row = tableView.indexPath(for: cell)?.row
            if row == positon {
                cell.accessoryType = .checkmark
            } else {
                cell.accessoryType = .none
            }
        }
        
    }
}

protocol SettingsChangeDelegate {
    func sortSettingHasChanged()
}

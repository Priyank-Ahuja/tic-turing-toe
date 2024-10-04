//
//  SettingsViewModel.swift
//  tic-turing-toe
//
//  Created by Priyank Ahuja on 10/3/24.
//

enum settingsSource {
    case home, game
}

class SettingsViewModel {
    var source: settingsSource?
    
    init(source: settingsSource?) {
        self.source = source
    }
}

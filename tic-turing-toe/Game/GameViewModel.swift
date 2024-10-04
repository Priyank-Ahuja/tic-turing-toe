//
//  GameViewModel.swift
//  tic-turing-toe
//
//  Created by Priyank Ahuja on 10/3/24.
//

import CoreBluetooth
import UIKit

import CoreBluetooth

class GameViewModel: NSObject, CBPeripheralManagerDelegate, CBCentralManagerDelegate, CBPeripheralDelegate {
    
    var peripheralManager: CBPeripheralManager?
    var centralManager: CBCentralManager?
    var connectedPeripheral: CBPeripheral?
    var moveCharacteristic: CBMutableCharacteristic?
    
    var isCentral = true // Default to central role
    var isBluetoothGame = false
    var hasSwitchedToPeripheral = false
    var switchRoleTimeout: Timer?
    
    let deviceUUID = UIDevice.current.identifierForVendor?.uuidString ?? UUID().uuidString

    let TicTacToeServiceUUID = CBUUID(string: "1234")
    let TicTacToeMoveCharacteristicUUID = CBUUID(string: "5678")
    
    var board = [String](repeating: "", count: 9)
    var currentPlayer = Constants.string.X
    var gameActive = true
    var level: GameLevel?

    let winningCombinations = [
        [0, 1, 2], [3, 4, 5], [6, 7, 8], // Rows
        [0, 3, 6], [1, 4, 7], [2, 5, 8], // Columns
        [0, 4, 8], [2, 4, 6]             // Diagonals
    ]
    
    init(level: GameLevel?) {
        self.level = level
        self.isBluetoothGame = level == .bluetooth ? true : false
        super.init()
        
        if isBluetoothGame {
            if isCentral {
                // Start as a central device, scanning for peripherals
                centralManager = CBCentralManager(delegate: self, queue: nil)
                startRoleSwitchingTimer() // Start timer to switch roles if no peripheral is found
            } else {
                // Start as a peripheral, advertising the service
                peripheralManager = CBPeripheralManager(delegate: self, queue: nil)
            }
        }
    }
    
    // Start a timer that will switch this device to peripheral mode if no connection is made as central
    func startRoleSwitchingTimer() {
        switchRoleTimeout = Timer.scheduledTimer(timeInterval: 5.0, target: self, selector: #selector(determineRoleSwitch), userInfo: nil, repeats: false)
    }

    // Determine whether to switch to peripheral mode or remain central based on device UUID
    @objc func determineRoleSwitch() {
        if isCentral && !hasSwitchedToPeripheral {
            print("Checking UUID to determine if this device should switch roles.")
            
            // Discover nearby peripherals to compare UUIDs
            centralManager?.scanForPeripherals(withServices: [TicTacToeServiceUUID], options: nil)
            
            // If no peripherals are found within the timeout, switch to peripheral mode
            DispatchQueue.main.asyncAfter(deadline: .now() + 5.0) {
                if self.isCentral {
                    // No other device found, decide role based on UUID
                    self.checkAndSwitchRoleBasedOnUUID()
                }
            }
        }
    }
    
    // Logic to compare UUIDs and switch roles based on UUID comparison
    func checkAndSwitchRoleBasedOnUUID() {
        if isCentral && !hasSwitchedToPeripheral {
            print("No device found. Switching to Peripheral mode.")
            switchToPeripheralMode()
        }
    }

    // Function to switch to peripheral mode
    func switchToPeripheralMode() {
        isCentral = false
        hasSwitchedToPeripheral = true
        centralManager?.stopScan()
        peripheralManager = CBPeripheralManager(delegate: self, queue: nil)
        print("Device has switched to Peripheral mode.")
    }
    
    // MARK: - Central Manager Delegate Methods

    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        if central.state == .poweredOn {
            // Scan for peripherals advertising the Tic-Tac-Toe service
            centralManager?.scanForPeripherals(withServices: [TicTacToeServiceUUID], options: nil)
        }
    }
    
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        if let otherDeviceUUID = advertisementData[CBAdvertisementDataLocalNameKey] as? String {
            print("Discovered device with UUID: \(otherDeviceUUID)")
            
            // Compare the UUIDs to determine whether to switch roles
            if self.deviceUUID < otherDeviceUUID {
                print("This device has a lower UUID. Remaining as central.")
                centralManager?.connect(peripheral, options: nil) // Connect to the peripheral
                switchRoleTimeout?.invalidate() // Stop the role switching timer since a peripheral is found
            } else {
                print("Switching to Peripheral mode due to UUID comparison.")
                switchToPeripheralMode()
            }
        }
    }

    // MARK: - Peripheral Manager Delegate Methods

    func peripheralManagerDidUpdateState(_ peripheral: CBPeripheralManager) {
        if peripheral.state == .poweredOn {
            // Start advertising the Tic-Tac-Toe service along with the device UUID
            let service = CBMutableService(type: TicTacToeServiceUUID, primary: true)
            moveCharacteristic = CBMutableCharacteristic(
                type: TicTacToeMoveCharacteristicUUID,
                properties: [.notify, .write],
                value: nil,
                permissions: [.writeable, .readable]
            )
            service.characteristics = [moveCharacteristic!]
            peripheralManager?.add(service)
            
            // Add the device UUID in the advertisement data
            let advertisementData: [String: Any] = [
                CBAdvertisementDataLocalNameKey: deviceUUID, // Use UUID as local name
                CBAdvertisementDataServiceUUIDsKey: [TicTacToeServiceUUID]
            ]
            
            peripheralManager?.startAdvertising(advertisementData)
        }
    }
    
    // Send the move to the connected opponent device
    func sendMoveToOpponent(move: Int) {
        if let moveData = "\(move)".data(using: .utf8) {
            if let moveCharacteristic = moveCharacteristic {
                // Send move over Bluetooth by updating the characteristic value
                peripheralManager?.updateValue(moveData, for: moveCharacteristic, onSubscribedCentrals: nil)
            } else if let connectedPeripheral = connectedPeripheral, let characteristic = connectedPeripheral.services?.first?.characteristics?.first(where: { $0.uuid == TicTacToeMoveCharacteristicUUID }) {
                // Write the move to the connected peripheral's characteristic
                connectedPeripheral.writeValue(moveData, for: characteristic, type: .withResponse)
            }
        }
    }

    // MARK: - Game Logic (Handling Moves)

    // Reset the game
    func resetGame() {
        board = [String](repeating: "", count: 9)
        currentPlayer = Constants.string.X
        gameActive = true
    }

    // Check if the current player has won
    func checkForWinner() -> Bool {
        for combination in winningCombinations {
            if board[combination[0]] != "" && board[combination[0]] == board[combination[1]] && board[combination[1]] == board[combination[2]] {
                return true
            }
        }
        return false
    }

    // Process player move
    func processMove(at index: Int, forPlayer player: String) -> Bool {
        if gameActive && board[index] == "" {
            board[index] = player
            return true
        }
        return false
    }

    // AI Move Logic (if not a Bluetooth game)
    func aiMove() -> Int {
        guard gameActive, !isBluetoothGame else { return -1 }

        let move: Int
        switch level {
        case .easy:
            move = randomMove()
        case .medium:
            move = Bool.random() ? randomMove() : optimalMove()
        case .hard:
            move = optimalMove()
        case .bluetooth:
            move = randomMove()
        case .none:
            move = randomMove()
        }

        board[move] = Constants.string.O
        return move
    }

    // Random move for AI
    func randomMove() -> Int {
        var emptySlots = [Int]()
        for (index, value) in board.enumerated() {
            if value == "" {
                emptySlots.append(index)
            }
        }
        return emptySlots.randomElement() ?? 0
    }

    // Optimal move using Minimax algorithm
    func optimalMove() -> Int {
        return minimax(board: board, depth: 0, isMaximizing: true, alpha: Int.min, beta: Int.max).position
    }

    // Minimax algorithm with alpha-beta pruning
    func minimax(board: [String], depth: Int, isMaximizing: Bool, alpha: Int, beta: Int) -> (score: Int, position: Int) {
        if let winner = evaluate(board: board) {
            return (winner, -1)
        }

        if !board.contains("") {
            return (0, -1) // Draw
        }

        var alpha = alpha
        var beta = beta
        var bestPosition = -1

        if isMaximizing {
            var bestScore = Int.min
            for i in 0..<board.count where board[i] == "" {
                var newBoard = board
                newBoard[i] = Constants.string.O
                let result = minimax(board: newBoard, depth: depth + 1, isMaximizing: false, alpha: alpha, beta: beta)
                if result.score > bestScore {
                    bestScore = result.score
                    bestPosition = i
                }
                alpha = max(alpha, bestScore)
                if beta <= alpha { break }
            }
            return (bestScore, bestPosition)
        } else {
            var bestScore = Int.max
            for i in 0..<board.count where board[i] == "" {
                var newBoard = board
                newBoard[i] = Constants.string.X
                let result = minimax(board: newBoard, depth: depth + 1, isMaximizing: true, alpha: alpha, beta: beta)
                if result.score < bestScore {
                    bestScore = result.score
                    bestPosition = i
                }
                beta = min(beta, bestScore)
                if beta <= alpha { break }
            }
            return (bestScore, bestPosition)
        }
    }

    // Evaluate the board state
    func evaluate(board: [String]) -> Int? {
        for combination in winningCombinations {
            if board[combination[0]] == Constants.string.O && board[combination[0]] == board[combination[1]] && board[combination[1]] == board[combination[2]] {
                return 1 // AI wins
            } else if board[combination[0]] == Constants.string.X && board[combination[0]] == board[combination[1]] && board[combination[1]] == board[combination[2]] {
                return -1 // Human wins
            }
        }
        return nil
    }
}

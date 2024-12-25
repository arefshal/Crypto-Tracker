# Crypto App

A modern iOS application for tracking and monitoring cryptocurrency prices in real-time.

## Technologies Used

- 🛠️ **Swift & SwiftUI**: Modern UI development
- 🔗 **Combine Framework**: Reactive and asynchronous programming
- 📊 **CoreData**: Local data storage
- 🎨 **Lottie Animations**: Smooth, delightful animations
- 🌐 **URLSession**: For seamless API integration

## Architecture & Project Structure

This project follows the **MVVM** (Model-View-ViewModel) architecture:

```
Crypto/
├── Core/
│   ├── Components/          # Reusable UI components
│   ├── Home/               # Main screen
│   │   ├── Views/
│   │   └── ViewModels/
│   └── Details/            # Detail screen
├── Models/                 # Data models
├── Services/               # Network and data services
│   ├── CoinDataService
│   ├── MarketDataService
│   └── PortfolioDataService
└── Utilities/             # Helper utilities
```

## Key Features

### 📈 Real-Time Cryptocurrency Data
- Fetch live prices and updates using the CoinGecko API.

### 🔍 Advanced Search
- Quickly find any cryptocurrency with a user-friendly search bar.

### ⭐ Watchlist
- Keep track of your favorite cryptocurrencies with a customizable watchlist.

### 📊 Detailed Analytics
- Interactive price charts and comprehensive market statistics.

### 🌟 Elegant UI & Smooth Animations
- Enjoy a modern design with fluid transitions using Lottie animations.

## Technical Requirements

- iOS 16.0+
- Xcode 15.0+
- Swift 6.0+

## API Integration

The app integrates with CoinGecko API endpoints:
- `/coins/markets`: Fetches coin listings
- `/global`: Retrieves global market data

## Implementation Details

- **MVVM Architecture**: Clean separation of concerns between Views and Business Logic
- **SwiftUI Views**: Modern declarative UI
- **Combine Publishers**: Reactive data streams for real-time updates
- **CoreData Integration**: Local storage for user preferences and watchlist
- **Network Layer**: Custom networking using URLSession
- **Custom Components**: Reusable UI components for consistency

## Getting Started

1. Clone the repository
2. Open in Xcode
3. Build and run

## Developer

Developed by Aref Shalchi


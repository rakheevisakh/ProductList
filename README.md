**Product List App:**

This is an iOS application built using Swift and UIKit, follows MVVM + Clean architecture. The app fetches a list of categories and allows the user to view detailed products information in  each category.

Includes MVVM design pattern, dependency injection, Combine and Unit test cases.

**To run the project, ensure you have:**
macOS with the latest Xcode
Swift 5.5+
iOS 16+ Simulator (or physical device)

**Layers and responsibilities**
The project is organized into distinct layers, each responsible for specific concerns:

Models: Domain models for products data
Views: views responsible for the UI layout and presentation.
ViewModels: Contains view models that manage UI state and interact with the domain layer.
Domain: Business logic and repositories.
Helper: Configuration, network, and utilities.

**Dependency Injection**
The project leverages dependency injection to manage dependencies between layers. This ensures loose coupling and enhances testability. Dependencies are injected through initializers, allowing for easy substitution of implementations during testing.

**Screenshots**

![Simulator Screenshot - iPhone 16 Pro - 2025-05-08 at 19 54 35](https://github.com/user-attachments/assets/48e5a506-1df8-4959-a1a0-a2e84437084b)

![Simulator Screenshot - iPhone 16 Pro - 2025-05-08 at 19 55 02](https://github.com/user-attachments/assets/3c0d4b10-6711-4dbd-8a6b-0b734743c173)


<img width="1183" alt="Screenshot 2025-05-08 at 7 54 16 PM" src="https://github.com/user-attachments/assets/10c1615e-4db1-4151-b2bd-844bdad5a1b8" />





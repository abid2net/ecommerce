# E-Commerce Flutter Application

## Overview

This project is a fully functional e-commerce application built with Flutter. It allows users to browse products, manage their cart, place orders, and manage their profiles. The application also includes features for admin users to manage products, categories, and vouchers.

## Features

- **User Authentication**: Users can sign up, log in, and manage their profiles.
- **Product Management**: Admin users can add, edit, and delete products.
- **Category Management**: Admin users can manage product categories.
- **Cart Functionality**: Users can add products to their cart, update quantities, and proceed to checkout.
- **Order Management**: Users can view their order history and details.
- **Review System**: Users can leave reviews for products they have purchased.
- **Wishlist**: Users can save products to their wishlist for future reference.
- **Discount Vouchers**: Users can apply discount codes to their orders.

## Tech Stack

- **Flutter**: The UI framework for building natively compiled applications for mobile, web, and desktop from a single codebase.
- **Firebase**: Used for backend services including authentication, Firestore database, and storage.
- **Bloc**: State management solution for Flutter that helps to separate business logic from UI.

## Project Structure

```
lib/
├── blocs/                     # Business Logic Components
│   ├── auth/                  # Authentication Bloc
│   ├── cart/                  # Cart Bloc
│   ├── category/              # Category Bloc
│   ├── order/                 # Order Bloc
│   ├── product/               # Product Bloc
│   ├── review/                # Review Bloc
│   ├── voucher/               # Voucher Bloc
│   └── wishlist/              # Wishlist Bloc
├── common/                    # Common utilities and widgets
│   ├── constants/             # Constants used throughout the app
│   ├── utils/                 # Utility functions
│   └── widgets/               # Common widgets
├── controllers/               # Controllers for managing app state
├── models/                    # Data models
│   ├── address_model.dart     # Address model
│   ├── category_model.dart    # Category model
│   ├── order_model.dart       # Order model
│   ├── product_model.dart     # Product model
│   ├── review_model.dart      # Review model
│   └── user_model.dart        # User model
├── repositories/              # Data repositories for interacting with Firestore
│   ├── address_repository.dart # Address repository
│   ├── auth_repository.dart    # Authentication repository
│   ├── cart_repository.dart    # Cart repository
│   ├── category_repository.dart # Category repository
│   ├── order_repository.dart   # Order repository
│   ├── product_repository.dart # Product repository
│   ├── review_repository.dart  # Review repository
│   └── voucher_repository.dart # Voucher repository
├── routes/                    # Application routes
├── screens/                   # UI screens
│   ├── auth/                  # Authentication screens
│   ├── cart/                  # Cart screen
│   ├── category/              # Category management screen
│   ├── home/                  # Home screen
│   ├── order/                 # Order screen
│   ├── product/               # Product management screens
│   ├── profile/               # User profile screen
│   ├── voucher/               # Voucher management screen
│   └── wishlist/              # Wishlist screen
└── main.dart                  # Entry point of the application
```

## Getting Started

### Prerequisites

- Flutter SDK
- Firebase project setup with Firestore, Authentication, and Storage enabled.

### Installation

1. Clone the repository:
   ```bash
   git clone https://github.com/abid2net/ecommerce.git
   cd ecommerce
   ```

2. Install dependencies:
   ```bash
   flutter pub get
   ```

3. Set up Firebase:
   - Create a Firebase project.
   - Add your Android and iOS apps to the Firebase project.
   - Download the `google-services.json` for Android and `GoogleService-Info.plist` for iOS and place them in the respective directories.

4. Run the application:
   ```bash
   flutter run
   ```

## Usage

- **User Registration**: Users can register using email and password or sign in with Google.
- **Product Browsing**: Users can browse products by categories and view product details.
- **Cart Management**: Users can add products to their cart, update quantities, and proceed to checkout.
- **Order Placement**: Users can place orders and view their order history.
- **Admin Features**: Admin users can manage products, categories, and vouchers.

## Contributing

Contributions are welcome! Please feel free to submit a pull request or open an issue for any suggestions or improvements.

## License

This project is licensed under the MIT License. See the LICENSE file for more details.

---

This documentation provides an overview of the e-commerce Flutter application, its features, structure, and how to get started. If you have any questions or need further assistance, feel free to reach out!

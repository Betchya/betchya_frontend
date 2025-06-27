# Mock Server for Local Development

This project sets up a simple mock server using Dart Frog for local development. It allows you to simulate backend API calls without hitting the actual backend, making it easier to develop and test your frontend application.

## Project Structure

```
mock-server
├── routes
│   ├── index.dart        # Main entry point for the mock server's routes
│   ├── users
│   │   └── index.dart    # User-related endpoints
│   └── posts
│       └── index.dart    # Post-related endpoints
├── pubspec.yaml          # Dart project configuration
└── README.md             # Project documentation
```

## Setup Instructions

1. **Clone the repository:**
   ```bash
   git clone <repository-url>
   cd mock-server
   ```

2. **Install dependencies:**
   Make sure you have Dart installed, then run:
   ```bash
   dart pub get
   ```

3. **Run the mock server:**
   You can start the server by running:
   ```bash
   dart run
   ```

## Usage

- The mock server will run locally and listen for requests. You can access the endpoints defined in the `routes` directory.
- Modify the route handlers in `routes/users/index.dart` and `routes/posts/index.dart` to customize the responses as needed.

## Contributing

Feel free to submit issues or pull requests if you have suggestions or improvements for the mock server. 

## License

This project is licensed under the MIT License. See the LICENSE file for more details.
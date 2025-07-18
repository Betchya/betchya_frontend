# Mock Server for Local Development

This project sets up a simple mock server using Dart Frog for local development. It allows you to simulate backend API calls without hitting the actual backend, making it easier to develop and test your frontend application.

## Project Structure

```
mock-server
├── routes
│   ├── users
│   │   └── index.dart    # /users endpoint
│   └── posts
│       |── index.dart    # /post endpoint
|       └── [id].dart     # /post/{id} endpoint
├── pubspec.yaml          # Dart project configuration
└── README.md             # Project documentation
```

NOTES: Dart Frog expects folder structure to match the path that is desired for a given endpoint
 1. For example, the GET /users endpoint needs to be under routes/users in an index.dart file
 2. Path variables can be passed and is denoted in the file name for the route/endpoint it applies to, e.g. routes/posts/[id].dart

## Setup Instructions

1. **Install dependencies:**
   Make sure you have Dart installed, then run:
   ```bash
   dart pub get
   ```

2. **Install the Dart Frog CLI:**
   Make sure you have Dart installed, then run:
   ```bash
   dart pub global activate dart_frog_cli
   ```

3. **Run the mock server locally with Dart Frog:**
   You can start the server locally by running:
   ```bash
   dart_frog dev
   ```

## Usage

- The mock server will run locally and listen for requests. You can access the endpoints defined in the `routes` directory.
- Modify the route handlers in `routes/users/index.dart` and `routes/posts/index.dart` to customize the responses as needed.
- NOTE: Dart Frog expects directory structure and file naming to follow certain conventions to bind routes to

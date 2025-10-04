# Backend Integration Setup

## Allow Localhost HTTP Connections

To connect to the local Go backend, you need to allow HTTP connections to localhost.

### Option 1: Add to Info.plist in Xcode (Recommended)

1. Open the Xcode project
2. Select the `Subspace` target
3. Go to the **Info** tab
4. Add a new key called **App Transport Security Settings** (or `NSAppTransportSecurity`)
5. Inside that dictionary, add:
   - Key: **Allow Arbitrary Loads in Web Content**
   - Value: **YES**
6. Also add **Exception Domains** dictionary with:
   - Key: **localhost**
   - Value: Dictionary containing:
     - Key: **NSExceptionAllowsInsecureHTTPLoads**
     - Value: **YES**

### Option 2: Manual Info.plist Configuration

Add this to your target's Info.plist:

```xml
<key>NSAppTransportSecurity</key>
<dict>
    <key>NSAllowsLocalNetworking</key>
    <true/>
    <key>NSExceptionDomains</key>
    <dict>
        <key>localhost</key>
        <dict>
            <key>NSExceptionAllowsInsecureHTTPLoads</key>
            <true/>
        </dict>
    </dict>
</dict>
```

## Start the Backend

```bash
cd Subspace-backend

# Option 1: Run directly (requires Go installed)
make run

# Option 2: Use Docker
make docker-up
```

The backend will be available at `http://localhost:8080`

## Test the Integration

1. Start the backend server
2. Run the iOS app in the simulator
3. Navigate to the **Profile** tab - it will fetch user data from the backend
4. Check the **Home** tab - it will display messages from the backend

## API Endpoints Used

- `GET /api/v1/users/{id}` - Fetch user profile
- `GET /api/v1/users/{userId}/messages` - Fetch user messages
- `GET /health` - Health check

## Troubleshooting

### "The resource could not be loaded because the App Transport Security policy requires..."

This means the Info.plist settings above weren't applied correctly. Double-check the configuration in Xcode.

### Connection refused

Make sure the Go backend is running on port 8080.

### No data showing

Check the Xcode console for network logs from `APIClient`. You should see requests being made.

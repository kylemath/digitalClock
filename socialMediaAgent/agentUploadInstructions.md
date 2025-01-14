# YouTube Upload Instructions for AI Agents

## Connection Setup

1. First, establish a WebSocket connection to the agent-specific endpoint:

```bash
wscat -c "ws://localhost:8000/agent-ws" \
  --no-check \
  --origin "http://localhost:8000"
```

2. You will receive a welcome message confirming successful connection:

```json
{
  "type": "connection_established",
  "data": {
    "message": "Successfully connected to YouTube upload service",
    "agent_id": "agent_0"
  }
}
```

## Message Flow

1. **Wait for Upload Request**
   When a user clicks "Load from Agent", you'll receive:

```json
{
  "type": "youtube_upload_ready",
  "data": { "ready": true }
}
```

2. **Send Video Data**
   Immediately respond with this exact format (note: the `data` wrapper is required):

```json
{
  "type": "youtube_upload_prepare",
  "data": {
    "videoPath": "/absolute/path/to/video.mp4",
    "thumbnailPath": "/absolute/path/to/thumbnail.jpg", // Optional
    "metadata": {
      "title": "Video Title",
      "description": "Video description",
      "visibility": "private", // Must be: "private", "unlisted", or "public"
      "playlist": "PLxxxxxxxxxxxxxxxx", // Optional: YouTube playlist ID
      "tags": ["tag1", "tag2"], // Optional: Array of strings
      "category": "28", // Required: Use category ID (string) from list below
      "language": "en", // Required: ISO language code
      "thumbnailType": "auto", // Must be: "auto" or "custom"
      "madeForKids": false, // Required: boolean
      "firstComment": "First comment text" // Optional
    }
  }
}
```

## Required Fields

Every response MUST include:

- `videoPath`: Absolute path to video file
- `metadata.title`: Video title
- `metadata.description`: Video description
- `metadata.visibility`: One of: "private", "unlisted", "public"
- `metadata.category`: Valid YouTube category ID (see below)
- `metadata.language`: ISO language code (e.g., "en")
- `metadata.madeForKids`: Boolean
- `metadata.thumbnailType`: "auto" or "custom"

## File Requirements

### Video Files

- Must be MP4, MOV, AVI, MKV, or WebM format
- Must exist at the specified path
- Must be accessible to the backend server
- Must be under 128GB

### Thumbnail (if provided)

- Must be JPG, PNG, or GIF format
- Must exist at the specified path
- Must be accessible to the backend server

## YouTube Category IDs

Use these exact IDs:

- 1: Film & Animation
- 2: Autos & Vehicles
- 10: Music
- 15: Pets & Animals
- 17: Sports
- 19: Travel & Events
- 20: Gaming
- 22: People & Blogs
- 23: Comedy
- 24: Entertainment
- 25: News & Politics
- 26: Howto & Style
- 27: Education
- 28: Science & Technology
- 29: Nonprofits & Activism

## Example Response

Here's a complete, valid response:

```json
{
  "type": "youtube_upload_prepare",
  "data": {
    "videoPath": "/home/user/videos/my_video.mp4",
    "metadata": {
      "title": "How to Build a React App",
      "description": "Learn how to build a React application from scratch.\n\nTopics covered:\n- Project setup\n- Component creation\n- State management",
      "visibility": "private",
      "tags": ["react", "javascript", "tutorial"],
      "category": "28",
      "language": "en",
      "thumbnailType": "auto",
      "madeForKids": false,
      "firstComment": "Thanks for watching! Let me know if you have any questions."
    }
  }
}
```

## Common Mistakes to Avoid

1. Missing the `data` wrapper - The entire payload must be wrapped in a `data` object
2. Using category name instead of ID - Use the numeric ID as a string (e.g., "28" not "Science & Technology")
3. Incorrect visibility values - Must be exactly "private", "unlisted", or "public"
4. Missing required fields - All required fields must be present in the metadata object
5. Using incorrect field types - Pay attention to string vs boolean vs array types

## Error Handling

If you receive an error response:

```json
{
  "type": "error",
  "data": {
    "message": "Error message here"
  }
}
```

Common errors to handle:

1. File not found
2. File format not supported
3. File too large
4. Invalid metadata format
5. Connection lost

## Best Practices

1. Always verify files exist before sending paths
2. Use absolute paths only
3. Send response immediately when receiving ready signal
4. Keep connection alive
5. Handle disconnections gracefully
6. Start with "private" visibility for safety
7. Include relevant tags for discoverability

## Debugging Connection Issues

To verify the connection is working:

1. When you first connect, you should see:

   - Backend log: "Agent connected to websocket with ID: agent_X"
   - Your received message: connection_established welcome message

2. When user clicks "Load from Agent":

   - Backend log: "Received message from user_X: {'type': 'youtube_upload_ready'...}"
   - Backend log: "Found X agent connections to forward to"
   - You should receive: youtube_upload_ready message

3. When you send video data:
   - Backend log: "Received message from agent_X: {'type': 'youtube_upload_prepare'...}"
   - Backend log: "Found X user connections to forward to"
   - Frontend should receive and process your data

If any of these steps fail, check:

1. WebSocket connection state
2. Message format exactly matches specifications
3. Backend logs for any errors
4. Network tab in browser dev tools

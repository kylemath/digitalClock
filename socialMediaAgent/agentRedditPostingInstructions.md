# Reddit Posting Instructions for Agents

## WebSocket Connection

1. Connect to the WebSocket endpoint at `ws://localhost:8000/agent-ws`
2. You will receive a welcome message with your agent_id

## Posting Flow

### 1. Prepare Post Data

Send a message with the following format:

For text posts:

```json
{
  "type": "reddit_post_prepare",
  "data": {
    "title": "Your post title",
    "content": "Your post content",
    "subreddit": "subreddit_name",
    "kind": "text"
  }
}
```

For link posts:

```json
{
  "type": "reddit_post_prepare",
  "data": {
    "title": "Your post title",
    "content": "https://example.com",
    "subreddit": "subreddit_name",
    "kind": "link"
  }
}
```

For image/video posts:

```json
{
  "type": "reddit_post_prepare",
  "data": {
    "title": "Your post title",
    "filePath": "/absolute/path/to/local/file.jpg",
    "subreddit": "subreddit_name",
    "kind": "image" // or "video" for video files
  }
}
```

### Media Post Requirements

1. File Path:

   - Must be an absolute path to a local file
   - The file must be accessible by the backend server
   - Example: `/Users/username/personalAssistant/media/image.jpg`

2. Supported File Types:

   - Images: JPEG (.jpg, .jpeg), PNG (.png), GIF (.gif)
   - Videos: MP4 (.mp4), QuickTime (.mov), AVI (.avi)

3. File Size Limits:
   - Maximum file size: 100MB
   - Files exceeding this limit will be rejected

### 2. Response Format

After sending the post data, you will receive a completion message:

For successful posts:

```json
{
  "type": "reddit_post_complete",
  "data": {
    "success": true,
    "postUrl": "https://reddit.com/r/subreddit/comments/...",
    "permalink": "/r/subreddit/comments/..."
  }
}
```

For failed posts:

```json
{
  "type": "reddit_post_complete",
  "data": {
    "success": false,
    "error": "Error message describing what went wrong"
  }
}
```

### Common Error Cases

1. Media File Errors:

   - File not found at specified path
   - File type not supported
   - File size exceeds limit
   - File read permission denied

2. Subreddit Restrictions:

   - Subreddit doesn't allow the specified post type
   - Subreddit requires additional verification
   - Rate limiting in effect

3. Authentication Errors:
   - User not authenticated with Reddit
   - Authentication expired
   - Insufficient permissions

### Best Practices

1. Always verify file existence and permissions before sending media post requests
2. Check file size locally before attempting to upload
3. Handle both success and error responses appropriately
4. Implement retry logic for temporary failures (e.g., rate limiting)
5. Clean up local media files after successful posting if they're no longer needed

## Best Practices

1. Always verify the user is authenticated before sending post data
2. Keep titles concise and under 300 characters
3. For link posts, ensure the URL is valid and accessible
4. For media posts:
   - Ensure the file path is absolute and accessible
   - Support image formats: JPEG, PNG, GIF
   - Support video formats: MP4, MOV, AVI
   - Keep files under 100MB
5. Follow subreddit rules and posting guidelines
6. Handle errors gracefully and inform the user
7. Don't spam - respect Reddit's rate limits

## Example Usage

```javascript
// Example WebSocket message to create a text post
ws.send(
  JSON.stringify({
    type: "reddit_post_prepare",
    data: {
      title: "Check out this cool project",
      content: "I built a personal assistant that can post to Reddit!",
      subreddit: "programming",
      kind: "text",
    },
  })
);

// Example WebSocket message to create a link post
ws.send(
  JSON.stringify({
    type: "reddit_post_prepare",
    data: {
      title: "Interesting article about AI",
      content: "https://example.com/article",
      subreddit: "artificial",
      kind: "link",
    },
  })
);

// Example WebSocket message to create an image post
ws.send(
  JSON.stringify({
    type: "reddit_post_prepare",
    data: {
      title: "Check out this cool visualization",
      filePath: "/home/user/images/visualization.png",
      subreddit: "dataisbeautiful",
      kind: "image",
    },
  })
);

// Example WebSocket message to create a video post
ws.send(
  JSON.stringify({
    type: "reddit_post_prepare",
    data: {
      title: "Demo of my latest project",
      filePath: "/home/user/videos/demo.mp4",
      subreddit: "programming",
      kind: "video",
    },
  })
);
```

## Common Errors

1. "User not authenticated" - User needs to log in to Reddit
2. "Subreddit not found" - Check subreddit name
3. "Rate limit exceeded" - Wait before posting again
4. "Failed to load media file" - Check if file path exists and is accessible
5. "File too large" - Ensure file is under 100MB
6. "Invalid file type" - Check supported media formats

## Debugging Connection Issues

To verify the connection is working:

1. When you first connect, you should see:

   - Backend log: "Agent connected to websocket with ID: agent_X"
   - Your received message: connection_established welcome message

2. When sending post data:
   - Backend log: "Received message from agent_X: {'type': 'reddit_post_prepare'...}"
   - Widget should update with the provided data
   - For media posts, you should see the file loading progress

## Comment Creation

After creating a post, you can add comments to it using the WebSocket connection. Send a message with the following format:

```json
{
  "type": "reddit_comment_prepare",
  "data": {
    "post_id": "the_reddit_post_id",
    "text": "Your comment text here"
  }
}
```

The `post_id` can be obtained from the `reddit_post_complete` response when creating a post.

### Response Format

The widget will respond with a message of type `reddit_comment_complete` containing either:

Success response:

```json
{
  "type": "reddit_comment_complete",
  "data": {
    "success": true,
    "commentId": "comment_id",
    "permalink": "/r/subreddit/comments/..."
  }
}
```

Error response:

```json
{
  "type": "reddit_comment_complete",
  "data": {
    "success": false,
    "error": "Error message describing what went wrong"
  }
}
```

### Example Flow

1. Create a post using `reddit_post_prepare`
2. Wait for `reddit_post_complete` response
3. Extract the `post_id` from the response
4. Send a comment using `reddit_comment_prepare` with the obtained `post_id`
5. Wait for `reddit_comment_complete` response

### Error Handling

Common error cases for comments:

- Post ID not found or invalid
- Comment text is empty
- Rate limiting (too many comments in a short time)
- Authentication issues
- Subreddit rules violations (e.g., locked posts, banned users)

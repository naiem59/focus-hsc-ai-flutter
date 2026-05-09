# API Integration Guide - Focus HSC AI

## Overview

Focus HSC AI integrates with Google's Gemini API for AI-powered study features. This guide explains the API setup and usage.

## Getting Gemini API Key

### Step 1: Access Google AI Studio

1. Visit [https://aistudio.google.com](https://aistudio.google.com)
2. Click "Get API Key" button
3. Create a new project or select existing

### Step 2: Create API Key

1. Click "Create API Key"
2. Choose your Google Cloud project
3. Copy the generated API key
4. Store it securely

### Step 3: Configure in App

Update `lib/constants/app_constants.dart`:

```dart
static const String geminiApiKey = 'YOUR_API_KEY_HERE';
```

## API Service Usage

### AI Chat Service

```dart
final service = GeminiAIService();

// Ask a question
final response = await service.askQuestion(
  question: 'What is photosynthesis?',
  subject: 'বায়োলজি',
  conversationHistory: null, // Optional for context
);
```

### CQ Answer Generation

```dart
final answer = await service.generateCQAnswer(
  question: 'Explain the French Revolution',
  subject: 'ইতিহাস',
);
```

### MCQ Explanation

```dart
final explanation = await service.getMCQExplanation(
  question: 'What is the capital of Bangladesh?',
  options: ['Dhaka', 'Chittagong', 'Sylhet', 'Khulna'],
  correctAnswerIndex: 0,
  subject: 'ভূগোল',
);
```

### Study Tips Generation

```dart
final tips = await service.generateStudyTips(
  subject: 'ইংরেজি',
  chapter: 'Grammar - Tenses',
);
```

## API Request Structure

### Request Format

```json
{
  "contents": [
    {
      "role": "user",
      "parts": [
        {
          "text": "Your prompt here"
        }
      ]
    }
  ],
  "generationConfig": {
    "temperature": 0.7,
    "topK": 40,
    "topP": 0.95,
    "maxOutputTokens": 1024
  }
}
```

### Response Format

```json
{
  "candidates": [
    {
      "content": {
        "parts": [
          {
            "text": "Generated response"
          }
        ]
      }
    }
  ]
}
```

## Generation Parameters

| Parameter | Value | Purpose |
|-----------|-------|---------|
| temperature | 0.5-0.7 | Controls response creativity |
| topK | 40 | Diversity in responses |
| topP | 0.95 | Nucleus sampling threshold |
| maxOutputTokens | 512-2048 | Response length limit |

## System Prompts

### HSC Study Prompt

```text
You are an HSC 1st Year exam study assistant for Arts students in Bangladesh.

Your role:
1. Provide exam-focused explanations in simple language
2. Answer questions strictly within HSC syllabus
3. Support Bangla and English languages
4. Give clear, concise answers suitable for board exams
5. Never provide irrelevant information

Maintain professionalism and keep answers focused on exam preparation.
```

## Error Handling

### Common Errors

```dart
try {
  final response = await service.askQuestion(
    question: question,
    subject: subject,
  );
} on DioException catch (e) {
  // Network error
  print('Network error: ${e.message}');
} catch (e) {
  // Other errors
  print('Error: $e');
}
```

### API Quota Errors

If you receive quota errors:
1. Wait 1-2 hours
2. Check quota in Google Cloud Console
3. Upgrade to paid plan if needed

### Rate Limiting

- Free tier: 60 requests per minute
- Premium: Custom limits based on plan

## Best Practices

1. **Cache Responses**: Store responses locally to reduce API calls
2. **Batch Requests**: Combine multiple requests when possible
3. **Implement Timeout**: Set reasonable timeouts (30 seconds)
4. **Handle Failures**: Gracefully handle API failures
5. **Monitor Usage**: Track API usage in Google Cloud Console

## Caching Strategy

```dart
class CacheManager {
  static final Map<String, String> _cache = {};

  static Future<String> getCachedOrFetch(
    String key,
    Future<String> Function() fetchFunc,
  ) async {
    if (_cache.containsKey(key)) {
      return _cache[key]!;
    }
    
    final result = await fetchFunc();
    _cache[key] = result;
    return result;
  }
}
```

## Production Checklist

- [ ] API key in environment variables
- [ ] Error handling implemented
- [ ] Caching mechanism active
- [ ] Rate limiting considered
- [ ] Timeout set to 30 seconds
- [ ] API quota monitored
- [ ] Response validation added
- [ ] Logging implemented

## Monitoring

### View API Usage

1. Open Google Cloud Console
2. Navigate to Generative AI API
3. Check usage statistics
4. Set quota alerts

### Debug Logging

```dart
logger.d('API Request: $question');
logger.d('API Response: $response');
logger.e('API Error: $error');
```

## Alternative APIs

If Gemini becomes unavailable:
- **OpenAI GPT-4**: Similar implementation
- **Claude API**: Anthropic's alternative
- **Local LLM**: Run locally with Ollama

## Troubleshooting

### "Invalid API Key"
- Verify key is copied correctly
- Check for spaces in key
- Regenerate key if needed

### "Quota Exceeded"
- Wait before making new requests
- Check request frequency
- Upgrade to paid plan

### "Invalid Request"
- Verify prompt format
- Check content guidelines
- Review error message details

---

**Last Updated**: May 8, 2026
**API Version**: Gemini 1.5

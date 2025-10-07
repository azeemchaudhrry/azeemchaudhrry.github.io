---
layout: post
title: "Building Smart Form Validation in Jetpack Compose: A UX-First Approach"
date: 2025-10-07 10:00:00 +0500
categories: [Android, Kotlin, Jetpack Compose, UI/UX]
tags: [android, kotlin, jetpack-compose, form-validation, material-design, compose, android-development]
author: Azeem Rehman
excerpt: "Learn how to build a reusable validated text field component in Jetpack Compose that provides intelligent error feedback only when users need it - not when they don't."
---
Form validation is one of those features that seems simple until you start thinking about user experience. Show errors too early, and you frustrate users before they've even started typing. Show them too late, and users submit invalid forms repeatedly. Today, I'll walk you through building a smart form validation system in Jetpack Compose that strikes the perfect balance.

## The Problem with Traditional Form Validation

Most form implementations I've seen (and built, if I'm honest) fall into one of these traps:

**Trap #1: Aggressive Validation**

```kotlin
// Don't do this!
TextField(
    value = name,
    onValueChange = { 
        name = it
        error = if (it.isEmpty()) "Name is required" else null
    }
)
```

This shows errors immediately when the page loads or as soon as users clear a field. It's technically correct but feels hostile.

**Trap #2: Passive Validation**

```kotlin
// Also not ideal
Button(onClick = { 
    if (name.isEmpty()) showError = true
})
```

This only validates on submit, which means users might fill out an entire form only to discover multiple errors at the end.

## A Better Approach: Context-Aware Validation

The solution is to validate **contextually** based on user interaction:

1. ✅ Don't show errors on initial page load
2. ✅ Show errors if users enter text then clear it
3. ✅ Show errors when users attempt to submit
4. ✅ Clear errors as soon as the field becomes valid

Let's build this.

## Building the Reusable Component

### Step 1: Enhanced Field State

First, we need to track more than just the value and error. We need to know *how* the user has interacted with the field:

```kotlin
data class FieldState(
    val value: String = "",
    val error: String? = null,
    val isTouched: Boolean = false,
    val hasBeenModified: Boolean = false
) {
    fun shouldShowError(forceValidation: Boolean = false): Boolean {
        return (hasBeenModified || forceValidation) && error != null
    }
}
```

**Key Concepts:**

- `isTouched`: Has the field been focused at least once?
- `hasBeenModified`: Has the user entered text and then cleared/changed it?
- `shouldShowError()`: Smart logic that decides when to display errors

### Step 2: The ValidatedTextField Component

Now we create a reusable composable that encapsulates this behavior:

```kotlin
@Composable
fun ValidatedTextField(
    value: String,
    onValueChange: (String) -> Unit,
    label: String,
    errorMessage: String? = null,
    showError: Boolean = false,
    onFocusChanged: ((Boolean) -> Unit)? = null,
    modifier: Modifier = Modifier,
    keyboardOptions: KeyboardOptions = KeyboardOptions.Default,
    keyboardActions: KeyboardActions = KeyboardActions.Default
) {
    val shouldShowError = showError && errorMessage != null
  
    Column(modifier = modifier) {
        OutlinedTextField(
            value = value,
            onValueChange = onValueChange,
            modifier = Modifier
                .fillMaxWidth()
                .onFocusChanged { focusState ->
                    onFocusChanged?.invoke(focusState.isFocused)
                },
            placeholder = { Text(label, color = Color.Gray) },
            isError = shouldShowError,
            colors = OutlinedTextFieldDefaults.colors(
                focusedBorderColor = if (shouldShowError) 
                    MaterialTheme.colorScheme.error 
                else 
                    MaterialTheme.colorScheme.primary,
                unfocusedBorderColor = if (shouldShowError) 
                    MaterialTheme.colorScheme.error 
                else 
                    Color.Gray
            ),
            keyboardOptions = keyboardOptions,
            keyboardActions = keyboardActions,
            shape = RoundedCornerShape(8.dp)
        )
      
        if (shouldShowError) {
            Text(
                text = errorMessage!!,
                color = MaterialTheme.colorScheme.error,
                fontSize = 12.sp,
                modifier = Modifier.padding(start = 16.dp, top = 4.dp)
            )
        }
    }
}
```

### Step 3: Smart State Management

Here's where the magic happens. When users interact with the field, we update the state intelligently:

```kotlin
ValidatedTextField(
    value = firstName.value,
    onValueChange = { newValue ->
        val hadValue = firstName.value.isNotEmpty()
        firstName = FieldState(
            value = newValue,
            error = validateFirstName(newValue),
            isTouched = true,
            // Mark as modified if user had text and cleared it
            hasBeenModified = firstName.hasBeenModified || 
                             (hadValue && newValue.isEmpty())
        )
    },
    label = "First Name",
    errorMessage = firstName.error,
    showError = firstName.shouldShowError(submitAttempted),
    onFocusChanged = { isFocused ->
        if (isFocused) {
            firstName = firstName.copy(isTouched = true)
        }
    }
)
```

**What's happening here?**

1. We track if the field previously had a value (`hadValue`)
2. If it did and now it's empty, we set `hasBeenModified = true`
3. Only then do we show the error message
4. On focus, we mark the field as touched

## Complete Form Example

Here's a complete recipient details form using this pattern:

```kotlin
@OptIn(ExperimentalMaterial3Api::class)
@Composable
fun RecipientDetailsScreen(
    onBackClick: () -> Unit = {},
    onContinueClick: (Map<String, String>) -> Unit = {}
) {
    var firstName by remember { mutableStateOf(FieldState()) }
    var lastName by remember { mutableStateOf(FieldState()) }
    var submitAttempted by remember { mutableStateOf(false) }
  
    val isFormValid = firstName.error == null && 
                     firstName.value.isNotBlank() &&
                     lastName.error == null && 
                     lastName.value.isNotBlank()
  
    Scaffold(
        topBar = {
            TopAppBar(
                title = { Text("Enter Recipient Details") },
                navigationIcon = {
                    IconButton(onClick = onBackClick) {
                        Icon(Icons.Default.ArrowBack, "Back")
                    }
                }
            )
        }
    ) { padding ->
        Column(
            modifier = Modifier
                .fillMaxSize()
                .padding(padding)
                .padding(16.dp),
            verticalArrangement = Arrangement.spacedBy(16.dp)
        ) {
            ValidatedTextField(
                value = firstName.value,
                onValueChange = { newValue ->
                    val hadValue = firstName.value.isNotEmpty()
                    firstName = FieldState(
                        value = newValue,
                        error = if (newValue.isBlank()) 
                            "Please enter first name" 
                        else null,
                        isTouched = true,
                        hasBeenModified = firstName.hasBeenModified || 
                                        (hadValue && newValue.isEmpty())
                    )
                },
                label = "First Name",
                errorMessage = firstName.error,
                showError = firstName.shouldShowError(submitAttempted)
            )
          
            ValidatedTextField(
                value = lastName.value,
                onValueChange = { newValue ->
                    val hadValue = lastName.value.isNotEmpty()
                    lastName = FieldState(
                        value = newValue,
                        error = if (newValue.isBlank()) 
                            "Please enter last name" 
                        else null,
                        isTouched = true,
                        hasBeenModified = lastName.hasBeenModified || 
                                        (hadValue && newValue.isEmpty())
                    )
                },
                label = "Last Name",
                errorMessage = lastName.error,
                showError = lastName.shouldShowError(submitAttempted)
            )
          
            Spacer(modifier = Modifier.weight(1f))
          
            Button(
                onClick = {
                    submitAttempted = true
                    firstName = firstName.copy(
                        hasBeenModified = true,
                        error = if (firstName.value.isBlank()) 
                            "Please enter first name" 
                        else null
                    )
                    lastName = lastName.copy(
                        hasBeenModified = true,
                        error = if (lastName.value.isBlank()) 
                            "Please enter last name" 
                        else null
                    )
                  
                    if (isFormValid) {
                        onContinueClick(
                            mapOf(
                                "firstName" to firstName.value,
                                "lastName" to lastName.value
                            )
                        )
                    }
                },
                modifier = Modifier
                    .fillMaxWidth()
                    .height(56.dp)
            ) {
                Text("Continue")
            }
        }
    }
}
```

## The User Experience

Let's see how this plays out in real usage:

| User Action                            | Behavior                 | Why?                       |
| -------------------------------------- | ------------------------ | -------------------------- |
| Page loads with empty fields           | No errors shown          | User hasn't interacted yet |
| User types "Jo" then deletes it        | Error appears            | User modified then cleared |
| User focuses field but doesn't type    | No error                 | No modification occurred   |
| User clicks Continue with empty fields | All errors appear        | Form submission attempted  |
| User types "John"                      | Error clears immediately | Field is now valid         |

## Performance Considerations

One concern with this approach is the frequency of recomposition. Here are some optimizations:

### 1. Derivation Instead of State

For computed values like `isFormValid`, use derived state:

```kotlin
val isFormValid by remember {
    derivedStateOf {
        firstName.error == null && firstName.value.isNotBlank() &&
        lastName.error == null && lastName.value.isNotBlank()
    }
}
```

### 2. Stable Keys for Lists

If you have multiple fields in a list, use stable keys:

```kotlin
fields.forEach { field ->
    key(field.id) {
        ValidatedTextField(/* ... */)
    }
}
```

### 3. Remember Validation Functions

Cache expensive validation logic:

```kotlin
val emailValidator = remember {
    { email: String ->
        if (!email.matches(Regex("^[A-Za-z0-9+_.-]+@(.+)$"))) {
            "Invalid email format"
        } else null
    }
}
```

## Testing the Component

Here's how you can test this behavior:

```kotlin
@Test
fun validatedTextField_showsError_whenModifiedAndCleared() {
    var state by mutableStateOf(FieldState())
  
    composeTestRule.setContent {
        ValidatedTextField(
            value = state.value,
            onValueChange = { newValue ->
                val hadValue = state.value.isNotEmpty()
                state = FieldState(
                    value = newValue,
                    error = if (newValue.isBlank()) "Required" else null,
                    hasBeenModified = hadValue && newValue.isEmpty()
                )
            },
            label = "Test Field",
            errorMessage = state.error,
            showError = state.shouldShowError()
        )
    }
  
    // Type and clear
    composeTestRule.onNodeWithText("Test Field").performTextInput("text")
    composeTestRule.onNodeWithText("Test Field").performTextClearance()
  
    // Error should appear
    composeTestRule.onNodeWithText("Required").assertIsDisplayed()
}
```

## Real-World Extensions

### Adding Async Validation

For backend validation (like checking username availability):

```kotlin
data class FieldState(
    val value: String = "",
    val error: String? = null,
    val isValidating: Boolean = false,
    val isTouched: Boolean = false,
    val hasBeenModified: Boolean = false
)

@Composable
fun AsyncValidatedTextField(
    /* ... */,
    onAsyncValidate: suspend (String) -> String?
) {
    LaunchedEffect(value) {
        if (value.isNotEmpty()) {
            delay(500) // Debounce
            isValidating = true
            error = onAsyncValidate(value)
            isValidating = false
        }
    }
  
    // Show loading indicator when validating
    if (isValidating) {
        CircularProgressIndicator(modifier = Modifier.size(20.dp))
    }
}
```

### Pattern-Based Validation

Create reusable validators:

```kotlin
object Validators {
    fun required(message: String = "This field is required"): (String) -> String? {
        return { if (it.isBlank()) message else null }
    }
  
    fun email(message: String = "Invalid email"): (String) -> String? {
        return { 
            if (!it.matches(Regex("^[A-Za-z0-9+_.-]+@(.+)$"))) 
                message 
            else 
                null 
        }
    }
  
    fun minLength(
        length: Int, 
        message: String = "Minimum $length characters"
    ): (String) -> String? {
        return { if (it.length < length) message else null }
    }
}

// Usage
val validators = listOf(
    Validators.required(),
    Validators.email(),
    Validators.minLength(6)
)
```

## Conclusion

Smart form validation is about respecting your users' time and attention. By tracking interaction state and showing errors contextually, we create forms that feel helpful rather than hostile.

The key principles:

1. **Track interaction state** - Know when users have engaged with fields
2. **Validate contextually** - Show errors only when meaningful
3. **Provide immediate feedback** - Clear errors as soon as fields become valid
4. **Make it reusable** - Build components that work consistently across your app

This approach has significantly improved our form completion rates and reduced user frustration. Give it a try in your next Compose project!

## Resources

- [Full source code on GitHub](https://github.com/azeemchaudhrry/ComposeForms)
- [Jetpack Compose Documentation](https://developer.android.com/jetpack/compose)
- [Material Design Form Guidelines](https://m3.material.io/)

---

*Have questions or improvements? Feel free to reach out or open an issue on GitHub!*

**Tags:** #Android #Kotlin #JetpackCompose #FormValidation #MaterialDesign #AndroidDevelopment #UX #UI

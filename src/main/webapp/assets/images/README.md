# Stockio Logo Placement

## Logo File Location
Place your Stockio logo image file here with the name: `logo.png`

## Logo Requirements
- **File name**: `logo.png`
- **Recommended size**: 200x60 pixels (or similar aspect ratio)
- **Format**: PNG with transparent background preferred
- **Maximum height**: 40px (will be automatically resized in header)

## Current Implementation
The header.jsp file is configured to:
1. Try to load `assets/images/logo.png`
2. If the image fails to load, it will fallback to text: "📦 Stockio"

## Alternative Formats
You can also use:
- `logo.jpg`
- `logo.svg`
- `logo.gif`

Just update the src attribute in `includes/header.jsp` if using a different format.

## Folder Structure
```
src/main/webapp/
├── assets/
│   └── images/
│       ├── logo.png          ← Place your logo here
│       └── README.md         ← This file
```
#!/bin/bash

# Database Configuration
export DATABASE_URL="ecto://USER:PASSWORD@HOST/DATABASE"

# Email Provider Configuration
export EMAIL_PROVIDER_API_KEY="your_email_provider_api_key"

# Google OAuth Configuration
export GOOGLE_CLIENT_ID="your_google_client_id"
export GOOGLE_CLIENT_SECRET="your_google_client_secret"
export GOOGLE_REDIRECT_URI="http://localhost:4000/auth/google/callback"

# GitHub OAuth Configuration
export GITHUB_CLIENT_ID="your_github_client_id"
export GITHUB_CLIENT_SECRET="your_github_client_secret"
export GITHUB_REDIRECT_URI="http://localhost:4000/auth/github/callback"

# Any other environment variables your MVP might need
# export VARIABLE_NAME="value"

echo "Environment variables initialized."

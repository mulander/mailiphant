OpenAI.configure do |config|
    config.access_token = Rails.application.credentials.dig(:azure_openai_api_key)
    config.uri_base = Rails.application.credentials.dig(:azure_openai_uri)
    config.api_type = :azure
    config.api_version = "2024-02-15-preview"
end
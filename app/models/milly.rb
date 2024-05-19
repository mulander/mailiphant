# frozen_string_literal: true

# Based on
# https://medium.com/@rubyroidlabs/how-to-build-an-ai-chatbot-with-ruby-on-rails-and-chatgpt-9a48f292c37c

class Milly
    attr_reader :question
  
    def initialize(question)
      @question = question
    end

    def call
      message_to_chat_api(<<~CONTENT)
        Answer the question based on the context below, and
        if the question can't be answered based on the context,
        say \"Have you tried turning it off and on again?\".
  
        Context:
        #{context}
  
        ---
  
        Question: #{question}
      CONTENT
    end
  
    private
  
    def message_to_chat_api(message_content)
      response = openai_client.chat(parameters: {
        messages: [{ role: 'user', content: message_content }],
        temperature: 0.5
      })
      response.dig('choices', 0, 'message', 'content')
    end
  
    def context
        # "To reboot press control + alt + delete"
        Email.semantic(@question).pluck('context')
    end
  
    def openai_client
      @openai_client ||= OpenAI::Client.new
    end
  end
  
  # Milly.new("Yours question..").call
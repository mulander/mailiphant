# frozen_string_literal: true

# Based on
# https://medium.com/@rubyroidlabs/how-to-build-an-ai-chatbot-with-ruby-on-rails-and-chatgpt-9a48f292c37c

class Milly
    attr_reader :question
  
    def initialize(question)
      @question = question
    end

    def call
      noidea = "Have you tried turning it off and on again?"
      results = context_split.map {|context|
        message_to_chat_api(<<~CONTENT)
          You are Milly, the playfull Mailiphant that knows everything
          about the PostgreSQL database.
          Answer the Question based on the Context below, and
          if the question can't be answered based on the context,
          say \"#{noidea}\".

          Context:
          #{context}

          ---

          Question: #{question}
        CONTENT
      }
      results.reject! {|r| r == noidea}
      results.empty? ? noidea : results.first
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
        Email.semantic(@question).pluck('context').first
    end

    def context_split
      ctx = context
      enc = Tiktoken.encoding_for_model("gpt-3.5-turbo")
      len = ctx.size
      n = 2
      n *= 2 until ctx.chars.each_slice(len / n).map(&:join).all? {|s| enc.encode(s).length < 3500}
      ctx.chars.each_slice(len / n).map(&:join)
    end

    def openai_client
      @openai_client ||= OpenAI::Client.new
    end
  end
  
  # Milly.new("Yours question..").call
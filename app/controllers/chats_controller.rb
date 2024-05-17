class ChatsController < ApplicationController
    def index
    end
  
    def create
      @reply = Milly.new(question).call
    end
  
    private
  
    def question
      params[:question][:question]
    end
  end
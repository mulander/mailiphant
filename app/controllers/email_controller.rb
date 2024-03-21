class EmailController < ApplicationController
    def show
        @email = Email.find_by(message_id: params[:message_id])
    end
end
  
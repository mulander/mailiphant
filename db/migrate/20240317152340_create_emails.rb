class CreateEmails < ActiveRecord::Migration[7.1]
  def change
    create_table :emails, id: false, primary_key: :message_id do |t|
      t.datetime :date
      t.text :message_id, null: false
      t.text :in_reply_to, index: true
      t.text :from
      t.text :to
      t.text :cc
      t.text :subject
      t.text :content

      t.timestamps
    end

    execute "ALTER TABLE emails ADD CONSTRAINT message_id_pk PRIMARY KEY(message_id);"

    # Can't use, as we have replies for emails we don't have
    #add_foreign_key :emails, :emails, column: :in_reply_to, primary_key: :message_id
  end
end

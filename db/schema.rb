# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.1].define(version: 2024_03_17_152340) do
  create_schema "azure_ai"
  create_schema "azure_cognitive"
  create_schema "azure_ml"
  create_schema "azure_openai"
  create_schema "azure_storage"

  # These are extensions that must be enabled in order to support this database
  enable_extension "azure_ai"
  enable_extension "azure_storage"
  enable_extension "plpgsql"
  enable_extension "vector"

  create_table "emails", primary_key: "message_id", id: :text, force: :cascade do |t|
    t.datetime "date"
    t.text "in_reply_to"
    t.text "from"
    t.text "to"
    t.text "cc"
    t.text "subject"
    t.text "content"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["in_reply_to"], name: "index_emails_on_in_reply_to"
  end

end

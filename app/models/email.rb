class Email < ApplicationRecord
    has_many :replies, class_name: "Email", foreign_key: :in_reply_to


    def self.semantic(query)
        sql =
        <<-SQL
            WITH RECURSIVE email_chain AS (
                SELECT e1.*
                FROM emails e1
                WHERE message_id IN (
                        SELECT message_id
                            FROM emails
                         WHERE date >= '2020-01-01' -- Optional date limitation
                    ORDER BY email_embedding <#> azure_openai.create_embeddings('text-embedding-ada-002'
                    , :query)::vector
                    LIMIT 5
                )
                UNION ALL
                SELECT e.*
                FROM emails e
                INNER JOIN email_chain ec ON ec.message_id = e.in_reply_to
            )
            select string_agg(content, ',') as context FROM (SELECT content FROM email_chain order by date asc);
        SQL
        sql.chomp
        ActiveRecord::Base.connection.exec_query(
            ActiveRecord::Base.send(:sanitize_sql_array, [sql, query: query]))
    end

    def self.summarize(context)
        sql =
        <<-SQL
            SELECT azure_cognitive.summarize_abstractive(:context,'en', sentence_count := 20) as context;
        SQL
        sql.chomp
        ActiveRecord::Base.connection.exec_query(
            ActiveRecord::Base.send(:sanitize_sql_array, [sql, context: context]))
    end

end

require 'mbox'
require 'iconv'

# Use env TARGET to provide the import target
namespace :emails do
  desc "Import emails from an mbox file, folder or glob path"
  task import: :environment do
    target = ENV['TARGET']
    targets = []
    failed = 0
    
    if File.file? target
      targets.append(target)
    elsif File.directory? target
      targets.append(Pathname.glob("#{target}/*"))
    else
      targets = Pathname.glob(target)
    end

    boxes = targets.map do |m|
      Mbox.open(m)
    end

    boxes.each do |box|
      puts box.pretty_inspect
      box.each do |msg|
        print "."
        message_id = msg.headers[:message_id]

        if msg.headers[:content_type]&.mime == "multipart/signed"
          puts "\nFound multi-part/signed, skipping: #{message_id}"
          failed += 1
          next
        end

        charset = nil
        begin
          charset = if msg.headers[:content_type]&.charset
            Iconv.new('UTF-8', msg.headers[:content_type].charset)
          else
            Class.new do
              def iconv(input)
                input
              end
            end.new
          end
        rescue => e
          puts "\n#{e.message}"
          puts "\nFailed to iconv, verify: #{message_id}"
          failed += 1
          next
        end

        email = Email.new
        begin
          email.date = msg.headers[:date].to_datetime
          email.message_id = message_id
          email.in_reply_to = msg.headers[:in_reply_to]
          email.from = charset.iconv(msg.headers[:from])
          email.to = charset.iconv(msg.headers[:to])
          email.cc = charset.iconv(msg.headers[:cc])
          email.subject = charset.iconv(msg.headers[:subject])
        rescue => e
          puts "\n#{e.message}"
          puts "\nFailed to iconv, verify: #{email.message_id}"
          failed += 1
          next
        end

        if msg.content.length > 1 then
          puts "\nFound multi-part, verify: #{email.message_id}"
          failed += 1
          next
        end

        begin
          email.content = charset.iconv(msg.content.first.to_s)
        rescue => e
          puts "\n#{e.message}"
          puts "\nFailed to iconv, verify: #{email.message_id}"
          failed += 1
          next
        end

        begin
          email.save!
        rescue => e
          puts "\n#{e.message}"
          puts "\n\nFailed on: #{email.message_id}\n\n#{msg.headers}\n\n"
          failed += 1
          next
        end
      end
      puts "\nfailed=#{failed}"
    end
    puts "\nfailed=#{failed}"
  end

end

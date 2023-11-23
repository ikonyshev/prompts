require 'open-uri'

namespace :dataset do
  desc "Import data from HuggingFace dataset. Truncates table before the import to prevent data duplication."
  task import: :environment do
    offset = Prompt.count
    lines_amount = 0
    retries = 0

    begin
      begin
        # Using test split, it is easier to import
        response = URI.parse("https://datasets-server.huggingface.co/rows?dataset=Gustavosta%2FStable-Diffusion-Prompts&config=default&split=test&offset=#{offset}&length=100").read
        parsed_response = JSON.parse(response)

        if parsed_response['error']
          # Sometimes hugging face requests fail.
          retries += 1
          sleep 5
        else
          lines_amount = parsed_response['num_rows_total'] if lines_amount == 0
          retries = 0
          offset += 100 # 100 is a maximum allowed lines to get from hugging face

          parsed_response['rows'].each do |row|
            Prompt.create(text: row['row']['Prompt'])
          end

          sleep 10 # hugging face has rate limiting so it is better to add delay here to not get banned
          puts "Processing offset #{offset} out of #{lines_amount} lines"
        end
      rescue
        # Congratulations! We are temporary blocked. Let's wait for another 5 minutes to try again
        retries += 1
        sleep 300
      end
    end while offset < lines_amount || retries < 3
  end
end

require 'open_ai_client'
# There are better ways to do this than a global variable, but I need something quick

openai_key = ENV.fetch('OPENAI_KEY')

$openai_client = openai_key ? OpenAiClient.new(openai_key) : nil

# Prompts demo application

It is a little bit dirty, I haven't removed unnecessary automatically generated files and components. 

Also, I don't think using React or other heavy-weight frontend library is needed here, so I just used `ujs` and `stimulus`

## Search approach

Just using `elasticsearch-rails` gem. But this is not fun. To add some fun I implemented OpenAI and vector search. 
The UI shows both results, so we can compare quality. To enable vector search create `.env` file with OPENAI_KEY environment
variable.

## How to start it

It is dockerized, so 

`docker-compose up` 

does the trick. Then navigate http://localhost:3000/

I implemented rake task to populate the database from HuggingFace using their APIs.
To populate the database run `rails dataset:import`, but in docker environment for convenience.

`docker-compose exec app rails dataset:import`

## Heroku

App is also deployed to Heroku https://aqueous-dusk-13079-0ef0af124e7c.herokuapp.com/

## Tests

No tests so far unfortunately, spent much time on integrating OpenAI

# README

This is very basic Rails 5 API app that was written using BDD approach. It is designed to retrieve website's pages by URL and parsing its H* tags, title and links, and saving to database
It uses integration tests to make sure API works correctly.

Requirements:
  - Rails 5.0+
  - PostgreSQL

Features:
  - BDD approach
  - Used PostgreSQL array type (so we can get rid of unnecessary one-to-many tables)
  - Two end-points: 
    post /api/pages/store: for grabbing website's pages by URL and parsing its H* tags, title and links, and returning JSON
    get /api/pages/get: for retrieving previously saved pages
  - Tests:
    - Pure Minitest tests
    - During tests database initialized with prepared fixtures.
    - WebMock used for stubbing and mocking http requests. 
    - Result of API calls is tested against with sample data (not loaded in database)
  - Rake task [b]rails test:dump[/b] for preparing stubbed http requests and sample data (note, these are not fixtures)

Installation:
  git clone https://github.com/xpopov/rails5-api-bdd-boilerplate.git .
  cd rails5-api-bdd-boilerplate
  bundle install
  rails db:setup

See its working:
  Run tests: rails test
  Or start API server
    - rails s -b 0.0.0.0 -p 8000
    - Access API end-points with 3rd-party http tools

Debugging tests:
  rdebug-ide --trace --debug --port 1234 --dispatcher-port 26166 --host 0.0.0.0 -- bin/rails test

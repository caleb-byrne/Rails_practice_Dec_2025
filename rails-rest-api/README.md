# Rails REST API - Actors API

A RESTful API built with Rails for managing actor data with real-world database testing patterns.

## Ruby Version

- Ruby 3.2.0 (installed via RVM with OpenSSL 1.1)

## System Dependencies

- PostgreSQL (required for database)
- RVM (recommended for Ruby version management)

## Setup Instructions

1. Install dependencies:
   ```bash
   bundle install
   ```

2. Create and seed the database:
   ```bash
   rails db:create
   rails db:migrate
   rails db:seed
   ```

3. Start the server:
   ```bash
   rails s -p 3001
   ```

The API will be available at `http://localhost:3001/api/v1`

## Architecture: Frontend-Backend Interaction

This API is designed to mimic **real-world database interactions** where multiple clients (web frontends, mobile apps, external services) interact with a shared database through HTTP endpoints.

### Key Design Patterns

**HTTP-Based Communication:**
- Frontend/clients make actual HTTP requests to the running server
- No mocking or stubbing of HTTP calls
- Data persists in the development database between requests
- Tests use the same database as the running server

**Shared Development Database:**
- Both manual testing and automated tests write to the same development database
- Each test run creates fresh test data via the `before(:each)` hook
- Data persists across test assertions, allowing multi-step test workflows
- This mirrors production behavior where multiple clients share a single database

**Real-World Testing Benefits:**
- Tests validate actual HTTP responses with correct status codes (200, 201, 204, 404, etc.)
- Database state changes are visible across sequential requests
- Tests can verify side effects (e.g., actor deleted, subsequent GET returns 404)
- JSON parsing and response structure validation happen on real data

## API Endpoints

### GET /api/v1/actors
Returns all actors in the database.

**Response:** 200 OK with array of actors
```json
[
  {"id": 1, "name": "Tom Holland", "country": "United Kingdom"},
  {"id": 2, "name": "Robert Downey Jr.", "country": "United States"}
]
```

### GET /api/v1/actors/:id
Returns a specific actor by ID.

**Response:** 200 OK with actor object, or 404 Not Found if actor doesn't exist

### POST /api/v1/actors
Creates a new actor.

**Request:**
```json
{
  "actor": {
    "name": "Tom Cruise",
    "country": "United States"
  }
}
```

**Response:** 201 Created with the created actor

### PATCH /api/v1/actors/:id
Updates an actor's fields.

**Response:** 200 OK with updated actor

### DELETE /api/v1/actors/:id
Deletes an actor.

**Response:** 204 No Content

## Running Tests

The test suite uses RSpec with the HTTP gem to make real HTTP requests to the running server. This validates the API behaves correctly in a real-world scenario.

### Prerequisites

1. Start the Rails server in one terminal:
   ```bash
   rails s -p 3001
   ```

2. Ensure PostgreSQL is running

### Using Rake Tasks (Recommended for Teams)

For easy cross-IDE compatibility, use Rake tasks to run tests:

**Run all tests:**
```bash
rake spec:tc_actors
```

**Run a specific test by tag:**
```bash
rake 'spec:tc_actor[tc_get_actors_01]'
rake 'spec:tc_actor[tc_post_actors_02]'
rake 'spec:tc_actor[tc_delete_actors_id_01]'
```

Each test has a unique tag (e.g., `tc_get_actors_01`, `tc_post_actors_02`) that corresponds to the test name. These tags allow selective test execution without IDE dependencies.

**Why Rake tasks?**
- Works across all IDEs (VS Code, RubyMine, Vim, etc.)
- No IDE configuration needed
- Team members just clone and run commands
- Standard Rails convention

### Direct RSpec Commands

You can also run RSpec directly:

```bash
# Run all tests
RAILS_ENV=development rspec ./spec/api_testing/api_testing_rspec.rb

# Run tests with a specific tag
RAILS_ENV=development rspec ./spec/api_testing/api_testing_rspec.rb -t tc_get_actors_01

# Run all tests with the main tag
RAILS_ENV=development rspec ./spec/api_testing/api_testing_rspec.rb -t tc_actors
```

The `RAILS_ENV=development` flag is critical—it ensures tests use the **development database** (same as the running server) instead of the isolated test database. This allows tests to validate real HTTP interactions with persistent data.

### Test Output

Each test outputs its name and HTTP status code:
```
tc_get_actors_01 - Status: 200 OK
tc_get_actors_02 - Status: 200 OK
tc_post_actors_01 - Status: 201 Created
tc_delete_actors_id_01 - Status: 204 No Content
...
Finished in 0.28 seconds
11 examples, 0 failures
```

## Test Structure

The test file (`spec/api_testing/api_testing_rspec.rb`) demonstrates best practices for testing HTTP APIs:

### Setup: Fresh Test Data Each Run
```ruby
before(:each) do
  Actor.delete_all
  
  test_data = [
    { name: 'Tom Holland', country: 'United Kingdom' },
    { name: 'Robert Downey Jr.', country: 'United States' },
    # ... more actors
  ]
  
  test_data.each { |data| Actor.create!(data) }
end
```

Each test starts with known, clean data. The database is reset before each test run.

### Making Real HTTP Requests
```ruby
it 'GET /actors returns 200 status' do
  response = HTTP.get("http://localhost:3001/api/v1/actors")
  expect(response.status).to eq(200)
  puts "Test passed - Status: #{response.status}"
end
```

Tests make actual HTTP calls to the running server, not mocked requests.

### Multi-Step Workflow Testing
```ruby
it 'delete actor then verify 404' do
  actor_id = Actor.all[3].id
  HTTP.delete("#{BASE_URL}/actors/#{actor_id}")
  
  # Second request validates the delete worked
  response = HTTP.get("#{BASE_URL}/actors/#{actor_id}")
  expect(response.status).to eq(404)
end
```

Tests can verify that actions have side effects visible to subsequent requests.

## Important Configuration

### Rails Configuration
- **Transactional Fixtures Disabled:** Set `use_transactional_fixtures = false` in `spec/rails_helper.rb` to prevent automatic rollback of test data
- **Environment Variable:** Tests default to `RAILS_ENV=development` to use the development database

### Why Shared Database Testing?
Traditional isolated test databases miss real-world issues:
- Database consistency across concurrent requests
- Side effects visible to other clients
- Actual HTTP response parsing
- Status code validation

This approach trades isolation for **realistic scenarios** that match production behavior.

## Debugging Tests

### Using Pry Debugger

Add `binding.pry` to pause execution and inspect variables:

```ruby
it 'tc_get_actors_02 returns an array of actors', :tc_get_actors_02, :tc_actors do
  response = HTTP.get("#{BASE_URL}/actors")
  body = JSON.parse(response.body)
  binding.pry  # Debugger pauses here
  expect(body).to be_a(Array)
end
```

**Run test with debugging:**
```bash
rake 'spec:tc_actor[tc_get_actors_02]'
```

When the test hits `binding.pry`, you'll enter the pry console. Inspect variables:

```
[1] pry(main)> body
=> [{"id"=>794, "name"=>"Tom Holland", ...}, ...]

[2] pry(main)> response.status
=> 200

[3] pry(main)> body.first
=> {"id"=>794, "name"=>"Tom Holland", "country"=>"United Kingdom", ...}

[4] pry(main)> continue  # Resume test execution
```

**Available debugger commands:**
- `step` - Step into code
- `next` - Next line
- `continue` - Resume execution
- `q` - Quit pager view (if output is long)
- `exit` - Exit debugger

The debugger works seamlessly with Rake tasks, allowing interactive inspection of test data and responses.

## Gems Used

- `rails`: Web framework
- `pg`: PostgreSQL adapter
- `rack-cors`: CORS support for frontend requests
- `http`: HTTP client for testing
- `rspec`: Testing framework
- `pry-rails`, `pry-byebug`: Debugging tools for RSpec tests

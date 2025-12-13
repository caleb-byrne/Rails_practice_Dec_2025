# Crud Example Tasks App

A simple Rails CRUD (Create, Read, Update, Delete) application built using `rails generate scaffold ExampleTask`. This app allows users to create, view, update, and delete tasks with a title and description.

## Ruby version

* Ruby 3.2.0

## System dependencies

* Rails 7.1.6
* SQLite3

## Getting Started

### 1. Install Dependencies

Make sure you're in the `crud_example_tasks_app` directory:

```bash
cd crud_example_tasks_app
bundle install
```

### 2. Database Setup

Create and migrate the database:

```bash
rake db:create
rake db:migrate
```

### 3. Run the Rails Server

Start the Rails development server:

```bash
rails server
```

The server will start on `http://localhost:3000`

### 4. Access the Application

Open your browser and navigate to the following routes:

* **View all tasks:** `http://localhost:3000/example_tasks`
* **Create a new task:** `http://localhost:3000/example_tasks/new`
* **View a specific task:** `http://localhost:3000/example_tasks/:id` (replace `:id` with the task ID)
* **Edit a task:** `http://localhost:3000/example_tasks/:id/edit`
* **Delete a task:** Click the delete button from the task show or index page

## Features

- **Create:** Add new tasks with a title and description
- **Read:** View all tasks in the index page or view individual task details
- **Update:** Edit existing tasks
- **Delete:** Remove tasks from the database

## Project Structure

- `app/models/example_task.rb` - Task model
- `app/controllers/example_tasks_controller.rb` - Controller handling CRUD operations
- `app/views/example_tasks/` - View templates for all CRUD operations
- `db/migrate/` - Database migration files

## Testing

To run the test suite:

```bash
rails test
```

## How to Stop the Server

Press `Ctrl+C` in the terminal where the server is running.

# Flicker - project documentation

[Polski](dokumentacja.md) | **English**

Flicker is a web application for browsing movie information, rating movies and
adding reviews. It is inspired by services such as Filmweb and IMDb, which let
users rate and comment on film productions.

## Table of contents

- [Features](#features)
- [Technologies](#technologies)
- [System architecture](#system-architecture)
- [System components](#system-components)
- [Database structure](#database-structure)
- [Use case scenarios](#use-case-scenarios)

## Features

### User

- browsing the movie list,
- searching movies by title,
- filtering by genre and release year,
- viewing detailed movie information,
- viewing the average rating of a movie,
- browsing other users' reviews,
- adding own ratings and reviews (after logging in).

### Administrator

- adding new movies,
- editing movie information,
- deleting movies,
- deleting reviews,
- managing users.

## Technologies

| Layer        | Technology stack                       |
| ------------ | -------------------------------------- |
| Frontend     | React.js / Next.js, Axios, TailwindCSS |
| Backend      | FastAPI, SQLAlchemy, JWT               |
| Database     | PostgreSQL / MySQL                     |

## System architecture

**Frontend** is responsible for:

- displaying the movie list,
- searching and filtering,
- login and registration forms,
- adding ratings and reviews.

**Backend** is responsible for:

- handling HTTP requests,
- authorizing users (JWT),
- processing data,
- communicating with the database (SQLAlchemy).

**Database** is a relational database (PostgreSQL or MySQL) that stores all
application data.

## System components

- **Home page** - movie list and search bar.
- **Movie details page** - movie details, average rating, list of reviews and the
  option to add your own rating and review.
- **User system** - registration and login.
- **Administrator panel** - adding, editing and deleting movies, editing reviews,
  managing users.
- **API** - endpoints for movies, users, ratings and reviews.
- **Database** - storage of system data and of the relationships between users,
  movies and reviews.

## Database structure

### Users

| Field         | Type    | Description                |
| ------------- | ------- | -------------------------- |
| id            | Integer | primary key                |
| username      | String  | user name                  |
| email         | String  | e-mail address             |
| password_hash | String  | hashed password            |
| role          | String  | role: `user` or `admin`    |

### Movies

| Field        | Type    | Description    |
| ------------ | ------- | -------------- |
| id           | Integer | primary key    |
| title        | String  | movie title    |
| description  | Text    | plot summary   |
| release_year | Integer | release year   |
| genre        | String  | genre          |

### Ratings

| Field    | Type    | Description                |
| -------- | ------- | -------------------------- |
| id       | Integer | primary key                |
| user_id  | Integer | foreign key to `Users`     |
| movie_id | Integer | foreign key to `Movies`    |
| rating   | Integer | rating on a 1-10 scale     |

### Reviews

| Field      | Type     | Description              |
| ---------- | -------- | ----------------------- |
| id         | Integer  | primary key             |
| user_id    | Integer  | foreign key to `Users`  |
| movie_id   | Integer  | foreign key to `Movies` |
| content    | Text     | review content          |
| created_at | DateTime | creation date           |

### Relationships

- one user can add many reviews,
- one movie can have many reviews,
- one user can rate many movies,
- one movie can have many ratings.

## Use case scenarios

### 1. Adding a rating and a review

**Primary actor:** logged-in user

**Preconditions:**

- the user has an account in the Flicker system,
- the user is logged in (holds a valid JWT token),
- the user is on the details page of a specific movie.

**Postconditions:**

- the rating and review are stored and linked to the movie and the user,
- the average rating of the movie is recalculated automatically,
- the review is visible to other users.

**Main scenario:**

1. The user selects "Add rating and review".
2. The system shows a form with a rating scale (1-10) and a text field for the review.
3. The user selects a numeric rating.
4. The user enters the review content.
5. The user clicks "Publish".
6. The system sends a request to the API together with the JWT token (authorization).
7. The system validates the data (whether the rating is within range, whether the content is not empty).
8. The system stores the data in the `Ratings` and `Reviews` tables.
9. The system recalculates the average rating for the movie.
10. The system shows a success message and refreshes the movie details view.

**Alternative scenarios:**

- *Session expired (invalid JWT token):* the system reports that the user must log
  in again and redirects to the login form.
- *Incomplete data:* the system highlights empty fields and blocks form submission
  until the data is completed.

### 2. Adding new movies

**Primary actor:** administrator

**Preconditions:**

- the user is logged in to an account with the `admin` role,
- the administrator is in the administration panel.

**Postconditions:**

- the new movie is added to the `Movies` table,
- the movie becomes available for searching and rating by all users.

**Main scenario:**

1. The administrator selects "Add new movie".
2. The system shows the movie creation form.
3. The administrator enters the data: title, plot summary, release year and genre.
4. The administrator submits the form with the "Save movie" button.
5. The system checks whether a movie with the same title and release year already exists.
6. The system validates the data types (e.g. whether the year is a number).
7. The system creates a new record in the `Movies` table (SQLAlchemy).
8. The system shows a confirmation that the movie was created in the catalog.

**Alternative scenarios:**

- *Movie already exists:* the system shows the message "This movie is already in
  the system" and offers to edit the existing movie.
- *Data validation error:* the system reports an invalid data format (e.g. a
  release year in the future) and asks for a correction before saving.

### 3. Registration and login

**Primary actor:** guest (not logged-in user)

**Preconditions:**

- none (the user has access to the internet and a browser).

**Postconditions:**

- for registration: a record is created in the `Users` table,
- for login: a JWT token is generated and passed to the user.

**Main scenario:**

1. The guest selects "Log in" or "Register".
2. For registration:
   - the user provides `username`, `email` and `password`,
   - the system hashes the password (`password_hash`),
   - the system stores the user in the database with the default `user` role.
3. For login:
   - the user provides the login credentials,
   - the system verifies the data against the database,
   - the system generates a JWT access token.
4. The system redirects the user to the home page with logged-in user permissions.

**Alternative scenarios:**

- *Invalid login credentials:* the system shows a message about a wrong login or
  password and blocks access to restricted features.

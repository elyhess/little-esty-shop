<!--
*** Thanks for checking out the Best-README-Template. If you have a suggestion
*** that would make this better, please fork the repo and create a pull request
*** or simply open an issue with the tag "enhancement".
*** Thanks again! Now go create something AMAZING! :D
***
***
***
*** To avoid retyping too much info. Do a search and replace for the following:
*** github_username, repo_name, twitter_handle, email, project_title, project_description
-->



<!-- PROJECT SHIELDS -->
<!--
*** I'm using markdown "reference style" links for readability.
*** Reference links are enclosed in brackets [ ] instead of parentheses ( ).
*** See the bottom of this document for the declaration of the reference variables
*** for contributors-url, forks-url, etc. This is an optional, concise syntax you may use.
*** https://www.markdownguide.org/basic-syntax/#reference-style-links
-->


![Little Esty Shop](/public/navbar.png)
<!-- TABLE OF CONTENTS -->
<summary><h2 style="display: inline-block">Table of Contents</h2></summary>
<ol>
  <li><a href="#about-the-project">About The Project</a>
  <li><a href="#project-board">Project Board</a></li>
  <li><a href="#database-schema">Database Schema</a></li>
  <li><a href="#built-with">Built With</a>
  <li><a href="#setup-instructions">Setup Instructions</a></li>
  <li><a href="#contact">Contact</a></li>
  <li><a href="#acknowledgements">Acknowledgements</a></li>
</ol>

<!-- ABOUT THE PROJECT -->
## About The Project

[Little Esty Shop](https://immense-ocean-82455.herokuapp.com/)  is a module 2 two-part project for the Turing School of Software & Design. The application resembles a fictitious e-commerce platform where merchants and administrators can manage inventory and fulfill customer invoices, and customers can make purchases. The project is broken into two parts, the first being a 4 person group project with the collaborators mentioned below, and the second part being a solo project

User stories tracked using [Github projects](https://github.com/elyhess/little-esty-shop/projects/13).

### Part 1: 

#### Skills Developed in part 1
* Designed schema with custom rake task for database seeding
* Used advanced ActiveRecord to perform complex database queries
* Utilized namespacing for efficient and organized routing  
* Practiced MVC concepts, effectively staying within rails conventions
* Consumed github API and utilized POROS as a way to apply OOP principals  
* Deployed application on [Heroku](https://immense-ocean-82455.herokuapp.com/)

#### Extensions Complete
* Utilized sessions & account models with Devise Gem
* Added a shopping cart session for customers
* Implemented a CSS framework

### Part 2:

#### Skills Developed in part 2
* Used advanced ActiveRecord to perform complex database queries
* Utilized namespacing for efficient and organized routing
* Practiced MVC concepts, effectively staying within rails conventions
* Implemented checkout and payment functionality using POROs and Braintree's paypal API implementation
* Use webmock to test functionality of API calls 
* Deployed application on [Heroku](https://immense-ocean-82455.herokuapp.com/)

#### Extensions Complete
* Used ActiveRecord to implement functionality that limits merchants from deleting/editing discounts belonging to invoices that are pending
* Used ActiveRecord to store pertinent discount information on invoice records for referencing throughout application

<!-- PROJECT BOARD -->
## Project Board
Check out the [Project board](https://github.com/elyhess/little-esty-shop/projects/13) for a complete list of features / user stories used to develop this application.

<!-- DATABBASE SCHEMA -->
## Database Schema

![Schema](https://github.com/elyhess/little-esty-shop/blob/main/schema2.png)

<!-- BUILT WITH -->
## Built With

* [Ruby on Rails](https://rubyonrails.org/)
* [Postgresql](https://www.postgresql.org/)
* [Devise](https://github.com/heartcombo/devise)
* [GitHub API](https://docs.github.com/en/rest)
* [Braintree](https://developers.braintreepayments.com/guides/drop-in/overview/javascript/v2)  
* [Bulma](https://bulma.io/)

<!-- SETUP INSTRUCTIONS -->
## Setup Instructions
To get a local copy up and running follow these simple steps.

1. Clone the repo
   ```
   git clone https://github.com/elyhess/little-esty-shop
   ```
2. Install dependencies
   ```
   bundle install
   ```
3. DB creation/migration
   ```
   rails db:create
   rails db:migrate
   rails db:seed
   ```
3. Run tests and view test coverage
   ```
   bundle exec rspec
   open coverage/index.html
   ```
4. Run server and navigate to http://localhost:3000/
   ```
   rails s
   ```
   
OR

1. Visit heroku
   ```
   https://immense-ocean-82455.herokuapp.com/
   ```

1. Login
   ```
   Admin:
   email: admin@example.com
   password: password
   
   User:
   email: merchant1@example.org
   password: strongpassword
   ```


<!-- CONTACT -->
## Contact

* [James Fox-Collis](https://github.com/jlfoxcollis) - jlfoxcollis@gmail.com
* [Samuel Yeo](https://github.com/SK-Sam) - yeosamuel95@gmail.com
* [Phil McCarthy](https://github.com/philmccarthy) - hi@philmccarthy.dev
* [Ely Hess](https://github.com/elyhess) - ely.hess@me.com



<!-- ACKNOWLEDGEMENTS -->
## Acknowledgements

* [README template](https://github.com/othneildrew/Best-README-Template)
* [Mod_2 Project: Part 1 (group)](https://github.com/turingschool-examples/little-esty-shop)
* [Mod_2 Project: Part 2 (solo)](https://backend.turing.io/module2/projects/bulk_discounts)

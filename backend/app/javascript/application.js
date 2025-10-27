// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
// import "@hotwired/turbo-rails"
// import "controllers"

import "@hotwired/turbo-rails"
import "controllers"
import "./chat"
import Rails from "@rails/ujs"

Rails.start()

//= require jquery3
//= require popper
//= require bootstrap-sprockets
//= require turbolinksimport * as bootstrap from "bootstrap"

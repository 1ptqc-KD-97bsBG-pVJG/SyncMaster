// Entry point for the build script in your package.json
import "@hotwired/turbo-rails"
import "./controllers"
import * as bootstrap from "bootstrap"
import Rails from "@rails/ujs"
Rails.start()
console.log("Rails UJS initialized:", Rails)
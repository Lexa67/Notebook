// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails

import "@hotwired/turbo-rails"
import "controllers"

document.addEventListener("DOMContentLoaded", function() {
  document.addEventListener("click", function(event) {
    if (event.target.closest(".lesson_info")) {
      const lessonInfo = event.target.closest(".lesson_info");
      const lessonPath = lessonInfo.dataset.lessonPath;
      window.location.href = lessonPath;
    }
  });
  document.addEventListener("click", function(event) {
      if (event.target.closest(".user_info")) {
        const userInfo = event.target.closest(".user_info");
        const userPath = userInfo.dataset.userPath;
        window.location.href = userPath;
      }
    });
  document.addEventListener("click", function(event) {
    if (event.target.closest(".lesson_info .button")) {event.stopPropagation()};
    });
  });
  
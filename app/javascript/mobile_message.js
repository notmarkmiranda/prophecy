document.addEventListener("DOMContentLoaded", function() {
  if (window.innerWidth <= 768) { // Adjust the width as needed for your definition of "mobile"
    document.getElementById('mobile-message').style.display = 'flex';
  }
});
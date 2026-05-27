// Subtle nav border on scroll
(function () {
  var nav = document.getElementById('nav');
  if (!nav) return;
  function update() {
    if (window.scrollY > 8) nav.classList.add('scrolled');
    else nav.classList.remove('scrolled');
  }
  window.addEventListener('scroll', update, { passive: true });
  update();
})();

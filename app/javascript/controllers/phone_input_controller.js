document.addEventListener("DOMContentLoaded", function () {
  const phoneInput = document.getElementById("phone_input");
  if (phoneInput) {
    phoneInput.addEventListener("input", function (e) {
      let value = e.target.value.replace(/\D/g, "");
      if (value.startsWith("380")) {
        value = "+" + value;
      } else if (!value.startsWith("+380") && value.length > 0) {
        value = "+380" + value;
      }
      e.target.value = value.slice(0, 13);
    });
  }
});

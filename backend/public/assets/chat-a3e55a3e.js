document.addEventListener("turbo:load", () => {
  // Toggle new chat sidebar
  document.querySelectorAll(".heading-compose").forEach(btn => {
    btn.addEventListener("click", () => {
      document.querySelector(".side-two").style.left = "0";
    });
  });

  document.querySelectorAll(".newMessage-back").forEach(btn => {
    btn.addEventListener("click", () => {
      document.querySelector(".side-two").style.left = "-100%";
    });
  });

  // Auto-scroll
  function scrollToBottom(smooth = true) {
    const chatBox = document.getElementById('messages');
    if (chatBox) {
      chatBox.scrollTo({
        top: chatBox.scrollHeight,
        behavior: smooth ? 'smooth' : 'auto'
      });
    }
  }

  scrollToBottom(false);

  document.addEventListener("turbo:before-stream-render", (event) => {
    if (event.target.action === "append") {
      setTimeout(() => scrollToBottom(true), 50);
    }
  });
});

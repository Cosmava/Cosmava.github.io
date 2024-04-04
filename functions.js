// Nav-bar scroll
const homeLink = document.getElementById("homeLink");
const aboutLink = document.getElementById("aboutLink");
const projectLink = document.getElementById("projectLink");
const logoHomeLink = document.getElementById("logoHomeLink");
const contactMeBtn = document.getElementById("contactMeBtn");

const homeSection = document.getElementById("home");
const aboutMe = document.querySelector(".about-me");
const aboutMe2 = document.getElementById("aboutMe2");
const projectsSection = document.getElementById("projects");
const footer = document.getElementById("footer");

logoHomeLink.onclick = () => {
  homeSection.scrollIntoView({
    behavior: "smooth",
    block: "center",
  });
};

homeLink.onclick = () => {
  homeSection.scrollIntoView({
    behavior: "smooth",
    block: "center",
  });
};

aboutLink.onclick = () => {
  aboutMe.scrollIntoView({
    behavior: "smooth",
    block: "center",
  });
};

aboutMe2.onclick = () => {
  aboutMe.scrollIntoView({
    behavior: "smooth",
    block: "center",
  });
};

projectLink.onclick = () => {
  projectsSection.scrollIntoView({
    behavior: "smooth",
    block: "center",
  });
};

contactMeBtn.onclick = () => {
  footer.scrollIntoView({
    behavior: "smooth",
    block: "end",
  });
};

// Birthday change year auto
const currentDate = new Date();
const birthday = new Date("2006/02/20");
let yearsPassed = currentDate.getFullYear() - birthday.getFullYear();
if (
  currentDate.getMonth() < birthday.getMonth() ||
  (currentDate.getMonth() === birthday.getMonth() &&
    currentDate.getDate() < birthday.getDate())
) {
  yearsPassed--;
}
document.getElementById("age").textContent = yearsPassed;

// Change the portfolio picture depends from the time
var dateNow = new Date().getHours();
if (dateNow <= 5 && dateNow >= 21) {
  document.getElementById("portfolioImage").src = "./images/night.png";
} else if (dateNow <= 15) {
  document.getElementById("portfolioImage").src = "./images/morning.png";
} else if (dateNow <= 21) {
  document.getElementById("portfolioImage").src = "./images/evening.png";
}

// footer Current Year
let currentYear = new Date().getFullYear();
document.getElementById("currentYear").textContent = currentYear;

//menu button transform

let menuOpen = false;

function transformMenu() {
  const line1 = document.querySelector(".line-1");
  const line2 = document.querySelector(".line-2");
  const line3 = document.querySelector(".line-3");
  var linksHam = document.getElementById("links");
  linksHam.classList.toggle("pop-up-ham-menu");

  if (menuOpen) {
    line2.style.opacity = 1;
    line1.style.transform = "none";
    line1.style.width = "100%";
    line3.style.transform = "none";
  } else {
    const linksHam = document.getElementById("links");
    linksHam.classList.add("pop-up-ham-menu");
    line2.style.opacity = 0;
    line1.style.transform = "translateY(10px) rotate(45deg)";
    line1.style.width = "100%";
    line3.style.transform = "translateY(-10px) rotate(-45deg)";
  }

  menuOpen = !menuOpen;
}

// night mode
let styleMode;
let modeBtn = document.querySelector(".night-mode");

function enableLightStyle() {
  document.body.classList.add("lightMode");
  document.querySelectorAll(".closeBtn").forEach((element) => {
    element.style.backgroundImage = "url(./images/icons/closeBlack.png)";
  });
  document.querySelector(".night-mode").style.backgroundImage =
    "url(./images/icons/sun.png)";

  localStorage.setItem("styleMode", "light");
}

function disableLightStyle() {
  document.body.classList.remove("lightMode");
  document.querySelector(".night-mode").style.backgroundImage =
    "url(./images/icons/moon.png)";
  document.querySelectorAll(".closeBtn").forEach((element) => {
    element.style.backgroundImage = "url(./images/icons/close.png)";
  });
  localStorage.removeItem("styleMode");
}

modeBtn.addEventListener("click", () => {
  styleMode = localStorage.getItem("styleMode");
  if (styleMode != "light") {
    enableLightStyle();
  } else {
    disableLightStyle();
  }
});

if (styleMode === "light") {
  enableLightStyle();
}

// pop up projects
function openPopUp(previewId) {
  document.getElementById(previewId).classList.add("open");
}

function closePopUp(previewId) {
  document.getElementById(previewId).classList.remove("open");
}

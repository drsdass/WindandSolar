# Wind and Solar Data Viewer

This is a single-page web application designed to demonstrate the integration of a public API source into a modern front-end layout.

The application fetches specific wind turbine data from the **USGS U.S. Wind Turbine Database (USWTDB)** API and displays key information such as location, coordinates, and rated capacity.

## Technology Stack

* **HTML/CSS:** Structure and presentation.
* **Tailwind CSS:** Utility-first CSS framework for responsive design.
* **JavaScript:** Used for asynchronous data fetching (`fetch API`) and DOM manipulation.
* **API Source:** `https://energy.usgs.gov/api/uswtdb/v1/turbines`
* **Deployment:** Dockerized using Nginx for serving static content.

## Deployment Notes (for Hosting)

This project is configured to be deployed via Docker on platforms that support containerization (e.g., Render, Digital Ocean, etc.).

1.  **`Dockerfile`**: Builds a lightweight container using `nginx:alpine`.
2.  **`nginx.conf`**: Configures Nginx to serve `index.html` as the default document.
